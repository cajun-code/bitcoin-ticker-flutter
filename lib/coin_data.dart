import 'package:http/http.dart' as http;
import 'dart:convert';


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

class CoinData {
  Future<String> getCoinData(String crypto, String currency) async { //
    String url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$currency';
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return data['last'].toString();
    }else{
      throw "Could not recieve data from server";
    }
  }

}
