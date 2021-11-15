import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';

import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';

class ProfileEditiScreen extends StatefulWidget {
  const ProfileEditiScreen({Key key}) : super(key: key);

  static String routeName = 'profile_edit_screen';

  @override
  State<ProfileEditiScreen> createState() => _ProfileEditiScreenState();
}

class _ProfileEditiScreenState extends State<ProfileEditiScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      TextEditingController _nameController = TextEditingController(
          text: dataBundleNotifier.dataBundleList.isEmpty
              ? ''
              : dataBundleNotifier.dataBundleList[0].firstName);
      TextEditingController _lastNameController = TextEditingController(
          text: dataBundleNotifier.dataBundleList.isEmpty
              ? ''
              : dataBundleNotifier.dataBundleList[0].lastName);
      TextEditingController _phoneController = TextEditingController(
          text: dataBundleNotifier.dataBundleList.isEmpty
              ? ''
              : dataBundleNotifier.dataBundleList[0].phone);
      TextEditingController _eMailController = TextEditingController(
          text: dataBundleNotifier.dataBundleList.isEmpty
              ? ''
              : dataBundleNotifier.dataBundleList[0].email);

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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(400),
                  child: Card(
                    color: kBeigeColor,
                    child: Center(
                        child: Text(
                      'Gestione Profilo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(830),
                    child: Card(
                      elevation: dataBundleNotifier.editProfile ? 5 : 2,
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
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/edit-cust.svg',
                                    width: dataBundleNotifier.editProfile
                                        ? getProportionateScreenWidth(30)
                                        : getProportionateScreenWidth(25),
                                    color: kPrimaryColor,
                                  ),
                                  onPressed: () {
                                    dataBundleNotifier
                                        .changeEditProfileBoolValue();
                                  },
                                ),
                              ),
                            ],
                          ),
                          dataBundleNotifier.editProfile
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Modifica profilo'),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text('   Nome',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12))),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 4, 20, 0),
                                      child: SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.05,
                                        child: CupertinoTextField(
                                          controller: _nameController,
                                          textInputAction:
                                              TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          clearButtonMode:
                                              OverlayVisibilityMode.editing,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text('   Cognome',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12))),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 4, 20, 0),
                                      child: SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.05,
                                        child: CupertinoTextField(
                                          controller: _lastNameController,
                                          textInputAction:
                                              TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          clearButtonMode:
                                              OverlayVisibilityMode.editing,
                                          autocorrect: false,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text('   Cellulare',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12))),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 4, 20, 0),
                                      child: SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.05,
                                        child: CupertinoTextField(
                                          controller: _phoneController,
                                          textInputAction:
                                              TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          clearButtonMode:
                                              OverlayVisibilityMode.editing,
                                          autocorrect: false,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text('   Email',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12))),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 4, 20, 0),
                                      child: SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.05,
                                        child: CupertinoTextField(
                                          controller: _eMailController,
                                          textInputAction:
                                              TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          clearButtonMode:
                                              OverlayVisibilityMode.editing,
                                          autocorrect: false,
                                        ),
                                      ),
                                    ),
                                    CupertinoButton(
                                        child: const Text(
                                          'Salva',
                                          style: TextStyle(
                                              color: Colors.green),
                                        ),
                                        onPressed: () {}),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Dati Profilo'),
                                        ],
                                      ),
                                      getCustomDetailRow(
                                          dataBundleNotifier
                                                  .dataBundleList.isEmpty
                                              ? ''
                                              : dataBundleNotifier
                                                  .dataBundleList[0]
                                                  .firstName,
                                          Icons.person),
                                      getCustomDetailRow(
                                          dataBundleNotifier
                                                  .dataBundleList.isEmpty
                                              ? ''
                                              : dataBundleNotifier
                                                  .dataBundleList[0]
                                                  .lastName,
                                          Icons.person),
                                      getCustomDetailRow(
                                          dataBundleNotifier
                                                  .dataBundleList.isEmpty
                                              ? ''
                                              : dataBundleNotifier
                                                  .dataBundleList[0].email,
                                          Icons.email),
                                      getCustomDetailRow(
                                          dataBundleNotifier
                                                  .dataBundleList.isEmpty
                                              ? ''
                                              : dataBundleNotifier
                                                  .dataBundleList[0].phone,
                                          Icons.phone),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                endIndent: getProportionateScreenWidth(40),
                indent: getProportionateScreenWidth(40),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(400),
                  child: const Card(
                    color: kBeigeColor,
                    child: Center(
                        child: Text(
                      'Gestione Attività',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    )),
                  ),
                ),
              ),
              buildBranchList(
                  dataBundleNotifier.dataBundleList[0].companyList),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: kPrimaryColor,
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Question mark.svg',
                        color: kPrimaryColor,
                        width: 22,
                      ),
                      const SizedBox(width: 20),
                      Expanded(child: const Text('Hai bisogno di aiuto?')),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: kCustomWhite,
                    padding: const EdgeInsets.all(15),
                    backgroundColor: kPinaColor,
                  ),
                  onPressed: () {
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    if (_auth != null) {
                      _auth.signOut();
                    }
                    dataBundleNotifier.clearAll();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                            duration: Duration(milliseconds: 2700),
                            backgroundColor: kPinaColor,
                            content: Text(
                              'Logging out...',
                              style: TextStyle(
                                  fontFamily: 'LoraFont',
                                  color: Colors.white),
                            )));
                    Navigator.pushNamed(context, SplashScreen.routeName);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Log out.svg',
                        color: kCustomWhite,
                        width: 22,
                      ),
                      const SizedBox(width: 20),
                      const Expanded(child: Text('Log Out')),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              const Text('Version 1.0.0'),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.profile,
        ),
      );
    });
  }

  buildBranchList(List<BranchModel> companyList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: getProportionateScreenWidth(500),
        height: getProportionateScreenHeight(400),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: companyList.length,
                itemBuilder: (context, index) => Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/Trash.svg',
                                          width: getProportionateScreenWidth(25),
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/edit-cust.svg',
                                          width: getProportionateScreenWidth(25),
                                          color: kPrimaryColor,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(companyList[index].companyName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(15))),
                                  Text(companyList[index].address),
                                  Text(companyList[index].city),
                                  Text(companyList[index].cap.toString()),
                                  Row(
                                    children: [
                                      Text('Codice: ' + buildCodeForCurrentBranch(companyList[index].pkBranchId)),
                                      IconButton(
                                          icon: Icon(Icons.share),
                                        onPressed: (){
                                          launch('https://api.whatsapp.com/send/?text=Ciao,'
                                              '%0aassocia il tuo account alla '
                                              'mia attività tramite il codice %0a%0a ${buildCodeForCurrentBranch(companyList[index].pkBranchId)} %0a%0a'
                                              ''
                                              + companyList[index].companyName);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        companyList.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(flex: 3),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  String buildCodeForCurrentBranch(int id) {
    String currentCode = '';
    for(int i = 0; i < (8 - (id*169).toString().length); i++){
      currentCode = currentCode + '0';
    }
    return currentCode + (id*169).toString();

  }
}

getCustomDetailRow(String text, IconData icon) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(
          icon,
          color: kBeigeColor,
          size: getProportionateScreenWidth(10),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
