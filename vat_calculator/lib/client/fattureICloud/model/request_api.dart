import 'dart:core';

import 'package:flutter/cupertino.dart';

class  FattureInCloudRequest{
  String apiUid;
  String apiKey;
  int year;
  String dataInizio;
  String dataFine;
  String fornitore;
  String idFornitore;
  String saldato;
  String mostraLinkAllegato;


  FattureInCloudRequest(
  {@required this.apiUid,
    @required this.apiKey,
    @required this.year,
    this.dataInizio,
    this.dataFine,
    this.fornitore,
    this.idFornitore,
    this.saldato,
    this.mostraLinkAllegato
});

  toMap(){
    return {
      'api_uid': apiUid,
      'api_key': apiKey,
      'anno': year,
      'data_inizio': dataInizio,
      'data_fine': dataFine,
      'fornitore': fornitore,
      'id_fornitore': idFornitore,
      'saldato': saldato,
      'mostra_link_allegato': mostraLinkAllegato,
    };

  }
}
