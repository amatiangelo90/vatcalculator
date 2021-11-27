import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';

import 'constant/utils_vatservice.dart';
import 'model/branch_model.dart';
import 'model/order_model.dart';
import 'model/product_model.dart';
import 'model/product_order_amount_model.dart';
import 'model/recessed_model.dart';
import 'model/save_product_into_storage_request.dart';
import 'model/storage_product_model.dart';
import 'model/user_branch_relation_model.dart';
import 'model/user_model.dart';

class ClientVatService{

  Future<Response> performSaveUser(String firstName,String lastName, String phoneNumber, String eMail, String privileges, int relatedUserId) async {
    var dio = Dio();
    String body = json.encode(
        UserModel(
            name: firstName,
            lastName: lastName,
            mail: eMail,
            phone: phoneNumber,
            privilege: privileges,
            relatedUserId: relatedUserId,
        ).toMap());

    Response post;
    try{
      post = await dio.post(

        VAT_SERVICE_URL_SAVE_USER,
        data: body,
      );

      print('Request' + body);
      print('Response From VatService (' + VAT_SERVICE_URL_SAVE_USER + '): ' + post.data.toString());

    }catch(e){
      print(e);
      rethrow;
    }
    return post;
  }
  Future<Response> checkSpecialUser(UserModel usermodel) async {

    var dio = Dio();

    String body = json.encode(usermodel.toMap());

    Response post;
    print('Is current user with mail ['+ usermodel.mail+'] '
        'in special list? Calling (' + VAT_SERVICE_URL_CHECK_SPECIAL_USER + ') ');

    try{
      print('Request' + body);
      post = await dio.post(
        VAT_SERVICE_URL_CHECK_SPECIAL_USER,
        data: body,
      );

     print('Response from [' + VAT_SERVICE_URL_CHECK_SPECIAL_USER + ']' + post.toString());

    }catch(e){
      print(e);
      rethrow;
    }
    return post;
  }

  //Action Done
  Future<Response> performSaveRecessed(
      double amount, String description, int iva, int dateTimeRecessed, int pkBranchId, ActionModel actionModel) async{

    var dio = Dio();

    String body = json.encode(
        RecessedModel(
            amount: amount,
            vat: iva,
            dateTimeRecessed: dateTimeRecessed,
            description: description,
            dateTimeRecessedInsert: DateTime.now().millisecondsSinceEpoch,
            fkBranchId: pkBranchId,
            pkRecessedId: null).toMap());

    Response post;
    print('Save import recessed request body: ' + body);
    try{
      post = await dio.post(

        VAT_SERVICE_URL_SAVE_RECESSED_FOR_BRANCH,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_RECESSED_FOR_BRANCH + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<Response> performSaveStorage({StorageModel storageModel, ActionModel actionModel}) async{
    var dio = Dio();
    String body = json.encode(
        storageModel.toMap());

    Response post;
    print('Save storage : ' + body);
    print('Calling save storage method ' + VAT_SERVICE_URL_SAVE_STORAGE_FOR_BRANCH + ' to save storage for branch with id ' + storageModel.fkBranchId.toString());
    try{
      post = await dio.post(

        VAT_SERVICE_URL_SAVE_STORAGE_FOR_BRANCH,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_STORAGE_FOR_BRANCH + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<Response> performSaveOrder({OrderModel orderModel, ActionModel actionModel}) async {

    var dio = Dio();
    String body = json.encode(
        orderModel.toMap());

    Response post;
    print('Save order : ' + body);
    print('Calling save order method ' + VAT_SERVICE_URL_SAVE_ORDER + ' to save order for branch with id ' + orderModel.fk_branch_id.toString());
    try{
      post = await dio.post(
        VAT_SERVICE_URL_SAVE_ORDER,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_ORDER + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<ProductOrderAmountModel>> retrieveProductByOrderId(OrderModel orderModel) async {

    var dio = Dio();

    List<ProductOrderAmountModel> prodOrderList = [];
    String body = json.encode(
        orderModel.toMap());

    Response post;
    print('Retrieve products by order id: ' + body);
    print('Calling retrieve method to get products by order id ' + VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID,
        data: body,
      );


      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((productOrderElement) {

        prodOrderList.add(
            ProductOrderAmountModel(
              pkProductId: productOrderElement['pkProductId'],
              nome: productOrderElement['name'],
              codice: productOrderElement['code'],
              unita_misura: productOrderElement['measureUnit'],
              iva_applicata: productOrderElement['vatApplied'],
              prezzo_lordo: productOrderElement['price'],
              descrizione: productOrderElement['description'],
              categoria: productOrderElement['category'],
              fkSupplierId: productOrderElement['fkSupplierId'],
              amount: productOrderElement['amount'],
              pkOrderProductId: productOrderElement['pkOrderProductId'],
              fkOrderId: productOrderElement['fkOrderId'],
            )
        );
      });
      print('Response from ($VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID): ' + prodOrderList.toString());
      return prodOrderList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<Response> performSaveSupplier({ResponseAnagraficaFornitori anagraficaFornitore, ActionModel actionModel}) async{

    var dio = Dio();

    String body = json.encode(
        anagraficaFornitore.toMap());
    Response post;

    print('Save supplier ($VAT_SERVICE_URL_SAVE_SUPPLIER_FOR_BRANCH) request body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_SAVE_SUPPLIER_FOR_BRANCH,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_SUPPLIER_FOR_BRANCH + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<Response> performSaveBranch(BranchModel company, ActionModel actionModel) async {

    var dio = Dio();

    String body = json.encode(
        company.toMap());


    print('Calling ' + VAT_SERVICE_URL_SAVE_BRANCH + '...');
    print('Body Request Save branch: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_SAVE_BRANCH,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_BRANCH + '): ' + post.data.toString());
        try{
          actionModel.fkBranchId = post.data;
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> performSaveProduct({ProductModel product, ActionModel actionModel}) async {

    var dio = Dio();
    String body = json.encode(
        product.toMap());

    print('Calling ' + VAT_SERVICE_URL_SAVE_PRODUCT + '...');
    print('Body Request Save product: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_SAVE_PRODUCT,
        data: body,
      );
      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_PRODUCT + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> performSaveProductIntoStorage({SaveProductToStorageRequest saveProductToStorageRequest, ActionModel actionModel}) async {

    var dio = Dio();

    String body = json.encode(
        saveProductToStorageRequest.toMap());


    print('Calling ' + VAT_SERVICE_URL_SAVE_PRODUCT_INTO_STORAGE + '...');
    print('Body Request Save product into storage with id [' + saveProductToStorageRequest.fkStorageId.toString() +' ]: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_SAVE_PRODUCT_INTO_STORAGE,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_PRODUCT_INTO_STORAGE + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }


      return post;
    }catch(e){
      rethrow;
    }
  }

  Future<Response> performSaveProductIntoOrder(double amount, int productId, int orderId) async {

    var dio = Dio();

    String body = json.encode(
        {"amount" : amount,
         "fk_product_id" : productId,
         "fk_order_id" : orderId
        });


    print('Calling ' + VAT_SERVICE_URL_SAVE_PRODUCT_INTO_ORDER + '...');
    print('Body Request Save product into order with id [' + orderId.toString() +' ]: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_SAVE_PRODUCT_INTO_ORDER,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_PRODUCT_INTO_ORDER + '): ' + post.data.toString());
      }


      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> performUpdateProduct({ProductModel product}) async {

    var dio = Dio();

    String body = json.encode(
        product.toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_PRODUCT + '...');
    print('Body Request update product: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_PRODUCT,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_PRODUCT + '): ' + post.data.toString());
      }

      return post;
    }catch(e){
      rethrow;
    }

  }
  //Action Done
  Future<Response> performDeleteProduct({ProductModel product, ActionModel actionModel}) async {

    var dio = Dio();

    String body = json.encode(
        product.toMap());


    print('Calling ' + VAT_SERVICE_URL_DELETE_PRODUCT + '...');
    print('Body Request delete product: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_PRODUCT,
        data: body,
      );



      if(post != null){

        print('Response From VatService removed product(' + VAT_SERVICE_URL_DELETE_PRODUCT + '): ' + post.data.toString());

        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> removeProductFromStorage({StorageProductModel storageProductModel, ActionModel actionModel}) async {

    var dio = Dio();

    String body = json.encode(
        storageProductModel.toMap());


    print('Calling ' + VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE + '...');
    print('Body Request delete product from storage: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE,
        data: body,
      );

      if(post != null && post.data){
        print('Response From VatService (' + VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE + '): ' + post.data);
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      rethrow;
    }
  }

  Future<UserModel> retrieveUserByEmail(String eMail) async {

    var dio = Dio();

    print('Retrieve user by email : ' + eMail);
    String body = json.encode(
        UserModel(
            name: '',
            lastName: '',
            mail: eMail,
            phone: '',
            privilege: ''
        ).toMap());

    print('Request body for Vat Service (Retrieve User by Email): ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL,
        data: body,
      );


      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL + '): ' + post.data.toString());

      UserModel userModel = UserModel(
        name: post.data['name'],
        id: post.data['id'],
        lastName: post.data['lastName'],
        phone: post.data['phone'],
        mail: post.data['mail'],
        privilege: post.data['privilege']
      );

      return userModel;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<BranchModel>> retrieveBranchesByUserId(int id) async {

    var dio = Dio();

    List<BranchModel> branchList = [];

    print('Retrieve branches list for the user with id ' + id.toString());
    print('Url: ' + VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USEREMAIL);
    String body = json.encode(
        UserModel(
            id: id,
            name: '',
            lastName: '',
            mail: '',
            phone: ''
        ).toMap());

    print('Retrieve branches body request: '  + body);
    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USEREMAIL,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USEREMAIL + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((branchElement) {

        branchList.add(
            BranchModel(
                pkBranchId: branchElement['pkBranchId'],
                companyName: branchElement['name'],
                eMail: branchElement['email'],
                vatNumber: branchElement['vatNumber'],
                address: branchElement['address'],
                city: branchElement['city'],
                cap: branchElement['cap'],
                phoneNumber: branchElement['phone'],
                providerFatture: branchElement['provider'],
                apiKeyOrUser: branchElement['idKeyUser'],
                apiUidOrPassword: branchElement['idUidPassword'],
                accessPrivilege: branchElement['accessPrivilege']
            ));
      });
      return branchList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<ActionModel>> retrieveActionsByBranchId(int branchId) async {

    var dio = Dio();

    List<ActionModel> actionModelList = [];

    print('Retrieve actions list for the branch with id ' + branchId.toString());
    print('Url: ' + VAT_SERVICE_URL_RETRIEVE_ACTIONS_BY_BRANCH_ID);
    String body = json.encode(
        BranchModel(
            pkBranchId: branchId
        ).toMap());

    print('Retrieve actions body request: ' + body);
    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_ACTIONS_BY_BRANCH_ID,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_ACTIONS_BY_BRANCH_ID + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((actionElement) {

        actionModelList.add(
            ActionModel(
              pkActionId: actionElement['pkActionId'],
              user: actionElement['user'],
              fkBranchId: actionElement['fkBranchId'],
              description: actionElement['description'],
              date: actionElement['date'],
              type: actionElement['type'],

            ));
      });
      return actionModelList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<StorageProductModel>> retrieveRelationalModelProductsStorage(int pkStorageId) async {

    var dio = Dio();

    List<StorageProductModel> storageProoductModelRelationList = [];

    print('Retrieve relation object for store with id : ' + pkStorageId.toString());
    print('Url: ' + VAT_SERVICE_URL_RETRIEVE_RELATIONAL_PRODUCTS_STORAGE);
    String body = json.encode(
        StorageModel(
            pkStorageId: pkStorageId,
            name: '',
            code: '',
            creationDate: null,
            address: '',
            city: '',
            cap: '',
            fkBranchId: 0,
        ).toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_RELATIONAL_PRODUCTS_STORAGE,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_RELATIONAL_PRODUCTS_STORAGE + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((branchElement) {

        storageProoductModelRelationList.add(
            StorageProductModel(
              pkStorageProductId: branchElement['pkStorageProductId'],
              supplierId: branchElement['supplierId'],
              available: branchElement['available'],
              fkProductId: branchElement['fkProductId'],
              productName: branchElement['productName'],
              stock: branchElement['stock'],
              fkStorageId: branchElement['fkStorageId'],
              supplierName: branchElement['supplierName'],
              price: branchElement['price'],
              vatApplied : branchElement['vatApplied'],
              unitMeasure : branchElement['unitMeasure'],

            ));
      });
      return storageProoductModelRelationList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<RecessedModel>> retrieveRecessedListByBranch(BranchModel currentBranch) async {
    var dio = Dio();

    List<RecessedModel> recessedList = [];


    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve recessed list by branch): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((recessedElement) {

        recessedList.add(
            RecessedModel(
                fkBranchId: recessedElement['fkBranchId'],
                description: recessedElement['description'],
                vat: recessedElement['vat'],
                dateTimeRecessed: recessedElement['dateTimeRecessed'],
                dateTimeRecessedInsert: recessedElement['dateTimeRecessedInsert'],
                amount: recessedElement['amount'],
                pkRecessedId: recessedElement['pkRecessedId']
            ));
      });
      return recessedList;
  }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }
  Future<List<OrderModel>> retrieveOrdersByBranch(BranchModel currentBranch) async {
    var dio = Dio();

    List<OrderModel> ordersList = [];


    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_ORDERS_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve recessed list by branch): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_ORDERS_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((orderElement) {

        ordersList.add(
            OrderModel(
                pk_order_id: orderElement['pk_order_id'],
                code: orderElement['code'],
                total: orderElement['total'],
                delivery_date: orderElement['delivery_date'],
                creation_date: orderElement['creation_date'],
                fk_supplier_id: orderElement['fk_supplier_id'],
                fk_user_id: orderElement['fk_user_id'],
                fk_storage_id: orderElement['fk_storage_id'],
                fk_branch_id: orderElement['fk_branch_id'],
                details: orderElement['details'],
                status: orderElement['status'],
                closedby: orderElement['closedby']
            ));
      });
      return ordersList;
  }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }
  Future<List<ResponseAnagraficaFornitori>> retrieveSuppliersListByBranch(BranchModel currentBranch) async {
    var dio = Dio();

    List<ResponseAnagraficaFornitori> suppliersList = [];

    String body = json.encode(
        currentBranch.toMap());

    Response post;
    print('Request body for Vat Service (Retrieve Suppliers list by branch): ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_BRANCHES,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((supplierElement) {

        suppliersList.add(
            ResponseAnagraficaFornitori(
              pkSupplierId: supplierElement['pk_supplier_id'],
              cf: supplierElement['cf'],
              extra: supplierElement['extra'],
              fax: supplierElement['fax'],
              id: supplierElement['id'],
              indirizzo_cap: supplierElement['indirizzo_cap'],
              indirizzo_citta: supplierElement['indirizzo_citta'],
              indirizzo_extra: supplierElement['indirizzo_extra'],
              indirizzo_provincia: supplierElement['indirizzo_provincia'],
              indirizzo_via: supplierElement['indirizzo_via'],
              mail: supplierElement['mail'],
              nome: supplierElement['name'],
              paese: supplierElement['paese'],
              pec: supplierElement['pec'],
              piva: supplierElement['piva'],
              referente: supplierElement['referente'],
              tel: supplierElement['tel'],
              fkBranchId: supplierElement['fkBranchId'],
            ));
      });
      return suppliersList;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<ProductModel>> retrieveProductsBySupplier(ResponseAnagraficaFornitori currentSupplier) async {
    var dio = Dio();
    List<ProductModel> productsList = [];

    String body = json.encode(
        currentSupplier.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_SUPPLIER,
        data: body,
      );

      print('Request body for Vat Service (Retrieve products list by supplier): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_SUPPLIER + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((product) {

        productsList.add(
            ProductModel(
                pkProductId: product['pkProductId'],
                nome: product['name'],
                codice: product['code'],
                unita_misura: product['measureUnit'],
                iva_applicata: product['vatApplied'],
                prezzo_lordo: product['price'],
                descrizione: product['description'],
                categoria: product['category'],
                fkSupplierId: product['fkSupplierId']));
      });
      return productsList;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }
  Future<List<ProductModel>> retrieveProductsByBranch(BranchModel branchModel) async {
    var dio = Dio();
    List<ProductModel> productsList = [];

    String body = json.encode(
        branchModel.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_BRANCH,
        data: body,
      );

      print('Request body for Vat Service (Retrieve products list by branch id filtering on suppliers): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_BRANCH + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((product) {

        productsList.add(
            ProductModel(
                pkProductId: product['pkProductId'],
                nome: product['name'],
                codice: product['code'],
                unita_misura: product['measureUnit'],
                iva_applicata: product['vatApplied'],
                prezzo_lordo: product['price'],
                descrizione: product['description'],
                categoria: product['category'],
                fkSupplierId: product['fkSupplierId']));
      });
      return productsList;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }
  Future<List<StorageModel>> retrieveStorageListByBranch(BranchModel currentBranch) async {
    var dio = Dio();
    List<StorageModel> storageList = [];

    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_STORAGE_BY_BRANCH,
        data: body,
      );

      print('Request body for Vat Service (Retrieve storage list by branch): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_STORAGE_BY_BRANCH + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((storage) {

        storageList.add(
          StorageModel(
              pkStorageId: storage['pk_storage_id'],
              name: storage['name'],
              code: storage['code'],
              creationDate: DateTime.fromMillisecondsSinceEpoch(storage['creation_date']),
              address: storage['address'],
              city: storage['city'],
              cap: storage['cap'],
              fkBranchId: storage['fk_branch_id']));
      });

      return storageList;
    }catch(e){
      print('Errore retrieving storage model : ');
      print(e);
      rethrow;
    }
  }
  Future<List<BranchModel>> retrieveBranchByBranchId(String codeBranch) async {
    var dio = Dio();

    List<BranchModel> branchList = [];

    print('Retrieve branch by id ' + codeBranch);
    print('Url: ' + VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_BRANCH_ID);
    String body = json.encode(
        BranchModel(
            pkBranchId: int.parse(codeBranch),
            accessPrivilege: '',
            providerFatture: '',
            apiKeyOrUser: '',
            apiUidOrPassword: '',
            eMail: '',
            phoneNumber: '',
            companyName: '',
            vatNumber: '',
            address: '',
            cap: 00000,
            city: ''
        ).toMap());

    print('Retrieve branches body request: '  + body);
    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_BRANCH_ID,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_BRANCH_ID + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((branchElement) {

        branchList.add(
            BranchModel(
                pkBranchId: branchElement['pkBranchId'],
                companyName: branchElement['name'],
                eMail: branchElement['email'],
                vatNumber: branchElement['vatNumber'],
                address: branchElement['address'],
                city: branchElement['city'],
                cap: branchElement['cap'],
                phoneNumber: branchElement['phone'],
                providerFatture: branchElement['provider'],
                apiKeyOrUser: branchElement['idKeyUser'],
                apiUidOrPassword: branchElement['idUidPassword'],
                accessPrivilege: branchElement['accessPrivilege']
            ));
      });
      return branchList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<UserModel>> retrieveUserListRelatedWithBranchByBranchId(BranchModel branchModel) async {

    var dio = Dio();

    List<UserModel> userModelList = [];
    String body = json.encode(
        branchModel.toMap());

    Response post;
    print('Retrieve users list, related on the same branch, by branch id: ' + body);
    print('Calling' + VAT_SERVICE_URL_RETRIEVE_USERS_LIST_RELATIONED_ON_BRANCH_BY_BRANCH_ID);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_USERS_LIST_RELATIONED_ON_BRANCH_BY_BRANCH_ID,
        data: body,
      );


      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((userElement) {

        userModelList.add(
            UserModel(
                id: userElement['id'],
                name: userElement['name'],
                lastName: userElement['lastName'],
                phone: userElement['phone'],
                mail: userElement['mail'],
                privilege: userElement['privilege'],
                relatedUserId: userElement['relatedUserId'])
        );
      });
      print('Response from ($VAT_SERVICE_URL_RETRIEVE_USERS_LIST_RELATIONED_ON_BRANCH_BY_BRANCH_ID): ' + userModelList.toString());
      return userModelList;

    }catch(e){
      print(e);
      rethrow;
    }
  }

  //Action Done
  Future<void> updateStock({List<StorageProductModel> currentStorageProductListForCurrentStorageUnload, ActionModel actionModel}) async {
    var dio = Dio();
    String body = '[';
    currentStorageProductListForCurrentStorageUnload.forEach((currentStorageProductElement) {
      body = body + json.encode(
          currentStorageProductElement.toMap()) + ',';
    });
    body = body.substring(0, body.length - 1);
    body = body + ']';

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_STOCK,
        data: body,
      );

      if(post != null){
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      print('Request body for Vat Service (Update Stock): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_UPDATE_STOCK + '): ' + post.toString());

    }catch(e){
      print('Errore retrieving storage model : ');
      print(e);
      rethrow;
    }
  }
  //Action DONE
  Future<void> deleteOrder({OrderModel orderModel, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        orderModel.toMap());

    Response post;
    print('Delete order : ' + body);
    print('Calling delete order method ' + VAT_SERVICE_URL_DELETE_ORDER + ' to delete order for branch with id ' + orderModel.fk_branch_id.toString());
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_ORDER,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_DELETE_ORDER + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<void> deleteStorage({StorageModel storageModel, ActionModel actionModel}) async{
    var dio = Dio();

    String body = json.encode(
        storageModel.toMap());

    Response post;
    print('Calling delete storage method ' + VAT_SERVICE_URL_DELETE_STORAGE + ' to delete storage ${storageModel.name} from current branch ');
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_STORAGE,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_DELETE_STORAGE + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<void> updateOrderStatus({OrderModel orderModel, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        orderModel.toMap());

    Response post;
    print('Update order with id : ' + orderModel.pk_order_id.toString() +  ' to status : ' + orderModel.status);
    print('Calling update order method ' + VAT_SERVICE_URL_UPDATE_ORDER_STATUS_BY_ID + ' to modify order for branch with id ' + orderModel.fk_branch_id.toString());
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_ORDER_STATUS_BY_ID,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_ORDER_STATUS_BY_ID + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<Response> addProviderDetailsToBranch({BranchModel branchModel, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        branchModel.toMap());

    Response post;
    print('Add provider configuration to  : ' + branchModel.pkBranchId.toString());
    print('Calling update order method ' + VAT_SERVICE_URL_UPDATE_BRANCH_ADD_PROVIDER_FATTURE + ' to modify provider for branch with id ' + branchModel.pkBranchId.toString());
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_BRANCH_ADD_PROVIDER_FATTURE,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_BRANCH_ADD_PROVIDER_FATTURE + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  Future<List<ResponseAnagraficaFornitori>> retrieveSuppliersListByCode({String code}) async {
    var dio = Dio();

    List<ResponseAnagraficaFornitori> suppliersList = [];

    String body = json.encode(
        ResponseAnagraficaFornitori(
          pkSupplierId: 0,
          cf: '',
          extra: code,
          fax: '',
          id: '',
          indirizzo_cap:'',
          indirizzo_citta: '',
          indirizzo_extra: '',
          indirizzo_provincia: '',
          indirizzo_via: '',
          mail: '',
          nome: '',
          paese: '',
          pec: '',
          piva: '',
          referente: '',
          tel: '',
          fkBranchId: 0,
        ).toMap());

    Response post;
    print('Request body for Vat Service (Retrieve Suppliers list by branch): ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_CODE_ALIAS_EXTRA,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_CODE_ALIAS_EXTRA + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((supplierElement) {

        suppliersList.add(ResponseAnagraficaFornitori(
          pkSupplierId: supplierElement['pk_supplier_id'],
          cf: supplierElement['cf'],
          extra: supplierElement['extra'],
          fax: supplierElement['fax'],
          id: supplierElement['id'],
          indirizzo_cap: supplierElement['indirizzo_cap'],
          indirizzo_citta: supplierElement['indirizzo_citta'],
          indirizzo_extra: supplierElement['indirizzo_extra'],
          indirizzo_provincia: supplierElement['indirizzo_provincia'],
          indirizzo_via: supplierElement['indirizzo_via'],
          mail: supplierElement['mail'],
          nome: supplierElement['name'],
          paese: supplierElement['paese'],
          pec: supplierElement['pec'],
          piva: supplierElement['piva'],
          referente: supplierElement['referente'],
          tel: supplierElement['tel'],
          fkBranchId: supplierElement['fkBranchId'],
        ));
      });
      return suppliersList;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<int> addSupplierToCurrentBranch({ResponseAnagraficaFornitori supplierRetrievedByCodeToUpdateRelationTableBranchSupplier, ActionModel actionModel}) async {
    var dio = Dio();

    List<ResponseAnagraficaFornitori> suppliersList = [];

    String body = json.encode(
        supplierRetrievedByCodeToUpdateRelationTableBranchSupplier.toMap());

    Response post;
    print('Request body for Vat Service (Add supplier to brancg): ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_ADD_SUPPLIER_TO_CURRENT_BRANCH,
        data: body,
      );

      print('Response From Vat Service add supplier to branch (' + VAT_SERVICE_ADD_SUPPLIER_TO_CURRENT_BRANCH + '): ' + post.data.toString());

      if(post != null){
        print('Adding action : ' + actionModel.toMap().toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      int result = post.data;
      return result;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  //Action Done
  Future<void> removeSupplierFromCurrentBranch({ResponseAnagraficaFornitori requestRemoveSupplierFromBranch,
    ActionModel actionModel}) async {
    var dio = Dio();
    String body = json.encode(
        requestRemoveSupplierFromBranch.toMap());

    print('Calling ' + VAT_SERVICE_URL_REMOVE_SUPPLIER_FROM_BRANCH + '...');
    print('Body Request remove supplier from branch: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_REMOVE_SUPPLIER_FROM_BRANCH,
        data: body,
      );

      if(post != null){
        print('Response From VatService remove supplier (' + VAT_SERVICE_URL_REMOVE_SUPPLIER_FROM_BRANCH + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> removeProviderFromBranch({BranchModel branchModel, ActionModel actionModel}) async {
    var dio = Dio();
    String body = json.encode(
        branchModel.toMap());
    print('Calling ' + VAT_SERVICE_URL_REMOVE_PROVIDER_FROM_BRANCH + '...');
    print('Body Request remove provider from branch: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_REMOVE_PROVIDER_FROM_BRANCH,
        data: body,
      );

      if(post != null){
        print('Response From VatService (' + VAT_SERVICE_URL_REMOVE_PROVIDER_FROM_BRANCH + '). Rows Affected: ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> createUserBranchRelation({int fkUserId, int fkBranchId, String accessPrivilege, ActionModel actionModel}) async {

    var dio = Dio();

    print('Create relation between User with id $fkUserId and branch with id $fkBranchId. Access level : $accessPrivilege');
    String body = json.encode(
        UserBranchRelationModel(
            pkUserBranchId: 0,
            fkUserId: fkUserId,
            fkBranchId: fkBranchId,
            accessPrivilege: accessPrivilege
        ).toMap());
    print('Calling the following endpoint $VAT_SERVICE_URL_CREATE_RELATION_BETWEEN_USER_AND_BRANCH with body request $body');

    Response post;
    try {
      post = await dio.post(
        VAT_SERVICE_URL_CREATE_RELATION_BETWEEN_USER_AND_BRANCH,
        data: body,
      );

      if(post != null){
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      print(e);
      return null;
    }
  }
  //Action Done
  Future<Response> updatePrivilegeForUserBranchRelation({int branchId, int userId, String privilegeType, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        UserBranchRelationModel(pkUserBranchId: 0,
            fkBranchId: branchId,
            fkUserId: userId,
            accessPrivilege: privilegeType)
            .toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_WITH_NEW_ACCESS_PRIVILEGE + '...');
    print('Body Request update user branches table with new access privilege for current user: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_WITH_NEW_ACCESS_PRIVILEGE,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_WITH_NEW_ACCESS_PRIVILEGE + '): ' + post.data.toString());
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      rethrow;
    }
  }
  //Action Done
  Future<Response> removeUserBranchRelation({int branchId, int userId, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        UserBranchRelationModel(pkUserBranchId: 0,
            fkBranchId: branchId,
            fkUserId: userId,
            accessPrivilege: '').toMap());


    print('Calling ' + VAT_SERVICE_URL_REMOVE_USER_BRANCH_RELATION + '...');
    print('Body Request delete user branch relation: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_REMOVE_USER_BRANCH_RELATION,
        data: body,
      );

      if(post != null && post.data){
        print('Response From VatService (' + VAT_SERVICE_URL_REMOVE_USER_BRANCH_RELATION + '): ' + post.data);
        try{
          String actionBody = json.encode(actionModel.toMap());
          await dio.post(
            VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
            data: actionBody,
          );
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      rethrow;
    }
  }

}
