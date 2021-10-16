import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/profile/profile_screen.dart';
import 'package:vat_calculator/screens/registration_company/registration_company_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/vat_calculator_screen.dart';
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
      builder: (context, dataBundleNotifier, child){
        return Container(
          color: const Color(0xFFF5F6F9),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F9),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -15),
                  blurRadius: 20,
                  color: const Color(0xFFDADADA).withOpacity(0.25),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
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
                            ? Colors.teal
                            : inActiveIconColor,
                      ),
                      onPressed: () {
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      }
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/Parcel.svg",
                        color: MenuState.vatcalc == selectedMenu
                            ? Colors.teal
                            : inActiveIconColor,),
                        onPressed: () {
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, VatCalculatorScreen.routeName);
                        }
                    ),
                    IconButton(
                        icon: SvgPicture.asset("assets/icons/Shop Icon.svg",
                          color: MenuState.company == selectedMenu
                              ? Colors.teal
                              : inActiveIconColor,),
                        onPressed: () {
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, RegistrationCompanyScreen.routeName);
                        }
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/User Icon.svg",
                        color: MenuState.profile == selectedMenu
                            ? Colors.teal
                            : inActiveIconColor,
                      ),
                        onPressed: () {
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, ProfileScreen.routeName);
                        }
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
