# Frequently used functions appended for development convenience

# Effeciently pick a random record from the database
module ActiveRecord
  class Base
    def self.random
      find(pluck(:id).sample)
    end
  end
end

# Strip HTML tags from a string
class String
  def strip_html
    gsub(%r{</?[^>]*>}, "")
  end
end 