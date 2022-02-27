import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
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

  Future<List<Widget>> populateWorkstationAndWorkstationsProductList(EventModel event, DataBundleNotifier dataBundleNotifier) {
    //retrieve workstations list by event id

    if(widget.workstationModelList.isNotEmpty){
      widget.workstationModelList.forEach((workstation) async {
        List<WorkstationProductModel> tmpList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstation);
        print('tmpList: ' + tmpList.length.toString());
        workstationProductModel.addAll(tmpList);
        print('Size list: ' + workstationProductModel.length.toString());
      });
    }

    return null;
  }

  buildWorkstationsWidget(List<WorkstationModel> workstationModelList) {
    List<Widget> list = [];

    workstationModelList.forEach((workstationModel) {
      list.add(Row(
        children: [
          Text(workstationModel.name),
          Text(workstationModel.closed),
          Text(workstationModel.type),
          Text(workstationModel.pkWorkstationId.toString()),
        ],
      ));
    });
    return list;
  }

  buildSettingEventPage(List<WorkstationModel> workstationModelList, DataBundleNotifier dataBundleNotifier) {
    return FutureBuilder(
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
                'Caricamento dati..',
                style: TextStyle(
                    fontSize: 16.0,
                    color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ],
      future: buildProductManagmentPage(workstationModelList, dataBundleNotifier),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: getProportionateScreenHeight(205),
              child: PageView.builder(
                itemCount: widget.workstationModelList.length,
                itemBuilder: (context, index) =>
                    WorkstationCard(
                      workstationModel: widget.workstationModelList[index],
                      showExpandedTile: false,
                      workstationIdProductListMap: workstationIdProductListMap,
                    ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future buildProductManagmentPage(List<WorkstationModel> workstationModelList, DataBundleNotifier dataBundleNotifier) async {

    List<WorkstationProductModel> workAll = [];
    workstationModelList.forEach((workstation) async {
      List<WorkstationProductModel> prodModelWorkstationList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstation);
      print(prodModelWorkstationList.length.toString());
      workstationIdProductListMap[workstation.pkWorkstationId] = prodModelWorkstationList;
    });

    return [];
  }
}