import 'dart:core';

import 'package:flutter/cupertino.dart';

class  FattureInCloudRequestFornitori{
  String apiUid;
  String apiKey;
  String filtro;
  String id;
  String nome;
  String cf;
  String piva;


  FattureInCloudRequestFornitori(
      {@required this.apiUid,
        @required this.apiKey,
        @required this.filtro,
        @required this.id,
        @required this.nome,
        @required this.cf,
        @required this.piva,
      });

  toMap(){
    return {
      'api_uid': apiUid,
      'api_key': apiKey,
      'filtro': filtro,
      'id': id,
      'nome': nome,
      'cf': cf,
      'piva': piva,
      'pagina': 1
    };

  }
}
