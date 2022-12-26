
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/response_fornitori.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/storage/components/move_produt_to_storage.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';

import '../../client/vatservice/model/storage_product_model.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.enums.swagger.dart';
import 'components/add_storage_screen.dart';
import 'components/add_widget_element.dart';
import 'components/create_product_and_add_to_storage.dart';
import 'load_unload_screens/load_screen.dart';
import 'load_unload_screens/unload_screen.dart';
import 'orders/order_from_storage_screen.dart';

class StorageScreen extends StatefulWidget{

  static String routeName = '/storagescreen';

  @override
  State<StorageScreen> createState() => _StorageScreenState();

  const StorageScreen({Key? key}) : super(key: key);
}

class _StorageScreenState extends State<StorageScreen> {


  String _filter = '';
  String supplierChoiced = '';
  List<String> suppliersList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        suppliersList.clear();
        return Scaffold(
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ButtonBar(

                alignment: MainAxisAlignment.spaceAround,
                children: [
                  dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? Text('') : SizedBox(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAndAddProductScreen(
                        ),),);
                      },
                    ),
                  ),
                  dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? Text('') : SizedBox(
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
                                          const AddElementWidget(),
                                          const SizedBox(height: 40),
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
                          Navigator.pushNamed(context, UnloadStorageScreen.routeName);
                        }
                    ),
                  ),
                  dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? SizedBox(height: 0,) : SizedBox(
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
                                                            ScaffoldMessenger.of(context)
                                                                .showSnackBar(const SnackBar(
                                                                backgroundColor: Colors.green,
                                                                duration: Duration(milliseconds: 1000),
                                                                content: Text('Magazzino svuotato')));
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
                ],
              ),
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: kPrimaryColor),
            actions: [
              GestureDetector(
                onTap: () {
                  buildStorageChooserDialog(context, dataBundleNotifier);
                },
                child: Stack(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/storage.svg',
                        color: kPrimaryColor,
                        width: getProportionateScreenHeight(28),
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
                          const Icon(
                            Icons.brightness_1,
                            size: 20,
                            color: kCustomPinkAccent,
                          ),
                          Positioned(
                            right: 6.5,
                            top: 1.5,
                            child: Center(
                              child: Text(dataBundleNotifier.getCurrentBranch().storages!.length.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: getProportionateScreenWidth(10))),
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
            backgroundColor: Colors.white,
            centerTitle: true,
            title: dataBundleNotifier.getCurrentBranch().storages!.isEmpty ? Text('Area Magazzini' , style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kPrimaryColor
            ),) : Column(
              children: [
                Text(
                  dataBundleNotifier.getCurrentStorage().name!,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  'Area gestione magazzini',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(11),
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: dataBundleNotifier.getUserEntity().branchList!.isEmpty
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
          ) : dataBundleNotifier.getCurrentBranch().storages!.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Ciao ${dataBundleNotifier.getUserEntity().name}, sembra "
                    "che tu non abbia configurato ancora nessun magazzino per ${dataBundleNotifier.getCurrentBranch().name}. "
                    "Ti ricordo che è possibile inserire prodotti al tuo magazzino solo dopo averli creati ed associati ad uno dei tuoi fornitori.",
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
                          branch: dataBundleNotifier.getCurrentBranch(),
                        ),
                      ),
                    );
                  }, textColor: Colors.white, color: kPrimaryColor,
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
                          child: SizedBox(
                            height: getProportionateScreenHeight(40),
                            width: getProportionateScreenWidth(500),
                            child: CupertinoTextField(
                              textInputAction: TextInputAction.next,
                              restorationId: 'Ricerca per nome',
                              keyboardType: TextInputType.text,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              placeholder: 'Ricerca per nome',
                              onChanged: (currentText) {
                                setState((){
                                  _filter = currentText;
                                });
                              },
                            ),
                          ),
                        ),
                        //buildCurrentListProductTable(dataBundleNotifier, context),
                        SizedBox(
                          height: getProportionateScreenHeight(550),
                          child: ListView.builder(
                            itemCount: getListProdFiltered(dataBundleNotifier.getCurrentStorage().products!, _filter).length,
                            itemBuilder: (context, index) {
                              final product = getListProdFiltered(dataBundleNotifier.getCurrentStorage().products!, _filter)[index];
                              return Dismissible(
                                key: Key(product.productId!.toString()),
                                onDismissed: (direction) async {
                                  print('Remove product from storage: ' + dataBundleNotifier.getCurrentStorage().storageId!.toInt().toString() + ' prod id: ' + dataBundleNotifier.getCurrentStorage().products![index]!.productId!.toInt().toString());
                                  Response apiV1AppProductsDeleteDelete = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageDeleteproductfromstorageDelete(
                                      storageId: dataBundleNotifier.getCurrentStorage().storageId!.toInt(),
                                      productId: getListProdFiltered(dataBundleNotifier.getCurrentStorage().products!, _filter)[index]!.productId!.toInt());

                                  if(apiV1AppProductsDeleteDelete.isSuccessful){
                                    setState(() {
                                      dataBundleNotifier.getCurrentStorage().products!.removeWhere((element) => element.productId == getListProdFiltered(dataBundleNotifier.getCurrentStorage().products!, _filter)[index]!.productId!);
                                      _filter = '';
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('${product.productName} eliminato')));
                                  }else{
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text('Si è verificato un problema durante la cancellazione del prodotto. Err:'), backgroundColor: Colors.red,));
                                  }
                                },
                                background: Container(color: Colors.red),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: getProportionateScreenHeight(20))),

                                            ],
                                          ),
                                          Container(
                                            width: getProportionateScreenWidth(100),
                                              child: Card(
                                                  elevation: 1,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Column(
                                                      children: [
                                                        Text(product.stock!.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: getProportionateScreenHeight(20))),
                                                        Text(product.unitMeasure!, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: getProportionateScreenHeight(11))),
                                                      ],
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                      Divider(color: kCustomWhite, height: 2,)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
  buildListStorages(DataBundleNotifier dataBundleNotifier, context) {
    List<Widget> storagesWidgetList = [];

    for (var currentStorageElement in dataBundleNotifier.getCurrentBranch().storages!) {
      storagesWidgetList.add(
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: dataBundleNotifier.getCurrentStorage().name ==
                  currentStorageElement.name
                  ? kPrimaryColor
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
                      IconButton(icon: SvgPicture.asset('assets/icons/storage.svg', color: dataBundleNotifier.getCurrentStorage().name ==
                          currentStorageElement.name ? Colors.green : kPrimaryColor, width: getProportionateScreenWidth(25),), onPressed: () {  }, ),
                      Text(
                        '   ' + currentStorageElement!.name!,
                        style: TextStyle(
                            fontSize: dataBundleNotifier.getCurrentStorage().name ==
                                currentStorageElement.name
                                ? getProportionateScreenWidth(16)
                                : getProportionateScreenWidth(13),
                            color: dataBundleNotifier.getCurrentStorage().name ==
                                currentStorageElement.name
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          onTap: () {
            dataBundleNotifier.setStorage(currentStorageElement);
            Navigator.pop(context);
          },
        ),
      );
    }
    storagesWidgetList.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          width: MediaQuery.of(context).size.width,
          child: CupertinoButton(
            child: Text('Crea Magazzino'),
            color: kCustomGreen,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStorageScreen(
                    branch: dataBundleNotifier.getCurrentBranch(),
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
  void buildStorageChooserDialog(BuildContext context, DataBundleNotifier dataBundleNotifier) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (context) {
          return SizedBox(

            width: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0)),
                      color: kCustomWhite,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '   Lista Magazzini',

                          style: TextStyle(
                            fontSize:
                            getProportionateScreenWidth(17),
                            color: kPrimaryColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Column(
                      children: buildListStorages(
                          dataBundleNotifier, context),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }

  getListProdFiltered(List<RStorageProduct> list, String filter) {
    List<RStorageProduct> listFiltered = [];
    list.forEach((element) {
      if(element!.productName!.contains(filter)){
        listFiltered.add(element);
      }
    });
    return listFiltered;

  }
}
