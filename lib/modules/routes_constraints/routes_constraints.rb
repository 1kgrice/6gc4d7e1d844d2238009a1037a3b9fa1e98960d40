#frozen_string_literal: true

module RoutesConstraints
  class DashboardSubdomain
    def self.matches?(request)
      request.subdomain == 'app'
    end
  end

  class DiscoverSubdomain
    def self.matches?(request)
      request.subdomain == 'discover'
    end
  end

  class WildcardSubdomain
    def self.matches?(request)
      request.subdomain.present? && request.subdomain != 'www'
    end
  end

  class NoSubdomain
    def self.matches?(request)
      request.subdomain.blank? || request.subdomain == 'www'
    end
  end
end