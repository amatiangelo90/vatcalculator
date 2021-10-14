class ResponseNDCApi{
  String id;
  String id_cliente;
  String nome;
  String data;
  String importo_netto;
  String importo_totale;
  String valuta;
  String valuta_cambio;
  String token;
  String prossima_scadenza;
  String pa;
  String tipo;
  String numero;
  String linkDoc;
  String pa_tipo_cliente;


  ResponseNDCApi({
    this.id,
    this.id_cliente,
    this.nome,
    this.data,
    this.importo_netto,
    this.importo_totale,
    this.valuta,
    this.valuta_cambio,
    this.token,
    this.prossima_scadenza,
    this.pa,
    this.tipo,
    this.numero,
    this.linkDoc,
    this.pa_tipo_cliente});

  factory ResponseNDCApi.fromMap(Map cartMap){
    return ResponseNDCApi(
        id: cartMap['id'].toString(),
        data: cartMap['data'].toString(),
        id_cliente: cartMap['id_cliente'].toString(),
        importo_netto: cartMap['importo_netto'].toString(),
        importo_totale: cartMap['importo_totale'].toString(),
        linkDoc: cartMap['link_doc'].toString(),
        nome: cartMap['nome'].toString(),
        numero: cartMap['numero'].toString(),
        pa: cartMap['pa'].toString(),
        pa_tipo_cliente: cartMap['PA_tipo_cliente'].toString(),
        prossima_scadenza: cartMap['prossima_scadenza'].toString(),
        tipo: cartMap['tipo'].toString(),
        token: cartMap['token'].toString(),
        valuta: cartMap['valuta'].toString(),
        valuta_cambio: cartMap['valuta_cambio'].toString()
    );
  }
}