import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/components/light_colors.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../client/vatservice/model/expence_event_model.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_manager_screen.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key key, @required this.eventModel, @required this.showButton, @required this.showArrow}) : super(key: key);

  final EventModel eventModel;
  final bool showButton;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Card(
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
                            showArrow ? IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                                onPressed: () => {
                                    Navigator.of(context).pop(),
                                  }
                                ) : const SizedBox(width: 0,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 6, 0),
                              child: ClipRect(
                                child: SvgPicture.asset(
                                  'assets/icons/party.svg',
                                  height: getProportionateScreenHeight(45),
                                  color: LightColors.kLightYellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(eventModel.eventName,
                              style: TextStyle(fontSize: getProportionateScreenHeight(19), color: Colors.white, fontWeight: FontWeight.bold),),

                            Row(
                              children: [
                                Text(
                                  'Location: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  eventModel.location,
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: LightColors.kPalePink, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Magazzino: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  dataBundleNotifier.retrieveStorageById(eventModel.fkStorageId),
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13),  color: LightColors.kPalePink, fontWeight: FontWeight.bold),),
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
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: LightColors.kPalePink, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Evento Aperto: ',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                Text(
                                  eventModel.closed == 'N' ? 'SI' : 'NO',
                                  style: TextStyle(fontSize: getProportionateScreenHeight(13), color: eventModel.closed == 'N' ? Colors.lightGreenAccent : kPinaColor, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Text(
                              'Creato da: ' + eventModel.owner,
                              style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: LightColors.kPalePink,
                  height: getProportionateScreenHeight(40),
                ),
                showButton ? SizedBox(
                  width: getProportionateScreenWidth(400),
                  child: CupertinoButton(
                    color: LightColors.kPalePink,
                    onPressed: () async {

                      List<WorkstationModel> workstationModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(eventModel);
                      List<ExpenceEventModel> listExpenceEvent = await dataBundleNotifier.getclientServiceInstance().retrieveEventExpencesByEventId(eventModel);

                      dataBundleNotifier.setCurrentExpenceEventList(listExpenceEvent);
                      dataBundleNotifier.setCurrentWorkstationModelList(workstationModelList);
                      dataBundleNotifier.setCurrentEventModel(eventModel);

                      dataBundleNotifier.workstationsProductsMapCalculate();

                      sleep(const Duration(milliseconds: 200));

                      Navigator.pushNamed(context, EventManagerScreen.routeName);
                    },
                    child: Text('Accedi a ' + eventModel.eventName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: getProportionateScreenWidth(20))),
                  ),
                ) : SizedBox(width: 0,)
              ],
            ),
          ),
        );
      },
    );
  }
}
