import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../client/fattureICloud/model/response_fatture_api.dart';
import '../../size_config.dart';

class FattureVenditeDetailsPage extends StatefulWidget {


  static String routeName = 'fatture_vendite_details_page';

  @override
  State<FattureVenditeDetailsPage> createState() =>
      _FattureVenditeDetailsPageState();

  const FattureVenditeDetailsPage({Key key}) : super(key: key);
}

class _FattureVenditeDetailsPageState
    extends State<FattureVenditeDetailsPage> {

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: const Text('  Dettaglio Fatture Vendite'),
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
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: getProportionateScreenHeight(40),
                      width: getProportionateScreenWidth(500),
                      child: CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Ricerca per nome fornitore',
                        keyboardType: TextInputType.text,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Ricerca per nome fornitore',
                        onChanged: (currentText) {
                          dataBundleNotifier.filterListaFattureByText(currentText);
                        },
                      ),
                    ),
                  ),
                  dataBundleNotifier.retrieveListaFatture.isNotEmpty ? Column(
                    children: buildListFattureAcquistiDetails(
                        dataBundleNotifier.retrieveListaFatture, height),
                  ) : const Center(child: Text('Non sono presenti fatture per il periodo indicato')),
                ],
              ),
            )
        );
      },
    );
  }

  buildListFattureAcquistiDetails(
      List<ResponseFattureApi> listResponseAcquisti, double height) {
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
                      child: Text( '€ ' + currentFatturaAcquisto.importo_totale),
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
                                                  const SizedBox(height: 20,),
                                                  buildRowDetails('Id Fattura: ', currentFatturaAcquisto.id),
                                                  buildRowDetails('Nome: ', currentFatturaAcquisto.nome),
                                                  buildRowDetails('Data: ', currentFatturaAcquisto.data),
                                                  buildRowDetails('Prossima Scadenza: ', currentFatturaAcquisto.prossima_scadenza),
                                                  buildRowDetails('Tipo Fattura: ', currentFatturaAcquisto.tipo),
                                                  buildRowDetails('Importo Totale: ', '€ ' + currentFatturaAcquisto.importo_totale),
                                                  buildRowDetails('Importo Netto: ', '€ ' + currentFatturaAcquisto.importo_netto),
                                                  buildRowDetails('DDT: ', currentFatturaAcquisto.ddt),
                                                  buildRowDetails('FTACC: ', currentFatturaAcquisto.ftacc),
                                                  buildRowDetails('Numero: ', currentFatturaAcquisto.numero),

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
