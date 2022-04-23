import 'package:flutter/cupertino.dart';

class ProductModel {
  int pkProductId;
  String nome;
  String codice;
  String unita_misura;
  int iva_applicata;
  double prezzo_lordo;
  String descrizione;
  String categoria;
  int fkSupplierId;
  double orderItems;

  ProductModel({
    @required this.pkProductId,
    @required this.nome,
    @required this.codice,
    @required this.unita_misura,
    @required this.iva_applicata,
    @required this.prezzo_lordo,
    @required this.descrizione,
    @required this.categoria,
    @required this.fkSupplierId,
    @required this.orderItems
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
      'fkSupplierId': fkSupplierId
    };
  }


  @override
  String toString() {
    return nome.toString() + ' --> Prezzo lordo: ' + prezzo_lordo.toStringAsFixed(2) + " - Iva Applicata: " + iva_applicata.toStringAsFixed(2);
  }

}