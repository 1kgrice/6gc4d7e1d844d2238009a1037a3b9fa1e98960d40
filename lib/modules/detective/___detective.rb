require_relative "../gumroad_meta/gumroad_meta"
require "open-uri"
require "selenium-webdriver"
require "rbconfig"
require "net/http"
require "uri"
require "nokogiri"

module Detective
  # Rough Selenium parser for Gumroad Discover
  class Detective
    def initialize(url, skip_browser = false)
      @url = url
      init_chrome unless skip_browser
      # @driver.manage.timeouts.page_load = 300
    end

    def run(**args, &block)
      # meta_category = args.fetch :meta_category, ""
      # meta_params = args.fetch :meta_params, ""
      testrun = args.fetch :testrun, false
      category = args.fetch :category, ""
      params = args.fetch :params, "sort=default"
      delay_range = args.fetch :delay_range, [2.0, 5.0]
      direct_json = args.fetch :direct_json, false
      batch_lookup_size = 99

      delay = Random.rand(5.0..10.0)
      print "Navigating to #{@url}\n"
      print "Waiting #{delay.round(2)} seconds\n"
      @driver.navigate.to @url unless direct_json
      sleep(delay)

      known_cards = []
      last_card_selector = "div.product-card-grid > article.product-card:last-child"
      all_cards_selector = "div.product-card-grid > article.product-card"
      iteration = 0

      retry_attempt = 0
      index_offset = 0

      direct_index = 0

      loop do
        iteration += 1
        print "Crawling loop ##{iteration}:\n"

        print "Retreive the cards\n"

        # rubocop:disable Lint/RescueException
        begin
          if direct_json
            uri = URI.parse(@url + "&from=#{direct_index + 1}")
            response = Net::HTTP.get_response(uri)
            parsed_response = JSON.parse(response.body)
            cards = parsed_response["products"]
          else
            cards =
              @driver.find_elements(
                :css,
                "div.product-card-grid > article.product-card:nth-last-child(-n+#{batch_lookup_size})"
              )
          end
        rescue Exception => e
          print "Error: #{e}\n"
          iteration -= 1
          retry_attempt += 1
          if retry_attempt <= 5
            print "Trying again\n"
            sleep(5.0..10.00)
            retry
          else
            print "Out of attempts\n"
            break
          end
        end
        # rubocop:enable Lint/RescueException

        if direct_json
          cards.each_with_index do |card, index|
            title = card["name"]
            product_url = card["url"].split("?").first
            category = '/' + category if category[0] != '/'
            meta_url = "https://discover.gumroad.com#{category}?#{params}"

            print "#{index + direct_index + 1}:\n"
            print "Product title: #{title}\n"
            print "Product URL: #{product_url}\n"

            product = {
              name: title,
              url: product_url,
              # images: product_images,
              # rating: rating_avg,
              # review_count: reviews,
              # textprice:,
              # user_name: author,
              # user_avatar: author_avatar,
              # user_url: author_url,
              meta_url: meta_url
            }

            block.call(product) if block_given?
          end
          direct_index += 9
        else
          retry_attempt = 0
          cards -= known_cards

          cards.each_with_index do |card, index|
            if known_cards.include?(card)
              print "Card already known\n"
            else
              begin
                header = card.find_element(:tag_name, "header")
                header_a = header.find_element(:tag_name, "a")
                footer = card.find_element(:tag_name, "footer")

                title = card.find_element(:tag_name, "a").attribute("aria-label")

                author_avatar = header_a.find_element(:tag_name, "img").attribute("src")
                author = header_a.text
                product_url = card.find_element(:tag_name, "a").attribute("href").split("?").first
                author_url = "https://#{URI.parse(header_a.attribute("href")).host}"

                product_images =
                  card.find_element(:class_name, "carousel").find_elements(:tag_name, "img")
                product_images.map! { |img| img.attribute("src") }

                rating = footer.find_element(:class_name, "rating")
              rescue Selenium::WebDriver::Error::StaleElementReferenceError
                print "StaleElementReferenceError Error\n"
                iteration -= 1
                retry_attempt += 1
                if attempt <= 5 # rubocop:disable Metrics/BlockNesting
                  print "Trying again\n"
                  sleep(5.0..10.00)
                  retry
                else
                  print "Out of attempts\n"
                  break
                end
                # rescue Selenium::WebDriver::Error::UnknownError
                #   product = { name: title, url: product_url, meta_url: @url }
                #   block.call(product) if block_given?
                #   next
              end
              begin
                # Raing slot can be not present and instead show "No ratings"
                rating_avg = rating.find_element(:class_name, "rating-average").text.to_f
                reviews = rating.find_element(:class_name, "ratings").text.tr("()", "").to_i
              rescue Selenium::WebDriver::Error::NoSuchElementError
                rating_avg = 0
                reviews = 0
              end
              # Observed Euro, Dollar and Pound signs
              # textprice = footer.find_element(:class_name, "price").text

              print "#{index + index_offset + 1}:\n"
              print "Product title: #{title}\n"
              print "Product URL: #{product_url}\n"
              # print "Product Images (#{product_images.length})\n"
              # product_images.each { |img| print " - #{img}\n" }
              # print "Rating: #{rating_avg} (#{reviews})\n"
              # print "Price: #{textprice}\n"
              # print "User: #{author}\n"
              # print "User Avatar: #{author_avatar}\n"
              # print "User URL: #{author_url}\n"
              # print "Meta URL: #{@url}\n"

              product = {
                name: title,
                url: product_url,
                images: product_images,
                rating: rating_avg,
                review_count: reviews,
                # textprice:,
                user_name: author,
                user_avatar: author_avatar,
                user_url: author_url,
                meta_url: @url
              }

              known_cards.pop if known_cards.length > (batch_lookup_size * 2)
              known_cards.unshift card

              block.call(product) if block_given?
            end
          end
          index_offset += cards.length

          begin
            last_card = @driver.find_element(:css, last_card_selector)
            # last_card.location_once_scrolled_into_view
            scroll = "document.querySelector('#{last_card_selector}').scrollIntoView();"
            # scroll = "window.scrollTo(0, Number.MAX_SAFE_INTEGER)"
            @driver.execute_script(scroll)
            card_count = @driver.find_elements(:css, all_cards_selector).length
            if card_count >= batch_lookup_size
              puts "Reached #{card_count} cards. Cleaning up DOM."
              @driver.execute_script(
                "document.querySelectorAll('#{all_cards_selector}:nth-child(-n+#{batch_lookup_size - 18})').forEach(c => {c.remove();});"
              )
              card_count = @driver.find_elements(:css, all_cards_selector).length
              puts "New count: #{card_count} cards."
            end
            delay = Random.rand(delay_range[0]..delay_range[1])
            sleep(delay)
            new_last_card = @driver.find_element(:css, last_card_selector)
          rescue Selenium::WebDriver::Error::NoSuchElementError
            puts "Haven't found a card to scroll to. Stopping the execution."
            break
          end

          # If the last card is the same as before, we've reached the end of the page
          # However, to really make sure that we've reached the end of the page,
          # wait for a bit and check again a couple more times
          should_break = false

          if new_last_card == last_card
            card_count = @driver.find_elements(:css, all_cards_selector).length
            puts "Seem to have reached the end of the page. Making sure..."
            25.times do |t|
              should_break = false
              puts "Take #{t + 1}..."
              begin
                sleep((t + 1) * 1.5)
                @driver.execute_script(scroll)
                new_last_card_check = @driver.find_element(:css, last_card_selector)
                new_card_count = @driver.find_elements(:css, all_cards_selector).length
                # new_last_card.location_once_scrolled_into_view

                if new_last_card_check != last_card ||
                     known_cards.include?(new_last_card_check) == false ||
                     new_card_count > card_count
                  puts "False alarm. There's actually more content.\n"
                  break
                end
              rescue Selenium::WebDriver::Error::UnknownError => e
                puts "UnknownError Error\n"
                puts e
                sleep 20
              rescue Selenium::WebDriver::Error::InvalidSessionIdError => e
                puts "Invalid Session Error\n"
                puts e
              end
              should_break = true
            end
          end

          if should_break
            puts "This was indeed the end.\n"
            break
          end
          break if testrun == true && iteration > 5
        end
      end

      # Quit the driver
      @driver.quit
    end

    def get_more_info(product_url, attempt = 0)
      print "Looking up product\n"
      print "Navigating to #{product_url}\n"
      @driver.navigate.to product_url
      sleep(0.5)

      meta_script_css = ".js-react-on-rails-component"
      # rubocop:disable Lint/RescueException
      begin
        attempt += 1
        elements = @driver.find_elements(:css, meta_script_css)
        puts elements.inspect
        element = elements.find { |e| e.attribute("data-component-name") == "ProductPage" }
        meta_script = element.attribute("innerHTML")
        puts meta_script
        puts "---"
        meta_script
      rescue Exception
        print "Trying again (#{attempts})...\n"
        print "No meta script found\n"
        if attempt <= 5
          sleep(attempt * 2)
          get_more_info(product_url, attempts)
        end
        nil
      end
      # rubocop:enable Lint/RescueException
    end

    def get_more_info_static(product_url)
      # rubocop:disable Lint/RescueException
      uri = URI.parse(product_url)
      response = Net::HTTP.get_response(uri)
      parsed_response = Nokogiri.parse(response.body)
      meta_script = parsed_response.css(".js-react-on-rails-component").last.text
      puts meta_script
      puts "---"
      meta_script
    rescue Exception => e
      puts "Error: #{e}"
      nil
      # rubocop:enable Lint/RescueException
    end

    def quit
      @driver&.quit
    end

    private

    def os
      @os ||=
        begin
          host_os = RbConfig::CONFIG["host_os"]
          case host_os
          when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            :windows
          when /darwin|mac os/
            :macosx
          when /linux/
            :linux
          when /solaris|bsd/
            :unix
          else
            raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
          end
        end
    end

    def init_firefox
      # rubocop:disable Style/GuardClause
      if os == :macosx
        Selenium::WebDriver::Firefox.path =
          # File.expand_path("./webdriver/geckodriver-v.33.0-macos-aarch64/geckodriver", __dir__)
          Selenium::WebDriver::Firefox.path = "/Applications/Firefox.app/Contents/MacOS/firefox"
        # Selenium::WebDriver::Firefox.path =
        # File.expand_path("./firefox/Firefox.app/Contents/MacOS/firefox", __dir__)
      else
        raise StandardError, "Unsupported OS: #{os}"
      end
      # rubocop:enable Style/GuardClause

      options = Selenium::WebDriver::Firefox::Options.new log_level: :error
      options.add_argument("--headless")
      options.add_argument("--disable-extensions")
      options.add_argument("--no-sandbox")
      options.add_argument("--disable-application-cache")
      options.add_argument("--disable-gpu")
      options.add_argument("--disable-dev-shm-usage")

      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 9999

      @driver = Selenium::WebDriver.for :firefox, options: options, http_client: client
    end

    def init_chrome
      if os == :macosx
        Selenium::WebDriver::Chrome.path =
          File.expand_path("./webdriver/chromedriver-mac-arm64/chromedriver", __dir__)
      elsif os == :linux
        Selenium::WebDriver::Chrome.path =
          File.expand_path("./webdriver/chromedriver-linux64/chromedriver", __dir__)
      else
        raise Exception, "unknown os: #{os}"
      end

      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--ignore-certificate-errors")
      options.add_argument("--incognito")
      options.add_argument("--disable-dev-shm-usage")
      options.add_argument("--no-sandbox")
      options.add_argument("--headless")

      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 9999

      @driver = Selenium::WebDriver.for :chrome, options:, http_client: client
    end
  end
end
