import 'dart:convert';

import 'package:http/http.dart' as http;

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
const apiKey = '';

class CoinData {
  Future<Map<String, String>> getData(String currency) async {
    Uri url;
    http.Response response;
    double rate;
    Map<String, String> mapCoinValues = {};

    for (String crypto in cryptoList) {
      url = Uri.parse('$coinAPIURL/$crypto/$currency?apikey=$apiKey');
      response = await http.get(url);

      if (response.statusCode == 200) {
        dynamic coinData = jsonDecode(response.body);
        rate = coinData['rate'];
        mapCoinValues[crypto] = rate.toStringAsFixed(1);
      } else {
        print('status code = ${response.statusCode}');
        print(response.body);
      }
    }

    return mapCoinValues;
  }
}
