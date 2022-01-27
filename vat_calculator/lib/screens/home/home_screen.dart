import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.9,
          overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati...',),
          child: Scaffold(
            drawer: const CommonDrawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: kCustomWhite),
              backgroundColor: Colors.black.withOpacity(0.9),
              actions: [
                Stack(
                  children: [ IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/receipt.svg',
                      color: kCustomWhite,
                      width: 25,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, CreateOrderScreen.routeName);
                    },
                  ),
                    Positioned(
                      top: 26.0,
                      right: 9.0,
                      child: Stack(
                        children: const <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 18,
                            color: Colors.black,
                          ),
                          Positioned(
                            right: 2.5,
                            top: 2.5,
                            child: Center(
                              child: Icon(Icons.add_circle_outline, size: 13, color: kCustomYellowDarker,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5,),
              ],
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    "Ciao ${dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].firstName : ''}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: kCustomYellow800,
                    ),
                  ),
                  Text(
                    dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].email : '',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(7),
                      color: kCustomWhite,
                    ),
                  ),
                  Text(
                    dataBundleNotifier.dataBundleList.isNotEmpty && dataBundleNotifier.dataBundleList[0].companyList.isNotEmpty ?
                    dataBundleNotifier.currentBranch.accessPrivilege + ' per ' + dataBundleNotifier.currentBranch.companyName : '',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(5),
                      color: kCustomWhite,
                    ),
                  ),

                ],
              ),

              elevation: 0,
            ),
            body: const HomePageBody(),
            bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
          ),
        );
      },
    );
  }
}