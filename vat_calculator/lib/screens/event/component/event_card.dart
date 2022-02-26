import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_manager_screen.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key key, @required this.event}) : super(key: key);

  final EventModel event;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 6, 0),
                            child: ClipRect(
                              child: SvgPicture.asset(
                                'assets/icons/party.svg',
                                height: getProportionateScreenHeight(45),
                                color: kCustomYellow800,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.eventName,
                                style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomYellow800, fontWeight: FontWeight.bold),),
                              Text(
                                'Creato da: ' + event.owner,
                                style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
                              Row(
                                children: [
                                  Text(
                                    'Location: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    event.location,
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: Colors.greenAccent, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Magazzino di riferimento: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    dataBundleNotifier.retrieveStorageById(event.fkStorageId),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: Colors.greenAccent, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Data Evento: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    DateTime.fromMillisecondsSinceEpoch(event.eventDate).day.toString() + '/' +
                                    DateTime.fromMillisecondsSinceEpoch(event.eventDate).month.toString() + '/' +
                                    DateTime.fromMillisecondsSinceEpoch(event.eventDate).year.toString(),
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: Colors.greenAccent, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Evento Aperto: ',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                                  Text(
                                    event.closed == 'N' ? 'SI' : 'NO',
                                    style: TextStyle(fontSize: getProportionateScreenHeight(13), color: Colors.greenAccent, fontWeight: FontWeight.bold),),
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
                    height: getProportionateScreenHeight(49),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(400),
                    child: CupertinoButton(
                      color: kCustomYellow800,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventManagerScreen(
                              event: event,
                            ),
                          ),
                        );
                      },
                      child: Text('Accedi a ' + event.eventName),
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
}
