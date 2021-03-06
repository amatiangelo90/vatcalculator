import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/cash_register_model.dart';
import 'package:vat_calculator/client/vatservice/model/deposit_order_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/expence_event_model.dart';
import 'package:vat_calculator/client/vatservice/model/move_product_between_storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/client/vatservice/service_interface.dart';
import 'package:vat_calculator/models/databundle.dart';
import 'constant/utils_vatservice.dart';
import 'model/archivied_not_paid_request.dart';
import 'model/branch_model.dart';
import 'model/expence_model.dart';
import 'model/order_model.dart';
import 'model/product_model.dart';
import 'model/product_order_amount_model.dart';
import 'model/recessed_model.dart';
import 'model/save_product_into_storage_request.dart';
import 'model/storage_product_model.dart';
import 'model/user_branch_relation_model.dart';
import 'model/user_model.dart';

class ClientVatService implements VatServiceInterface{

  @override
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
  @override
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
  @override
  Future<Response> performSaveRecessed(double amountF,
      double amountNF,
      double amountCash,
      double amountPos,
      String description,
      int iva,
      int dateTimeRecessed,
      int pkCashRegisterId,
      ActionModel actionModel) async{

    var dio = Dio();

    String body = json.encode(
        RecessedModel(
            amountF: amountF,
            amountNF: amountNF,
            amountCash: amountCash,
            amountPos: amountPos,
            vat: iva,
            dateTimeRecessed: dateTimeRecessed,
            description: description,
            dateTimeRecessedInsert: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
            fkCashRegisterId: pkCashRegisterId,
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
  @override
  Future<Response> performSaveExpence(double amount, String description, int iva, int dateTimeExpence, int pkBranchId, String fiscal, ActionModel actionModel) async{

    var dio = Dio();
    String body = json.encode(
        ExpenceModel(
            amount: amount,
            vat: iva,
            dateTimeExpence: dateTimeExpence,
            description: description,
            dateTimeExpenceInsert: DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
            fkBranchId: pkBranchId,
            pkExpenceId: null,
            fiscal: fiscal
        ).toMap());

    Response post;
    print('Save expence request body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_SAVE_EXPENCE_FOR_BRANCH,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_SAVE_EXPENCE_FOR_BRANCH + '): ' + post.data.toString());
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
  @override
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
  @override
  Future<Response> performSaveOrder({OrderModel orderModel}) async {

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
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }
  @override
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
        if(productOrderElement['amount'] > 0){
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
        }

      });

      print('Response from service to retrieve product into order ($VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID): ' + prodOrderList.toString());

      return prodOrderList;

    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<Response> performSaveSupplier({SupplierModel anagraficaFornitore, ActionModel actionModel}) async{

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
  @override
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
        print('Response From VatService create branch (' + VAT_SERVICE_URL_SAVE_BRANCH + '): ' + post.data.toString());
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
  @override
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
  @override
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
  @override
  Future<Response> performSaveProductIntoOrder(double amount, int productId, int orderId) async {

    var dio = Dio();

    String body = json.encode(
        {"pk_product_order_id" : 0,
          "amount" : amount,
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
  @override
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
  @override
  Future<Response> performUpdateExpence({ExpenceModel expenceModel, ActionModel actionModel}) async {

    var dio = Dio();

    String body = json.encode(
        expenceModel.toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_EXPENCE + '...');
    print('Body Request update exence: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_EXPENCE,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_EXPENCE + '): ' + post.data.toString());
      }
      return post;
    }catch(e){
      rethrow;
    }

  }
  @override
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
  @override
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

      if(post != null){
        print('Response From VatService delete product (' + VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE + '): ' + post.data.toString());
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
      print('Exception: ' + e.toString());
      rethrow;
    }
  }
  @override
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
  @override
  Future<List<BranchModel>> retrieveBranchesByUserId(int id) async {

    var dio = Dio();

    List<BranchModel> branchList = [];

    print('Retrieve branches list for the user with id ' + id.toString());
    print('Url: ' + VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USER_ID);
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
        VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USER_ID,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USER_ID + '): ' + post.data.toString());
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
                accessPrivilege: branchElement['accessPrivilege'],
                token: branchElement['token'],
            ));
      });
      return branchList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  @override
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
  @override
  Future<List<ActionModel>> retrieveLastWeekActionsByBranchId(int branchId) async {

    var dio = Dio();

    List<ActionModel> actionModelList = [];

    print('Retrieve actions list for the branch with id ' + branchId.toString());
    print('Url: ' + VAT_SERVICE_URL_RETRIEVE_LASTWEEK_ACTIONS_BY_BRANCH_ID);
    String body = json.encode(
        BranchModel(
            pkBranchId: branchId
        ).toMap());

    print('Retrieve actions body request: ' + body);
    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_LASTWEEK_ACTIONS_BY_BRANCH_ID,
        data: body,
      );

      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_LASTWEEK_ACTIONS_BY_BRANCH_ID + '): ' + post.data.toString());
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
  @override
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
              amountHundred: branchElement['amountHundred'],
              selected: false,
              extra: 0.0,
              loadUnloadAmount: 0.0
            ));
      });
      return storageProoductModelRelationList;

    }catch(e){
      print(e);
      rethrow;
    }
  }
  @override
  Future<List<RecessedModel>> retrieveRecessedListByCashRegister(CashRegisterModel cashRegister) async {
    var dio = Dio();

    List<RecessedModel> recessedList = [];


    String body = json.encode(
        cashRegister.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve recessed list by cashRegister model): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((recessedElement) {

        recessedList.add(
            RecessedModel(

                fkCashRegisterId: recessedElement['fkCashRegisterId'],
                description: recessedElement['description'],
                vat: recessedElement['vat'],
                dateTimeRecessed: recessedElement['dateTimeRecessed'],
                dateTimeRecessedInsert: recessedElement['dateTimeRecessedInsert'],
                amountF: recessedElement['amountF'],
                amountNF: recessedElement['amountNF'],
                amountPos: recessedElement['amountPos'],
                amountCash: recessedElement['amountCash'],
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
  @override
  Future<List<ExpenceModel>> retrieveExpencesListByBranch(BranchModel currentBranch) async {
    var dio = Dio();

    List<ExpenceModel> expenceList = [];


    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_EXPENCE_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve expences list by branch): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_EXPENCE_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((expenceElement) {

        expenceList.add(
            ExpenceModel(
                fkBranchId: expenceElement['fkBranchId'],
                description: expenceElement['description'],
                vat: expenceElement['vat'],
                dateTimeExpence: expenceElement['dateTimeExpence'],
                dateTimeExpenceInsert: expenceElement['dateTimeExpenceInsert'],
                amount: expenceElement['amount'],
                fiscal: expenceElement['fiscal'],
                pkExpenceId: expenceElement['pkExpenceId']
            ));
      });
      return expenceList;
  }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }
  @override
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
                closedby: orderElement['closedby'],
                paid: orderElement['paid']
            ));
      });
      return ordersList;
  }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> retrieveArchiviedOrdersByBranch(BranchModel currentBranch) async {
    var dio = Dio();

    List<OrderModel> ordersList = [];


    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_ARCHIVIE_ORDERS_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve archivied order by branch id): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_ARCHIVIE_ORDERS_BY_BRANCHES + '): ' + post.data.toString());
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
                closedby: orderElement['closedby'],
                paid: orderElement['paid'],
            ));
      });
      return ordersList;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }


  @override
  Future<List<SupplierModel>> retrieveSuppliersListByBranch(BranchModel currentBranch) async {
    var dio = Dio();

    List<SupplierModel> suppliersList = [];

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
            SupplierModel(
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
  @override
  Future<List<ProductModel>> retrieveProductsBySupplier(SupplierModel currentSupplier) async {
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
                fkSupplierId: product['fkSupplierId'],
                orderItems: 0.0
            ));
      });
      return productsList;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }
  @override
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
  @override
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
  @override
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
  @override
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

  @override
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
  @override
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
  @override
  Future<void> updateOrderStatus({OrderModel orderModel, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        orderModel.toMap());

    Response post;
    print('Update order with id : ' + orderModel.pk_order_id.toString() +  ' to status : ' + orderModel.status + ' (Paid: ${orderModel.paid})');
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
  @override
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
  @override
  Future<List<SupplierModel>> retrieveSuppliersListByCode({String code}) async {
    var dio = Dio();

    List<SupplierModel> suppliersList = [];

    String body = json.encode(
        SupplierModel(
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

        suppliersList.add(SupplierModel(
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
  @override
  Future<int> addSupplierToCurrentBranch({SupplierModel supplierRetrievedByCodeToUpdateRelationTableBranchSupplier, ActionModel actionModel}) async {
    var dio = Dio();

    List<SupplierModel> suppliersList = [];

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
  @override
  Future<void> removeSupplierFromCurrentBranch({SupplierModel requestRemoveSupplierFromBranch, ActionModel actionModel}) async {
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
  @override
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

  @override
  Future<Response> performCreateEvent({EventModel eventModel, ActionModel actionModel}) async {
    var dio = Dio();

    print('Create event ${eventModel.eventName} for branch with id ${eventModel.fkBranchId}');
    String body = json.encode(
        eventModel.toMap());
    print('Calling the following endpoint $VAT_SERVICE_URL_CREATE_EVENT with body request $body');

    Response post;
    try {
      post = await dio.post(
        VAT_SERVICE_URL_CREATE_EVENT,
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


  @override
  Future<Response> createUserBranchRelation({int fkUserId, int fkBranchId, String accessPrivilege, ActionModel actionModel}) async {

    var dio = Dio();

    print('Create relation between User with id $fkUserId and branch with id $fkBranchId. Access level : $accessPrivilege');
    String body = json.encode(
        UserBranchRelationModel(
            pkUserBranchId: 0,
            fkUserId: fkUserId,
            fkBranchId: fkBranchId,
            accessPrivilege: accessPrivilege,
            token: ''
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
  @override
  Future<Response> updatePrivilegeForUserBranchRelation({int branchId, int userId, String privilegeType, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        UserBranchRelationModel(pkUserBranchId: 0,
            fkBranchId: branchId,
            fkUserId: userId,
            accessPrivilege: privilegeType,
            token: '').toMap());


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

  @override
  Future<Response> updateFirebaseTokenForUserBranchRelation({int branchId, int userId, String token}) async {
    var dio = Dio();

    String body = json.encode(
        UserBranchRelationModel(pkUserBranchId: 0,
            fkBranchId: branchId,
            fkUserId: userId,
            accessPrivilege: '',
            token: token).toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_REFRESH_FIREBASE_TOKEN + '...');
    print('Body Request update user branches table with new token for current user: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_REFRESH_FIREBASE_TOKEN,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_REFRESH_FIREBASE_TOKEN + '): ' + post.data.toString());
        try{
          print('Token updated!!');
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }

      return post;
    }catch(e){
      rethrow;
    }
  }

  @override
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
  @override
  Future<Response> performEditSupplier({SupplierModel anagraficaFornitore, ActionModel actionModel}) async {
    var dio = Dio();

    String body = json.encode(
        anagraficaFornitore.toMap());
    Response post;

    print('Update supplier ($VAT_SERVICE_URL_UPDATE_SUPPLIER) request body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_SUPPLIER,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_SUPPLIER + '): ' + post.data.toString());
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
  @override
  Future<Response> removeProductFromOrder(ProductOrderAmountModel element) async {
    var dio = Dio();

    String body = json.encode(
        element.toMap());


    print('Calling ' + VAT_SERVICE_URL_DELETE_PRODUCT_FROM_ORDER + '...');
    print('Body Request delete product from Order: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_PRODUCT_FROM_ORDER,
        data: body,
      );

      if(post != null){
        print('Response From VatService removed product from order(' + VAT_SERVICE_URL_DELETE_PRODUCT_FROM_ORDER + '): ' + post.data.toString());
      }

      return post;
    }catch(e){
      rethrow;
    }
  }
  @override
  Future<Response> updateProductAmountIntoOrder(int pkOrderProductId, double amount, int pkProductId, int pk_order_id) async {
    var dio = Dio();

    String body = json.encode(
        {
          "pk_product_order_id" : pkOrderProductId,
          "amount" : amount,
          "fk_product_id" : pkProductId,
          "fk_order_id" : pk_order_id
        });


    print('Calling ' + VAT_SERVICE_URL_UPDATE_PRODUCT_AMOUNT_INTO_ORDER + '...');
    print('Body Request update amount product in Order: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_PRODUCT_AMOUNT_INTO_ORDER,
        data: body,
      );

      if(post != null){
        print('Response From VatService removed product from order(' + VAT_SERVICE_URL_UPDATE_PRODUCT_AMOUNT_INTO_ORDER + '): ' + post.data.toString());
      }

      return post;
    }catch(e){
      rethrow;
    }
  }
  @override
  Future<void> deleteExpence({ExpenceModel expenceModel, ActionModel actionModel}) async {

    var dio = Dio();

    String body = json.encode(expenceModel.toMap());

    Response post;
    print('Calling delete expence method ' + VAT_SERVICE_URL_DELETE_EXPENCE + ' to delete expence with id ${expenceModel.pkExpenceId} from current branch ');
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_EXPENCE,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_DELETE_EXPENCE + '): ' + post.data.toString());
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

  @override
  Future<void> updateUserData(UserDetailsModel userDetail) async {
    var dio = Dio();

    String body = json.encode(
        {
          "id" : userDetail.id,
          "name" : userDetail.firstName,
          "lastName" : userDetail.lastName,
          "phone" : userDetail.phone,
          "mail" : userDetail.email,
          "privilege" : userDetail.privilege,
          "relatedUserId" : 0,
        });


    print('Calling ' + VAT_SERVICE_URL_UPDATE_USER_DATA + '...');
    print('Body Request update amount product in Order: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_USER_DATA,
        data: body,
      );

      if(post != null){
        print('Response From VatService. Updated user data result (url: ' + VAT_SERVICE_URL_UPDATE_USER_DATA + '). Result: ' + post.data.toString());
      }

      return post;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<List<EventModel>> retrieveEventsListByBranchId(BranchModel currentBranch) async {

    var dio = Dio();

    List<EventModel> eventList = [];


    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_EVENTS_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve events list by branch): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_EVENTS_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((orderElement) {

        eventList.add(
            EventModel(
                pkEventId: orderElement['pkEventId'],
                closed: orderElement['closed'],
                creationDate: orderElement['creationDate'],
                eventDate: orderElement['eventDate'],
                eventName: orderElement['eventName'],
                fkBranchId: orderElement['fkBranchId'],
                fkStorageId: orderElement['fkStorageId'],
                owner: orderElement['owner'],
                location: orderElement['location'],
            ));
      });
      return eventList;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }

  }

  Future createWorkstations(List<WorkstationModel> workstationModelList) async {
    var dio = Dio();

    print('Create workstations ${workstationModelList.toString()}');
    String request = '[';

    workstationModelList.forEach((workstation) {
      request = request + json.encode(
          workstation.toMap() ) + ',';
    });

    if (request != null && request.length > 0) {
      request = request.substring(0, request.length - 1);
    }
    request = request + ']';


    print('Calling the following endpoint $VAT_SERVICE_URL_CREATE_WORKSTATIONS with body request $request');

    Response post;
    try {
      post = await dio.post(
        VAT_SERVICE_URL_CREATE_WORKSTATIONS,
        data: request,
      );

      return post;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<void> createRelationBetweenWorkstationsAndProductStorage(List<dynamic> listWorkstationIds,
      List<int> idsListFromCurrentStorageProductList) async {

    if(listWorkstationIds.isNotEmpty && idsListFromCurrentStorageProductList.isNotEmpty){
      var dio = Dio();
      Response post;
      print('Creating relation between workstations and productstorage...');
      print(listWorkstationIds.toString());
      print(idsListFromCurrentStorageProductList.toString());
      String request =  '{"workstationsIdsList":' + listWorkstationIds.toString() + ', "productStorageIdsList":' + idsListFromCurrentStorageProductList.toString()
          + '}';
      print(request);
      try {

        post = await dio.post(
          VAT_SERVICE_URL_CREATE_WORKSTATIONS_PRODUCTSTORAGE_RELATION,
          data: request,
        );
      }catch(e){
        print(e);
      }
    }else{
      print('Empty list. Cannot create relations. Workstations list: ' + listWorkstationIds.toString() + ' - prodStorageIdsList : ' + idsListFromCurrentStorageProductList.toString());
    }



  }

  Future<List<WorkstationModel>> retrieveWorkstationListByEventId(EventModel eventModel) async {


    if(eventModel != null || eventModel.pkEventId > 0){
      var dio = Dio();
      Response post;
      print('Retrieve workstations by event id ${eventModel.toString()}...');
      print('Retrieve workstations by event id. Calling $VAT_SERVICE_URL_RETRIEVE_WORKSTATIONS_BY_EVENT_ID..');


      List<WorkstationModel> workstationList = [];
      try {
        String body = json.encode(
            eventModel.toMap());
        post = await dio.post(
          VAT_SERVICE_URL_RETRIEVE_WORKSTATIONS_BY_EVENT_ID,
          data: body,
        );

        String encode = json.encode(post.data);

        List<dynamic> valueList = jsonDecode(encode);

        valueList.forEach((workstationElement) {

          workstationList.add(
              WorkstationModel(
                type: workstationElement['type'],
                name: workstationElement['name'],
                pkWorkstationId: workstationElement['pkWorkstationId'],
                fkEventId: workstationElement['fkEventId'],
                extra: workstationElement['extra'],
                closed: workstationElement['closed'],
                responsable: workstationElement['responsable'],
              )
          );
        });
        return workstationList;

      }catch(e){
        print(e);
      }
    }else{
      print('Impossible to retrieve workstation while event is null or event id is empty or null. Event: ' + eventModel.toString());
    }


  }

  @override
  Future<List<WorkstationProductModel>>retrieveWorkstationProductModelByWorkstationId(WorkstationModel workstation) async {
    if(workstation != null || workstation.pkWorkstationId > 0){
      var dio = Dio();
      Response post;
      print('Retrieve workstation product model by workstation id ${workstation.pkWorkstationId.toString()}...');
      print('Retrieve workstation products list. Calling $VAT_SERVICE_URL_RETRIEVE_WORKSTATION_PRODUCT_LIST_BY_WORKSTATION_ID..');


      List<WorkstationProductModel> workstationProductList = [];
      try {
        String body = json.encode(
            workstation.toMap());
        post = await dio.post(
          VAT_SERVICE_URL_RETRIEVE_WORKSTATION_PRODUCT_LIST_BY_WORKSTATION_ID,
          data: body,
        );

        String encode = json.encode(post.data);

        List<dynamic> valueList = jsonDecode(encode);

        valueList.forEach((workstationElement) {

          double storeStock = workstationElement['storeStock'];
          double refillStock = workstationElement['refillStock'];
          double consumed = workstationElement['consumed'];

          workstationProductList.add(
              WorkstationProductModel(
                amountHunderd: workstationElement['amountHunderd'],
                consumed: double.parse(consumed.toStringAsFixed(2)),
                fkStorProdId: workstationElement['fkStorProdId'],
                fkSupplierId:  workstationElement['fkSupplierId'],
                fkWorkstationId: workstationElement['fkWorkstationId'],
                pkWorkstationStorageProductId: workstationElement['pkWorkstationStorageProductId'],
                productName: workstationElement['productName'],
                refillStock: double.parse(refillStock.toStringAsFixed(2)),
                storeStock: double.parse(storeStock.toStringAsFixed(2)),
                unitMeasure: workstationElement['unitMeasure'],
                fkProductId: workstationElement['fkProductId'],
                productPrice: workstationElement['productPrice'],
                backupRefillStock: double.parse(refillStock.toStringAsFixed(2),
                ),
              )
          );
        });

        workstationProductList.forEach((element) {
          print(
            element.toMap().toString()
          );
        });
        return workstationProductList;
      }catch(e){
        print(e);
      }
    }else{
      print('Impossible to retrieve workstation products while workstationmodel is null or workstation id is empty or null. Event: ' + workstation.toString());
    }

  }

  @override
  Future<void> updateStock({List<StorageProductModel> currentStorageProductListForCurrentStorageUnload, ActionModel actionModel}) async {
    var dio = Dio();
    print('Upload on storage. Call $VAT_SERVICE_URL_UPDATE_STOCK...');
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

  @override
  Future updateWorkstationProductModel(List<WorkstationProductModel> workStationProdModelList, ActionModel actionModel) async {

    try{
      var dio = Dio();
      String body = '[';
      workStationProdModelList.forEach((workStationProdModel) {
        body = body + json.encode(
            workStationProdModel.toMap()) + ',';
      });
      body = body.substring(0, body.length - 1);
      body = body + ']';
      Response post = await dio.post(
        VAT_SERVICE_URL_UPDATE_WORKSTATIONS_PRODUCTS,
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

  Future updateWorkstationDetails(WorkstationModel workstationModel) async {
    try{
      var dio = Dio();
      String body = json.encode(
          workstationModel.toMap());


      Response post = await dio.post(
        VAT_SERVICE_URL_UPDATE_WORKSTATIONS_DETAILS,
        data: body,
      );

      print('Request body for Vat Service (Update Workstation): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_UPDATE_WORKSTATIONS_DETAILS + '): ' + post.toString());

    }catch(e){
      print('Errore retrieving storage model : ');
      print(e);
      rethrow;
    }
  }

  Future<void> removeWorkstation(WorkstationModel workstationModel) async {
    try{
      var dio = Dio();
      String body = json.encode(
          workstationModel.toMap());


      Response post = await dio.post(
        VAT_SERVICE_URL_DELETE_WORKSTATION,
        data: body,
      );

      print('Request body for Vat Service (Delete Workstation): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_DELETE_WORKSTATION + '): ' + post.toString());

    }catch(e){
      print('Errore retrieving storage model : ');
      print(e);
      rethrow;
    }
  }

  Future<void> updateAmountHundredIntoStorage(double currentValue, int fkStorProdId) async {

    try{
      var dio = Dio();
      String body = '{"pkStorageProduct" : $fkStorProdId, "amountHundred" : $currentValue }';

      print(body);
      Response post = await dio.post(
        VAT_SERVICE_URL_UPDATE_AMOUNT_HUNDRED,
        data: body,
      );

      print('Request body for Vat Service (update amount hundred on storage): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_UPDATE_AMOUNT_HUNDRED + '): ' + post.toString());

    }catch(e){
      print('Errore retrieving storage model : ');
      print(e);
      rethrow;
    }
  }

  performUpdateBranch(BranchModel company, ActionModel actionModel) async {
    var dio = Dio();

    String body = json.encode(
        company.toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_BRANCH + '...');
    print('Body Request Update branch: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_BRANCH,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_BRANCH + '): ' + post.data.toString());
        try{
          if(actionModel != null){
            actionModel.fkBranchId = post.data;
            String actionBody = json.encode(actionModel.toMap());
            await dio.post(
              VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH,
              data: actionBody,
            );
          }
        }catch(e){
          print('Exception: ' + e.toString());
        }
      }
      return post;
    }catch(e){
      rethrow;
    }
  }

  performUpdateRecessed(RecessedModel recessedModel, ActionModel actionModel) async {

    var dio = Dio();

    String body = json.encode(
        recessedModel.toMap());

    print('Calling ' + VAT_SERVICE_URL_UPDATE_RECESSED + '...');
    print('Body Request update recessed: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_RECESSED,
        data: body,
      );

      print('post after update:  '  + post.data.toString());
      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_RECESSED + '): ' + post.data.toString());
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

  performDeleteRecessed(RecessedModel recessed, ActionModel actionModel) async {
    var dio = Dio();

    String body = json.encode(
        recessed.toMap());
    print('Calling ' + VAT_SERVICE_URL_DELETE_RECESSED + '...');
    print('Body Request delete recessed: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_RECESSED,
        data: body,
      );

      if(post != null){
        print('Response From VatService removed recessed(' + VAT_SERVICE_URL_DELETE_RECESSED + '): ' + post.data.toString());
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

  @override
  Future<Response> createCashRegister(CashRegisterModel cashRegisterModel) async {
    var dio = Dio();

    String body = json.encode(
        cashRegisterModel.toMap());


    print('Calling ' + VAT_SERVICE_URL_CREATAE_CASH_REGISTER + '...');
    print('Body Request create cash register : ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_CREATAE_CASH_REGISTER,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService create branch (' + VAT_SERVICE_URL_CREATAE_CASH_REGISTER + '): ' + post.data.toString());
      }
      return post;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Response> deleteCashRegister(CashRegisterModel cashRegisterModel) async {
    var dio = Dio();

    String body = json.encode(
        cashRegisterModel.toMap());
    print('Calling ' + VAT_SERVICE_URL_DELETE_CASH_REGISTER + '...');
    print('Body Request delete cash register: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_CASH_REGISTER,
        data: body,
      );
      return post;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Response> updateCashRegister(CashRegisterModel cashRegisterModel) async {
    var dio = Dio();

    String body = json.encode(
        cashRegisterModel.toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_CASH_REGISTER + '...');
    print('Body Request update cassh register: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_CASH_REGISTER,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService (' + VAT_SERVICE_URL_UPDATE_CASH_REGISTER + '): ' + post.data.toString());
      }

      return post;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<List<CashRegisterModel>> retrieveCashRegistersByBranchId(BranchModel branchModel) async {

    var dio = Dio();

    List<CashRegisterModel> cashRegisterList = [];
    String body = json.encode(
        branchModel.toMap());

    Response post;
    print('Retrieve cash registers model by branch id: ' + branchModel.pkBranchId.toString());
    print('Calling retrieve method to get cash registers model by branch id ' + VAT_SERVICE_URL_RETRIEVE_CASH_REGISTERS_BY_BRANCH_ID);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_CASH_REGISTERS_BY_BRANCH_ID,
        data: body,
      );


      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((productOrderElement) {

        cashRegisterList.add(
            CashRegisterModel(
              fkBranchId: productOrderElement['fkBranchId'],
              name: productOrderElement['name'],
              pkCashRegisterId: productOrderElement['pkCashRegisterId'],
            )
        );
      });
      print('Response from api to retrieve cashregisters ($VAT_SERVICE_URL_RETRIEVE_CASH_REGISTERS_BY_BRANCH_ID): ');
      if(cashRegisterList != null && cashRegisterList.isNotEmpty)
      cashRegisterList.forEach((cashitem) {
        print(cashitem.toMap().toString());
      });
      return cashRegisterList;

    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<Response> removeProductFromWorkstation(WorkstationProductModel prodModelWorkstation) async {
    var dio = Dio();

    List<CashRegisterModel> cashRegisterList = [];
    String body = json.encode(
        prodModelWorkstation.toMap());

    Response post;
    print('Delete product ${prodModelWorkstation.productName} from workstation with id ' + prodModelWorkstation.pkWorkstationStorageProductId.toString());
    print('Calling retrieve method to get cash registers model by branch id ' + VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_WORKSTATION);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_WORKSTATION,
        data: body,
      );

      return post;

    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<Response> updateEventModel(EventModel event) async {
    var dio = Dio();

    String body = json.encode(
        event.toMap());


    print('Calling ' + VAT_SERVICE_URL_UPDATE_EVENT + '...');
    print('Body Request update event: ' + body);

    Response post;
    try{

      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_EVENT,
        data: body,
      );

      if(post != null && post.data != null){
        print('Response From VatService update event (' + VAT_SERVICE_URL_UPDATE_EVENT + '): ' + post.data.toString());
      }

      return post;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<List<EventModel>> retrieveEventsClosedListByBranchId(BranchModel currentBranch) async {
    var dio = Dio();

    List<EventModel> eventList = [];


    String body = json.encode(
        currentBranch.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_CLOSED_EVENTS_BY_BRANCHES,
        data: body,
      );

      print('Request body for Vat Service (Retrieve closed events list by branch): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_CLOSED_EVENTS_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((orderElement) {

        eventList.add(
            EventModel(
              pkEventId: orderElement['pkEventId'],
              closed: orderElement['closed'],
              creationDate: orderElement['creationDate'],
              eventDate: orderElement['eventDate'],
              eventName: orderElement['eventName'],
              fkBranchId: orderElement['fkBranchId'],
              fkStorageId: orderElement['fkStorageId'],
              owner: orderElement['owner'],
              location: orderElement['location'],
            ));
      });
      return eventList;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }

  }

  @override
  Future<List<String>> retrieveTokenList(BranchModel branchModel) async {

    var dio = Dio();

    String body = json.encode(branchModel.toMap());

    print('Calling ' + VAT_SERVICE_URL_RETRIEVE_TOKEN_BY_BRANCH + '...');
    print('Body Request to retrieve tokens: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_TOKEN_BY_BRANCH,
        data: body,
      );

      String encode = json.encode(post.data);
      List<dynamic> valueList = jsonDecode(encode);

      print('Tokens Retrieved: ' + valueList.cast<String>().toString());
      return valueList.cast<String>();
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Response> createEventExpenceModel(ExpenceEventModel expenceEventModel) async {
    var dio = Dio();

    print('Create expence ${expenceEventModel.description} for event with id ${expenceEventModel.fkEventId}');
    String body = json.encode(
        expenceEventModel.toMap());
    print('Calling the following endpoint $VAT_SERVICE_URL_CREATE_EVENT_EXPENCE with body request $body');

    Response post;
    try {
      post = await dio.post(
        VAT_SERVICE_URL_CREATE_EVENT_EXPENCE,
        data: body,
      );

      return post;
    }catch(e){
      print(e);
      return null;
    }
  }

  @override
  Future<Response> deleteEventExpenceModel(ExpenceEventModel expenceEventModel) async {
    var dio = Dio();

    print('DELETE expence ${expenceEventModel.description} for event with id ${expenceEventModel.fkEventId}');
    String body = json.encode(
        expenceEventModel.toMap());
    print('Calling the following endpoint $VAT_SERVICE_URL_DELETE_EVENT_EXPENCE with body request $body');

    Response post;
    try {
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_EVENT_EXPENCE,
        data: body,
      );

      return post;
    }catch(e){
      print(e);
      return null;
    }
  }

  @override
  Future<List<ExpenceEventModel>> retrieveEventExpencesByEventId(EventModel eventModel) async {

    var dio = Dio();

    List<ExpenceEventModel> expenceEventModel = [];

    String body = json.encode(
        eventModel.toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_EVENT_EXPENCES_BY_EVENT_ID,
        data: body,
      );

      print('Request body for Vat Service (Retrieved event expence by event id): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_EVENT_EXPENCES_BY_EVENT_ID + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((eventExpenceItem) {
        expenceEventModel.add(
            ExpenceEventModel(
              pkEventExpenceId: eventExpenceItem['pkEventExpenceId'],
              amount: eventExpenceItem['amount'],
              cost: eventExpenceItem['cost'],
              dateTimeInsert: eventExpenceItem['pkEventId'],
              description: eventExpenceItem['description'],
              fkEventId: eventExpenceItem['fkEventId']
            ));
      });

      return expenceEventModel;
    }catch(e){
      print('Errore retrieving recessed : ');
      print(e);
      rethrow;
    }
  }

  @override
  Future<Response> updateEventExpenceModel(ExpenceEventModel expenceEventModel) async {
    var dio = Dio();

    print('Update expence ${expenceEventModel.description} for event with id ${expenceEventModel.fkEventId}');
    String body = json.encode(
        expenceEventModel.toMap());
    print('Calling the following endpoint $VAT_SERVICE_URL_UPDATE_EVENT_EXPENCE with body request $body');

    Response post;
    try {
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_EVENT_EXPENCE,
        data: body,
      );
      return post;
    } catch(e){
      print(e);
      return null;
    }
  }

  @override
  Future<Response> moveProductBetweenStorage({List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel, ActionModel actionModel}) async {

    var dio = Dio();

    String body = '[';
    listMoveProductBetweenStorageModel.forEach((moveProductModel) {
      body = body + json.encode(
          moveProductModel.toMap()) + ',';
    });
    body = body.substring(0, body.length - 1);
    body = body + ']';

    print('Call ' + VAT_SERVICE_URL_MOVE_PRODUCT_BETWEEN_STORAGE);
    print('Body Request: ' + body);
    try{
      Response post = await dio.post(
        VAT_SERVICE_URL_MOVE_PRODUCT_BETWEEN_STORAGE,
        data: body,
      );
      return post;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<Response> performEmptyStockStorage(StorageModel currentStorage) async {
    var dio = Dio();
    String body = json.encode(
        currentStorage.toMap());

    Response post;
    print('Empty stock storage : ' + body);
    print('Calling empty stock storage method ' + VAT_SERVICE_URL_EMPTY_STOCK_STORAGE + ' to set at 0 all product\'s stock on storage ${currentStorage.name} with id ' + currentStorage.pkStorageId.toString());

    try{
      post = await dio.post(
        VAT_SERVICE_URL_EMPTY_STOCK_STORAGE,
        data: body,
      );
      return post;
    }catch(e){
      print(e);
      return Response(
        data: 0
      );
    }


  }

  Future<Response> deleteEventModel(EventModel event) async {

    var dio = Dio();
    String body = json.encode(
        event.toMap());
    print('Calling ' + VAT_SERVICE_URL_DELETE_EVENT + 'to delete event...');
    print('Body Request delete event: ' + body);

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_EVENT,
        data: body,
      );
      return post;
    }catch(e){
      rethrow;
    }
  }

  Future<Response> performSetNullAllProductsWithNegativeValueForStockStorage(StorageModel currentStorage) async {
    var dio = Dio();
    String body = json.encode(
        currentStorage.toMap());

    Response post;
    print('Empty stock storage : ' + body);
    print('Calling method to set stock storage on 0 where value is negative ' + VAT_SERVICE_URL_SET_0_WHERE_IS_NEGATIVE_STOCK_STORAGE + ' for storage ${currentStorage.name} with id ' + currentStorage.pkStorageId.toString());

    try{
      post = await dio.post(
        VAT_SERVICE_URL_SET_0_WHERE_IS_NEGATIVE_STOCK_STORAGE,
        data: body,
      );
      return post;
    }catch(e){
      print(e);
      return Response(
          data: 0
      );
    }
  }

  @override
  Future<Response> performDeleteDepositOrder(DepositOrder depositOrder) async {
    var dio = Dio();

    String body = json.encode(
        depositOrder.toMap());

    Response post;
    print('Delete deposit order request body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_DELETE_ORDER_DEPOSIT,
        data: body,
      );

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<Response> performInsertDepositOrder(DepositOrder depositOrder) async {
    var dio = Dio();

    String body = json.encode(
        depositOrder.toMap());

    Response post;
    print('Save deposit order url:($VAT_SERVICE_URL_INSERT_ORDER_DEPOSIT'
        ') request body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_INSERT_ORDER_DEPOSIT,
        data: body,
      );

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<List<DepositOrder>> performRetrieveDepositOrderByOrderId(OrderModel orderModel) async {
    var dio = Dio();

    List<DepositOrder> depositOrderList = [];
    String body = json.encode(
        orderModel.toMap());

    Response post;
    print('Retrieve deposit by order id: ' + orderModel.pk_order_id.toString());
    print('Calling retrieve method to get deposit by order id ' + VAT_SERVICE_URL_RETRIEVE_ORDER_DEPOSITS_BY_ORDER_ID);


    print('Get deposit by order id body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_ORDER_DEPOSITS_BY_ORDER_ID,
        data: body,
      );


      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((depositOrderElement) {
        depositOrderList.add(
            DepositOrder(
              amount: depositOrderElement['amount'],
              creationDate: depositOrderElement['creation_date'],
              fkOrderId: depositOrderElement['fk_order_id'],
              pkDepositOrderId: depositOrderElement['pk_deposit_order_id'],
              user: depositOrderElement['user'],
            )
        );
      });

      print('Response from service to retrieve deposit order ($VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID): ' + depositOrderList.toString());

      return depositOrderList;

    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<Response> performUpdateDepositOrder(DepositOrder depositOrder) async {
    var dio = Dio();

    String body = json.encode(
        depositOrder.toMap());

    Response post;
    print('Update deposit order request body: ' + body);
    try{
      post = await dio.post(
        VAT_SERVICE_URL_UPDATE_ORDER_DEPOSIT,
        data: body,
      );

      return post;
    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> retrieveOrderModelBySupplierIdAndBranchIdWhereStatusIsReceivedAndPaidIsFalse(int supplierId, int branchId) async {
    var dio = Dio();

    List<OrderModel> ordersList = [];

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_ORDERS_BY_BRANCH_ID_SUPPLIER_ID_WITH_STATUS_ARCHIVIED_NOT_PAID,
        data: ArchiviedNotPaidRequest(
          pkBranchId: branchId,
          pkSupplierId: supplierId
        ).toMap(),
      );

      print('Request body for Vat Service (Retrieve orders list by branch id and supplier id where status is RICEVUTO E ARCHIVIATO e NON PAGATO). BranchId: ' + branchId.toString() + ', SupplierId: ' + supplierId.toString());
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_ORDERS_BY_BRANCH_ID_SUPPLIER_ID_WITH_STATUS_ARCHIVIED_NOT_PAID + '): ' + post.data.toString());
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
                closedby: orderElement['closedby'],
                paid: orderElement['paid']
            ));
      });
      return ordersList;
    }catch(e){
      print('Errore retrieving orders : ');
      print(e);
      rethrow;
    }
  }

}
