import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
import '../size_config.dart';

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

                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.4, 0.7, 0.9],
                        colors: [
                          Colors.black54,
                          kPrimaryColor,
                          kPrimaryColor,
                          kPrimaryColor,
                        ],
                      ),
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 20,),
                                dataBundleNotifier.dataBundleList.isNotEmpty ? Text(dataBundleNotifier.dataBundleList[0].firstName, style:const TextStyle(color: kBeigeColor, fontSize: 20)) :
                                const SizedBox(width: 0,),
                              ],
                            ),
                            Row(
                              children: [
                                dataBundleNotifier.isSpecialUser ? Icon(Icons.star_border, size:20, color: Colors.yellow.shade700,
                                ) : SizedBox(width: 0,),
                                const SizedBox(width: 20,),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20,),
                            dataBundleNotifier.dataBundleList.isNotEmpty ? Text(dataBundleNotifier.dataBundleList[0].email, style:const TextStyle(color: kCustomWhite)) : const SizedBox(width: 0,),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Builder(
                                    builder: (context) {
                                      var height = MediaQuery.of(context).size.height;
                                      var width = MediaQuery.of(context).size.width;
                                      return SizedBox(
                                        height: height - 350,
                                        width: width,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10.0),
                                                      topLeft: Radius.circular(10.0) ),
                                                  color: kPrimaryColor,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('  Lista Attività',style: TextStyle(
                                                      fontSize: getProportionateScreenWidth(17),
                                                      color: Colors.white,
                                                    ),),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: Colors.white,
                                                    ), onPressed: () {
                                                      Navigator.popAndPushNamed(context, HomeScreen.routeName);
                                                      },),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: buildListBranches(dataBundleNotifier),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 20,),
                                  dataBundleNotifier.currentBranch != null ? Text(dataBundleNotifier.currentBranch.companyName, style:const TextStyle(color: kCustomWhite)) : const SizedBox(width: 0,),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.keyboard_arrow_down, color: kCustomWhite,),
                                  const SizedBox(width: 20,),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, CompanyRegistration.routeName);
                                      },
                                      child: const Icon(Icons.add_circle_outline_rounded, color: kBeigeColor,size: 29,)
                                  ),
                                  const SizedBox(width: 20,),
                                ],
                              ),

                            ],

                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
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

                        Navigator.pushNamed(context, StorageScreen.routeName);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/storage.svg',
                            color: kPrimaryColor,
                            width: 22,
                          ),
                          const SizedBox(width: 20),
                          const Expanded(child: Text('Magazzino')),
                          Row(
                            children: [
                              SizedBox(
                                height: 28,
                                width: dataBundleNotifier.currentListSuppliers.length > 90 ? 35 : 28,
                                child: Card(
                                  color: Colors.red,
                                  child: Center(child: Text(dataBundleNotifier.currentStorageList.length.toString()
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

                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/party.svg',
                            color: kPrimaryColor,
                            width: 22,
                          ),
                          const SizedBox(width: 20),
                          const Expanded(child: Text('Eventi')),
                          Row(
                            children: [
                              SizedBox(
                                height: 28,
                                width: dataBundleNotifier.currentListSuppliers.length > 90 ? 35 : 28,
                                child: Card(
                                  color: Colors.red,
                                  child: Center(child: Text('0'
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

  buildListBranches(DataBundleNotifier dataBundleNotifier) {

    List<Widget> branchWidgetList = [];

    dataBundleNotifier.dataBundleList[0].companyList.forEach((currentBranch) {
      branchWidgetList.add(
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? kBeigeColor : Colors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('   ' + currentBranch.companyName,
                    style: TextStyle(
                      fontSize: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? getProportionateScreenWidth(20) : getProportionateScreenWidth(16),
                      color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : Colors.black,
                    ),),
                ],
              ),
            ),
          ),
          onTap: () {
            EasyLoading.show();
            dataBundleNotifier.setCurrentBranch(currentBranch);
            EasyLoading.dismiss();
            Navigator.pop(context);
          },
        ),
      );
    });
    return branchWidgetList;
  }
}

