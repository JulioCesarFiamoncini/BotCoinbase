import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mercury_client/mercury_client.dart';

class CoinBaseAPI {
  final String _apiSecretBase64;
  final String _apiKey;
  final String _apiPass;

  final String apiUrl;

  CoinBaseAPI(this._apiSecretBase64, this._apiKey, this._apiPass,
      {this.apiUrl = 'https://api.pro.coinbase.com/'});

  String _signMessage(
      String secretBase64, int timestamp, String method, String requestPath,
      [String? body]) {
    method = method.toUpperCase();

    var key = base64.decode(secretBase64);
    var hmacSha256 = Hmac(sha256, key);

    var msg = '$timestamp$method$requestPath';
    if (body != null) msg += body;

    var msgBytes = utf8.encode(msg);

    var sign = hmacSha256.convert(msgBytes).bytes;
    var signBase64 = base64.encode(sign);

    return signBase64;
  }

  Future<HttpResponse> doCoinbaseRequest(String method, String requestPath,
      [dynamic body]) async {
    var timeStamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    var sign = _signMessage(_apiSecretBase64, timeStamp, method, requestPath);

    var client = HttpClient(apiUrl)
      ..requestHeadersBuilder = (clt, url) => {
            'CB-ACCESS-SIGN': sign,
            'CB-ACCESS-KEY': _apiKey,
            'CB-ACCESS-PASSPHRASE': _apiPass,
            'CB-ACCESS-TIMESTAMP': '$timeStamp',
          };

    var response = await client.request(getHttpMethod(method)!, requestPath);
    return response;
  }

  Future<List<Map>?> getAccounts() async {
    var response = await doCoinbaseRequest('GET', '/accounts');
    if (response.isNotOK || !response.isBodyTypeJSON) return null ;
    var list = response.json as List;
    return list.cast<Map<String,dynamic>>();
  }

  Future<List<Map>?> getProducts() async {
    var response = await doCoinbaseRequest('GET', '/products');
    if (response.isNotOK || !response.isBodyTypeJSON) return null ;
    var list = response.json as List;
    return list.cast<Map<String,dynamic>>();
  }

  Future<List<Map>?> getSingleProduct(String productId) async {
    var response = await doCoinbaseRequest('GET', '/products/<'+productId+'>');
    if (response.isNotOK || !response.isBodyTypeJSON) return null ;
    var list = response.json as List;
    return list.cast<Map<String,dynamic>>();
  }


  Future<List<Map>?> getOrders() async {
    var response = await doCoinbaseRequest('GET', '/orders');
    if (response.isNotOK || !response.isBodyTypeJSON) return null ;
    var list = response.json as List;
    return list.cast<Map<String,dynamic>>();
  }

  Future<List<Map>?> getSingleOrder(String orderId) async {
    var response = await doCoinbaseRequest('GET', '/orders/<'+orderId+'>');
    if (response.isNotOK || !response.isBodyTypeJSON) return null ;
    var list = response.json as List;
    return list.cast<Map<String,dynamic>>();
  }

  Future<List<Map>?> getProductOrderBook(String productId, String level) async {
    var response = await doCoinbaseRequest('GET', '/products/<'+productId+'>/'+level);
    if (response.isNotOK || !response.isBodyTypeJSON) return null ;
    var list = response.json as List;
    return list.cast<Map<String,dynamic>>();
  }



}
