import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/add_storage_screen.dart';
import 'components/dismissable_widget_products.dart';
import 'components/unload_comunication_page.dart';

class StorageScreen extends StatefulWidget{
  static String routeName = "/storagescreen";

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen>{

  @override
  Widget build(BuildContext context) {


    final kPages = <Widget>[
      Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: kPrimaryColor,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: buildGestureDetectorStoragesSelector(
                            context, dataBundleNotifier),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DefaultButton(
                          text: 'Aggiungi Prodotti',
                          press: () {
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
                          color: kPrimaryColor,
                        ),
                      ),

                      buildCurrentListProductTable(dataBundleNotifier, context),
                      const SizedBox(height: 80,),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
      Consumer<DataBundleNotifier>(
    builder: (context, dataBundleNotifier, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: kPrimaryColor,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildCurrentListProdutctTableForStockManagmentLoad(dataBundleNotifier, context),
                ),
                const SizedBox(height: 80,),
              ],
            ),
          ),
        ),
      );
        }
      ),
      Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: kPrimaryColor,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildCurrentListProdutctTableForStockManagmentUnload(dataBundleNotifier, context),
                      ),
                      const SizedBox(height: 80,),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    ];

    final kTab = <Tab>[
      const Tab(child: Text('Area Gestione'),),
      const Tab(child: Text('Carico')),
      const Tab(child: Text('Scarico')),
    ];

    return DefaultTabController(
      length: kTab.length,
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            drawer: const CommonDrawer(),
            appBar: AppBar(
              bottom: TabBar(
                tabs: kTab,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0, color: kPrimaryLightColor),

                ),
              ),
              iconTheme: const IconThemeData(color: kPrimaryLightColor),
              centerTitle: true,
              title: GestureDetector(
                onTap: () {
                  buildStorageChooserDialog(context, dataBundleNotifier);
                },
                child: Text(
                  dataBundleNotifier.currentStorageList.isNotEmpty ?
                  dataBundleNotifier.currentStorage.name : 'Crea Magazzino',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    color: kCustomWhite,
                  ),
                ),
              ),
              backgroundColor: kPrimaryColor,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.refresh_sharp,
                      color: kCustomWhite,
                      size: getProportionateScreenHeight(25),
                    ),
                    onPressed: () {
                      refreshPage(dataBundleNotifier);
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
                    : TabBarView(
                        children: kPages,
                      ),
            bottomNavigationBar:
                const CustomBottomNavBar(selectedMenu: MenuState.storage),
          );
        },
      ),
    );
  }

  GestureDetector buildGestureDetectorStoragesSelector(
      BuildContext context, DataBundleNotifier dataBundleNotifier) {
    return GestureDetector(
      onTap: () {
        buildStorageChooserDialog(context, dataBundleNotifier);
      },
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
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
            ),
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

  buildCurrentListProdutctTableForStockManagmentUnload(DataBundleNotifier dataBundleNotifier, context){
    List<Row> rows = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                color: kPinaColor,
                text: 'Effettua Scarico',
                press: () async {
                  int stockProductDiffentThan0 = 0;
                  Map<int, List<StorageProductModel>> orderedMapBySuppliers = {};
                  dataBundleNotifier.currentStorageProductListForCurrentStorageUnload.forEach((element) {
                    if(element.stock != 0){
                      stockProductDiffentThan0 = stockProductDiffentThan0 + 1;

                      if(orderedMapBySuppliers.keys.contains(element.supplierId)){
                          orderedMapBySuppliers[element.supplierId].add(element);
                      }else{
                        orderedMapBySuppliers[element.supplierId] = [element];
                      }
                    }
                  });
                  if(stockProductDiffentThan0 == 0){
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kPinaColor,
                      content: Text('Immettere la quantità di scarico per almeno un prodotto'),
                    ));
                  }else{
                    Map<int, List<StorageProductModel>> recapMapForCustomer = orderedMapBySuppliers;
                    orderedMapBySuppliers.forEach((key, value) async {
                      Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performSaveOrder(OrderModel(
                          code: DateTime.now().microsecondsSinceEpoch.toString().substring(3,16),
                          details: 'Ordine Bozza per fornitore con id ' + key.toString(),
                          total: 0.0,
                          status: OrderState.DRAFT,
                          creation_date: DateTime.now().millisecondsSinceEpoch,
                          delivery_date: null,
                          fk_branch_id: dataBundleNotifier.currentBranch.pkBranchId,
                          fk_storage_id: dataBundleNotifier.currentStorage.pkStorageId,
                          fk_user_id: dataBundleNotifier.dataBundleList[0].id,
                          pk_order_id: 0,
                          fk_supplier_id: key
                      ));

                      value.forEach((element) {

                        print('Create relation between ' + performSaveOrderId.data.toString() + ' and : ' + element.fkProductId.toString() + ' - Stock: ' +  element.stock.toString());
                        dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(
                            element.stock,
                            element.fkProductId,
                            performSaveOrderId.data
                        );

                        dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((standardElement) {
                          if(standardElement.pkStorageProductId == element.pkStorageProductId){
                            element.stock = standardElement.stock - element.stock;
                            ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();
                            getclientServiceInstance.updateStock([element]);
                          }
                        });


                      });
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ComunicationUnloadStorageScreen(orderedMapBySuppliers: recapMapForCustomer ,),),);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.2,
              child: DefaultButton(
                color: kBeigeColor,
                text: 'Clear',
                press: () {
                  dataBundleNotifier.clearUnloadProductList();
                },
              ),
            ),
          ),
        ],
      ),
    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorageUnload.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.stock.toString());
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
                    child: Text(element.productName, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                ),
                Row(
                  children: [
                    Text(element.unitMeasure, style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),),
                    ),
                    Text(element.price.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(element.stock <= 0){
                      }else{
                        element.stock --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      if( double.tryParse(text) != null){
                        element.stock = double.parse(text);
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Immettere un valore numerico corretto per ' + element.productName),
                        ));
                      }

                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    setState(() {
                      element.stock = element.stock + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
    return Column(
      children: rows,
    );
  }
  buildCurrentListProdutctTableForStockManagmentLoad(DataBundleNotifier dataBundleNotifier, context){
    List<Row> rows = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                color: Colors.green.shade700,
                text: 'Effettua Carico',
                press: () {
                  int currentProductWithMorethan0Amount = 0;
                  dataBundleNotifier.currentStorageProductListForCurrentStorageLoad.forEach((element) {
                    if(element.stock != 0){
                      currentProductWithMorethan0Amount = currentProductWithMorethan0Amount + 1;
                    }
                  });
                  if(currentProductWithMorethan0Amount == 0){
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kPinaColor,
                      content: Text('Immettere la quantità di carico per almeno un prodotto'),
                    ));
                  }else{
                    dataBundleNotifier.currentStorageProductListForCurrentStorageLoad.forEach((element) {
                      dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((standardElement) {
                        if(standardElement.pkStorageProductId == element.pkStorageProductId){
                          element.stock = standardElement.stock + element.stock;
                        }
                      });
                    });
                    ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();
                    getclientServiceInstance.updateStock(dataBundleNotifier.currentStorageProductListForCurrentStorageLoad);
                    dataBundleNotifier.clearUnloadProductList();
                    dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                    refreshPage(dataBundleNotifier);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.2,
              child: DefaultButton(
                color: kBeigeColor,
                text: 'Clear',
                press: () {
                  dataBundleNotifier.clearLoadProductList();
                },
              ),
            ),
          ),
        ],
      ),
    ];

    dataBundleNotifier.currentStorageProductListForCurrentStorageLoad.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.stock.toString());
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
                    child: Text(element.productName, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                ),
                Row(
                  children: [
                    Text(element.unitMeasure, style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),),
                    ),
                    Text(element.price.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(element.stock <= 0){
                      }else{
                        element.stock --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      if( double.tryParse(text) != null){
                        element.stock = double.parse(text);
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Immettere un valore numerico corretto per ' + element.productName),
                        ));
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      element.stock = element.stock + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
    return Column(
      children: rows,
    );
  }
  buildCurrentListProductTable(DataBundleNotifier dataBundleNotifier, context) {
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
