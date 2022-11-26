import 'package:flutter/cupertino.dart';

class ConfigurationModel{

  String recessedextra;

  ConfigurationModel({
    required this.recessedextra,
  });

  toMap(){
    return {
      'recessedextra' : recessedextra,
    };
  }
}
