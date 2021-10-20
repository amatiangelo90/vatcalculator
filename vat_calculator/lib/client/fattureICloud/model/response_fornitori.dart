class ResponseFornitori{
  String id;
  String nome;
  String referente;
  String indirizzo_via;
  String indirizzo_cap;
  String indirizzo_citta;
  String indirizzo_provincia;
  String indirizzo_extra;
  String paese;
  String mail;
  String pec;
  String tel;
  String fax;
  String piva;
  String cf;
  String termini_pagamento;
  bool pagamento_fine_mese;
  String val_iva_default;
  String desc_iva_default;
  String extra;
  bool PA;
  bool PA_codice;


  ResponseFornitori({
    this.id,
    this.nome,
    this.referente,
    this.indirizzo_via,
    this.indirizzo_cap,
    this.indirizzo_citta,
    this.indirizzo_provincia,
    this.indirizzo_extra,
    this.paese,
    this.mail,
    this.pec,
    this.tel,
    this.fax,
    this.piva,
    this.cf,
    this.termini_pagamento,
    this.pagamento_fine_mese,
    this.val_iva_default,
    this.desc_iva_default,
    this.extra,
    this.PA,
    this.PA_codice});

  factory ResponseFornitori.fromMap(Map cartMap){
    return ResponseFornitori(
      id: cartMap['id'].toString(),
      nome: cartMap['nome'].toString(),
      referente: cartMap['referente'].toString(),
      indirizzo_via: cartMap['indirizzo_via'].toString(),
      indirizzo_cap:  cartMap['indirizzo_cap'].toString(),
      indirizzo_citta: cartMap['indirizzo_citta'].toString(),
      indirizzo_provincia: cartMap['indirizzo_provincia'].toString(),
      indirizzo_extra: cartMap['indirizzo_extra'].toString(),
      paese: cartMap['paese'].toString(),
      mail: cartMap['mail'].toString(),
      pec: cartMap['pec'].toString(),
      tel: cartMap['tel'].toString(),
      fax: cartMap['fax'].toString(),
      piva: cartMap['piva'].toString(),
      cf: cartMap['cf'].toString(),
      termini_pagamento: cartMap['termini_pagamento'].toString(),
      pagamento_fine_mese: cartMap['pagamento_fine_mese'],
      val_iva_default: cartMap['val_iva_default'].toString(),
      desc_iva_default: cartMap['desc_iva_default'].toString(),
      extra: cartMap['extra'].toString(),
      PA: cartMap['PA'],
      PA_codice: cartMap['PA_codice']);
  }


}