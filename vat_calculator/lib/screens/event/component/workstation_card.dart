import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../constants.dart';

class WorkstationCard extends StatelessWidget {
  const WorkstationCard({Key key, this.eventModel, this.workstationModel, this.isBarType}) : super(key: key);

  final EventModel eventModel;
  final WorkstationModel workstationModel;
  final bool isBarType;
  @override
  Widget build(BuildContext context) {
    print('workstation model ' + workstationModel.pkWorkstationId.toString());

    Color barColor = kCustomYellow800;
    Color champColor = Colors.redAccent;


    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Card(
          shadowColor: isBarType ? barColor : champColor,
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
                                    isBarType ? 'assets/icons/bartender.svg' : 'assets/icons/champagnerie.svg',
                                    height: getProportionateScreenHeight(45),
                                    color: isBarType ? barColor : champColor,
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
                                style: TextStyle(fontSize: getProportionateScreenHeight(19), color: isBarType ? barColor : champColor, fontWeight: FontWeight.bold),),
                              Row(
                                children: [
                                  Text(
                                    'Magazzino di riferimento: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    dataBundleNotifier.retrieveStorageById(eventModel.fkStorageId),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? barColor : champColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Workstation: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    workstationModel.type,
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? barColor : champColor, fontWeight: FontWeight.bold),),
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
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: isBarType ? barColor : champColor, fontWeight: FontWeight.bold),),
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
                    color: kCustomYellow800,
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
                      color: isBarType ? barColor : champColor,
                      onPressed: () async {
                      },
                      child: Text('Accedi a ' + workstationModel.name),
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
    List<Widget> list = [];

    List<WorkstationProductModel> workStationProdModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstationModel);
      workStationProdModelList.forEach((workstationProd) {
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(workstationProd.productName),
            Text(workstationProd.storeStock.toString()),
            Text(workstationProd.consumed.toString()),
            Text(workstationProd.amountHunderd.toString()),


          ],
        ));
      });
    return list;
  }

}
