import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'component/event_body.dart';
import 'component/event_create_screen.dart';

class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({Key key}) : super(key: key);
  static String routeName = "/eventscreen";

  @override
  _EventHomeScreenState createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Creazione evento in corso...',),
      child: Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      Navigator.pushNamed(context, HomeScreen.routeName),
                    }),
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: kPrimaryColor,
                centerTitle: true,
                title: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Area Eventi',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(17),
                            color: kCustomYellow800,
                          ),
                        ),
                        Text(
                          dataBundleNotifier.currentBranch.companyName,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(11),
                            color: kCustomWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      Navigator.pushNamed(
                          context, EventCreateScreen.routeName);
                    },
                  ),
                ],
                elevation: 2,
              ),
              body: const EventsBodyWidget(),
            );
          }),
    );
  }
}
