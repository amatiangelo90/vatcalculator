import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../client/vatservice/model/event_model.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_card.dart';

class ArchiviedEventPage extends StatelessWidget {
  const ArchiviedEventPage({Key? key}) : super(key: key);

  static String routeName = "/eventarchivied";
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Area Eventi Chiusi ed Archiviati',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      dataBundleNotifier.currentBranch.companyName,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(11),
                        color: kCustomGreenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            elevation: 2,
          ),
          body: FutureBuilder(
            initialData: <Widget>[
              Column(
                children: const [
                  CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                  Center(child: Text('Caricamento dati..')),
                ],
              ),
            ],
            builder: (context, snapshot){
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: snapshot.data,
                ),
              );
            },
            future: retrieveEventsClosed(dataBundleNotifier),
          ),
        );
      },
    );
  }
  Future retrieveEventsClosed(DataBundleNotifier dataBundleNotifier) async {
    List<EventModel> eventsList = await dataBundleNotifier.getclientServiceInstance().retrieveEventsClosedListByBranchId(dataBundleNotifier.currentBranch);

    List<Widget> eventWidget = [
    ];
    eventsList.forEach((eventModelItem) {
      eventWidget.add(EventCard(eventModel: eventModelItem, showArrow: false, showButton: true));
    });

    return eventWidget;
  }
}
