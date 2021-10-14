import 'package:flutter/cupertino.dart';

import '../client/vatservice/model/company.dart';

class DataBundle {

  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  List<Company> companyList;

  DataBundle({@required this.email, this.password, this.firstName, this.lastName,
    this.companyList, this.phone});
}