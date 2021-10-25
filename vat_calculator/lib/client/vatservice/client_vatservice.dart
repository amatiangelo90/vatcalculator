import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';

import 'constant/utils_vatservice.dart';
import 'model/branch_model.dart';
import 'model/product_model.dart';
import 'model/recessed_model.dart';
import 'model/user_model.dart';

class ClientVatService{

  Future<Response> performSaveUser(
      String firstName,
      String lastName,
      String phoneNumber,
      String eMail) async {

    var dio = Dio();

    String body = json.encode(
        UserModel(
            name: firstName,
            lastName: lastName,
            mail: eMail,
            phone: phoneNumber
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

  Future<Response> performSaveRecessed(
      double amount,
      String description,
      int iva,
      int dateTimeRecessed,
      int pkBranchId) async{

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
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }

  }

  Future<Response> performSaveSupplier(ResponseAnagraficaFornitori anagraficaFornitore
      ) async{

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
      }

      return post;
    }catch(e){
      print(e);
      rethrow;
    }

  }

  Future<Response> performSaveBranch(
      BranchModel company) async {

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
      }
      return post;
    }catch(e){
      rethrow;
    }

  }

  Future<Response> performSaveProduct(
      ProductModel product) async {

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
      }


      return post;
    }catch(e){
      rethrow;
    }

  }

  Future<UserModel> retrieveUserByEmail(
      String eMail) async {

    var dio = Dio();

    String body = json.encode(
        UserModel(
            name: '',
            lastName: '',
            mail: eMail,
            phone: ''
        ).toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL,
        data: body,
      );

      print('Request body for Vat Service (Retrieve User by Email): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL + '): ' + post.data.toString());

      UserModel userModel = UserModel(
        name: post.data['name'],
        id: post.data['id'],
        lastName: post.data['lastName'],
        phone: post.data['phone'],
        mail: post.data['mail']
      );

      return userModel;
    }catch(e){
      print(e);
      rethrow;
    }

  }

  Future<List<BranchModel>> retrieveBranchesByUserEmail(
      String eMail) async {

    var dio = Dio();

    List<BranchModel> branchList = [];

    String body = json.encode(
        UserModel(
            name: '',
            lastName: '',
            mail: eMail,
            phone: ''
        ).toMap());

    Response post;
    try{
      post = await dio.post(
        VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USEREMAIL,
        data: body,
      );

      print('Request body for Vat Service (Retrieve User by Email): ' + body);
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
                phoneNumber: branchElement['phone'],
                providerFatture: branchElement['provider'],
                apiKeyOrUser: branchElement['idKeyUser'],
                apiUidOrPassword: branchElement['idUidPassword']));
      });
      return branchList;

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
}
