import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/workstation_manager_screen.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../constants.dart';

class WorkstationCard extends StatefulWidget {
  const WorkstationCard({Key key, this.eventModel, this.workstationModel, this.isBarType}) : super(key: key);

  final EventModel eventModel;
  final WorkstationModel workstationModel;
  final bool isBarType;

  @override
  State<WorkstationCard> createState() => _WorkstationCardState();
}

class _WorkstationCardState extends State<WorkstationCard> {



  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Card(
          shadowColor: widget.isBarType ? kCustomOrange : kGreenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: kPrimaryColor,
          elevation: 5,
          child: GestureDetector(
            onTap: () {

            },
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
                                    widget.isBarType ? 'assets/icons/bartender.svg' : 'assets/icons/bouvette.svg',
                                    height: getProportionateScreenHeight(45),
                                    color: widget.isBarType ? kCustomOrange : kGreenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.workstationModel.name,
                                style: TextStyle(fontSize: getProportionateScreenHeight(19), color: widget.isBarType ? kCustomOrange : kGreenAccent, fontWeight: FontWeight.bold),),
                              Row(
                                children: [
                                  Text(
                                    'Magazzino di riferimento: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    dataBundleNotifier.retrieveStorageById(widget.eventModel.fkStorageId),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: widget.isBarType ? kCustomOrange : kGreenAccent, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Workstation: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    widget.workstationModel.type,
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: widget.isBarType ? kCustomOrange : kGreenAccent, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Responsabile: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    widget.workstationModel.responsable == '' ? '-' : widget.workstationModel.responsable,
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: widget.isBarType ? kCustomOrange : kGreenAccent, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Data Evento: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    DateTime.fromMillisecondsSinceEpoch(widget.eventModel.eventDate).day.toString() + '/' +
                                        DateTime.fromMillisecondsSinceEpoch(widget.eventModel.eventDate).month.toString() + '/' +
                                        DateTime.fromMillisecondsSinceEpoch(widget.eventModel.eventDate).year.toString(),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: widget.isBarType ? kCustomOrange : kGreenAccent, fontWeight: FontWeight.bold),),
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
                          future: buildProductPage(dataBundleNotifier, widget.workstationModel),
                          builder: (context, snapshot) {
                            return Column(
                              children: snapshot.data,
                            );
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
                      color: widget.isBarType ? kCustomOrange : kGreenAccent,
                      onPressed: () async {
                        List<WorkstationProductModel> workStationProdModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(widget.workstationModel);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkstationManagerScreen(
                                eventModel: widget.eventModel,
                                workstationModel: widget.workstationModel,
                                workStationProdModelList: workStationProdModelList,
                                callbackFuntion: callbackFuntion
                            ),
                          ),
                        );
                      },
                      child: Text('Accedi a ' + widget.workstationModel.name),
                    ),
                  ),
                ],
              ),
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
                Text('Prodotto', style: TextStyle(fontSize: getProportionateScreenHeight(12), color: widget.isBarType ? kCustomOrange : kGreenAccent)),
              ],
            )]),
            Column(children:[Text('Carico', style: TextStyle(fontSize: getProportionateScreenHeight(12),color: widget.isBarType ? kCustomOrange : kGreenAccent))]),
            Column(children:[Text('Consumo', style: TextStyle(fontSize: getProportionateScreenHeight(12),color: widget.isBarType ? kCustomOrange : kGreenAccent))]),
          ]
      )
    ];

    List<WorkstationProductModel> workStationProdModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstationModel);

    workStationProdModelList.forEach((workstationProd) {
        list.add(TableRow(
          children: [
            Column(children:[Row(
              children: [
                Text(workstationProd.productName, style: TextStyle(fontSize: 11.0, color: Colors.white)),
                Text(' (${workstationProd.unitMeasure})', style: TextStyle(fontSize: 11.0)),
              ],
            )]),
            Column(children:[Text(workstationProd.refillStock.toStringAsFixed(2), style: TextStyle(fontSize: 11.0, color: Colors.greenAccent.shade700))]),
            Column(children:[Text(workstationProd.consumed.toStringAsFixed(2), style: TextStyle(fontSize: 11.0, color: Colors.redAccent.shade400))]),
          ]
        ));
      });
    return [Table(
      children: list,
    )];
  }

  callbackFuntion() {
    setState(() {
    });
  }
}
