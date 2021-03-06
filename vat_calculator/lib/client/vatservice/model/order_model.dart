import 'package:flutter/cupertino.dart';

class OrderModel{

  int pk_order_id;
  String code;
  double total;
  String status;
  String details;
  String creation_date;
  String delivery_date;
  int fk_user_id;
  int fk_supplier_id;
  int fk_branch_id;
  int fk_storage_id;
  String closedby;
  String paid;

  OrderModel({
    @required this.pk_order_id,
    this.code,
    this.total,
    this.status,
    this.details,
    this.creation_date,
    this.delivery_date,
    this.fk_user_id,
    this.fk_supplier_id,
    this.fk_branch_id,
    this.fk_storage_id,
    this.closedby,
    @required this.paid
  });

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
      'fk_storage_id' : fk_storage_id,
      'closedby' : closedby,
      'paid': paid
    };
  }
}