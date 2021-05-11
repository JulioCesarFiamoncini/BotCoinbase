import 'package:botCoinbase/BotCoinbase.dart';

String apiSecretBase64 = 'fN6yy3YHw6sHQcULRFAjXm9UK42vyxyoum5orGssA6YLWwQLHPOos4MywrmWjdfzynnYMze1XhY9qDYlzVDrWw==';
String apiKey = '772acfb08bd0933e6361efe968e372ef';
String apiPass = 'FormulaMD%';

Future main(List<String> arguments) async {
  var coinBaseAPI = CoinBaseAPI(apiSecretBase64, apiKey, apiPass);

  var accounts = await coinBaseAPI.getAccounts();
  print(accounts);

  var products = await coinBaseAPI.getProducts();
  print(products);

  var singleProduct = await coinBaseAPI.getSingleProduct('BTC-USDC');
  print(singleProduct);

  var orders = await coinBaseAPI.getOrders();
  print(orders);

  var singleOrder = await coinBaseAPI.getSingleOrder('');
  print(singleOrder);

  // products/BTC-USD/book
  var productOrderBook = await coinBaseAPI.getProductOrderBook('BTC-USDC','book');
  print(productOrderBook);

  var productOrderBookLevel3 = await coinBaseAPI.getProductOrderBook('BTC-USDC','book?level=3');
  print(productOrderBookLevel3);



}

/*
  https://docs.pro.coinbase.com/#products
  https://docs.pro.coinbase.com/#get-single-product
  https://docs.pro.coinbase.com/#list-orders
  https://docs.pro.coinbase.com/#get-product-order-book

  https://docs.pro.coinbase.com/#place-a-new-order
  https://docs.pro.coinbase.com/#cancel-an-order


  https://www.ionos.com/digitalguide/hosting/technical-matters/http-request/
 */