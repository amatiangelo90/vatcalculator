import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';

import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';

class ProfileEditiScreen extends StatelessWidget {
  const ProfileEditiScreen({Key key}) : super(key: key);

  static String routeName = 'profile_edit_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            drawer: const CommonDrawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: kPrimaryColor),
              centerTitle: true,
              title: Text(
                'Gestione Profilo',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  color: kPrimaryColor,
                ),
              ),
              backgroundColor: kCustomWhite,
            ),
            body: Stack(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(150),
                  child: SizedBox(
                    height: getProportionateScreenHeight(50),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0)),
                        color: kCustomWhite,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          height: getProportionateScreenHeight(200),
                          width: getProportionateScreenWidth(330),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset('assets/icons/edit-cust.svg',
                                        width: getProportionateScreenWidth(30),
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      getCustomDetailRow(dataBundleNotifier.dataBundleList[0].firstName, Icons.person),
                                      getCustomDetailRow(dataBundleNotifier.dataBundleList[0].lastName, Icons.person),
                                      getCustomDetailRow(dataBundleNotifier.dataBundleList[0].email, Icons.email),
                                      getCustomDetailRow(dataBundleNotifier.dataBundleList[0].phone, Icons.phone),
                                      getCustomDetailRow(dataBundleNotifier.dataBundleList[0].privilege, Icons.vpn_key_outlined),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.profile,),
          );
        }
    );
  }
}

getCustomDetailRow(String text, IconData icon){
  return Row(
    children: [
      Icon(icon, color: Colors.grey, size: getProportionateScreenWidth(10),),
      const SizedBox(width: 5,),
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold),),
    ],
  );
}