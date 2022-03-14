import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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
                                    color: kCustomBlueAccent,
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
                                style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomBlueAccent, fontWeight: FontWeight.bold),),
                              Text(
                                'Creato da: ' + eventModel.owner,
                                style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
                              Row(
                                children: [
                                  Text(
                                    'Location: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    eventModel.location,
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: kCustomOrange, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Magazzino di riferimento: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    dataBundleNotifier.retrieveStorageById(eventModel.fkStorageId),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: kCustomOrange, fontWeight: FontWeight.bold),),
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
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: kCustomOrange, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Evento Aperto: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    eventModel.closed == 'N' ? 'SI' : 'NO',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: kCustomOrange, fontWeight: FontWeight.bold),),
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
                    color: kCustomOrange,
                    height: getProportionateScreenHeight(49),
                  ),
                  showButton ? SizedBox(
                    width: getProportionateScreenWidth(400),
                    child: CupertinoButton(
                      color: kCustomBlueAccent,
                      onPressed: () async {
                        List<WorkstationModel> workstationModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(eventModel);

                        sleep(const Duration(milliseconds: 200));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventManagerScreen(
                              event: eventModel,
                              workstationModelList: workstationModelList,
                            ),
                          ),
                        );
                      },
                      child: Text('Accedi a ' + eventModel.eventName),
                    ),
                  ) : SizedBox(width: 0,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
