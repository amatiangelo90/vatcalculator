import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';
import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Container(
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            border: Border(
              top: BorderSide(
                color: kPrimaryColor,
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/home.svg",
                        color: MenuState.home == selectedMenu
                            ? Colors.greenAccent
                            : inActiveIconColor,
                        width: 30,
                      ),
                      onPressed: () {
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      }),
                  Stack(
                    children: [
                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/icons/receipt.svg",
                            color: MenuState.orders == selectedMenu
                                ? Colors.greenAccent
                                : inActiveIconColor,
                            width: 30,
                          ),
                          onPressed: () {
                            dataBundleNotifier.setShowIvaButtonToFalse();
                            Navigator.pushNamed(
                                context, OrdersScreen.routeName);
                          }),
                      Positioned(
                        top: 3.0,
                        right: 10.0,
                        child: Stack(
                          children: <Widget>[
                            const Icon(Icons.brightness_1, size: 15, color: Colors.redAccent,),
                            Positioned(
                              right: 5.0,
                              top: 3.0,
                              child: Center(child: Text('0'.toString() , style: TextStyle(fontSize: 8.0, color: Colors.white, fontFamily: 'LoraFont'),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/storage.svg",
                        color: MenuState.storage == selectedMenu
                            ? Colors.greenAccent
                            : inActiveIconColor,
                        width: 30,
                      ),
                      onPressed: () {
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        Navigator.pushNamed(context, StorageScreen.routeName);
                      }),
                  IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/Parcel.svg",
                        color: MenuState.vatcalc == selectedMenu
                            ? Colors.greenAccent
                            : inActiveIconColor,
                        width: 30,
                      ),
                      onPressed: () {
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        if (dataBundleNotifier.currentBranch == null) {
                          Navigator.pushNamed(context,
                              FattureInCloudCalculatorScreen.routeName);
                        }
                        switch (
                            dataBundleNotifier.currentBranch.providerFatture) {
                          case 'fatture_in_cloud':
                            Navigator.pushNamed(context,
                                FattureInCloudCalculatorScreen.routeName);
                            break;
                          case 'aruba':
                            Navigator.pushNamed(
                                context, ArubaCalculatorScreen.routeName);
                            break;
                        }
                      }),
                ],
              )),
        );
      },
    );
  }
}
