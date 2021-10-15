import 'dart:convert';

import 'package:dio/dio.dart';

import 'constant/utils_vatservice.dart';
import 'model/branch_model.dart';
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

  Future<Response> saveRecessed(
      double amount,
      String description,
      int dateTimeRecessed,
      int pkBranchId) async{

    var dio = Dio();

    String body = json.encode(
        RecessedModel(
            amount: amount,
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

      print('Response From VatService (' + VAT_SERVICE_URL_SAVE_RECESSED_FOR_BRANCH + '): ' + post.data.toString());
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
    print('Body Request ' + body);

    Response post;
    try{
      post = await dio.post(
        'http://217.160.242.158:8080/vatservices/api/retrievemodelbranch',
      );

      post = await dio.post(
        VAT_SERVICE_URL_SAVE_BRANCH,
        data: body,
      );

      print('Response From VatService (' + VAT_SERVICE_URL_SAVE_BRANCH + '): ' + post.data.toString());
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

      print('Request body for Vat Service (Retrieve User by Email): ' + body);
      print('Response From Vat Service (' + VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES + '): ' + post.data.toString());
      String encode = json.encode(post.data);

      List<dynamic> valueList = jsonDecode(encode);

      valueList.forEach((recessedElement) {

        recessedList.add(
            RecessedModel(
                fkBranchId: recessedElement['fkBranchId'],
                description: recessedElement['description'],
                dateTimeRecessed: recessedElement['dateTimeRecessed'],
                dateTimeRecessedInsert: recessedElement['dateTimeRecessedInsert'],
                amount: recessedElement['amount'],
                pkRecessedId: recessedElement['pkRecessedId']
            ));
      });
      return recessedList;
  }catch(e){
      print(e);
      rethrow;
    }
  }
}
