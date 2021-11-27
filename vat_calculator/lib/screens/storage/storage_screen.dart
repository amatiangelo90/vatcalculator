import 'package:chips_choice/chips_choice.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
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

  String supplierChoiced = '';
  List<String> suppliersList;

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        suppliersList = retrieveListSuppliers(dataBundleNotifier.currentListSuppliers);

        return Scaffold(
          floatingActionButton: dataBundleNotifier.currentStorageList.isEmpty
              ? SizedBox(width: 0,) :
          FloatingActionButton(
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
                              context, BranchChoiceCreationEnjoy.routeName);
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 5,),
                            IconButton(
                                icon: dataBundleNotifier.isZtoAOrderded ? SvgPicture.asset('assets/icons/sort_a_to_z.svg') : SvgPicture.asset('assets/icons/sort_z_to_a.svg'),
                                onPressed: () {
                                  dataBundleNotifier.sortCurrentStorageListDuplicatedFromAToZ();
                                }
                            ),
                            Content(
                              child: ChipsChoice<String>.single(
                                choiceActiveStyle: C2ChoiceStyle(
                                  color: kPinaColor,
                                  elevation: 2,
                                  showCheckmark: false,
                                ),
                                value: supplierChoiced,
                                onChanged: (val) => setState(() {
                                  supplierChoiced = val;
                                  dataBundleNotifier.filterStorageProductList(val);
                                }),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: suppliersList,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                  tooltip: (i, v) => v,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  Row(
                    children: [
                      IconButton(icon: SvgPicture.asset('assets/icons/storage.svg', width: getProportionateScreenWidth(16),), ),
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
          width: getProportionateScreenWidth(250),
          child: CupertinoButton(
            child: Text('Crea Magazzino'),
            color: Colors.green,
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

  buildCurrentListProductTable(
      DataBundleNotifier dataBundleNotifier, context) {

    List<Widget> rows = [
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
        .forEach((productStorageElementToRemove) {
      TextEditingController controller =
      TextEditingController(text: productStorageElementToRemove.stock.toString());
      rows.add(
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: kPinaColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Elimina ' + productStorageElementToRemove.productName + '?', style: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenWidth(15)),),
                SizedBox(width: 10,),
                IconButton(
                  color: kPinaColor,
                  icon: Icon(FontAwesomeIcons.trash, size: getProportionateScreenHeight(16),color: kCustomWhite,),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
          key: Key(productStorageElementToRemove.pkStorageProductId.toString()),
          onDismissed: (value){
            dataBundleNotifier.removeObjectFromStorageProductList(productStorageElementToRemove);

            dataBundleNotifier.getclientServiceInstance()
                .removeProductFromStorage(
                  storageProductModel: productStorageElementToRemove,
                actionModel: ActionModel(
                    date: DateTime.now().millisecondsSinceEpoch,
                    description: 'Ha rimosso ${productStorageElementToRemove.productName} dal magazzino ${dataBundleNotifier.currentStorage.name} ',
                    fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                    user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                    type: ActionType.PRODUCT_DELETE
                )
            );


            dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
            suppliersList = retrieveListSuppliers(dataBundleNotifier.currentListSuppliers);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productStorageElementToRemove.productName,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: getProportionateScreenWidth(18)),
                    ),
                    Text(
                      productStorageElementToRemove.supplierName,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                    Row(
                      children: [
                        Text(
                          productStorageElementToRemove.unitMeasure,
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
                        dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? Text('',style:
                          TextStyle(fontSize: getProportionateScreenWidth(8))) : Text(
                          productStorageElementToRemove.price.toString() + ' €',
                          style:
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
                        ),
                      ],
                    ),
                  ],
                ),
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
                ],
              ),
            ],
          ),
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

  retrieveListSuppliers(List<ResponseAnagraficaFornitori> currentListSuppliers) {
    List<String> currentListNameSuppliers = ['Tutti i fornitori'];
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
