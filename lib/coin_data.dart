import 'package:bitcoin_ticker/networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '16C87E26-EAA2-4112-A541-7A52EF480AE3';

class CoinData {
  Future<dynamic> getCoinData(String selectedCurrency, String crypto) async {
    var url = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
    NetworkHelper networkHelper = url != null ? NetworkHelper(url) : "";
    var coinData = await networkHelper.getData();
    print(coinData);
    return coinData;
  }
}
