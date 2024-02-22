module ProductConstants
  MIN_SEARCHABLE_PRICE_CENT = 0
  MAX_SEARCHABLE_PRICE_CENT = 1_000_000
  MAX_NAME_LENGTH = 255
  CURRENCY_CODES = %w[usd eur brl gbp cad aud inr sgd jpy php nzd chf hkd zar twd pln krw ils czk].freeze
  PERMALINK_REGEX = /\A[\w\-]+\z/
end