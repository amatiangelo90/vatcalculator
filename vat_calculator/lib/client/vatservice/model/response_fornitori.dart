class SupplierModel {
  final int pkSupplierId;
  final String id;
  final String nome;
  final String referente;
  final String indirizzo_via;
  final String indirizzo_cap;
  final String indirizzo_citta;
  final String indirizzo_provincia;
  final String indirizzo_extra;
  final String paese;
  final String mail;
  final String pec;
  final String tel;
  final String fax;
  final String piva;
  final String cf;
  final String extra;
  final int fkBranchId;


  SupplierModel(
      {
        required this.pkSupplierId,
      required this.id,
      required this.nome,
      required this.referente,
      required this.indirizzo_via,
      required this.indirizzo_cap,
      required this.indirizzo_citta,
      required this.indirizzo_provincia,
      required this.indirizzo_extra,
      required this.paese,
      required this.mail,
      required this.pec,
      required this.tel,
      required this.fax,
      required this.piva,
      required this.cf,
      required this.extra,
      required this.fkBranchId});

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
