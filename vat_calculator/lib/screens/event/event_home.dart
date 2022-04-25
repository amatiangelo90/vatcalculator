import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../main_page.dart';
import 'component/archivied_events_screen.dart';
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
      overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati in corso...',),
      child: Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              bottomSheet: dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : Padding(
                padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(400),
                  child: CupertinoButton(
                    color: kCustomGreenAccent,
                    child: Text('CREA EVENTO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(15))),
                    onPressed: (){
                      Navigator.pushNamed(context,
                          EventCreateScreen.routeName);
                    },
                  ),
                ),
              ),
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      dataBundleNotifier.onItemTapped(0);
                      Navigator.pushNamed(context, HomeScreenMain.routeName);
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
                actions: [
                  dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? const SizedBox(width: 5) : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/archive.svg",
                          width: 25,
                          color: kCustomWhite,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, ArchiviedEventPage.routeName);
                        }),
                  ),
                  const SizedBox(width: 5),
                  dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Stack(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/party.svg',
                            color: Colors.white,
                            width: 50,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context,
                                EventCreateScreen.routeName);
                          },
                        ),
                        Positioned(
                          top: 26.0,
                          right: 9.0,
                          child: Stack(
                            children:  const <Widget>[
                              Icon(
                                Icons.brightness_1,
                                size: 18,
                                color: kPrimaryColor,
                              ),
                              Positioned(
                                right: 2.5,
                                top: 2.5,
                                child: Center(
                                  child: Icon(
                                    Icons
                                        .add_circle_outline,
                                    size: 13,
                                    color:
                                    kCustomGreenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                ],
                elevation: 2,
              ),
              body: EventsBodyWidget(),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}