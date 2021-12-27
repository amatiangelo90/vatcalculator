import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'managment_pages/branch_edit_screen.dart';

class ProfileEditiScreen extends StatefulWidget {
  const ProfileEditiScreen({Key key}) : super(key: key);

  static String routeName = 'profile_edit_screen';

  @override
  State<ProfileEditiScreen> createState() => _ProfileEditiScreenState();
}

class _ProfileEditiScreenState extends State<ProfileEditiScreen> {
  int currentPage = 0;

  TextEditingController _nameController;
  TextEditingController _lastNameController;
  TextEditingController _phoneController;
  TextEditingController _eMailController;

  refreshPage(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {


    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {

      _nameController = TextEditingController(text: dataBundleNotifier.dataBundleList.isEmpty? '' : dataBundleNotifier.dataBundleList[0].firstName);
      _lastNameController = TextEditingController(text: dataBundleNotifier.dataBundleList.isEmpty ? '' : dataBundleNotifier.dataBundleList[0].lastName);
      _phoneController = TextEditingController(text: dataBundleNotifier.dataBundleList.isEmpty ? '' : dataBundleNotifier.dataBundleList[0].phone);
      _eMailController = TextEditingController(text: dataBundleNotifier.dataBundleList.isEmpty ? '' : dataBundleNotifier.dataBundleList[0].email);

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
        body: RefreshIndicator(
          onRefresh: (){
            setState(() {

            });
            return Future.delayed(Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
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
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
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
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          child: CupertinoTextField(
                                            controller: _nameController,
                                            textInputAction: TextInputAction.next,
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
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          child: CupertinoTextField(
                                            controller: _lastNameController,
                                            textInputAction: TextInputAction.next,
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
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          child: CupertinoTextField(
                                            controller: _phoneController,
                                            textInputAction: TextInputAction.next,
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
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          child: CupertinoTextField(
                                            controller: _eMailController,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.text,
                                            clearButtonMode:
                                                OverlayVisibilityMode.editing,
                                            autocorrect: false,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.85,
                                          child: CupertinoButton(
                                            color: Colors.orange.withOpacity(0.7),
                                              child: Text(
                                                'Salva Modifiche',
                                                style: TextStyle(color: kCustomWhite),
                                              ),
                                              onPressed: () {}),
                                        ),
                                      ),
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
                                                    .dataBundleList[0].firstName,
                                            Icons.person),
                                        getCustomDetailRow(
                                            dataBundleNotifier
                                                    .dataBundleList.isEmpty
                                                ? ''
                                                : dataBundleNotifier
                                                    .dataBundleList[0].lastName,
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
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      )),
                    ),
                  ),
                ),
                (dataBundleNotifier.dataBundleList != null && dataBundleNotifier.dataBundleList.isNotEmpty && dataBundleNotifier.dataBundleList[0].companyList.isNotEmpty) ? buildBranchList(dataBundleNotifier.dataBundleList[0].companyList,
                    dataBundleNotifier) : Center(child: Column(
                      children: [
                        Text('Nessuna Attività creata'),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: SizedBox(
                            width: SizeConfig.screenWidth * 0.6,
                            child: CreateBranchButton(),
                          ),
                        ),
                      ],
                    )),
                Divider(
                  endIndent: getProportionateScreenWidth(40),
                  indent: getProportionateScreenWidth(40),
                ),
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 2700),
                          backgroundColor: kPinaColor,
                          content: Text(
                            'Logging out...',
                            style: TextStyle(
                                fontFamily: 'LoraFont', color: Colors.white),
                          )));
                      Navigator.pushNamed(context, SplashAnim.routeName);
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
                Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: const Text('Version 1.0.0'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.profile,
        ),
      );
    });
  }

  buildBranchList(
      List<BranchModel> companyList, DataBundleNotifier dataBundleNotifier) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: getProportionateScreenWidth(500),
        height: getProportionateScreenHeight(400),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: companyList.length,
                itemBuilder: (context, index) => Container(
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 16,
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(60)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kBeigeColor,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)),
                              color: kCustomGreyBlue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(companyList[index].companyName,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w200,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    22))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                        'Sei ' +
                                            companyList[index].accessPrivilege +
                                            ' per ' +
                                            companyList[index].companyName,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w200,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    12))),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text((dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers.isNotEmpty &&
                                          dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].userModelList != null &&
                                          dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].userModelList.isNotEmpty)
                                          ? dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].userModelList.length.toString()
                                          + ' x ' : '0 x ',
                                          style: TextStyle(
                                              color: kCustomWhite,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenHeight(25),
                                          height:
                                              getProportionateScreenHeight(25),
                                          child: SvgPicture.asset(
                                            'assets/icons/people-branch.svg',
                                            fit: BoxFit.contain,
                                            color: kCustomWhite,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          (dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers.isNotEmpty &&
                                              dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].supplierModelList != null &&
                                              dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].supplierModelList.isNotEmpty) ?
                                          dataBundleNotifier
                                                  .currentMapBranchIdBundleSupplierStorageUsers[
                                                      companyList[index]
                                                          .pkBranchId]
                                                  .supplierModelList
                                                  .length
                                                  .toString() + ' x' : '0 x',
                                          style: const TextStyle(
                                              color: kCustomWhite,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenHeight(25),
                                          height:
                                              getProportionateScreenHeight(25),
                                          child: SvgPicture.asset(
                                            'assets/icons/supplier.svg',
                                            fit: BoxFit.contain,
                                            color: kCustomWhite,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          (dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers.isNotEmpty &&
                                              dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].storageModelList != null &&
                                              dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers[companyList[index].pkBranchId].storageModelList.isNotEmpty) ?
                                          dataBundleNotifier
                                                  .currentMapBranchIdBundleSupplierStorageUsers[
                                                      companyList[index]
                                                          .pkBranchId]
                                                  .storageModelList
                                                  .length
                                                  .toString() + ' x ' : '0 x ',
                                          style: TextStyle(
                                              color: kCustomWhite,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenHeight(20),
                                          height:
                                              getProportionateScreenHeight(20),
                                          child: SvgPicture.asset(
                                            'assets/icons/storage.svg',
                                            fit: BoxFit.contain,
                                            color: kCustomWhite,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              companyList[index].accessPrivilege == Privileges.EMPLOYEE ? SizedBox(height: 0,) : SizedBox(
                                width: getProportionateScreenWidth(300),
                                height: getProportionateScreenHeight(50),
                                child: CupertinoButton(
                                  color: Colors.deepOrange,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditBranchScreen(
                                          callBackFuntion: refreshPage,
                                          currentBranch:
                                              companyList[index],
                                          listStorageModel: dataBundleNotifier
                                              .currentMapBranchIdBundleSupplierStorageUsers[
                                                  companyList[index].pkBranchId]
                                              .storageModelList,
                                          listSuppliersModel: dataBundleNotifier
                                              .currentMapBranchIdBundleSupplierStorageUsers[
                                                  companyList[index].pkBranchId]
                                              .supplierModelList,
                                          listUserModel: dataBundleNotifier
                                              .currentMapBranchIdBundleSupplierStorageUsers[
                                                  companyList[index].pkBranchId]
                                              .userModelList,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.settings),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Gestisci'),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 2, 2),
                                        child: Text(
                                            buildCodeForCurrentBranch(
                                                companyList[index].pkBranchId),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        20))),
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/Question mark.svg',
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    content: Builder(
                                                      builder: (context) {
                                                        var height =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height;
                                                        var width =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width;
                                                        return SizedBox(
                                                          height: height - 450,
                                                          width: width - 90,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                10.0),
                                                                        topLeft:
                                                                            Radius.circular(10.0)),
                                                                    color:
                                                                        kCustomGreyBlue,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '  Cosa rappresenta questo codice?',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: getProportionateScreenWidth(14),
                                                                              fontWeight: FontWeight.bold,
                                                                              color: kCustomWhite,
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.clear,
                                                                              color: kCustomWhite,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              18.0),
                                                                  child: Text(
                                                                    'Questo è un codice che identifica la tua attività. Puoi distribuirlo ai tuoi soci o dipendenti. '
                                                                    'In base al tipo di utenza creata e ai permessi assegnati, potranno accedere ai tuoi dati, aiutandoti nella gestione della tua attività.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  companyList[
                                                                          index]
                                                                      .companyName,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .lightBlue),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      getProportionateScreenHeight(
                                                                          50),
                                                                  width:
                                                                      getProportionateScreenWidth(
                                                                          300),
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    buildCodeForCurrentBranch(
                                                                      companyList[
                                                                              index]
                                                                          .pkBranchId,
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            getProportionateScreenWidth(30)),
                                                                  )),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons.share,
                                                                    color:
                                                                        kCustomGreyBlue,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    launch('https://api.whatsapp.com/send/?text=Ciao,'
                                                                            '%0aassocia il tuo account alla '
                                                                            'mia attività tramite il codice %0a%0a ${buildCodeForCurrentBranch(companyList[index].pkBranchId)} %0a%0a'
                                                                            '' +
                                                                        companyList[index].companyName +
                                                                        '%0a');
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ));
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: kCustomGreyBlue,
                                    ),
                                    onPressed: () {
                                      launch('https://api.whatsapp.com/send/?text=Ciao,'
                                              '%0aassocia il tuo account alla '
                                              'mia attività tramite il codice %0a%0a ${buildCodeForCurrentBranch(companyList[index].pkBranchId)} %0a%0a'
                                              '' +
                                          companyList[index].companyName);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
        color: currentPage == index ? kCustomGreyBlue : kBeigeColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  String buildCodeForCurrentBranch(int id) {
    String currentCode = '';
    for (int i = 0; i < (8 - (id * 169).toString().length); i++) {
      currentCode = currentCode + '0';
    }
    return currentCode + (id * 169).toString();
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
