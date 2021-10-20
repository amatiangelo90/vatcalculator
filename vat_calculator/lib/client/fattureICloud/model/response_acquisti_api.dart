class ResponseAcquistiApi{
  String id;
  String id_fornitore;
  String nome;
  String data;
  String importo_netto;
  String importo_iva;
  String importo_totale;
  String valuta;
  String valuta_cambio;
  String descrizione;
  String file_allegato;
  String prossima_scadenza;
  String tipo;
  bool saldato;

  ResponseAcquistiApi(
      {
        this.id,
        this.id_fornitore,
        this.nome,
        this.data,
        this.importo_netto,
        this.importo_iva,
        this.importo_totale,
        this.valuta,
        this.valuta_cambio,
        this.descrizione,
        this.file_allegato,
        this.prossima_scadenza,
        this.tipo,
        this.saldato});


  factory ResponseAcquistiApi.fromMap(Map cartMap){
    return ResponseAcquistiApi(
      id: cartMap['id'].toString(),
      id_fornitore: cartMap['id_fornitore'].toString(),
      nome: cartMap['nome'].toString(),
      data: cartMap['data'].toString(),
      importo_netto: cartMap['importo_netto'].toString(),
      importo_iva: cartMap['importo_iva'].toString(),
      importo_totale: cartMap['importo_totale'].toString(),
      valuta: cartMap['valuta'].toString(),
      valuta_cambio: cartMap['valuta_cambio'].toString(),
      descrizione: cartMap['descrizione'].toString(),
      file_allegato: cartMap['file_allegato'].toString(),
      prossima_scadenza: cartMap['prossima_scadenza'].toString(),
      tipo: cartMap['tipo'].toString(),
      saldato: cartMap['saldato'],
    );
  }


}