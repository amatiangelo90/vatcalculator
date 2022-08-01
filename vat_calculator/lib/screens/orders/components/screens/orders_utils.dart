import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';

import '../../../../client/vatservice/model/storage_product_model.dart';

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
      if(currentProductOrderAmount.orderItems != 0){

        orderString = orderString + currentProductOrderAmount.nome +
            ' x ' + currentProductOrderAmount.orderItems.toString() + ' ${currentProductOrderAmount.unita_misura} <br>';
      }
    });
    orderString = orderString + '-------------------------------------</h4>';
    orderString = orderString + '<br><br>Da consegnare $deliveryDate<br>a $storageCity ($storageCap)<br>in via: $storageAddress.';
    orderString = orderString + '<br><br>Cordiali Saluti<br>${currentUserName}<br><br>$branchName';
    return orderString;
  }

  static buildMessageFromCurrentOrderListStorageOrder({List<StorageProductModel> orderedMapBySuppliers,
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
    orderedMapBySuppliers.forEach((currentProductOrderAmount) {
      if(currentProductOrderAmount.extra != 0){

        orderString = orderString + currentProductOrderAmount.productName +
            ' x ' + currentProductOrderAmount.extra.toString() + ' ${currentProductOrderAmount.unitMeasure} <br>';
      }
    });
    orderString = orderString + '-------------------------------------</h4>';
    orderString = orderString + '<br><br>Da consegnare $deliveryDate<br>a $storageCity ($storageCap)<br>in via: $storageAddress.';
    orderString = orderString + '<br><br>Cordiali Saluti<br>${currentUserName}<br><br>$branchName';
    return orderString;
  }

  static buildWhatsAppMessageFromCurrentOrderList({List<ProductModel> productList,
    String branchName,
    String orderId,
    String supplierName,
    String storageAddress,
    String storageCity,
    String storageCap,
    String deliveryDate,
    String currentUserName}) {

    print('MATTIALIUZZI');
    print(productList.toString());

    String orderString = 'Ciao $supplierName,%0a%0aOrdine #$orderId%0a%0aCarrello%0a----------------%0a';
    productList.forEach((currentProductOrderAmount) {
      if(currentProductOrderAmount.orderItems != 0){
        orderString = orderString + currentProductOrderAmount.nome +
            ' x ' + currentProductOrderAmount.orderItems.toString() + ' ${currentProductOrderAmount.unita_misura} %0a';
      }
    });
    orderString = orderString + '----------------';
    orderString = orderString + '%0a%0aDa consegnare $deliveryDate%0aa $storageCity ($storageCap)%0ain via: $storageAddress.';
    orderString = orderString + '%0a%0aCordiali Saluti%0a${currentUserName}%0a%0a$branchName';
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