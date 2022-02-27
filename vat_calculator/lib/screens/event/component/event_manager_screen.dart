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

              bottom: TabBar(
                indicatorColor: kCustomYellow800,
                indicatorWeight: 4,
                tabs: [
                  Tab(icon: SvgPicture.asset('assets/icons/party.svg', color: kCustomYellow800, width: getProportionateScreenHeight(34),)),
                  Tab(icon: SvgPicture.asset('assets/icons/chart.svg', width: getProportionateScreenHeight(27),)),
                  Tab(icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomYellow800,)),
                ],

              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.event.eventName,
                    style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomYellow800, fontWeight: FontWeight.bold),),
                  Text(
                    'Creato da: ' + widget.event.owner,
                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
                ],
              ),
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