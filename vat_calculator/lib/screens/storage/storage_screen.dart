import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/load_screen.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/unload_screen.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/add_storage_screen.dart';
import 'components/dismissable_widget_products.dart';

class StorageScreen extends StatefulWidget{
  static String routeName = "/storagescreen";

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen>{

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                                FutureBuilder(
                                  initialData: <dynamic>[
                                    const Center(
                                        child: CircularProgressIndicator(
                                          color: kPinaColor,
                                        )),
                                    const SizedBox(),
                                    Column(
                                      children: const [
                                        Center(
                                          child: Text(
                                            'Caricamento prodotti..',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: kPrimaryColor,
                                                fontFamily: 'LoraFont'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  future: buildListProducts(dataBundleNotifier, context),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DismissableWidgetProducts();
                                    } else {
                                      return const CircularProgressIndicator();
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
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          drawer: const CommonDrawer(),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.storage),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
            centerTitle: true,
            title: dataBundleNotifier.searchStorageButton ? SizedBox(
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenWidth(300),
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
            ) : GestureDetector(
              onTap: () {
                buildStorageChooserDialog(context, dataBundleNotifier);
              },
              child: Text(
                dataBundleNotifier.currentStorageList.isNotEmpty ?
                dataBundleNotifier.currentStorage.name : 'Crea Magazzino',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  color: kPrimaryColor,
                ),
              ),
            ),
            backgroundColor: kCustomWhite,
            actions: [
              dataBundleNotifier.searchStorageButton ? IconButton(
                  icon: dataBundleNotifier.isZtoAOrderded ? SvgPicture.asset('assets/icons/sort_a_to_z.svg') : SvgPicture.asset('assets/icons/sort_z_to_a.svg'),
                  onPressed: () {
                    dataBundleNotifier.sortCurrentStorageListDuplicatedFromAToZ();
                  }
              ) : SizedBox(width: 0,),

              IconButton(
                  icon: Icon(
                    dataBundleNotifier.searchStorageButton ? Icons.cancel_outlined : Icons.search,
                    color: dataBundleNotifier.searchStorageButton ? kPinaColor : kPrimaryColor,
                    size: getProportionateScreenHeight(30),
                  ),
                  onPressed: () {
                    dataBundleNotifier.filterStorageProductList('');
                    dataBundleNotifier.switchSearchProductStorageButton();
                  }
              ),

              dataBundleNotifier.searchStorageButton ? SizedBox(width: 0,) : IconButton(
                  icon: Icon(
                    Icons.arrow_circle_down_outlined,
                    color: kPinaColor,
                    size: getProportionateScreenHeight(30),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, UnloadStorageScreen.routeName);
                  }
                  ),
              dataBundleNotifier.searchStorageButton ? SizedBox(width: 0,) : IconButton(
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
                      child: DefaultButton(
                        text: "Crea Attività",
                        press: () async {
                          Navigator.pushNamed(
                              context, CompanyRegistration.routeName);
                        },
                      ),
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
                            dataBundleNotifier.dataBundleList.isNotEmpty
                                ? "Ciao ${dataBundleNotifier.dataBundleList[0].firstName}, sembra "
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
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: buildGestureDetectorStoragesSelector(
                            context, dataBundleNotifier),
                      ),
                      buildCurrentListProductTable(dataBundleNotifier, context),
                    ],
                  ),
                );
              }
          ),

        );
      },
    );
  }

  GestureDetector buildGestureDetectorStoragesSelector(
      BuildContext context, DataBundleNotifier dataBundleNotifier) {
    return GestureDetector(
      onTap: () {
        buildStorageChooserDialog(context, dataBundleNotifier);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 3, left: 3, bottom: 3),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: kPinaColor,
          elevation: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: Text(
                  '   ' + dataBundleNotifier.currentStorage.name
                      + ' (' + dataBundleNotifier.currentStorageProductListForCurrentStorage.length.toString() + ')',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(15)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 15, 0),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
                  ? kPinaColor
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
                  dataBundleNotifier.currentStorage.name ==
                      currentStorageElement.name ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                        child: SvgPicture.asset(
                    'assets/icons/success-green.svg',
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
      GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ' Crea Nuovo  ',
                textAlign: TextAlign.center,
                style: TextStyle(

                  fontSize: getProportionateScreenWidth(16),
                  color : Colors.white,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
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
    );
    return storagesWidgetList;
  }



  buildCurrentListProductTableToReplace(DataBundleNotifier dataBundleNotifier, context) {
    DataTable dataTable2;

    if(dataBundleNotifier.cupertinoSwitch){
      dataTable2 = DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 500,
          columns: [
            DataColumn2(
              label: dataBundleNotifier.currentPrivilegeType == 'User' ? const SizedBox(width: 0,) : CupertinoSwitch(
                activeColor: Colors.green.shade700,
                value: dataBundleNotifier.cupertinoSwitch,
                onChanged: (bool value) { dataBundleNotifier.switchCupertino(); },
              ),
              size: ColumnSize.S,
            ),
            const DataColumn2(
              label: Text('Prodotto'),
              size: ColumnSize.L,
            ),
            const DataColumn(
              label: Text('Stock'),
            ),
            const DataColumn(
              label: Text('Misura'),
            ),
            const DataColumn(
              label: Text('Prezzo Lordo'),
            ),
            const DataColumn(
              label: Text('Iva'),
            ),
            const DataColumn(
              label: Text('Fornitore'),
              numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
              dataBundleNotifier.currentStorageProductListForCurrentStorage.length,
                  (index) => DataRow(cells: [
                DataCell(GestureDetector(
                    onTap: () {
                      //EasyLoading.show();
                      dataBundleNotifier.getclientServiceInstance().removeProductFromStorage(dataBundleNotifier.currentStorageProductListForCurrentStorage[index]);
                      dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                      //EasyLoading.dismiss();
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 3,),
                        Icon(FontAwesomeIcons.trash, size: getProportionateScreenHeight(16),color: kPinaColor,),
                      ],
                    )),
                ),
                DataCell(
                    SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].productName)
                    ),
                ),
                DataCell(Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].stock.toString())),
                DataCell(Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].unitMeasure)),
                DataCell(Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].price.toString() + ' €')),
                DataCell(Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].vatApplied.toString() + '%'),),
                DataCell(Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].supplierName),),

              ]))
      );
    }else{
      dataTable2 = DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 500,
          columns: [
            DataColumn2(
              label: dataBundleNotifier.currentPrivilegeType == 'User' ? SizedBox(width: 0,) : CupertinoSwitch(
                activeColor: Colors.green.shade700,
                value: dataBundleNotifier.cupertinoSwitch,
                onChanged: (bool value) { dataBundleNotifier.switchCupertino(); },
              ),
              size: ColumnSize.S,
            ),
            const DataColumn2(
              label: Text('Prodotto'),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Stock'),
            ),
          ],
          rows: List<DataRow>.generate(
              dataBundleNotifier.currentStorageProductListForCurrentStorage.length,
                  (index) => DataRow(cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      //EasyLoading.show();
                      dataBundleNotifier.getclientServiceInstance().removeProductFromStorage(dataBundleNotifier.currentStorageProductListForCurrentStorage[index]);
                      dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                      //EasyLoading.dismiss();
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 3,),
                        Icon(FontAwesomeIcons.trash, size: getProportionateScreenHeight(16),color: kPinaColor,),
                      ],
                    ),
                  ),
                ),
                DataCell(Column(
                  children: [
                    Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].productName),
                  ],
                )),
                DataCell(Text(dataBundleNotifier.currentStorageProductListForCurrentStorage[index].stock.toString())),

              ]))
      );
    }
    return dataTable2;
  }

  buildCurrentListProductTable(
      DataBundleNotifier dataBundleNotifier, context) {

    List<Row> rows = [

    ];

    if(dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.isEmpty){
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, getProportionateScreenHeight(200), 0, 0),
              child: const Center(child: Text('Nessun prodotto presente')),
            ),
          ],
        ),
      );
    }

    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated
        .forEach((element) {
      TextEditingController controller =
      TextEditingController(text: element.stock.toString());
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(
                    element.productName,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      element.unitMeasure,
                      style:
                      TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    Text(
                      element.price.toString() + ' €',
                      style:
                      TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                      getProportionateScreenWidth(70),
                      getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    enabled: false,
                    controller: controller,
                    onChanged: (text) {
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                IconButton(
                  color: kPinaColor,
                  icon: Icon(FontAwesomeIcons.trash, size: getProportionateScreenHeight(16),color: kPinaColor,),
                  onPressed: () {
                    //EasyLoading.show();
                    dataBundleNotifier.getclientServiceInstance()
                        .removeProductFromStorage(element);
                    dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                    //EasyLoading.dismiss();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
    return Padding(
      padding: EdgeInsets.fromLTRB(getProportionateScreenHeight(8), getProportionateScreenHeight(8), getProportionateScreenHeight(8), getProportionateScreenHeight(90)),
      child: Column(
        children: rows,
      ),
    );
  }


  Future<List<Widget>> buildListProducts(DataBundleNotifier dataBundleNotifier,
      BuildContext context) async {


    List<Widget> fakeList = [];
    List<ProductModel> retrieveProductsByBranch = await dataBundleNotifier.getclientServiceInstance().retrieveProductsByBranch(dataBundleNotifier.currentBranch);
    List<int> listProductIdsToRemove = [];
    print('coming list size ' + retrieveProductsByBranch.length.toString());
      dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((currentProductAlreadyPresent) {
        listProductIdsToRemove.add(currentProductAlreadyPresent.fkProductId);
      });


    retrieveProductsByBranch.removeWhere((element) =>
      listProductIdsToRemove.contains(element.pkProductId),
    );

    print('coming list size ' + retrieveProductsByBranch.length.toString());
    dataBundleNotifier.addAllCurrentListProductToProductListToAddToStorage(retrieveProductsByBranch);
    return fakeList;
  }

  refreshPage(DataBundleNotifier dataBundleNotifier) {

      dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();

  }
}
