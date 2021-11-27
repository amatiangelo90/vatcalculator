import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class EditBranchScreen extends StatefulWidget {
  const EditBranchScreen({Key key, this.currentBranch, this.listStorageModel, this.listUserModel, this.listSuppliersModel, this.callBackFuntion}) : super(key: key);

  final BranchModel currentBranch;
  final List<UserModel> listUserModel;
  final List<ResponseAnagraficaFornitori> listSuppliersModel;
  final List<StorageModel> listStorageModel;
  final Function callBackFuntion;
  @override
  _EditBranchScreenState createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {

  int currentUserPage = 0;
  int currentStoragePage = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                widget.callBackFuntion();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            title: Text(widget.currentBranch.companyName,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: Colors.blue,
                fontWeight: FontWeight.bold
              ),
            ),
            backgroundColor: kPrimaryColor,
          ),
          body: Stack(
            children: [
              Container(
                color: kPrimaryColor,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/people-branch.svg',
                          width: getProportionateScreenWidth(30),
                          color: kCustomWhite,),
                        SizedBox(width: 5,),
                        Text(
                          'Personale', style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenWidth(18)),
                        ),
                      ],
                    )),
                    buildListUsersForCurrentBranch(widget.listUserModel, widget.currentBranch, dataBundleNotifier),
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/storage.svg',
                          width: getProportionateScreenWidth(27),
                          color: kCustomWhite,),
                        const SizedBox(width: 5,),
                        Text(
                          'Magazzini', style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenWidth(18)),
                        ),
                      ],
                    )),
                    buildListStoragesForCurrentBranch(widget.listStorageModel, widget.currentBranch, dataBundleNotifier),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: getProportionateScreenHeight(70),
                        width: getProportionateScreenWidth(400),
                        child: CupertinoButton(
                          child: Text('Elimina Attività'),
                          onPressed: (){

                          },
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildListUsersForCurrentBranch(List<UserModel> listUserModel,
      BranchModel currentBranch,
      DataBundleNotifier dataBundleNotifier) {

    return SizedBox(
      width: getProportionateScreenWidth(500),
      height: getProportionateScreenHeight(400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentUserPage = value;
                  });
                },
                itemCount: listUserModel.length,
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
                            color: kCustomWhite,
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
                              Text(listUserModel[index].privilege, style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20)),),
                              listUserModel[index].id == dataBundleNotifier.dataBundleList[0].id ? SizedBox(height: 0,) :
                              listUserModel[index].privilege == Privileges.OWNER ? SizedBox(width: 0,) : Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      listUserModel[index].privilege == Privileges.EMPLOYEE ? SizedBox(
                                        height: getProportionateScreenHeight(50),
                                        width: getProportionateScreenWidth(300),
                                        child: CupertinoButton(
                                          child: const Text('Rendi Amministratore'),
                                          color: Colors.green,
                                          onPressed: () async {
                                            Response response = await dataBundleNotifier
                                                .getclientServiceInstance()
                                                .updatePrivilegeForUserBranchRelation(
                                                branchId: currentBranch.pkBranchId,
                                              userId: listUserModel[index].id,

                                              privilegeType: Privileges.ADMIN,
                                                actionModel: ActionModel(
                                                    date: DateTime.now().millisecondsSinceEpoch,
                                                    description: 'Ha modificato i privilegi per ${listUserModel[index].name} in ${Privileges.ADMIN}',
                                                    fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                                    user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                                    type: ActionType.UPDATE_PRIVILEGE
                                                )

                                            );

                                            setState(() {
                                              if(response.data > 0){
                                                listUserModel[index].privilege = Privileges.ADMIN;
                                              }
                                            });

                                            //dataBundleNotifier.clearAndUpdateMapBundle();

                                          },
                                        ),
                                      ) : SizedBox(
                                        height: getProportionateScreenHeight(50),
                                        width: getProportionateScreenWidth(300),
                                        child: CupertinoButton(
                                          child: const Text('Rendi Utente Base'),
                                          color: Colors.green,
                                          onPressed: () async {
                                            Response response = await dataBundleNotifier
                                                .getclientServiceInstance()
                                                .updatePrivilegeForUserBranchRelation(
                                                branchId: currentBranch.pkBranchId,
                                                userId: listUserModel[index].id,
                                                privilegeType: Privileges.EMPLOYEE,
                                                actionModel: ActionModel(
                                                    date: DateTime.now().millisecondsSinceEpoch,
                                                    description: 'Ha modificato i privilegi per ${listUserModel[index].name} in ${Privileges.EMPLOYEE}',
                                                    fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                                    user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                                    type: ActionType.UPDATE_PRIVILEGE
                                                )
                                            );
                                            setState(() {
                                              if(response.data > 0){
                                                listUserModel[index].privilege = Privileges.EMPLOYEE;
                                              }
                                            });
                                            //dataBundleNotifier.clearAndUpdateMapBundle();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(listUserModel[index].name, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(23)),),
                                  SizedBox(width: 3,),
                                  Text(listUserModel[index].lastName, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(23)),),
                                ],
                              ),
                              ],
                          ),
                        ),
                      ),
                      listUserModel[index].id == dataBundleNotifier.dataBundleList[0].id ? const SizedBox(width: 0,) : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              listUserModel[index].privilege == Privileges.OWNER ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(''),
                              ) : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                IconButton(
                                    onPressed: () async {

                                      Widget cancelButton = TextButton(
                                        child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
                                        onPressed:  () {
                                          Navigator.of(context).pop();
                                        },
                                      );

                                      Widget continueButton = TextButton(
                                        child: const Text("Elimina", style: TextStyle(color: kPinaColor)),
                                        onPressed:  () async {
                                          Response response = await dataBundleNotifier
                                              .getclientServiceInstance()
                                              .removeUserBranchRelation(
                                              branchId: currentBranch.pkBranchId,
                                              userId: listUserModel[index].id);

                                          if(response == null || response.data == null){

                                          }else{
                                            setState(() {
                                              dataBundleNotifier
                                                  .currentMapBranchIdBundleSupplierStorageUsers[currentBranch.pkBranchId]
                                                  .userModelList.removeWhere((element) => element.id == listUserModel[index].id);
                                              widget.callBackFuntion();
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog (
                                            actions: [
                                              ButtonBar(
                                                alignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  cancelButton,
                                                  continueButton,
                                                ],
                                              ),
                                            ],
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
                                                  height: getProportionateScreenHeight(180),
                                                  width: width - 90,
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
                                                              Text('  Elimina Utente?',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: getProportionateScreenWidth(15),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kCustomWhite,
                                                                  )),
                                                              IconButton(icon: const Icon(
                                                                Icons.clear,
                                                                color: kCustomWhite,
                                                              ), onPressed: () { Navigator.pop(context); },),

                                                            ],
                                                          ),
                                                        ),
                                                        const Text(''),
                                                        const Text(''),
                                                        Center(
                                                          child: Text('Rimuovere ${listUserModel[index].name} ${listUserModel[index].lastName} dalla lista dipendenti di \'${currentBranch.companyName}\'? ', textAlign: TextAlign.center,),
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
                                    icon: SvgPicture.asset('assets/icons/Trash.svg', width: getProportionateScreenWidth(20),)),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/Phone.svg',
                                          color: kCustomWhite,
                                          height: getProportionateScreenHeight(23),
                                        ),
                                        onPressed: () => {
                                          launch('tel://${getRefactoredNumber(listUserModel[index].phone)}')
                                        }
                                    ),
                                    IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/ws.svg',
                                          height: getProportionateScreenHeight(25),
                                        ),
                                        onPressed: () => {
                                          launch('https://api.whatsapp.com/send/?phone=${getRefactoredNumber(listUserModel[index].phone)}')
                                        }
                                    ),
                                    SizedBox(width: 10,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                        listUserModel.length,
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


  buildListStoragesForCurrentBranch(List<StorageModel> listStorageModel, BranchModel currentBranch, DataBundleNotifier dataBundleNotifier) {
    return SizedBox(
      width: getProportionateScreenWidth(500),
      height: getProportionateScreenHeight(400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentStoragePage = value;
                  });
                },
                itemCount: listStorageModel.length,
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
                            color: kPinaColor,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Codice: ', style: TextStyle(color: kCustomWhite,  fontSize: getProportionateScreenWidth(18))),
                                          Text(listStorageModel[index].pkStorageId.toString(), style: TextStyle(color: Colors.orangeAccent, fontSize: getProportionateScreenWidth(18))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Data Creazione: ', style: TextStyle(color: kCustomWhite,  fontSize: getProportionateScreenWidth(18))),
                                          Text(
                                              listStorageModel[index].creationDate.day.toString() + '/' +
                                              listStorageModel[index].creationDate.month.toString() + '/' +
                                              listStorageModel[index].creationDate.year.toString()

                                              ,style: TextStyle(color: Colors.orangeAccent, fontSize: getProportionateScreenWidth(18))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Indirizzo: ', style: TextStyle(color: kCustomWhite,  fontSize: getProportionateScreenWidth(18))),
                                          Text(listStorageModel[index].address, style: TextStyle(color: Colors.orangeAccent, fontSize: getProportionateScreenWidth(18))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Città: ', style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenWidth(18) )),
                                          Text(listStorageModel[index].city, style: TextStyle(color: Colors.orangeAccent, fontSize: getProportionateScreenWidth(18))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Cap: ', style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenWidth(18))),
                                          Text(listStorageModel[index].cap, style: TextStyle(color: Colors.orangeAccent, fontSize: getProportionateScreenWidth(18))),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              Text(listStorageModel[index].name, style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20)),),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: SvgPicture.asset('assets/icons/Trash.svg', width: getProportionateScreenWidth(20),),
                              color: Colors.red,
                              onPressed: () {
                                Widget cancelButton = TextButton(
                                  child: Text("Indietro", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(20))),
                                  onPressed:  () {
                                    Navigator.of(context).pop();
                                  },
                                );

                                Widget continueButton = TextButton(
                                  child: Text("Elimina", style: TextStyle(color: kPinaColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(20))),
                                  onPressed:  () async {

                                    dataBundleNotifier.getclientServiceInstance().deleteStorage(
                                        storageModel: listStorageModel[index],
                                        actionModel: ActionModel(
                                            date: DateTime.now().millisecondsSinceEpoch,
                                            description: 'Ha eliminato il magazzino ${listStorageModel[index].name} da ${dataBundleNotifier.currentBranch.companyName}.',
                                            fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                            user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                            type: ActionType.STORAGE_DELETE
                                        )
                                    );

                                    listStorageModel.removeAt(index);
                                    if(dataBundleNotifier.currentBranch != null){
                                      List<RecessedModel> _recessedModelList = await dataBundleNotifier.getclientServiceInstance().retrieveRecessedListByBranch(dataBundleNotifier.currentBranch);
                                      dataBundleNotifier.addCurrentRecessedList(_recessedModelList);
                                    }

                                    if(dataBundleNotifier.currentBranch != null){
                                      List<ResponseAnagraficaFornitori> _suppliersModelList = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                                      dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList);
                                    }
                                    if(dataBundleNotifier.currentBranch != null){
                                      List<StorageModel> _storageModelList = await dataBundleNotifier.getclientServiceInstance().retrieveStorageListByBranch(dataBundleNotifier.currentBranch);
                                      dataBundleNotifier.addCurrentStorageList(_storageModelList);
                                    }

                                    if(dataBundleNotifier.currentBranch != null){
                                      List<OrderModel> _orderModelList = await dataBundleNotifier.getclientServiceInstance().retrieveOrdersByBranch(dataBundleNotifier.currentBranch);
                                      dataBundleNotifier.addCurrentOrdersList(_orderModelList);
                                    }
                                    widget.callBackFuntion();
                                    Navigator.of(context).pop();
                                  },
                                );
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog (
                                      actions: [
                                        ButtonBar(
                                          alignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            cancelButton,
                                            continueButton,
                                          ],
                                        ),
                                      ],
                                      contentPadding: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(10.0))),
                                      content: Builder(
                                        builder: (context) {
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
                                                          topLeft: Radius.circular(10.0) ),
                                                      color: kPrimaryColor,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('  Elimina ${listStorageModel[index].name}?',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: getProportionateScreenWidth(15),
                                                              fontWeight: FontWeight.bold,
                                                              color: kCustomWhite,
                                                            )),
                                                        IconButton(icon: const Icon(
                                                          Icons.clear,
                                                          color: kCustomWhite,
                                                        ), onPressed: () { Navigator.pop(context); },),

                                                      ],
                                                    ),
                                                  ),
                                                  const Text(''),
                                                  const Text(''),
                                                  Center(
                                                    child: Text('Ti ricordo che eliminando il magazzino perderai i dati per quanto riguarda:', textAlign: TextAlign.center,),
                                                  ),
                                                  Text(' - Dettagli Giacenza', textAlign: TextAlign.center,),
                                                  Text(' - Ordini in Stato BOZZA/LAVORAZIONE associati al magazzino che si intende eliminare', textAlign: TextAlign.center,),
                                                  Text(''),
                                                  Text('Continuare?', style: TextStyle(fontWeight: FontWeight.bold,),),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: SvgPicture.asset('assets/icons/edit-cust.svg', width: getProportionateScreenWidth(25), color: kCustomWhite,),
                              color: kCustomWhite,
                            ),
                          ),
                        ],
                      ),
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
                        listStorageModel.length,
                            (index) => buildDotStoragePages(index: index),
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
      width: currentUserPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentUserPage == index ? Colors.deepOrangeAccent : kBeigeColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  AnimatedContainer buildDotStoragePages({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentStoragePage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentStoragePage == index ? kPinaColor : kBeigeColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  getRefactoredNumber(String tel) {
    if(tel.contains('+39') || tel.contains('0039')){
      return tel;
    }
    return '+39' + tel;
  }

}
