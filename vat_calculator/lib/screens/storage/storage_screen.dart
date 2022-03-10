import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/save_product_into_storage_request.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/load_screen.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/unload_screen.dart';
import 'package:vat_calculator/screens/storage/qhundred/amount_hundred_screen.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/add_storage_screen.dart';
import 'components/product_datasource_storage.dart';

class StorageScreen extends StatefulWidget{
  static String routeName = "/storagescreen";
  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {


  String supplierChoiced = '';
  List<String> suppliersList = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitMeasureController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _selectedValue4 = false;
  bool _selectedValue5 = false;
  bool _selectedValue10 = false;
  bool _selectedValue22 = false;

  bool _litresUnitMeasure = false;
  bool _kgUnitMeasure = false;
  bool _packagesUnitMeasure = false;
  bool _otherUnitMeasure = false;

  String _selectedSupplier = 'Seleziona Fornitore';

  int _rowsPerPage = 7;

  void setCurrentSupplier(String supplier, DataBundleNotifier dataBundleNotifier) {
    setState(() {
      _selectedSupplier = supplier;
    });
  }

  @override
  Widget build(BuildContext context) {

    const double _initFabHeight = 80.0;
    double _fabHeight = 0;
    double _panelHeightOpen = 0;
    double _panelHeightClosed = 45.0;



    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        suppliersList.clear();
        //dataBundleNotifier.setToSelectedFalseAllItemOnCurrentStorageProductListForCurrentStorageDuplicated();
        _panelHeightOpen = MediaQuery.of(context).size.height * .75;
        return Scaffold(

          drawer: const CommonDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: kCustomWhite),
            actions: [
              GestureDetector(
                onTap: () {
                  buildStorageChooserDialog(context, dataBundleNotifier);
                },
                child: Stack(
                  children: [ IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/storage.svg',
                      color: kCustomWhite,
                      width: getProportionateScreenHeight(40),
                    ),
                    onPressed: () {
                      buildStorageChooserDialog(context, dataBundleNotifier);
                    },
                  ),
                    Positioned(
                      top: 26.0,
                      right: 4.0,
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 20,
                            color: Colors.amber,
                          ),
                          Positioned(
                            right: 3.5,
                            top: 3.5,
                            child: Center(
                              child: Icon(Icons.compare_arrows_outlined, size: 13, color: customGreenAccent,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
            ],
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(dataBundleNotifier.currentBranch == null ? 'Area Magazzini' : dataBundleNotifier.currentStorage == null ?  'Area Magazzini': dataBundleNotifier.currentStorage.name, style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
            color: kCustomWhite,
          ),),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: const BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 3,
            color: kPrimaryColor,
            child: CustomBottomNavBar(selectedMenu: MenuState.storage),
          ),
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
                return Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                dataBundleNotifier.currentStorage == null ? const SizedBox(width: 0,) : GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, UnloadStorageScreen.routeName);
                                  },
                                  child: Card(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('   SCARICO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),),
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_circle_down_outlined,
                                              color: Colors.orange,
                                              size: getProportionateScreenHeight(30),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(context, UnloadStorageScreen.routeName);
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                dataBundleNotifier.currentStorage == null ? const SizedBox(width: 0,) : GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, LoadStorageScreen.routeName);
                                  },
                                  child: Card(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('   CARICO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_circle_up_outlined,
                                              color: Colors.green,
                                              size: getProportionateScreenHeight(30),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(context, LoadStorageScreen.routeName);
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                dataBundleNotifier.currentStorage == null ? const SizedBox(width: 0,) : GestureDetector(
                                  onTap: (){
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
                                            duration: Duration(milliseconds: 400),
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
                                  child: Card(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('   ELIMINA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),),
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                              size: getProportionateScreenHeight(30),
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                dataBundleNotifier.currentStorage == null ? const SizedBox(width: 0,) : GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, AmountHundredScreen.routeName);
                                  },
                                  child: Card(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('   Q/100', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
                                        IconButton(
                                            icon: Icon(
                                              Icons.apps,
                                              color: Colors.lightBlueAccent,
                                              size: getProportionateScreenHeight(30),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(context, AmountHundredScreen.routeName);
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
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
                          const SizedBox(height: 100,),
                        ],
                      ),
                    ),
                    SlidingUpPanel(
                      maxHeight: _panelHeightOpen,
                      minHeight: _panelHeightClosed,
                      parallaxEnabled: true,
                      parallaxOffset: .3,
                      panelBuilder: (sc) => _panel(sc, dataBundleNotifier),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      onPanelSlide: (double pos) => setState(() {
                        _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                            _initFabHeight;
                      }),
                    ),
                  ],
                );
              }
          ),

        );
      },
    );
  }

  Widget _panel(ScrollController sc, DataBundleNotifier dataBundleNotifier) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        child: ListView(
          controller: sc,
          children: <Widget>[
            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 35,
                  height: 5,

                  decoration: BoxDecoration(

                      color: customGreenAccent,
                      borderRadius: BorderRadius.all(const Radius.circular(12.0))),
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Aggiungi Prodotti",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: getProportionateScreenHeight(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            buildWidgetRowForProduct(dataBundleNotifier),

          ],
        ),
      ),
    );
  }

  void buildStorageChooserDialog(BuildContext context, DataBundleNotifier dataBundleNotifier) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return SizedBox(

                width: width,
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
                              '  Lista Magazzini',
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

                      Column(
                        children: buildListStorages(
                            dataBundleNotifier, context),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  buildListStorages(DataBundleNotifier dataBundleNotifier, context) {
    List<Widget> storagesWidgetList = [];

    dataBundleNotifier.currentStorageList.forEach((currentStorageElement) {
      storagesWidgetList.add(
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: dataBundleNotifier.currentStorage.name ==
                  currentStorageElement.name
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(icon: SvgPicture.asset('assets/icons/storage.svg', color: Colors.yellow.shade700.withOpacity(0.8), width: getProportionateScreenWidth(16),), ),
                      Text(
                        '   ' + currentStorageElement.name,
                        style: TextStyle(
                          fontSize: dataBundleNotifier.currentStorage.name ==
                              currentStorageElement.name
                              ? getProportionateScreenWidth(16)
                              : getProportionateScreenWidth(13),
                          color: dataBundleNotifier.currentStorage.name ==
                              currentStorageElement.name
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  dataBundleNotifier.currentStorage.name ==
                      currentStorageElement.name ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                    child: SvgPicture.asset(
                      'assets/icons/success-green.svg',
                      color: Colors.yellow.shade700.withOpacity(0.8),
                      width: 22,
                    ),
                  ) : SizedBox(height: 0,),
                ],
              ),
            ),
          ),
          onTap: () {
            //EasyLoading.show();
            dataBundleNotifier.setCurrentStorage(currentStorageElement);
            //EasyLoading.dismiss();
            Navigator.pop(context);
          },
        ),
      );
    });
    storagesWidgetList.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          width: MediaQuery.of(context).size.width,
          child: CupertinoButton(
            child: Text('Crea Magazzino'),
            color: Colors.green.shade900.withOpacity(0.9),
            onPressed: () {
              Navigator.pop(context);
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
      ),
    );
    return storagesWidgetList;
  }

  buildCurrentListProductTable(DataBundleNotifier dataBundleNotifier, context) {

    List<DataColumn> kTableColumns = <DataColumn>[
      DataColumn(
        label: Row(children: [ const Text('Prodotto'),
          IconButton(
              icon: dataBundleNotifier.isZtoAOrderded ? SvgPicture.asset('assets/icons/sort_a_to_z.svg') : SvgPicture.asset('assets/icons/sort_z_to_a.svg'),
              onPressed: () {
                dataBundleNotifier.sortCurrentStorageListDuplicatedFromAToZ();
              }
          ),]),
      ),
      const DataColumn(
        label: Text('Giacenza'),
        numeric: true,
      ),
      const DataColumn(
        label: Text('Prezzo'),
        numeric: true,
      ),
      const DataColumn(
        label: Text('Fornitore'),
        numeric: true,
      ),
    ];
    return Column(
      children: [
        PaginatedDataTable(
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const <int>[7, 14, 21, 28],
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          columns: kTableColumns,
          source: ProductDataSourceStorage(dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated, dataBundleNotifier.currentListSuppliers),
        ),
      ],
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

  buildWidgetRowForProduct(DataBundleNotifier dataBundleNotifier) {

    List<Widget> listWidget = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('  --  Crea ed aggiungi prodotti al magazzino  --  ', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(10)),),
      )
    ];

    listWidget.add(Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Center(
                child: DropdownWithSearch(
                  title: 'Seleziona Fornitore',
                  placeHolder: 'Ricerca Fornitore',
                  disabled: false,
                  items: dataBundleNotifier.currentListSuppliers.map((SupplierModel supplier) {
                    return supplier.pkSupplierId.toString() + ' - ' + supplier.nome;
                  }).toList(),
                  selected: _selectedSupplier,
                  onChanged: (storage) {
                    setCurrentSupplier(storage, dataBundleNotifier);
                  },
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 11,),
                Text('   Nome', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(10))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height *0.04,
                child: CupertinoTextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 11,),
                Text('   Unità di Misura', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(10))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _litresUnitMeasure = true;
                          _kgUnitMeasure = false;
                          _packagesUnitMeasure = false;
                          _otherUnitMeasure = false;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.04,
                        decoration: BoxDecoration(
                          color: _litresUnitMeasure ? Colors.lightGreen.shade700.withOpacity(0.6) : Colors.white,
                          border: Border.all(
                            width: 0.2,
                            color: Colors.grey,
                          ),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                        ),
                        child: Center(child: Text('litri', style: TextStyle(color: _litresUnitMeasure ? Colors.white : kPrimaryColor,),)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _litresUnitMeasure = false;
                          _kgUnitMeasure = true;
                          _packagesUnitMeasure = false;
                          _otherUnitMeasure = false;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.04,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.1,
                            color: kBeigeColor,
                          ),
                          color: _kgUnitMeasure ? Colors.lightGreen.shade700.withOpacity(0.6) : Colors.white,
                        ),
                        child: Center(child: Text('kg', style: TextStyle(color: _kgUnitMeasure ? Colors.white : kPrimaryColor,))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _litresUnitMeasure = false;
                          _kgUnitMeasure = false;
                          _packagesUnitMeasure = true;
                          _otherUnitMeasure = false;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.04,
                        decoration: BoxDecoration(
                          color: _packagesUnitMeasure ? Colors.lightGreen.shade700.withOpacity(0.6) : Colors.white,
                          border: Border.all(
                            width: 0.1,
                            color: kBeigeColor,
                          ),
                        ),
                        child: Center(child: Text('Pacchi', style: TextStyle(color: _packagesUnitMeasure ? Colors.white : kPrimaryColor,))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _litresUnitMeasure = false;
                          _kgUnitMeasure = false;
                          _packagesUnitMeasure = false;
                          _otherUnitMeasure = true;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.04,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.1,
                            color: kBeigeColor,
                          ),
                          color: _otherUnitMeasure ? Colors.lightGreen.shade700.withOpacity(0.6) : Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                        ),
                        child: Center(child: Text('Altro', style: TextStyle(color: _otherUnitMeasure ? Colors.white : kPrimaryColor,),)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _otherUnitMeasure ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height *0.04,
                child: CupertinoTextField(
                  controller: _unitMeasureController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                ),
              ),
            ) : const SizedBox(width: 0,),
            Row(
              children: [
                const SizedBox(width: 11,),
                Text('   Prezzo Lordo', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(10))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height *0.04,
                child: CupertinoTextField(
                  controller: _priceController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: CupertinoButton(
                color: Colors.green.shade700.withOpacity(0.8),
                onPressed: () async {
                  if(_nameController.text.isEmpty || _nameController.text == ''){
                    buildSnackBar(text: 'Inserire il nome del prodotto', color: kPinaColor);
                  }else if(!_litresUnitMeasure && !_otherUnitMeasure && !_kgUnitMeasure && !_packagesUnitMeasure){
                    buildSnackBar(text: 'Unità di misura del prodotto obbligatoria', color: kPinaColor);
                  } else if(_otherUnitMeasure && (_unitMeasureController.text.isEmpty || _unitMeasureController.text == '')){
                    buildSnackBar(text: 'Specificare unità di misura', color: kPinaColor);
                  }else if(_priceController.text.isEmpty || _priceController.text == ''){
                    buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text);
                  }else if(double.tryParse(_priceController.text.replaceAll(",", ".")) == null){
                    buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kPinaColor);
                  }else if(_selectedSupplier == 'Seleziona Fornitore'){
                    buildSnackBar(text: 'Selezionare un fornitore a cui associare il prodotto da creare', color: kPinaColor);
                  } else{

                    SupplierModel currentSupplierToSaveProduct = dataBundleNotifier.retrieveSupplierFromSupplierListByIdName(_selectedSupplier);
                    ProductModel productModel = ProductModel(
                        nome: _nameController.text,
                        categoria: '',
                        codice: const Uuid().v1(),
                        descrizione: '',
                        iva_applicata: _selectedValue4 ? 4 : _selectedValue5 ? 5 : _selectedValue10 ? 10 : _selectedValue22 ? 22 : 0,
                        prezzo_lordo: double.parse(_priceController.text.replaceAll(",", ".")),
                        unita_misura: _litresUnitMeasure ? 'litri' : _kgUnitMeasure ? 'kg' : _packagesUnitMeasure ? 'pacchi' : _otherUnitMeasure ? _unitMeasureController.text : '',
                        fkSupplierId: currentSupplierToSaveProduct.pkSupplierId
                    );

                    print(productModel.toMap().toString());

                    Response performSaveProduct = await dataBundleNotifier.getclientServiceInstance().performSaveProduct(
                        product: productModel,
                        actionModel: ActionModel(
                            date: DateTime.now().millisecondsSinceEpoch,
                            description: 'Ha aggiunto ${productModel.nome} al catalogo prodotti del fornitore ${currentSupplierToSaveProduct.nome} ',
                            fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                            user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                            type: ActionType.PRODUCT_CREATION
                        )
                    );
                    sleep(const Duration(milliseconds: 600));


                    if(performSaveProduct != null && performSaveProduct.statusCode == 200){
                      List<ProductModel> retrieveProductsBySupplier = await dataBundleNotifier.getclientServiceInstance().retrieveProductsBySupplier(currentSupplierToSaveProduct);
                      dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                      clearAll();


                      dataBundleNotifier.getclientServiceInstance().performSaveProductIntoStorage(
                          saveProductToStorageRequest: SaveProductToStorageRequest(
                              fkStorageId: dataBundleNotifier.currentStorage.pkStorageId,
                              fkProductId: performSaveProduct.data,
                              available: 'true',
                              stock: 0,
                              dateTimeCreation: DateTime.now().millisecondsSinceEpoch,
                              dateTimeEdit: DateTime.now().millisecondsSinceEpoch,
                              pkStorageProductCreationModelId: 0,
                              user: dataBundleNotifier.userDetailsList[0].firstName
                          ),
                          actionModel: ActionModel(
                              date: DateTime.now().millisecondsSinceEpoch,
                              description: 'Ha aggiunto ${productModel.nome} al magazzino ${dataBundleNotifier.currentStorage.name}.',
                              fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                              user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                              type: ActionType.ADD_PRODUCT_TO_STORAGE
                          )
                      );
                      dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                      buildSnackBar(text: 'Prodotto ' + productModel.nome + ' salvato per fornitore ' + currentSupplierToSaveProduct.nome + ' ed inserito nel magazzino ${dataBundleNotifier.currentStorage.name}', color: Colors.green.shade700);
                    }else{
                      buildSnackBar(text: 'Si sono verificati problemi durante il salvataggio. Risposta servizio: ' + performSaveProduct.toString(), color: kPinaColor);
                    }

                  }
                },
                child: Text('Crea ' + _nameController.text),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
    );
    listWidget.add(buildListProductDividedBySupplier(dataBundleNotifier));


    listWidget.add(const Divider(color: Colors.grey, endIndent: 40, indent: 40, height: 60,));
    return Column(children: listWidget,);
  }


  void clearAll() {
    setState((){
      _selectedValue4 = false;
      _selectedValue5 = false;
      _selectedValue10 = false;
      _selectedValue22 = false;

      _litresUnitMeasure = false;
      _kgUnitMeasure = false;
      _packagesUnitMeasure = false;
      _otherUnitMeasure = false;

      _nameController.clear();
      _unitMeasureController.clear();
      _priceController.clear();
    });
  }

  void buildSnackBar({@required String text, @required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

  Widget buildListProductDividedBySupplier(DataBundleNotifier dataBundleNotifier) {

    List<Widget> listWidget = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('  --  Oppure selezionali dal catalogo dei fornitori  --  ', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(10)),),
      )
    ];

    if(dataBundleNotifier.productToAddToStorage.isNotEmpty){
      Map<String, List<ProductModel>> mapSupplierListProduct = {};

      dataBundleNotifier.productToAddToStorage.forEach((product) {
        if(mapSupplierListProduct.containsKey(dataBundleNotifier.retrieveSupplierById(product.fkSupplierId))){
          mapSupplierListProduct[dataBundleNotifier.retrieveSupplierById(product.fkSupplierId)].add(product);
        }else{
          mapSupplierListProduct[dataBundleNotifier.retrieveSupplierById(product.fkSupplierId)] = [product];
        }
      });
      mapSupplierListProduct.forEach((key, value) {
        //print('Build list for current supplier : ' + key.toString());
        listWidget.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 5, 13, 2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54.withOpacity(0.7),
                ),
                width: MediaQuery.of(context).size.width,
                child: Text(key, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
              ),
            ),
        );
        value.forEach((element) {
          listWidget.add(
            GestureDetector(
              onTap: (){
                dataBundleNotifier.getclientServiceInstance().performSaveProductIntoStorage(
                    saveProductToStorageRequest: SaveProductToStorageRequest(
                        fkStorageId: dataBundleNotifier.currentStorage.pkStorageId,
                        fkProductId: element.pkProductId,
                        available: 'true',
                        stock: 0,
                        dateTimeCreation: DateTime.now().millisecondsSinceEpoch,
                        dateTimeEdit: DateTime.now().millisecondsSinceEpoch,
                        pkStorageProductCreationModelId: 0,
                        user: dataBundleNotifier.userDetailsList[0].firstName
                    ),
                    actionModel: ActionModel(
                        date: DateTime.now().millisecondsSinceEpoch,
                        description: 'Ha aggiunto ${element.nome} (${dataBundleNotifier.getSupplierName(element.fkSupplierId)}) al magazzino ${dataBundleNotifier.currentStorage.name}.',
                        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                        user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                        type: ActionType.ADD_PRODUCT_TO_STORAGE
                    )
                );

                dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                setState(() {
                  dataBundleNotifier.removeProductToAddToStorage(element);
                });

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    duration: const Duration(milliseconds: 400),
                    content: Text('${element.nome} aggiunto')));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(element.nome, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenHeight(10)),),
                      ],
                    ),
                    SvgPicture.asset('assets/icons/rightarrow.svg', width: getProportionateScreenHeight(25), color: Colors.greenAccent.shade700.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
    }else{
      listWidget.add(
        const Center(child: Text('Nessun prodotto disponibile'),)
      );
    }

    return Column(children: listWidget,);
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
