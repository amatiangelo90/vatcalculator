import 'package:flutter/cupertino.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';

class ProductOrderAmountModel {

  int pkProductId;
  String nome;
  String codice;
  String unita_misura;
  int iva_applicata;
  double prezzo_lordo;
  String descrizione;
  String categoria;
  int fkSupplierId;
  double amount;
  int pkOrderProductId;
  int fkOrderId;

  ProductOrderAmountModel({
    required this.pkProductId,
    required this.nome,
    required this.codice,
    required this.unita_misura,
    required this.iva_applicata,
    required this.prezzo_lordo,
    required this.descrizione,
    required this.categoria,
    required this.fkSupplierId,
    required this.amount,
    required this.pkOrderProductId,
    required this.fkOrderId,
  });

  toMap(){
    return {
      'pkProductId' : pkProductId,
      'name': nome,
      'code' : codice,
      'measureUnit' : unita_misura,
      'vatApplied': iva_applicata,
      'price': prezzo_lordo,
      'description': descrizione,
      'category': categoria,
      'fkSupplierId': fkSupplierId,
      'amount' : amount,
      'pkOrderProductId' : pkOrderProductId,
      'fkOrderId' : fkOrderId
    };
  }
}