// Updated 09-Feb-22

const fiatSymbols = [
  'USD/SDR',
  'USD/KRW',
  'USD/MNT',
  'USD/EUR',
  'USD/CNY',
  'USD/JPY',
  'USD/GBP',
  'USD/INR',
  'USD/CAD',
  'USD/CHF',
  'USD/HKD',
  'USD/AUD',
  'USD/SGD',
  'USD/THB',
  'USD/SEK',
  'USD/DKK',
  'USD/IDR',
  'USD/PHP',
  'USD/MYR',
  'USD/NOK',
  'USD/TWD',
]

module.exports = {
  port: 8532,
  metricsPort: 8533,
  sentry: '', // sentry dsn (https://sentry.io/ - error reporting service)
  slack: {
    // for incident alarm (e.g. exchange shutdown)
    channel: '#bot-test',
    url: '',
  },
  lunaProvider: {
    adjustTvwapSymbols: ['LUNC/USDT'],
    huobi: { symbols: ['LUNC/USDT'] },
    binance: { symbols: ['LUNC/USDT'] },
    kucoin: { symbols: ['LUNC/USDT'] },
  },
  cryptoProvider: {
    adjustTvwapSymbols: ['USDT/USD'],
    bitfinex: { symbols: ['USDT/USD'] },
    kraken: { symbols: ['USDT/USD'] },
  },
  fiatProvider: {
    fallbackPriority: ['exchangerate', 'bandprotocol'],
    bandprotocol: {
      // DKK is not supported for bandprotocol
      symbols: fiatSymbols.filter((v) => !v.includes('DKK') && !v.includes('PHP')),
      interval: 60 * 1000,
      timeout: 5000,
      // https://data.bandprotocol.com/
    },
    exchangerate: {
      symbols: fiatSymbols,
      interval: 60 * 1000,
      timeout: 5000,
      // https://exchangerate.host/
    },
  },
  fiatSymbols,
}
