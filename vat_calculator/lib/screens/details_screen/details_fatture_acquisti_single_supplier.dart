import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../client/fattureICloud/model/response_acquisti_api.dart';
import '../../constants.dart';
import '../../size_config.dart';

class DetailsFattureAcquistiSingleSupplier extends StatefulWidget {
  const DetailsFattureAcquistiSingleSupplier({Key key, this.currentListFattureAcquisti}) : super(key: key);

  static String routeName = 'fatture_acquisti_details_page_single_supplier';
  final List<ResponseAcquistiApi> currentListFattureAcquisti;

  @override
  State<DetailsFattureAcquistiSingleSupplier> createState() => _DetailsFattureAcquistiSingleSupplierState();
}

class _DetailsFattureAcquistiSingleSupplierState extends State<DetailsFattureAcquistiSingleSupplier> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: const Text('  Dettaglio Fatture Acquisti',style: TextStyle(
            fontSize: 15.0,
            color: kCustomWhite,
            fontWeight: FontWeight.w800,
          ),),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: buildListFattureAcquistiDetails(
              widget.currentListFattureAcquisti, height),
        ),
      ),
    ));
  }

  buildListFattureAcquistiDetails(
      List<ResponseAcquistiApi> listResponseAcquisti, double height) {
    List<Widget> outList = [];

    listResponseAcquisti.forEach((currentFatturaAcquisto) {
      outList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SizedBox(
            height: 80,
            child: Card(
              elevation: 5,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(currentFatturaAcquisto.nome, style: TextStyle(fontSize: 11),),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Text(currentFatturaAcquisto.data, style: TextStyle(fontSize: 10),),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Text( '??? ' + currentFatturaAcquisto.importo_totale),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: IconButton(icon: const Icon(
                        Icons.description,
                        color: kPrimaryColor,
                      ), onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  var height = MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return SizedBox(
                                    height: height - 350,
                                    width: width,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  topLeft: Radius.circular(10.0)),
                                              color: kPrimaryColor,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '    Dettaglio Fattura Acquisto',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize:
                                                    getProportionateScreenWidth(
                                                        10),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.clear,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  Center(child: Text(currentFatturaAcquisto.nome),),
                                                  SizedBox(height: 20,),
                                                  buildRowDetails('Id Fattura: ', currentFatturaAcquisto.id),
                                                  buildRowDetails('Id Fornitore: ', currentFatturaAcquisto.id_fornitore),
                                                  buildRowDetails('Data: ', currentFatturaAcquisto.data),
                                                  buildRowDetails('Prossima Scadenza: ', currentFatturaAcquisto.prossima_scadenza),
                                                  buildRowDetails('Tipo Fattura: ', currentFatturaAcquisto.tipo),
                                                  buildRowDetails('Importo Totale: ', '??? ' + currentFatturaAcquisto.importo_totale),
                                                  buildRowDetails('Importo Netto: ', '??? ' + currentFatturaAcquisto.importo_netto),
                                                  buildRowDetails('Importo Iva: ', '??? ' + currentFatturaAcquisto.importo_iva),
                                                  buildRowDetails('Descrizione: ', currentFatturaAcquisto.descrizione),
                                                  buildRowDetails('Saldato: ', currentFatturaAcquisto.saldato.toString()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ));

                      },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return outList;
  }

  buildRowDetails(String description, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
        ),
        Text(
          data,
        ),
      ],
    );
  }

}
