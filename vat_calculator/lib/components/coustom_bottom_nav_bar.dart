import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/home.svg",
                      color: MenuState.home == selectedMenu
                          ? Colors.white
                          : inActiveIconColor,
                      width: 30,
                    ),
                    onPressed: () {
                      dataBundleNotifier.onItemTapped(0);
                      Navigator.pop(context);
                    },
                ),
                MenuState.home == selectedMenu
                    ? Card(
                  color: kCustomBlueAccent,
                    child: Text(' HOME ',
                      style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11)),
                    ),
                ) : const SizedBox(height: 0,)
              ],
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/storage.svg",
                      color: MenuState.storage == selectedMenu
                          ? Colors.white
                          : inActiveIconColor,
                      width: 32,
                    ),
                    onPressed: () {
                      dataBundleNotifier.onItemTapped(1);
                      Navigator.pop(context);

                    }),
                MenuState.storage == selectedMenu
                    ? Card(
                  color: kCustomBlueAccent,
                  child: Text(' MAGAZZINO ',
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11)),
                  ),
                ) : const SizedBox(height: 0,)
               ],
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GestureDetector(
                  onTap: () {
                    dataBundleNotifier.onItemTapped(2);
                    Navigator.pop(context);
                  },
                  child: Stack(
                    children: [
                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/icons/receipt.svg",
                            color: MenuState.orders == selectedMenu
                                ? Colors.white
                                : inActiveIconColor,
                            width: 30,
                          ),
                          onPressed: () {
                            dataBundleNotifier.onItemTapped(2);
                            Navigator.pop(context);

                          }
                          ),
                      Positioned(
                        top: 1.0,
                        right: dataBundleNotifier.currentUnderWorkingOrdersList.length > 9 ? 3.0 : 5.0,
                        child: Stack(
                          children: <Widget>[
                            const Icon(
                              Icons.brightness_1,
                              size: 16,
                              color: Colors.blueAccent,
                            ),
                            Positioned(
                              right: dataBundleNotifier.currentUnderWorkingOrdersList.length > 9 ? 3.0 : 5.0,
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
                        top: 13.0,
                        right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 3.0 : 5.0,
                        child: Stack(
                          children: <Widget>[
                            const Icon(
                              Icons.brightness_1,
                              size: 16,
                              color: Colors.orange,
                            ),
                            Positioned(
                              right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 3.0 : 5.0,
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
                    ? Card(
                  color: kCustomBlueAccent,
                  child: Text(' ORDINI ',
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11)),
                  ),
                ) : const SizedBox(height: 0,)],
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/Settings.svg",
                        color: MenuState.profile == selectedMenu
                            ? Colors.white
                            : inActiveIconColor,
                        width: 30,
                      ),
                      onPressed: () {
                        dataBundleNotifier.onItemTapped(3);
                        Navigator.pop(context);
                      }),
                ),
                MenuState.profile == selectedMenu
                    ? Card(
                  color: kCustomBlueAccent,
                  child: Text(' GESTIONE ',
                    style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11)),
                  ),
                ) : const SizedBox(height: 0,)
              ],
            ),

          ],
        );
      },
    );
  }
}
