export const currencyInfo = {
  USD: { symbol: '$', divisor: 100 }, // United States Dollar
  EUR: { symbol: '€', divisor: 100 }, // Euro
  BRL: { symbol: 'R$', divisor: 100 },  // Brazilian Real
  GBP: { symbol: '£', divisor: 100 }, // British Pound
  CAD: { symbol: 'CAD$', divisor: 100 }, // Canadian Dollar
  AUD: { symbol: 'A$', divisor: 100 },  // Australian Dollar
  INR: { symbol: '₹', divisor: 100 }, // Indian Rupee
  SGD: { symbol: 'SGD$', divisor: 100 }, // Singapore Dollar
  JPY: { symbol: '¥', divisor: 1 }, // Japanese Yen
  PHP: { symbol: '₱', divisor: 100 }, // Philippine Peso
  NZD: { symbol: 'NZ$', divisor: 100 }, // New Zealand Dollar
  CHF: { symbol: 'CHF ', divisor: 100 },  // Swiss Franc
  HKD: { symbol: 'HK$', divisor: 100 },  // Hong Kong Dollar
  ZAR: { symbol: 'R', divisor: 100 }, // South African Rand
  TWD: { symbol: 'NT$', divisor: 100 },  // New Taiwan Dollar
  PLN: { symbol: 'zł', divisor: 100 },  // Polish Zloty
  KRW: { symbol: '₩', divisor: 1 }, // South Korean Won
  ILS: { symbol: '₪', divisor: 100 },  // Israeli New Shekel
  CZK: { symbol: 'Kč', divisor: 100 } // Czech Koruna
};

export function formatPrice(priceInCents, currency, skipSymbol = false, fixed = 2, plusCondition = false) {
  // Check if the currency is supported
  if (!currencyInfo[currency.toUpperCase()]) {
    console.error('Unsupported currency');
    return null;
  }

  const { symbol, divisor } = currencyInfo[currency.toUpperCase()];
  let formattedPrice = (Number(priceInCents) / divisor).toFixed(fixed);

  // Check if after applying toFixed, the number ends with zeroes
  // If so, convert it to a number and back to string to remove trailing zeroes
  if (parseFloat(formattedPrice).toString() === parseFloat(formattedPrice).toFixed(0)) {
    formattedPrice = parseFloat(formattedPrice).toFixed(0);
  }

  // Decide whether to include the currency symbol based on skipSymbol
  if (skipSymbol) {
    return formattedPrice + (plusCondition ? '+' : '');
  }

  return `${symbol}${formattedPrice}${plusCondition ? '+' : ''}`;
}

