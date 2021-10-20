import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/constants.dart';

import '../../size_config.dart';

class FattureAcquistiDetailsPage extends StatefulWidget {
  List<ResponseAcquistiApi> listResponseAcquisti = [];

  FattureAcquistiDetailsPage({@required this.listResponseAcquisti, Key key})
      : super(key: key);

  @override
  State<FattureAcquistiDetailsPage> createState() =>
      _FattureAcquistiDetailsPageState();
}

class _FattureAcquistiDetailsPageState
    extends State<FattureAcquistiDetailsPage> {
  TextEditingController editingController = TextEditingController();
  List<ResponseAcquistiApi> currentFattureAcquistiList;
  List<ResponseAcquistiApi> appoggio;

  @override
  void initState() {
    super.initState();
    currentFattureAcquistiList = widget.listResponseAcquisti;
    appoggio = widget.listResponseAcquisti;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: const Text('  Dettaglio Fatture Acquisti'),
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
          children: buildListFattureAcquistiDetails(
              currentFattureAcquistiList, height),
        ),
      ),
    );
  }

  buildListFattureAcquistiDetails(
      List<ResponseAcquistiApi> listResponseAcquisti, double height) {
    List<Widget> outList = [];
    outList.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: height * 1 / 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                    labelText:
                        "Ricerca per Fornitore, Id Fornitore o importo iva",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
          ),
        ),
      ),
    );

    Map<String, List<ResponseAcquistiApi>> map = {};

    listResponseAcquisti.forEach((currentElement) {
      if (map.containsKey(currentElement.id_fornitore)) {
        map[currentElement.id_fornitore].add(currentElement);
      } else {
        List<ResponseAcquistiApi> list = [];
        list.add(currentElement);
        map[currentElement.id_fornitore] = list;
      }
    });

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
                                                    SizedBox(height: 20,),
                                                    buildRowDetails('Id Fattura: ', currentFatturaAcquisto.id),
                                                    buildRowDetails('Id Fornitore: ', currentFatturaAcquisto.id_fornitore),
                                                    buildRowDetails('Data: ', currentFatturaAcquisto.data),
                                                    buildRowDetails('Prossima Scadenza: ', currentFatturaAcquisto.prossima_scadenza),
                                                    buildRowDetails('Tipo Fattura: ', currentFatturaAcquisto.tipo),
                                                    buildRowDetails('Importo Totale: ', '€ ' + currentFatturaAcquisto.importo_totale),
                                                    buildRowDetails('Importo Netto: ', '€ ' + currentFatturaAcquisto.importo_netto),
                                                    buildRowDetails('Importo Iva: ', '€ ' + currentFatturaAcquisto.importo_iva),
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

  refreshList(List<ResponseAcquistiApi> incomingList) {
    print(incomingList.length);
    print(incomingList[0].nome.toString());
    setState(() {
      currentFattureAcquistiList.clear();
      currentFattureAcquistiList.addAll(incomingList);
    });
  }

  void filterSearchResults(String query) {
    List<ResponseAcquistiApi> fattureAcquistiList = <ResponseAcquistiApi>[];
    fattureAcquistiList.addAll(appoggio);

    if (query.isNotEmpty) {
      List<ResponseAcquistiApi> dummyListData = <ResponseAcquistiApi>[];

      fattureAcquistiList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase()) ||
            item.id_fornitore.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      refreshList(dummyListData);
      return;
    } else {
      print('empty');
      refreshList(appoggio);
      return;
    }
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
