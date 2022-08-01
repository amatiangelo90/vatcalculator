import 'package:flutter/cupertino.dart';

import '../client/vatservice/model/branch_model.dart';

class UserDetailsModel {

  int _id;
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _phone;
  String _privilege;
  List<BranchModel> _companyList;

  UserDetailsModel(this._id,
      this._email,
      this._password,
      this._firstName,
      this._lastName,
      this._phone,
      this._privilege,
      this._companyList);


  String get privilege => _privilege;

  set privilege(String value) {
    _privilege = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  List<BranchModel> get companyList => _companyList;

  set companyList(List<BranchModel> value) {
    _companyList = value;
  }
}