import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundle.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'managment_pages/branch_edit_screen.dart';

class ProfileEditiScreen extends StatefulWidget {
  const ProfileEditiScreen({Key key}) : super(key: key);

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

      return Scaffold(
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
                      color: kPrimaryColor,
                      child: Center(
                          child: Text(
                        'Gestione Profilo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
                        elevation: 2,
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
                                      width: getProportionateScreenWidth(25),
                                      color: kPrimaryColor,
                                    ),
                                    onPressed: () {

                                      _nameController = TextEditingController(text: dataBundleNotifier.userDetailsList.isEmpty? '' : dataBundleNotifier.userDetailsList[0].firstName);
                                      _lastNameController = TextEditingController(text: dataBundleNotifier.userDetailsList.isEmpty ? '' : dataBundleNotifier.userDetailsList[0].lastName);
                                      _phoneController = TextEditingController(text: dataBundleNotifier.userDetailsList.isEmpty ? '' : dataBundleNotifier.userDetailsList[0].phone);

                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            actions: [
                                              ButtonBar(
                                                alignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  TextButton(
                                                    child: Text(
                                                      "Aggiorna",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize:
                                                          getProportionateScreenHeight(15)),
                                                    ),
                                                    onPressed: () async {
                                                      try {
                                                        KeyboardUtil.hideKeyboard(context);
                                                        if (_nameController.text == '') {
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(SnackBar(
                                                              duration: const Duration(
                                                                  milliseconds: 2000),
                                                              backgroundColor: Colors
                                                                  .redAccent
                                                                  .withOpacity(0.8),
                                                              content: const Text(
                                                                'Inserire nome',
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                              )));
                                                        }else if (_lastNameController.text == '') {
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(SnackBar(
                                                              duration: const Duration(
                                                                  milliseconds: 2000),
                                                              backgroundColor: Colors
                                                                  .redAccent
                                                                  .withOpacity(0.8),
                                                              content: const Text(
                                                                'Inserire cognome',
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                              )));

                                                        }else if (_phoneController.text == '') {
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(SnackBar(
                                                              duration: const Duration(
                                                                  milliseconds: 2000),
                                                              backgroundColor: Colors
                                                                  .redAccent
                                                                  .withOpacity(0.8),
                                                              content: const Text(
                                                                'Inserire numero di telefono',
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                              )));

                                                        } else {
                                                          ClientVatService clientService = dataBundleNotifier.getclientServiceInstance();
                                                          UserDetailsModel userDetail = dataBundleNotifier.userDetailsList[0];

                                                          userDetail.firstName = _nameController.value.text;
                                                          userDetail.lastName = _lastNameController.value.text;
                                                          userDetail.phone = _phoneController.value.text;

                                                          clientService.updateUserData(userDetail);

                                                        }
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(SnackBar(
                                                            duration: const Duration(
                                                                milliseconds: 2000),
                                                            backgroundColor: Colors.green.withOpacity(0.6),
                                                            content: Text(
                                                              'Utente aggiornato',
                                                              style: const TextStyle(
                                                                  color: Colors.white),
                                                            )));
                                                        Navigator.of(context).pop();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(SnackBar(
                                                            duration: const Duration(
                                                                milliseconds: 6000),
                                                            backgroundColor: Colors.red,
                                                            content: Text(
                                                              'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                                              style: const TextStyle(
                                                                  fontFamily: 'LoraFont',
                                                                  color: Colors.white),
                                                            )));
                                                      }


                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                            contentPadding: EdgeInsets.zero,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.0))),
                                            content: Builder(
                                              builder: (context) {
                                                var height = MediaQuery.of(context).size.height;
                                                var width = MediaQuery.of(context).size.width;
                                                return SizedBox(
                                                  width: width - 90,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(10.0),
                                                                topLeft: Radius.circular(10.0)),
                                                            color: kPrimaryColor,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(' Modifica Dati Profilo',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                    getProportionateScreenWidth(
                                                                        15),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kCustomWhite,
                                                                  )),
                                                              IconButton(
                                                                icon: const Icon(
                                                                  Icons.clear,
                                                                  color: kCustomWhite,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  const Text('Nome'),
                                                                  SizedBox(
                                                                    width:
                                                                    getProportionateScreenWidth(
                                                                        150),
                                                                    child: CupertinoTextField(
                                                                      controller:
                                                                      _nameController,
                                                                      onChanged: (text) {},
                                                                      textInputAction:
                                                                      TextInputAction.next,
                                                                      clearButtonMode:
                                                                      OverlayVisibilityMode
                                                                          .never,
                                                                      textAlign: TextAlign.center,
                                                                      autocorrect: false,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  const Text('Cognome'),
                                                                  SizedBox(
                                                                    width:
                                                                    getProportionateScreenWidth(
                                                                        150),
                                                                    child: CupertinoTextField(
                                                                      controller:
                                                                      _lastNameController,
                                                                      onChanged: (text) {},
                                                                      textInputAction:
                                                                      TextInputAction.next,
                                                                      clearButtonMode:
                                                                      OverlayVisibilityMode
                                                                          .never,
                                                                      textAlign: TextAlign.center,
                                                                      autocorrect: false,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  const Text('Cell'),
                                                                  SizedBox(
                                                                    width:
                                                                    getProportionateScreenWidth(
                                                                        150),
                                                                    child: CupertinoTextField(
                                                                      controller:
                                                                      _phoneController,
                                                                      onChanged: (text) {},
                                                                      textInputAction:
                                                                      TextInputAction.next,
                                                                      keyboardType:
                                                                      const TextInputType
                                                                          .numberWithOptions(
                                                                          decimal: true,
                                                                          signed: false),
                                                                      clearButtonMode:
                                                                      OverlayVisibilityMode
                                                                          .never,
                                                                      textAlign: TextAlign.center,
                                                                      autocorrect: false,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
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
                                ),
                              ],
                            ),
                            Padding(
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
                                                    .userDetailsList.isEmpty
                                                ? ''
                                                : dataBundleNotifier
                                                    .userDetailsList[0].firstName,
                                            Icons.person),
                                        getCustomDetailRow(
                                            dataBundleNotifier
                                                    .userDetailsList.isEmpty
                                                ? ''
                                                : dataBundleNotifier
                                                    .userDetailsList[0].lastName,
                                            Icons.person),
                                        getCustomDetailRow(
                                            dataBundleNotifier
                                                    .userDetailsList.isEmpty
                                                ? ''
                                                : dataBundleNotifier
                                                    .userDetailsList[0].email,
                                            Icons.email),
                                        getCustomDetailRow(
                                            dataBundleNotifier
                                                    .userDetailsList.isEmpty
                                                ? ''
                                                : dataBundleNotifier
                                                    .userDetailsList[0].phone,
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
                    child: Card(
                      color: kPrimaryColor,
                      child: Center(
                          child: Text(
                        'Gestione Attività',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ),
                  ),
                ),
                (dataBundleNotifier.userDetailsList != null && dataBundleNotifier.userDetailsList.isNotEmpty && dataBundleNotifier.userDetailsList[0].companyList.isNotEmpty) ? buildBranchList(dataBundleNotifier.userDetailsList[0].companyList,
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
                const Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(38.0),
                    child: Text('Version 1.5.10', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
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
                            color: kPrimaryColor,
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
                                            color: kCustomOrange,
                                            fontWeight: FontWeight.w500,
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
                                            color: Colors.white,
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
                                              color: kCustomOrange,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenHeight(25),
                                          height:
                                              getProportionateScreenHeight(25),
                                          child: SvgPicture.asset(
                                            'assets/icons/people-branch.svg',
                                            fit: BoxFit.contain,
                                            color: kCustomOrange,
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
                                          style: TextStyle(
                                              color: kCustomOrange,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenHeight(25),
                                          height:
                                              getProportionateScreenHeight(25),
                                          child: SvgPicture.asset(
                                            'assets/icons/supplier.svg',
                                            fit: BoxFit.contain,
                                            color: kCustomOrange,
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
                                              color: kCustomOrange,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenHeight(20),
                                          height:
                                              getProportionateScreenHeight(20),
                                          child: SvgPicture.asset(
                                            'assets/icons/storage.svg',
                                            fit: BoxFit.contain,
                                            color: kCustomOrange,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              companyList[index].accessPrivilege == Privileges.EMPLOYEE ? SizedBox(height: 0,) : SizedBox(
                                width: getProportionateScreenWidth(400),
                                height: getProportionateScreenHeight(50),
                                child: CupertinoButton(
                                  color: kCustomGreenAccent,
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
                                                color: kCustomOrange,
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
                                                                      () async {
                                                                    String urlString = 'https://api.whatsapp.com/send/?text=Ciao,'
                                                                        '%0aassocia il tuo account alla '
                                                                        'mia attivita tramite il codice %0a%0a ${buildCodeForCurrentBranch(companyList[index].pkBranchId)} %0a%0a'
                                                                        '' +
                                                                        companyList[index].companyName +
                                                                        '%0a';
                                                                    urlString = urlString.replaceAll(' ', '%20');

                                                                    if (await canLaunch(urlString)) {
                                                                          await launch(urlString);
                                                                        } else {
                                                                          throw 'Could not launch $urlString';
                                                                        }
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
                                      color: kCustomOrange,
                                    ),
                                    onPressed: () async {

                                      String urlString = 'https://api.whatsapp.com/send/?text=Ciao,'
                                          '%0aassocia il tuo account alla '
                                          'mia attivita tramite il codice %0a%0a ${buildCodeForCurrentBranch(companyList[index].pkBranchId)} %0a%0a'
                                          '' +
                                          companyList[index].companyName +
                                          '%0a';
                                      urlString = urlString.replaceAll(' ', '%20');
                                      if (await canLaunch(urlString)) {
                                      await launch(urlString);
                                      } else {
                                      throw 'Could not launch $urlString';
                                      }
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
        color: currentPage == index ? kCustomGreyBlue : kCustomOrange,
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
