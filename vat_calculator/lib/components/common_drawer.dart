import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/actions_manager/action_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_creation.dart';
import 'package:vat_calculator/screens/branch_registration/branch_join.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/profile_edit/profile_edit_home.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';

import '../constants.dart';
import '../size_config.dart';
import 'create_branch_button.dart';
import 'loader_overlay_widget.dart';

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
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati...',),
      child: Drawer(
        elevation: 6.0,
        child: Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Container(
              color: Colors.black.withOpacity(0.9),
              child: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.9),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.popAndPushNamed(context, HomeScreen.routeName);
                                    },
                                    child: SizedBox(
                                      child: Image.asset('assets/logo/logo_home_yellow.png'),
                                      height: getProportionateScreenHeight(50),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('20m2', style: TextStyle(fontWeight: FontWeight.w600, color: kCustomYellow, fontSize: getProportionateScreenHeight(18))),
                                    Text('IVA, ORDINI E GESTIONE', style: TextStyle(fontWeight: FontWeight.w300, color: kBeigeColor, fontSize: getProportionateScreenHeight(9)),),

                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        dataBundleNotifier.isSpecialUser ? Icon(Icons.star_border, size:20, color: Colors.green.shade700,
                                        ) : const SizedBox(width: 0,),
                                        const SizedBox(width: 20,),
                                      ],
                                    ),
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
                            SizedBox(height: 2,child: Container(color: Colors.white,),),
                            dataBundleNotifier.currentBranch == null ? const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: CreateBranchButton(),
                            ) : SizedBox(
                              height: getProportionateScreenHeight(40),
                              child: Container(
                                color: kBeigeColor,
                                child: GestureDetector(
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
                                          dataBundleNotifier.currentBranch != null ? Text(dataBundleNotifier.currentBranch.companyName, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(15))) : const SizedBox(width: 0,),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.keyboard_arrow_down, color: kCustomWhite,),
                                          const SizedBox(width: 20,),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
                                              },
                                              child: const Icon(Icons.add_circle_outline_rounded, color: Colors.white,size: 29,)
                                          ),
                                          const SizedBox(width: 10,),
                                        ],
                                      ),

                                    ],

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2,child: Container(color: Colors.white,),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                        child: buildDrawerRow('assets/icons/home.svg','Home',(){
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        },
                            Colors.white,
                            Colors.black54.withOpacity(0.1),
                            kCustomWhite),
                      ),
                      buildDrawerRow('assets/icons/iva.svg','Dettaglio Iva',(){
                        if(dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE){
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog (
                                contentPadding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(10.0))),
                                content: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.height / 5,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Utente non abilitato per '
                                          'utilizzare la funzione calcolo iva', textAlign: TextAlign.center,)),
                                    )),
                              )
                          );
                        } else{
                          dataBundleNotifier.setShowIvaButtonToFalse();

                          switch(dataBundleNotifier.currentBranch.providerFatture){
                            case 'fatture_in_cloud':
                              Navigator.pushNamed(context, FattureInCloudCalculatorScreen.routeName);
                              break;
                            case 'aruba':
                              Navigator.pushNamed(context, ArubaCalculatorScreen.routeName);
                              break;
                            case '':
                              Navigator.pushNamed(context, RegisterFattureProviderScreen.routeName);
                              break;
                          }
                        }
                      }, Colors.white,
                          Colors.black54.withOpacity(0.1),
                          kCustomWhite),
                      buildDrawerRow('assets/icons/expence.svg','Gestione Spese',(){
                        if(dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE){
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog (
                                contentPadding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(10.0))),
                                content: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.height / 5,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Utente non abilitato per '
                                          'utilizzare la funzione calcolo iva', textAlign: TextAlign.center,)),
                                    )),
                              )
                          );
                        } else{

                        }
                      }, Colors.white,
                          Colors.black54.withOpacity(0.1),
                          kCustomWhite),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kCustomWhite,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, OrdersScreen.routeName);
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 9,),
                              SvgPicture.asset(
                                'assets/icons/receipt.svg',
                                color: Colors.white,
                                width: 22,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(child: Text('Ordini')),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentOrdersForCurrentBranch.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.blueAccent.withOpacity(0.5),
                                      child: Center(child: Text(dataBundleNotifier.currentUnderWorkingOrdersList.length.toString(),
                                        style: const TextStyle(fontSize: 12.0, color: Colors.white),),),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentListSuppliers.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.orange.withOpacity(0.8),
                                      child: Center(child: Text(getDraftOrdersNumber(dataBundleNotifier.currentOrdersForCurrentBranch)
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
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kCustomWhite,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){

                            Navigator.pushNamed(context, SuppliersScreen.routeName);
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 9,),
                              SvgPicture.asset(
                                'assets/icons/supplier.svg',
                                color: Colors.white,
                                width: 22,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(child: Text('Fornitori')),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentListSuppliers.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      child: Center(child: Text(dataBundleNotifier.currentListSuppliers.length.toString()
                                        , style: const TextStyle(fontSize: 12.0, color: kCustomWhite),),),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, color: kCustomWhite,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){

                            Navigator.pushNamed(context, StorageScreen.routeName);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 9,),
                              SvgPicture.asset(
                                'assets/icons/storage.svg',
                                color: kCustomWhite,
                                width: 22,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(child: Text('Magazzini', style: TextStyle(color: kCustomWhite),)),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentListSuppliers.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      child: Center(child: Text(dataBundleNotifier.currentStorageList.length.toString()
                                        , style: const TextStyle(fontSize: 12.0, color: Colors.white),),),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, color: kCustomWhite,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){

                          },
                          child: Row(
                            children: [
                              SizedBox(width: 9,),
                              SvgPicture.asset(
                                'assets/icons/party.svg',
                                color: kCustomWhite,
                                width: 22,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(child: Text('Eventi', style: TextStyle(color: kCustomWhite),)),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentListSuppliers.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      child: Center(child: Text('0'
                                        , style: const TextStyle(fontSize: 12.0, color: Colors.white),),),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,color: kCustomWhite,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
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
                              SizedBox(width: 9,),
                              SvgPicture.asset(
                                'assets/icons/Shop Icon.svg',
                                color: kCustomWhite,
                                width: 22,
                              ),
                              const SizedBox(width: 20),
                              Expanded(child: Text('Attività', style: const TextStyle(color: kCustomWhite),)),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      child: Center(child: dataBundleNotifier.dataBundleList.isNotEmpty ? Text(dataBundleNotifier.dataBundleList[0].companyList.length.toString()
                                        , style: const TextStyle(fontSize: 12.0, color: Colors.white),) : const SizedBox(width: 0,)),
                                    ),
                                  ),
                                  showBranchStuff ? const Icon(Icons.keyboard_arrow_down_rounded, size: 30,) : const Icon(Icons.arrow_forward_ios, color: kCustomWhite,),
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
                          Navigator.pushNamed(context, CreationBranchScreen.routeName);
                        }, kPrimaryColor,
                            kCustomWhite,
                            kPrimaryColor),
                      ) : SizedBox(width: 0,),
                      showBranchStuff ? Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: buildDrawerRow('','Associa tramite Codice',(){
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, BranchJoinScreen.routeName);
                        }, kPrimaryColor,
                            kCustomWhite,
                            kPrimaryColor),
                      ) : SizedBox(width: 0,),
                      showBranchStuff ? buildBranchList(dataBundleNotifier) : SizedBox(width: 0,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, ActionsDetailsScreen.routeName);
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 9,),
                              SvgPicture.asset(
                                'assets/icons/activity.svg',
                                color: kCustomWhite,
                                width: 22,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(child: Text('Azioni', style: TextStyle(color: kCustomWhite),)),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentBranchActionsList.length > 100 ? getProportionateScreenWidth(40) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: Colors.purple.withOpacity(0.4),
                                      child: Center(child: Text(dataBundleNotifier.currentBranchActionsList.length > 100 ? '+100' : dataBundleNotifier.currentBranchActionsList.length.toString()
                                        , style: const TextStyle(fontSize: 12.0, color: Colors.white),),),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,color: kCustomWhite,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildDrawerRow('assets/icons/Settings.svg',
                          'Area Gestione',
                              (){
                                dataBundleNotifier.setShowIvaButtonToFalse();
                                Navigator.pushNamed(context, ProfileEditiScreen.routeName);
                                },
                        kCustomWhite,
                        Colors.black54.withOpacity(0.1),
                        kCustomWhite,),
                      buildDrawerRow(
                          'assets/icons/Question mark.svg',
                          'Hai bisogno di aiuto?',(){
                        Navigator.pushNamed(context, SplashScreen.routeName);
                      }, kCustomWhite,
                          Colors.black54.withOpacity(0.1),
                          kCustomWhite),
                      const SizedBox(height: 40,),
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
                            content: Text('Logging out...', style: TextStyle(color: Colors.white),)));
                        Navigator.pushNamed(context, SplashAnim.routeName);
                      }, kCustomWhite,
                          kPinaColor,
                          kCustomWhite),
                      const SizedBox(height: 90,),
                      Text('Developed by A.A.', style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite),),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  buildDrawerRow(String icon, String description, Function onPress, Color iconColor, Color backgroundColor, Color textColor){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: textColor,
          padding: const EdgeInsets.all(1),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPress,
        child: Row(
          children: [
            SizedBox(width: 9,),
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
              Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
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
              color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.green.shade700 : Colors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.format_align_right_rounded, color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : kPrimaryColor,),
                  Icon(currentBranch.accessPrivilege == Privileges.EMPLOYEE ? Icons.person : Icons.vpn_key_outlined, color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : kPrimaryColor,),
                  Text('   ' + currentBranch.companyName,
                    style: TextStyle(
                      fontSize: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? getProportionateScreenWidth(16) : getProportionateScreenWidth(13),
                      color: dataBundleNotifier.currentBranch.companyName == currentBranch.companyName ? Colors.white : Colors.black,
                    ),),
                ],
              ),
            ),
          ),
          onTap: () async {
            context.loaderOverlay.show();
            Navigator.pop(context);
            await dataBundleNotifier.setCurrentBranch(currentBranch);
            context.loaderOverlay.hide();

          },
        ),
      );
    });
    return branchWidgetList;
  }

  String getDraftOrdersNumber(List<OrderModel> currentOrdersForCurrentBranch) {
    int counter = 0;
    currentOrdersForCurrentBranch.forEach((element) {
      if(element.status.toString() == OrderState.DRAFT.toString()){
        counter = counter + 1;
      }
    });
    return counter.toString();
  }

}

