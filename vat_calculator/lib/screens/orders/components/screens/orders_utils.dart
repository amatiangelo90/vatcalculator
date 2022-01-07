import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';

class OrderUtils{

  static buildMessageFromCurrentOrderList({List<ProductModel> productList,
    String branchName,
    String orderId,
    String supplierName,
    String storageAddress,
    String storageCity,
    String storageCap,
    String deliveryDate,
    String currentUserName
  }) {
    String orderString = 'Ciao $supplierName,<br><br><br>Ordine #$orderId<br><br><h4>Carrello<br>-------------------------------------<br>';
    productList.forEach((currentProductOrderAmount) {
      if(currentProductOrderAmount.prezzo_lordo != 0){

        orderString = orderString + currentProductOrderAmount.nome +
            ' x ' + currentProductOrderAmount.prezzo_lordo.toString() + ' ${currentProductOrderAmount.unita_misura} <br>';
      }
    });
    orderString = orderString + '-------------------------------------</h4>';
    orderString = orderString + '<br><br>Da consegnare $deliveryDate<br>a $storageCity ($storageCap)<br>in via: $storageAddress.';
    orderString = orderString + '<br><br>Cordiali Saluti<br>${currentUserName}<br><br>$branchName';
    return orderString;
  }

  static buildMessageFromCurrentOrderListFromDraft({List<ProductOrderAmountModel> orderProductList,
    String branchName,
    String orderId,
    String storageAddress,
    String storageCity,
    String storageCap,
    String deliveryDate,
    String currentUserName,
    String supplierName}) {

    String orderString = 'Ciao $supplierName,<br><br><br>Ordine #$orderId<br><br><h4>Carrello<br>-------------------------------------<br>';
    orderProductList.forEach((currentProductOrderAmount) {
      if(currentProductOrderAmount.amount != 0){

        orderString = orderString + currentProductOrderAmount.nome +
            ' x ' + currentProductOrderAmount.amount.toString() + ' ${currentProductOrderAmount.unita_misura} <br>';
      }
    });
    orderString = orderString + '-------------------------------------</h4>';
    orderString = orderString + '<br><br>Da consegnare $deliveryDate<br>a $storageCity ($storageCap)<br>in via: $storageAddress.';
    orderString = orderString + '<br><br>Cordiali Saluti<br>${currentUserName}<br><br>$branchName';
    return orderString;
  }


}