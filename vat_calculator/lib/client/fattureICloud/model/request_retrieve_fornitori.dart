import 'dart:core';

import 'package:flutter/cupertino.dart';

class  FattureInCloudFornitoriRequest{
  String apiUid;
  String apiKey;
  String filtro;
  String id;
  String nome;
  String cf;
  String piva;
  int pagina;

  FattureInCloudFornitoriRequest(
      {@required this.apiUid,
        @required this.apiKey,
        this.filtro,
        this.id,
        this.nome,
        this.cf,
        this.piva,
        this.pagina
      });

  toMap(){
    return {
      'api_uid': apiUid,
      'api_key': apiKey,
      'filtro' : filtro,
      'id' : id,
      'nome' : nome,
      'cf' : cf,
      'piva' : piva,
      'pagina' : pagina};

  }
}
