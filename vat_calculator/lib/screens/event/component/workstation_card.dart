import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/workstation_manager_screen.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../constants.dart';

class WorkstationCard extends StatelessWidget {
  const WorkstationCard({Key? key,required this.eventModel,required this.workstationModel,required this.isBarType}) : super(key: key);

  final EventModel eventModel;
  final WorkstationModel workstationModel;
  final bool isBarType;



  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Card(
          shadowColor: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: kPrimaryColor,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 6, 0),
                              child: ClipRect(
                                child: SvgPicture.asset(
                                  isBarType ? 'assets/icons/bartender.svg' : 'assets/icons/bouvette.svg',
                                  height: getProportionateScreenHeight(45),
                                  color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(workstationModel.name,
                              style: TextStyle(fontSize: getProportionateScreenHeight(19), color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen, fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Text(
                                  'Magazzino: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  dataBundleNotifier.retrieveStorageById(eventModel.fkStorageId),
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Workstation: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  workstationModel.type,
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Responsabile: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  workstationModel.responsable == '' ? workstationModel.pkWorkstationId.toString() : '',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Data Evento: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  DateTime.fromMillisecondsSinceEpoch(eventModel.eventDate).day.toString() + '/' +
                                      DateTime.fromMillisecondsSinceEpoch(eventModel.eventDate).month.toString() + '/' +
                                      DateTime.fromMillisecondsSinceEpoch(eventModel.eventDate).year.toString(),
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen, fontWeight: FontWeight.bold),),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.white,
                  height: getProportionateScreenHeight(20),
                ),
                ExpansionTile(
                  textColor: kCustomWhite,
                  collapsedIconColor: kCustomWhite,
                  iconColor: kCustomWhite,
                  title: Text(
                    'Mostra Dettaglio',
                    style: TextStyle(
                        color: kCustomWhite,
                        fontSize: getProportionateScreenHeight(13)),
                  ),
                  children: [
                    FutureBuilder(
                        future: buildProductPage(dataBundleNotifier, workstationModel),
                        builder: (context, snapshot) {
                          if(snapshot != null && snapshot.data != null){
                            return Column(
                              children: snapshot != null ? snapshot.data : [Text('Caricamento')],
                            );
                          }else{
                            return Column(
                              children:  [Text('Caricamento')],
                            );
                          }

                        },
                        initialData: <Widget>[
                        const Center(
                            child: CircularProgressIndicator(
                              color: kPinaColor,
                            )),
                        const SizedBox(),
                        Column(
                          children: const [
                            Center(
                              child: Text(
                                'Caricamento prodotti..',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: kPrimaryColor,
                                    fontFamily: 'LoraFont'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(20),),
                  ],
                ),
                SizedBox(
                  width: getProportionateScreenWidth(400),
                  child: CupertinoButton(
                    color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen,
                    onPressed: () async {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkstationManagerScreen(
                              eventModel: eventModel,
                              workstationModel: workstationModel
                          ),
                        ),
                      );
                    },
                    child: Text('Accedi a ' + workstationModel.name),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future buildProductPage(DataBundleNotifier dataBundleNotifier, WorkstationModel workstationModel) async {
    List<TableRow> list = [
      TableRow(
          children: [
            Column(children:[Row(
              children: [
                Text('Prodotto', style: TextStyle(fontSize: getProportionateScreenHeight(15), color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen)),
              ],
            )]),
            Column(children:[Text('Carico', style: TextStyle(fontSize: getProportionateScreenHeight(15),color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen))]),
            Column(children:[Text('Scarico', style: TextStyle(fontSize: getProportionateScreenHeight(15),color: isBarType ? kCustomOrange : kCustomEvidenziatoreGreen))]),
          ]
      )
    ];

    dataBundleNotifier.workstationsProductsMap[workstationModel.pkWorkstationId]!.forEach((workstationProd) {
        list.add(TableRow(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(workstationProd.productName, style: TextStyle(fontSize: 15.0, color: Colors.white)),
            Text('(${workstationProd.unitMeasure})', style: TextStyle(fontSize: 11.0)),
              ],
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
              Text(workstationProd.refillStock.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 16.0, color: Colors.greenAccent.shade700)),
              ]
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[Text(workstationProd.consumed.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontSize: 16.0, color: Colors.redAccent.shade400))]),
          ]
        ));
      });
    return [Table(
      columnWidths: {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: list,
    )];
  }
}
