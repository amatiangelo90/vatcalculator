import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel{

  int pk_order_id;
  String code;
  double total;
  String status;
  String details;
  int creation_date;
  int delivery_date;
  int fk_user_id;
  int fk_supplier_id;
  int fk_branch_id;
  int fk_storage_id;

  OrderModel({
    @required this.pk_order_id,
    @required this.code,
    @required this.total,
    @required this.status,
    @required this.details,
    @required this.creation_date,
    @required this.delivery_date,
    @required this.fk_user_id,
    @required this.fk_supplier_id,
    @required this.fk_branch_id,
    @required this.fk_storage_id});

  toMap(){
    return {
      'pk_order_id' : pk_order_id,
      'code' : code,
      'total' : total,
      'status' : status,
      'details' : details,
      'creation_date' : creation_date,
      'delivery_date' : delivery_date,
      'fk_user_id' : fk_user_id,
      'fk_supplier_id' : fk_supplier_id,
      'fk_branch_id' : fk_branch_id,
      'fk_storage_id' : fk_storage_id
    };
  }
}