import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';

class OrderUtils{

  static String buildMessageFromCurrentOrder(List<ProductOrderAmountModel> productList) {
    String orderString = '';
    productList.forEach((currentProductOrderAmount) {

      orderString = orderString + currentProductOrderAmount.amount.toString() +
          ' X ' + currentProductOrderAmount.nome +
          '(${currentProductOrderAmount.unita_misura})'+ '';

    });
    return orderString;
  }

  static buildMessageFromCurrentOrderList(List<ProductModel> productList) {
    String orderString = '';
    productList.forEach((currentProductOrderAmount) {

      orderString = orderString + currentProductOrderAmount.prezzo_lordo.toString() +
          ' X ' + currentProductOrderAmount.nome +
          '(${currentProductOrderAmount.unita_misura})'+ '';

    });
    return orderString;

  }

}