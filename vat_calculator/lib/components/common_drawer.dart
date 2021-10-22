import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';

import '../constants.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {

  bool showBranchStuff = false;
  bool showProfileStuff = false;
  bool showFornitoriStuff = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3.0,
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Container(
            color: kPrimaryColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 100,),
                  Row(
                    children: [
                      const SizedBox(width: 20,),
                      dataBundleNotifier.dataBundleList.isNotEmpty ? Text(dataBundleNotifier.dataBundleList[0].firstName, style:const TextStyle(color: Colors.white, fontSize: 20)) :
                      const SizedBox(width: 0,),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20,),
                      dataBundleNotifier.dataBundleList.isNotEmpty ? Text(dataBundleNotifier.dataBundleList[0].email, style:const TextStyle(color: Colors.white)) : const SizedBox(width: 0,),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  buildDrawerRow('assets/icons/home.svg','Home',(){
                    dataBundleNotifier.setShowIvaButtonToFalse();
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  },
                      kPrimaryColor,
                  kCustomWhite,
                  kPrimaryColor),
                  buildDrawerRow('assets/icons/Parcel.svg','Iva',(){
                    dataBundleNotifier.setShowIvaButtonToFalse();
                    if(dataBundleNotifier.currentBranch == null){
                      Navigator.pushNamed(context, FattureInCloudCalculatorScreen.routeName);
                    }
                    switch(dataBundleNotifier.currentBranch.providerFatture){
                      case 'fatture_in_cloud':
                        Navigator.pushNamed(context, FattureInCloudCalculatorScreen.routeName);
                        break;
                      case 'aruba':
                        Navigator.pushNamed(context, ArubaCalculatorScreen.routeName);
                        break;
                    }
                  }, kPrimaryColor,
                      kCustomWhite,
                      kPrimaryColor),
                  buildDrawerRow('assets/icons/storage.svg','Magazzino',(){
                    dataBundleNotifier.setShowIvaButtonToFalse();
                    Navigator.pushNamed(context, StorageScreen.routeName);
                  }, kPrimaryColor,
                      kCustomWhite,
                      kPrimaryColor),

                  buildDrawerRow('assets/icons/receipt.svg','Ordini',(){
                    dataBundleNotifier.setShowIvaButtonToFalse();
                    Navigator.pushNamed(context, OrdersScreen.routeName);
                  }, kPrimaryColor,
                      kCustomWhite,
                      kPrimaryColor),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: kPrimaryColor,
                        padding: const EdgeInsets.all(15),
                        backgroundColor: kCustomWhite,
                      ),
                      onPressed: (){

                        Navigator.pushNamed(context, SuppliersScreen.routeName);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/supplier.svg',
                            color: kPrimaryColor,
                            width: 22,
                          ),
                          const SizedBox(width: 20),
                          const Expanded(child: Text('Fornitori')),
                          Row(
                            children: [
                              SizedBox(
                                height: 28,
                                width: dataBundleNotifier.currentListSuppliers.length > 90 ? 35 : 28,
                                child: Card(
                                  color: Colors.red,
                                  child: Center(child: Text(dataBundleNotifier.currentListSuppliers.length.toString()
                                    , style: const TextStyle(fontSize: 12.0, color: Colors.white),),),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
               Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: kPrimaryColor,
                        padding: const EdgeInsets.all(15),
                        backgroundColor: kCustomWhite,
                      ),
                      onPressed: (){
                        setState((){
                          if(showBranchStuff){
                            showBranchStuff = false;
                          }else{
                            showBranchStuff = true;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Shop Icon.svg',
                            color: kPrimaryColor,
                            width: 22,
                          ),
                          const SizedBox(width: 20),
                          Expanded(child: Text('Attività')),
                          Row(
                            children: [
                              SizedBox(
                                height: 28,
                                width: 28,
                                child: Card(
                                  color: Colors.red,
                                  child: Center(child: dataBundleNotifier.dataBundleList.isNotEmpty ? Text(dataBundleNotifier.dataBundleList[0].companyList.length.toString()
                                    , style: const TextStyle(fontSize: 12.0, color: Colors.white),) : const SizedBox(width: 0,)),
                                ),
                              ),
                              showBranchStuff ? const Icon(Icons.keyboard_arrow_down_rounded, size: 30,) : const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  showBranchStuff ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: buildDrawerRow('','Crea',(){
                      dataBundleNotifier.setShowIvaButtonToFalse();
                      Navigator.pushNamed(context, CompanyRegistration.routeName);
                    }, kPrimaryColor,
                        kCustomWhite,
                        kPrimaryColor),
                  ) : SizedBox(width: 0,),
                  showBranchStuff ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: buildDrawerRow('','Associa tramite Codice',(){
                      dataBundleNotifier.setShowIvaButtonToFalse();
                      Navigator.pushNamed(context, CompanyRegistration.routeName);
                    }, kPrimaryColor,
                        kCustomWhite,
                        kPrimaryColor),
                  ) : SizedBox(width: 0,),
                  showBranchStuff ? buildBranchList(dataBundleNotifier) : SizedBox(width: 0,),

                  buildDrawerRow('assets/icons/User Icon.svg','Profilo',(){
                  }, kPrimaryColor,
                      kCustomWhite,
                      kPrimaryColor),

                  buildDrawerRow(
                      'assets/icons/Question mark.svg',
                      'Hai bisogno di aiuto?',(){
                  }, kPrimaryColor,
                      kCustomWhite,
                      kPrimaryColor),
                  SizedBox(height: 50,),
                  buildDrawerRow('assets/icons/Log out.svg','Log Out',(){
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    if(_auth!=null){
                      _auth.signOut();
                    }
                    dataBundleNotifier.clearAll();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        duration: Duration(milliseconds: 2700),
                        backgroundColor: kPinaColor,
                        content: Text('Logging out...', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                    Navigator.pushNamed(context, SplashScreen.routeName);
                  }, kCustomWhite,
                      kPinaColor,
                      kCustomWhite),
                  SizedBox(height: 90,),
                  Text('Developed by Angelo Amati', style: TextStyle(fontSize: 10)),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildDrawerRow(String icon,String description, Function onPress, Color iconColor, Color backgroundColor, Color textColor){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: textColor,
          padding: const EdgeInsets.all(15),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPress,
        child: Row(
          children: [
            icon == '' ? const SizedBox(width: 0,) : SvgPicture.asset(
              icon,
              color: iconColor,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(description)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget buildBranchList(DataBundleNotifier dataBundleNotifier) {
    List<Widget> branchList = [];

    dataBundleNotifier.dataBundleList[0].companyList.forEach((element) {
      branchList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: buildDrawerRow('',element.companyName,(){
              dataBundleNotifier.setShowIvaButtonToFalse();
              Navigator.pushNamed(context, CompanyRegistration.routeName);
            }, kPrimaryColor,
                kCustomWhite,
                kPinaColor),
          ),
      );
    });
    return Column(children: branchList,);
  }
}

