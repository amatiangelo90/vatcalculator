import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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

  List<WorkstationProductModel> workstationProductModel = [];


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.event.eventName, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(17))),
            centerTitle: true,
          ),
          body: FutureBuilder(
              initialData: <Widget>[
                const Center(
                    child: CircularProgressIndicator(
                      color: kPinaColor,
                    )),
                const SizedBox(),
                Column(
                  children: [
                    Center(
                      child: Text(
                        'Caricamento dati per evento ${widget.event.eventName}..',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
              future: populateWorkstationAndWorkstationsProductList(widget.event, dataBundleNotifier),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Text(workstationProductModel.length.toString()),
                    Text(widget.workstationModelList.length.toString()),
                  ]
                );
              }),
        );
      },
    );
  }

  Future<List<Widget>> populateWorkstationAndWorkstationsProductList(EventModel event, DataBundleNotifier dataBundleNotifier) async {
    //retrieve workstations list by event id

    if(widget.workstationModelList.isNotEmpty){
      widget.workstationModelList.forEach((workstation) async {
        List<WorkstationProductModel> tmpList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstation);
        print('tmpList: ' + tmpList.length.toString());
        workstationProductModel.addAll(tmpList);
      });
    }

    return [];
  }
}