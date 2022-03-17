import 'dart:io';
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
import '../../client/vatservice/model/storage_product_model.dart';
import '../../client/vatservice/model/utils/action_type.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/add_storage_screen.dart';
import 'components/add_widget_element.dart';
import 'components/create_product_and_add_to_storage.dart';
import 'components/product_datasource_storage.dart';
import 'load_unload_screens/load_screen.dart';
import 'load_unload_screens/unload_screen.dart';

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
          backgroundColor: kPrimaryColor,
          body: dataBundleNotifier.currentBranch == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sembra che tu non abbia configurato ancora nessuna attività. ",
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
                      "Ti ricordo che è possibile inserire prodotti al tuo magazzino solo dopo averli creati ed associati ad uno dei tuoi fornitori."
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
                                IconButton(
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
                                SizedBox(
                                  width: getProportionateScreenWidth(160),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.pinkAccent.shade400,
                                    ),
                                    child: Center(child: Column(
                                      children: [
                                        Text('CREA ED AGGIUNGI', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold),),
                                        Text('NUOVO PRODOTTO', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold),),
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
                                SizedBox(
                                  width: getProportionateScreenWidth(170),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent.shade200,
                                    ),
                                    child: Center(child: Column(
                                      children: [
                                        Text('AGGIUNGI PRODOTTI DA ', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold),),
                                        Text('CATALOGO FORNITORI', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(13), fontWeight: FontWeight.bold),),
                                      ],
                                    )),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                            content: Builder(
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
                                                        AddElementWidget()
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
                                SizedBox(
                                  width: getProportionateScreenWidth(160),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                    child: Column(
                                      children: [
                                        Text('EFFETTUA',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
                                        Text('CARICO',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)), ),
                                      ],
                                    ),
                                    onPressed: ()=> Navigator.pushNamed(context, LoadStorageScreen.routeName),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(160),
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
                                    onPressed: ()=> Navigator.pushNamed(context, UnloadStorageScreen.routeName),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(160),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: kCustomBlueAccent,
                                    ),
                                    child: Column(
                                      children: [
                                        Text('CONFIGURA',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
                                        Text('Q/100',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)), ),
                                      ],
                                    ),
                                    onPressed: (){

                                    },
                                  ),
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
      rowsPerPage: 8,
      columns: kTableColumns,
      source: ProductDataSourceStorage(dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated, dataBundleNotifier.currentListSuppliers),
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
