import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_type.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/workstation_card.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../constants.dart';

class EventManagerScreen extends StatefulWidget {
  const EventManagerScreen({Key key, this.event, this.workstationModelList}) : super(key: key);

  final EventModel event;
  final List<WorkstationModel> workstationModelList;

  @override
  _EventManagerScreenState createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  Map<int, List<WorkstationProductModel>> workstationIdProductListMap = {};
  List<WorkstationProductModel> workstationProductModel = [];


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                Stack(
                  children: [ IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/bouvette.svg',
                      color: kGreenAccent,
                      width: 25,
                    ),
                    onPressed: () async {
                      await dataBundleNotifier.getclientServiceInstance().createWorkstations([
                        WorkstationModel(
                            closed: 'N',
                            extra: '',
                            fkEventId: widget.event.pkEventId,
                            pkWorkstationId: 0,
                            name: 'Nuova Champagnerie',
                            responsable: '',
                            type: WORKSTATION_TYPE_CHAMP
                        )
                      ]);

                      List<WorkstationModel> workstationModelListNew = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(widget.event);

                      setState(() {
                        widget.workstationModelList.clear();
                        widget.workstationModelList.addAll(workstationModelListNew);
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.green.withOpacity(0.8),
                          duration: Duration(milliseconds: 800),
                          content: Text('Nuova postazione Champagnerie creata')));
                    },
                  ),
                    Positioned(
                      top: 26.0,
                      right: 9.0,
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 18,
                            color: kPrimaryColor,
                          ),
                          Positioned(
                            right: 2.5,
                            top: 2.5,
                            child: Center(
                              child: Icon(Icons.add_circle_outline, size: 13, color: kGreenAccent,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [ IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/bartender.svg',
                      color: kCustomOrange,
                      width: 25,
                    ),
                    onPressed: () async {
                      await dataBundleNotifier.getclientServiceInstance().createWorkstations([
                        WorkstationModel(
                            closed: 'N',
                            extra: '',
                            fkEventId: widget.event.pkEventId,
                            pkWorkstationId: 0,
                            name: 'Nuovo Bar',
                            responsable: '',
                            type: WORKSTATION_TYPE_BAR
                        )
                      ]);

                      List<WorkstationModel> workstationModelListNew = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(widget.event);

                      setState(() {
                        widget.workstationModelList.clear();
                        widget.workstationModelList.addAll(workstationModelListNew);
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.green.withOpacity(0.8),
                          duration: Duration(milliseconds: 800),
                          content: Text('Nuova postazione Bar creata')));

                    },
                  ),
                    Positioned(
                      top: 26.0,
                      right: 9.0,
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 18,
                            color: kPrimaryColor,
                          ),
                          Positioned(
                            right: 2.5,
                            top: 2.5,
                            child: Center(
                              child: Icon(Icons.add_circle_outline, size: 13, color: kCustomOrange,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                indicatorColor: kCustomOrange,
                indicatorWeight: 4,
                tabs: [
                  Tab(icon: SvgPicture.asset('assets/icons/party.svg', color: kCustomOrange, width: getProportionateScreenHeight(34),)),
                  Tab(icon: SvgPicture.asset('assets/icons/chart.svg', width: getProportionateScreenHeight(27),)),
                  Tab(icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomOrange,)),
                ],
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.event.eventName,
                    style: TextStyle(fontSize: getProportionateScreenHeight(22), color: kCustomOrange, fontWeight: FontWeight.bold),),
                  Text(
                    'Creato da: ' + widget.event.owner,
                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
                ],
              ),
              elevation: 5,
            ),
            backgroundColor: Colors.white,
            body: TabBarView(
              children: [
                buildSettingEventPage(widget.workstationModelList, dataBundleNotifier),
                Text('chart'),
                Text('settings'),
              ],
            ),
          ),
        );
      },
    );
  }


  buildSettingEventPage(List<WorkstationModel> workstationModelList, DataBundleNotifier dataBundleNotifier) {
    List<Widget> listWgBar = [];
    workstationModelList.where((element) => element.type == WORKSTATION_TYPE_BAR).forEach((wkStation) {
      listWgBar.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: WorkstationCard(
          eventModel: widget.event,
          workstationModel: wkStation,
          isBarType : true,
        ),
      ),);
    });
    List<Widget> listWgChamp = [];
    workstationModelList.where((element) => element.type == WORKSTATION_TYPE_CHAMP).forEach((wkStation) {
      listWgChamp.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: WorkstationCard(
          eventModel: widget.event,
          workstationModel: wkStation,
          isBarType : false,
        ),
      ),);
    });

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Column(
            children: listWgBar,
          ),
          Column(
            children: listWgChamp,
          ),
        ])
    );
  }


}