class ResponseCompanyFattureInCloud{

  String nome;
  String tipo_licenza;
  int durata_licenza;

  ResponseCompanyFattureInCloud({
    this.nome, this.tipo_licenza, this.durata_licenza});

  factory ResponseCompanyFattureInCloud.fromMap(Map respInfoCompanyMap){
    return ResponseCompanyFattureInCloud(
      durata_licenza: respInfoCompanyMap['durata_licenza'],
      nome: respInfoCompanyMap['nome'],
      tipo_licenza: respInfoCompanyMap['tipo_licenza']);
  }
}