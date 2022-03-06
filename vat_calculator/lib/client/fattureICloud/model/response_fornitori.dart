class SupplierModel {
  int pkSupplierId;
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
  String pagamento_fine_mese;
  String val_iva_default;
  String desc_iva_default;
  String extra;
  String PA;
  String PA_codice;
  int fkBranchId;

  SupplierModel(
      {this.pkSupplierId,
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
      this.extra,
      this.fkBranchId});

  factory SupplierModel.fromMap(Map cartMap) {
    return SupplierModel(
        pkSupplierId: 0,
        id: cartMap['id'].toString(),
        nome: cartMap['name'].toString(),
        referente: cartMap['referente'].toString(),
        indirizzo_via: cartMap['indirizzo_via'].toString(),
        indirizzo_cap: cartMap['indirizzo_cap'].toString(),
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
        extra: cartMap['extra'].toString(),
        fkBranchId: cartMap['fkBranchId']);
  }

  toMap() {
    return {
      'pk_supplier_id': pkSupplierId,
      'id': id,
      'name': nome,
      'referente': referente,
      'indirizzo_via': indirizzo_via,
      'indirizzo_cap': indirizzo_cap,
      'indirizzo_citta': indirizzo_citta,
      'indirizzo_provincia': indirizzo_provincia,
      'indirizzo_extra': indirizzo_extra,
      'paese': paese,
      'mail': mail,
      'pec': pec,
      'tel': tel,
      'fax': fax,
      'piva': piva,
      'cf': cf,
      'extra': extra,
      'fk_branch_id': fkBranchId
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplierModel &&
          runtimeType == other.runtimeType &&
          nome == other.nome;

  @override
  int get hashCode => nome.hashCode;


}
