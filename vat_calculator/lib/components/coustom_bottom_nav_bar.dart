import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/size_config.dart';
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
            color: Colors.transparent,
            border: Border(
              top: BorderSide(
                color: kCustomWhite,
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
              bottom: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/icons/home.svg",
                            color: MenuState.home == selectedMenu
                                ? Colors.black
                                : inActiveIconColor,
                            width: 30,
                          ),
                          onPressed: () {
                            dataBundleNotifier.setShowIvaButtonToFalse();
                            Navigator.pushNamed(context, HomeScreen.routeName);
                          },
                      ),
                      MenuState.home == selectedMenu
                          ? Text('Home', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(11)),) : SizedBox(height: 0,)
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/icons/storage.svg",
                            color: MenuState.storage == selectedMenu
                                ? kPrimaryColor
                                : inActiveIconColor,
                            width: 30,
                          ),
                          onPressed: () {
                            dataBundleNotifier.setShowIvaButtonToFalse();
                            Navigator.pushNamed(context, StorageScreen.routeName);
                          }),
                      MenuState.storage == selectedMenu
                          ? Text('Magazzino', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(11)),) : SizedBox(height: 0,)
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/party.svg",
                          color: MenuState.vatcalc == selectedMenu
                              ? kPrimaryColor
                              : inActiveIconColor,
                          width: 30,
                        ),
                        onPressed: () {
                          dataBundleNotifier.setShowIvaButtonToFalse();
                        },
                      ),
                      MenuState.vatcalc == selectedMenu
                          ? Text('Eventi', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(11)),) : SizedBox(height: 0,)
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, OrdersScreen.routeName);
                        },
                        child: Stack(
                          children: [
                            IconButton(
                                icon: SvgPicture.asset(
                                  "assets/icons/receipt.svg",
                                  color: MenuState.orders == selectedMenu
                                      ? kPrimaryColor
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
                              right: dataBundleNotifier.currentUnderWorkingOrdersList.length > 9 ? 3.0 : 5.0,
                              child: Stack(
                                children: <Widget>[
                                  const Icon(
                                    Icons.brightness_1,
                                    size: 15,
                                    color: Colors.blueAccent,
                                  ),
                                  Positioned(
                                    right: 5.0,
                                    top: 2.0,
                                    child: Center(
                                      child: Text(
                                        dataBundleNotifier.currentUnderWorkingOrdersList.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 8.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 15.0,
                              right: 6.0,
                              child: Stack(
                                children: <Widget>[
                                  const Icon(
                                    Icons.brightness_1,
                                    size: 15,
                                    color: Colors.orange,
                                  ),
                                  Positioned(
                                    right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 3.0 : 4.0,
                                    top: 2,
                                    child: Center(
                                      child: Text(
                                        dataBundleNotifier.currentDraftOrdersList.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 8.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      MenuState.orders == selectedMenu
                          ? Text('Ordini', style: TextStyle(color: kPrimaryColor,  fontSize: getProportionateScreenHeight(11)),) : const SizedBox(height: 0,)
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
