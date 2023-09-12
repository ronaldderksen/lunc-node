// Updated 30-April-23

const fiatSymbols = [
  'SDR/USD',
  'KRW/USD',
  'MNT/USD',
  'EUR/USD',
  'CNY/USD',
  'JPY/USD',
  'GBP/USD',
  'INR/USD',
  'CAD/USD',
  'CHF/USD',
  'HKD/USD',
  'AUD/USD',
  'SGD/USD',
  'THB/USD',
  'SEK/USD',
  'DKK/USD',
  'IDR/USD',
  'PHP/USD',
  'MYR/USD',
  'NOK/USD',
  'TWD/USD',
]

module.exports = {
  port: 8532,
  metricsPort: 8533,
  sentry: '', // sentry dsn (https://sentry.io/ - error reporting service)
  reporter: true,
  slack: {
    // for incident alarm (e.g. exchange shutdown)
    channel: '#bot-test',
    url: '',
  },
  cryptoProvider: {
    adjustTvwap: { symbols: [] },
    fallbackPriority: [
      'binance',
      // 'osmosis', // DO NOT USE THIS. BROKEN PROVIDER
      // 'kraken',
      // 'bitfinex',
      // 'huobi',
      // 'kucoin',
      'coinGecko', // required for USDT/USDC/BUSD to USD quotes.
    ],
    coinGecko: {
      interval: 6 * 1000,
      symbols: [
        'USDT/USD',
        'LUNC/USD',
        'USTC/USD',
      ],
    },
    osmosis: {
      interval: 6 * 1000,
      symbols: [
        'ATOM/USDC',
        'AKT/USDC',
        'JUNO/USDC',
        'SCRT/USDC',
        'STARS/USDC',
        'OSMO/USDC',
        'INJ/USDC',
        'LUNA/USDC',
        'KAVA/USDC',
        'LINK/USDC',
        'DOT/USDC',
        'LUNC/USDC',
      ],
    },
    binance: {
      interval: 6 * 1000,
      symbols: [
        'USDC/USDT',
        'BUSD/USDT',
        'USDC/BUSD',
        'USTC/USDT',
        'USTC/BUSD',
        'LUNC/USDT',
        'LUNC/BUSD',
      ],
    },
    kraken: {
      interval: 6 * 1000,
      symbols: [
        'USDC/USDT',
        'USDC/USD',
      ],
    },
    kucoin: {
      interval: 6 * 1000,
      symbols: [
        'USDC/USDT',
        'LUNC/USDT',
        'USTC/USDT',
      ],
    },
    huobi: {
      symbols: [
        'USTC/USDT',
        'LUNC/USDT',
        'USDC/USDT',
      ],
    },
    bitfinex: {
      symbols: [
      ],
    },
  },
  fiatProvider: {
    fallbackPriority: [
      /* Providers who requires payment to obtain API key */
      // 'fastforex',
      // 'currencylayer',
      // 'fixer',
      // 'alphavantage'
      /* Free providers */
      'exchangerate',
      'frankfurter',
      'fer',
    ],
    // https://exchangerate.host/
    exchangerate: {
      symbols: fiatSymbols,
      interval: 30 * 1000,
      timeout: 5000,
    },
    // https://fer.ee/
    fer: {
      symbols: fiatSymbols.filter((f) => !f.includes('SDR')),
      interval: 30 * 1000,
      timeout: 5000,
    },
    // https://www.frankfurter.app/docs/
    frankfurter: {
      symbols: fiatSymbols.filter((f) => !f.includes('SDR')),
      interval: 30 * 1000,
      timeout: 5000,
    },
    // https://fastforex.readme.io
    // price: $9/month
    fastforex: {
      symbols: fiatSymbols,
      interval: 60 * 1000,
      timeout: 5000,
      apiKey: '', // necessary
    },
    // https://currencylayer.com/product
    // recommend: Enterprise (60second Updates): $59.99/month
    currencylayer: {
      symbols: fiatSymbols,
      interval: 60 * 1000,
      timeout: 5000,
      apiKey: '', // necessary
    },
    // https://www.alphavantage.co/premium/
    // recommend: 150 API request per minute: $99.99/month
    alphavantage: {
      symbols: fiatSymbols,
      interval: 60 * 1000,
      timeout: 5000,
      apiKey: '', // necessary
    },
    // https://fixer.io/product
    // recommend: professional plus(60second Updates): $99.99/month
    fixer: {
      symbols: fiatSymbols,
      interval: 60 * 1000,
      timeout: 5000,
      apiKey: '', // necessary
    },
  },
}
