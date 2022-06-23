import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/actions_manager/action_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_creation.dart';
import 'package:vat_calculator/screens/branch_registration/branch_join.dart';
import 'package:vat_calculator/screens/event/event_home.dart';
import 'package:vat_calculator/screens/expence_manager/expence_home.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/recessed_manager/recessed_home.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';
import '../constants.dart';
import '../screens/main_page.dart';
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
              color: kPrimaryColor,
              child: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        color: kPrimaryColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      dataBundleNotifier.onItemTapped(0);
                                      Navigator.pushNamed(context, HomeScreenMain.routeName);
                                    },
                                    child: SizedBox(
                                      child: Image.asset('assets/logo/logo_home_white.png'),
                                      height: getProportionateScreenHeight(50),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('20m2', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: getProportionateScreenHeight(18))),
                                    Text('IVA, ORDINI E GESTIONE', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: getProportionateScreenHeight(9)),),

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
                                        dataBundleNotifier.userDetailsList.isNotEmpty ? Text(dataBundleNotifier.userDetailsList[0].firstName + ' ' +dataBundleNotifier.userDetailsList[0].lastName , style:const TextStyle(color: Colors.white, fontSize: 20)) :
                                        const SizedBox(width: 0,),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 20,),
                                dataBundleNotifier.userDetailsList.isNotEmpty ? Text(dataBundleNotifier.userDetailsList[0].email, style:const TextStyle(color: kCustomEvidenziatoreGreen)) : const SizedBox(width: 0,),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(height: 2,child: Container(color: Colors.grey,),),
                            dataBundleNotifier.currentBranch == null ? const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: CreateBranchButton(),
                            ) : SizedBox(
                              height: getProportionateScreenHeight(40),
                              child: Container(
                                color: kCustomGreenAccent,
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
                            SizedBox(height: 2,child: Container(color: Colors.grey,),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                        child: buildDrawerRow('assets/icons/home.svg','Home',(){
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          dataBundleNotifier.onItemTapped(0);
                          Navigator.pushNamed(context, HomeScreenMain.routeName);
                        },
                            Colors.white,
                            Colors.black54.withOpacity(0.1),
                            kCustomWhite),
                      ),
                      dataBundleNotifier.currentBranch == null ? const SizedBox(width: 0,) : Padding(
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
                                      color: kPinaColor,
                                      child: Center(child: dataBundleNotifier.userDetailsList.isNotEmpty
                                          ? Text(dataBundleNotifier.userDetailsList[0].companyList.length.toString()
                                        , style: const TextStyle(fontSize: 12.0, color: Colors.white),) : const SizedBox(width: 0,)),
                                    ),
                                  ),
                                  showBranchStuff ? const Icon(Icons.keyboard_arrow_down_rounded, size: 30, color: Colors.white,) : const Icon(Icons.arrow_forward_ios, color: kCustomWhite,),
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
                        }, kCustomWhite,
                            kPrimaryColor,
                            kCustomWhite),
                      ) : SizedBox(width: 0,),
                      showBranchStuff ? Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: buildDrawerRow('','Associa tramite Codice',(){
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(context, BranchJoinScreen.routeName);
                        }, kCustomWhite,
                            kPrimaryColor,
                            kCustomWhite),
                      ) : SizedBox(width: 0,),
                      showBranchStuff ? buildBranchList(dataBundleNotifier) : SizedBox(width: 0,),

                      dataBundleNotifier.currentBranch == null ? const SizedBox(width: 0,) : dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : buildDrawerRow('assets/icons/iva.svg','Dettaglio Iva',(){
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
                      }, Colors.white,
                          Colors.black54.withOpacity(0.1),
                          kCustomWhite),
                      dataBundleNotifier.currentBranch == null ? const SizedBox(width: 0,) : dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : buildDrawerRow('assets/icons/expence.svg','Gestione Spese',(){
                          Navigator.pushNamed(
                              context, ExpenceScreen.routeName);
                      }, Colors.white,
                          Colors.black54.withOpacity(0.1),
                          kCustomWhite),
                      dataBundleNotifier.currentBranch == null ? const SizedBox(width: 0,) : dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : buildDrawerRow('assets/icons/cashregister.svg','Gestione Incassi',(){
                          Navigator.pushNamed(context, RecessedScreen.routeName);
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
                            dataBundleNotifier.onItemTapped(2);
                            Navigator.pop(context);
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
                                      color: kCustomBlue,
                                      child: Center(child: Text(dataBundleNotifier.currentUnderWorkingOrdersList.length.toString(),
                                        style: const TextStyle(fontSize: 12.0, color: Colors.white),),),
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
                              const SizedBox(width: 9,),
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
                                      color: kPinaColor,
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
                            dataBundleNotifier.onItemTapped(1);
                            Navigator.pop(context);
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
                              const Expanded(child: Text('Magazzino', style: TextStyle(color: kCustomWhite),)),
                              Row(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(28),
                                    width: dataBundleNotifier.currentListSuppliers.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: kPinaColor,
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
                      dataBundleNotifier.currentBranch == null ? SizedBox(width: 0,) : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, EventHomeScreen.routeName);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 9,),
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
                                    width: dataBundleNotifier.eventModelList.length > 90 ? getProportionateScreenWidth(35) : getProportionateScreenWidth(28),
                                    child: Card(
                                      color: kPinaColor,
                                      child: Center(child: Text(dataBundleNotifier.retrieveEventsNumberOpenStatus(), style: TextStyle(fontSize: 12.0, color: Colors.white),),),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,color: kCustomWhite,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      dataBundleNotifier.currentBranch == null ? const SizedBox(width: 0,) : dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? SizedBox(height: 0,) : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: const EdgeInsets.all(1),
                            backgroundColor: Colors.black54.withOpacity(0.1),
                          ),
                          onPressed: (){
                            Navigator.pushNamed(
                                  context, ActionsDetailsScreen.routeName);

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
                                      color: kCustomPurple,
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
                                dataBundleNotifier.onItemTapped(3);
                                Navigator.pop(context);
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

    dataBundleNotifier.userDetailsList[0].companyList.forEach((branch) {
      branchList.add(Divider(indent: 50, endIndent: 1, height: 1, color: Colors.grey.withOpacity(0.2),));
      branchList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: buildDrawerRow('',branch.companyName,(){
              dataBundleNotifier.setShowIvaButtonToFalse();
              dataBundleNotifier.setCurrentBranch(branch);
              dataBundleNotifier.onItemTapped(0);
              Navigator.pushNamed(context, HomeScreenMain.routeName);
            }, kPrimaryColor,
                kPrimaryColor,
                kCustomEvidenziatoreGreen),
          ),
      );
      
    });
    return Column(children: branchList,);
  }

  void buildCustomShowDialogPriviledgeWarning(String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog (
          backgroundColor: kPrimaryColor,
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.0))),
          content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset('assets/icons/warning.svg', color: kCustomOrange, height: 100,),
                        Text('WARNING', textAlign: TextAlign.center, style: TextStyle(color: kCustomOrange)),                        ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )),
              )),
        )
    );
  }

}

