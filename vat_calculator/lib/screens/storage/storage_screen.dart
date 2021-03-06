import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/storage/components/move_produt_to_storage.dart';
import '../../client/vatservice/model/storage_product_model.dart';
import '../../client/vatservice/model/utils/action_type.dart';
import '../../client/vatservice/model/utils/privileges.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/add_storage_screen.dart';
import 'components/add_widget_element.dart';
import 'components/create_product_and_add_to_storage.dart';
import 'components/product_datasource_storage.dart';
import 'load_unload_screens/load_screen.dart';
import 'load_unload_screens/unload_screen.dart';
import 'orders/order_from_storage_screen.dart';

class StorageScreen extends StatefulWidget{


  @override
  State<StorageScreen> createState() => _StorageScreenState();

  const StorageScreen({Key key}) : super(key: key);
}

class _StorageScreenState extends State<StorageScreen> {


  String supplierChoiced = '';
  List<String> suppliersList = [];

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        suppliersList.clear();
        return Scaffold(
          backgroundColor: dataBundleNotifier.currentBranch == null ? Colors.white : kPrimaryColor,
          body: dataBundleNotifier.currentBranch == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sembra che tu non abbia configurato ancora nessuna attivit??. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: const CreateBranchButton(),
              ),
            ],
          )
              : dataBundleNotifier.currentStorageList.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dataBundleNotifier.userDetailsList.isNotEmpty
                      ? "Ciao ${dataBundleNotifier.userDetailsList[0].firstName}, sembra "
                      "che tu non abbia configurato ancora nessun magazzino per ${dataBundleNotifier.currentBranch.companyName}. "
                      "Ti ricordo che ?? possibile inserire prodotti al tuo magazzino solo dopo averli creati ed associati ad uno dei tuoi fornitori."
                      : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: DefaultButton(

                  text: "Crea Magazzino",
                  press: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStorageScreen(
                          branch: dataBundleNotifier.currentBranch,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
              : Consumer<DataBundleNotifier>(
              builder: (context, dataBundleNotifier, child) {
                return RefreshIndicator(
                  onRefresh: () {
                    dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                    setState(() {});
                    return Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ButtonBar(

                              alignment: MainAxisAlignment.spaceAround,
                              children: [

                                dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? SizedBox(height: 0,) : IconButton(
                                  icon: SvgPicture.asset('assets/icons/Trash.svg', height: 27, color: Colors.red),
                                  onPressed: (){
                                    try{
                                      List<StorageProductModel> productToRemove = [];
                                      dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
                                        if(element.selected){
                                          productToRemove.add(element);
                                        }
                                      });
                                      if(productToRemove.isEmpty){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            backgroundColor: kPinaColor,
                                            duration: Duration(milliseconds: 600),
                                            content: Text('Nessun prodotto selezionato')));
                                      }else{
                                        productToRemove.forEach((productStorageElementToRemove) async {
                                          await dataBundleNotifier.getclientServiceInstance()
                                              .removeProductFromStorage(
                                              storageProductModel: productStorageElementToRemove,
                                              actionModel: ActionModel(
                                                  date: DateTime.now().millisecondsSinceEpoch,
                                                  description: 'Ha rimosso ${productStorageElementToRemove.productName} (${productStorageElementToRemove.supplierName}) dal magazzino ${dataBundleNotifier.currentStorage.name}. '
                                                      'Giacenza al momendo della rimozione: ${productStorageElementToRemove.stock} ${productStorageElementToRemove.unitMeasure}.',
                                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                                  type: ActionType.PRODUCT_DELETE
                                              )
                                          );
                                        });
                                        //TODO magari riproporre la logica per l'eliminazione dalla lista oltre che ricaricare lo storage tramite set current storage
                                        sleep(const Duration(milliseconds: 500));
                                        dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                      }
                                    }catch(e){
                                      print('Impossible to remove product from storage. Exception: ' + e);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          duration: const Duration(milliseconds: 400),
                                          content: Text('Impossible to remove product from storage. Exception: ' + e)));
                                    }
                                  },
                                ),

                                dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? Text('') : SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.pinkAccent.shade400,
                                    ),
                                    child: Center(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('CREA ED AGGIUNGI', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
                                        Text('NUOVO PRODOTTO', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
                                      ],
                                    )),
                                    onPressed: () {

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAndAddProductScreen(
                                        callBackFunction: (){
                                          setState(() {

                                          });
                                        }
                                      ),),);
                                    },
                                  ),
                                ),
                                dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? Text('') : SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent.shade200,
                                    ),
                                    child: Center(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('AGGIUNGI PRODOTTI DA ', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
                                        Text('CATALOGO FORNITORI', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
                                      ],
                                    )),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Builder(
                                              builder: (context) {

                                                return SizedBox(
                                                  width: getProportionateScreenWidth(900),
                                                  height: getProportionateScreenHeight(600),
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
                                                              Text(
                                                                '  Lista Prodotti',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                  getProportionateScreenWidth(17),
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                  Icons.clear,
                                                                  color: Colors.white,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        AddElementWidget(),
                                                        SizedBox(height: 40),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                    },
                                  ),
                                ),
                                SizedBox(
                                width: getProportionateScreenWidth(170),
                                height: getProportionateScreenHeight(60),
                                child: TextButton(
                                 style: TextButton.styleFrom(
                                    backgroundColor: kCustomOrange,
                                  ),
                                 child: Center(child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                     Text('EFFETTUA', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold),),
                                     Text('ORDINE', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(14), fontWeight: FontWeight.bold),),
                      ],
                                   )),
                                onPressed: () {
                                    Navigator.pushNamed(context, OrderFromStorageScreen.routeName);
                                                      },
                                  ),
                        ),
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                    ),
                                    child: Center(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('SPOSTA PRODOTTI', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
                                        Text('IN ALTRO MAGAZZINO', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
                                      ],
                                    )),
                                    onPressed: () {
                                      Navigator.pushNamed(context, MoveProductToStorageScreen.routeName);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),

                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('EFFETTUA',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
                                        Text('CARICO',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)), ),
                                      ],
                                    ),
                                    onPressed: (){
                                        dataBundleNotifier.clearLoadUnloadParameterOnEachProductForCurrentStorage();
                                        Navigator.pushNamed(context, LoadStorageScreen.routeName);
                                    }
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),

                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: kCustomBordeaux,
                                    ),
                                    child: Column(
                                      children: [
                                        Text('EFFETTUA',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
                                        Text('SCARICO',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)), ),
                                      ],
                                    ),
                                    onPressed: (){
                                      dataBundleNotifier.clearLoadUnloadParameterOnEachProductForCurrentStorage();
                                      Navigator.pushNamed(context, UnloadStorageScreen.routeName);
                                    }
                                  ),
                                ),
                                dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? SizedBox(height: 0,) : SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.lightBlueAccent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('CONFIGURA',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
                                        Text('Q/100',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)), ),
                                      ],
                                    ),
                                    onPressed: (){

                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('SVUOTA',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
                                        Text('MAGAZZINO',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)), ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                            backgroundColor: kCustomWhite,
                                            contentPadding: EdgeInsets.only(top: 10.0),
                                            elevation: 30,

                                            content: SizedBox(
                                              height: getProportionateScreenHeight(240),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text('Svuota Magazzino?', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text('Impostare la giacenza per tutti i prodotti presenti in ${dataBundleNotifier.currentStorage.name} a 0?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
                                                      ),
                                                      SizedBox(height: 40),
                                                      InkWell(
                                                        child: Container(
                                                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                            decoration: const BoxDecoration(
                                                              color: Colors.redAccent,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(25.0),
                                                                  bottomRight: Radius.circular(25.0)),
                                                            ),
                                                            child: SizedBox(
                                                              width: getProportionateScreenWidth(300),
                                                              child: CupertinoButton(child: const Text('SVUOTA MAGAZZINO',
                                                                  style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.redAccent,
                                                                  onPressed: () async {
                                                                  try{
                                                                    Response response = await dataBundleNotifier.getclientServiceInstance().performEmptyStockStorage(dataBundleNotifier.currentStorage);

                                                                    if(response.data.toString() != '0'){
                                                                      dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                                                      Navigator.of(context).pop();
                                                                      ScaffoldMessenger.of(context)
                                                                          .showSnackBar(const SnackBar(
                                                                          backgroundColor: Colors.green,
                                                                          duration: Duration(milliseconds: 1000),
                                                                          content: Text('Magazzino svuotato')));
                                                                    }else{
                                                                      ScaffoldMessenger.of(context)
                                                                          .showSnackBar(SnackBar(
                                                                          backgroundColor: kPinaColor,
                                                                          duration: Duration(milliseconds: 1600),
                                                                          content: Text(response.data)));
                                                                    }
                                                                  } catch(e){
                                                                    print('Errore');
                                                                  }

                                                                }
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      );
                                    }),
                                  ),
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red.shade700,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('IMPOSTA GIACENZA 0',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(11)), ),
                                          Text('I PRODOTTI IN NEGATIVO',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(11)), ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                              backgroundColor: kCustomWhite,
                                              contentPadding: EdgeInsets.only(top: 10.0),
                                              elevation: 30,

                                              content: SizedBox(
                                                height: getProportionateScreenHeight(270),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: const Text('', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Impostare la giacenza a 0 per tutti i prodotti presenti in ${dataBundleNotifier.currentStorage.name} che abbiamo un valore per la giacenza in negativo?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
                                                        ),
                                                        SizedBox(height: 40),
                                                        InkWell(
                                                          child: Container(
                                                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                              decoration: BoxDecoration(
                                                                color: Colors.red.shade700,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(25.0),
                                                                    bottomRight: Radius.circular(25.0)),
                                                              ),
                                                              child: SizedBox(
                                                                width: getProportionateScreenWidth(300),
                                                                child: CupertinoButton(child: const Text('PROCEDI',
                                                                    style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.red.shade700,
                                                                    onPressed: () async {
                                                                      try{
                                                                        Response response = await dataBundleNotifier.getclientServiceInstance().performSetNullAllProductsWithNegativeValueForStockStorage(dataBundleNotifier.currentStorage);

                                                                        if(response.data.toString() != '0'){
                                                                          dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                                                          Navigator.of(context).pop();
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(
                                                                              backgroundColor: Colors.green,
                                                                              duration: Duration(milliseconds: 1000),
                                                                              content: Text('Magazzino svuotato')));
                                                                        }else{
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                              backgroundColor: kPinaColor,
                                                                              duration: Duration(milliseconds: 1600),
                                                                              content: Text(response.data)));
                                                                        }
                                                                      } catch(e){
                                                                        print('Errore');
                                                                      }
                                                                    }
                                                                ),
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      }),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  height: getProportionateScreenHeight(60),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.deepOrange.shade700,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('IMPOSTA GIACENZA 0',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(11)), ),
                                          Text('X PRODOTTI SELEZIONATI',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(11)), ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                              backgroundColor: kCustomWhite,
                                              contentPadding: EdgeInsets.only(top: 10.0),
                                              elevation: 30,

                                              content: SizedBox(
                                                height: getProportionateScreenHeight(270),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: const Text('', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Impostare la giacenza a 0 per tutti i prodotti selezionati in ${dataBundleNotifier.currentStorage.name}?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
                                                        ),
                                                        SizedBox(height: 40),
                                                        InkWell(
                                                          child: Container(
                                                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                              decoration: BoxDecoration(
                                                                color: Colors.red.shade700,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(25.0),
                                                                    bottomRight: Radius.circular(25.0)),
                                                              ),
                                                              child: SizedBox(
                                                                width: getProportionateScreenWidth(300),
                                                                child: CupertinoButton(child: const Text('PROCEDI',
                                                                    style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.red.shade700,
                                                                    onPressed: () async {
                                                                      try{
                                                                        List<StorageProductModel> productToRemove = [];
                                                                        dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
                                                                          if(element.selected){
                                                                            productToRemove.add(element);
                                                                          }
                                                                        });
                                                                        if(productToRemove.isEmpty){
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(
                                                                              backgroundColor: kPinaColor,
                                                                              duration: Duration(milliseconds: 600),
                                                                              content: Text('Nessun prodotto selezionato')));
                                                                        }else{
                                                                          productToRemove.forEach((productStorageElementToRemove) async {
                                                                            //TODO finire la questione set a 0 dei prodotti selezionati
                                                                          });
                                                                          dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                                                        }
                                                                      }catch(e){
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                            duration: const Duration(milliseconds: 400),
                                                                            content: Text('Impossibile completare operazione. Riprovare fra un paio di minuti. Exception: ' + e)));
                                                                      }

                                                                    }
                                                                ),
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: getProportionateScreenHeight(40),
                            width: getProportionateScreenWidth(500),
                            child: CupertinoTextField(
                              textInputAction: TextInputAction.next,
                              restorationId: 'Ricerca per nome o fornitore',
                              keyboardType: TextInputType.text,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              placeholder: 'Ricerca per nome o fornitore',
                              onChanged: (currentText) {
                                dataBundleNotifier.filterStorageProductList(currentText);
                              },
                            ),
                          ),
                        ),
                        buildCurrentListProductTable(dataBundleNotifier, context),
                      ],
                    ),
                  ),
                );
              }
          ),

        );
      },
    );
  }

  buildCurrentListProductTable(DataBundleNotifier dataBundleNotifier, context) {
    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      element.selected = false;
    });

    List<DataColumn> kTableColumns = <DataColumn>[
      DataColumn(
        label: Row(children: [ Text('PRODOTTO', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(15), fontWeight: FontWeight.bold),),
          IconButton(
              icon: dataBundleNotifier.isZtoAOrderded ? SvgPicture.asset('assets/icons/sort_a_to_z.svg') : SvgPicture.asset('assets/icons/sort_z_to_a.svg'),
              onPressed: () {
                dataBundleNotifier.sortCurrentStorageListDuplicatedFromAToZ();
              }
          ),]),
      ),
      DataColumn(
        label: Text('GIACENZA', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(15), fontWeight: FontWeight.bold)),
        numeric: true,
      ),
      DataColumn(
        label: Text('PREZZO', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(15), fontWeight: FontWeight.bold)),
        numeric: true,
      ),
      DataColumn(
        label: Text('FORNITORE', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(15), fontWeight: FontWeight.bold)),
        numeric: true,
      ),
    ];
    return PaginatedDataTable(
      showCheckboxColumn: dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? false : true,
      rowsPerPage: 8,
      columnSpacing: getProportionateScreenHeight(50),
      columns: kTableColumns,
      source: ProductDataSourceStorage(dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated, dataBundleNotifier.currentListSuppliers, dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? true : false),
    );
  }

  refreshPage(DataBundleNotifier dataBundleNotifier) {
    dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
  }

  retrieveListSuppliersBis(List<SupplierModel> currentListSuppliers) {
    List<String> currentListNameSuppliers = [];
    currentListSuppliers.forEach((element) {
      currentListNameSuppliers.add(element.nome);
    });
    return currentListNameSuppliers;
  }
}

class Content extends StatefulWidget {

  final Widget child;
  Content({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> with AutomaticKeepAliveClientMixin<Content>  {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: widget.child,
        ),
      ],
    );
  }

}
