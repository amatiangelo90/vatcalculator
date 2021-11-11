import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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
          overlayWidget: LoaderOverlayWidget(),
          child: Scaffold(
            drawer: const CommonDrawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: kPrimaryColor),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/chat-cust.svg',
                    color: kPrimaryColor,
                    width: 25,
                  ),
                  onPressed: () {

                  },
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
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].email : '',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(7),
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),

              elevation: 0,
            ),
            body: const Body(),
            bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home),
          ),
        );
      },
    );
  }
}