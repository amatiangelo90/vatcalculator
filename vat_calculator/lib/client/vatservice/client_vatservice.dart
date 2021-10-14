import 'dart:convert';

import 'package:dio/dio.dart';

import 'constant/utils_vatservice.dart';
import 'model/branch_model.dart';
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
    }
    return post;
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

    }catch(e){
      print(e);
    }
    return post;
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
    }
    return null;

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
    }
    return branchList;
  }
}
