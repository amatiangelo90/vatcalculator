
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.enums.swagger.dart';
import 'components/add_storage_screen.dart';
import 'components/add_widget_element.dart';
import 'components/create_product_and_add_to_storage.dart';
import 'components/load_unload_screen.dart';
import 'components/order_from_storage_widget.dart';

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
              child: dataBundleNotifier.getCurrentBranch().storages!.isEmpty ? Text('') : getButtonBottonBar(dataBundleNotifier)
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: kCustomGrey),
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
                        color: kCustomGrey,
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
                color: kCustomGrey
            ),) : Column(
              children: [
                Text(
                  dataBundleNotifier.getCurrentStorage().name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(17),
                    color: kCustomGrey,
                  ),
                ),
                Text(
                  'Area gestione magazzini',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(11),
                    color: kCustomGrey,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: dataBundleNotifier.getCurrentBranch().storages!.isEmpty
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
                    color: kCustomGrey,
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
                  }, textColor: Colors.white, color: kCustomGreen,
                ),
              ),
            ],
          )
              : Consumer<DataBundleNotifier>(
              builder: (context, dataBundleNotifier, child) {
                return RefreshIndicator(
                  onRefresh: () {
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
                        SizedBox(
                          height: getProportionateScreenHeight(550),
                          child: ListView.builder(
                            itemCount: getListProdFiltered(dataBundleNotifier.getCurrentStorage().products!, _filter).length,
                            itemBuilder: (context, index) {
                              RStorageProduct product = getListProdFiltered(dataBundleNotifier.getCurrentStorage().products!, _filter)[index];
                              return Dismissible(
                                background: Container(
                                  color: kCustomBordeaux,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Icon(Icons.delete, color: Colors.white, size: getProportionateScreenHeight(40)),
                                      )
                                    ],
                                  ),
                                ),
                                key: Key(product.productId!.toString()),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Conferma operazione"),
                                        content: const Text("Sei sicuro di voler eliminare il prodotto?"),
                                        actions: <Widget>[
                                          OutlinedButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text("Elimina", style: TextStyle(color: kRed),)
                                          ),
                                          OutlinedButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("Indietro"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                resizeDuration: Duration(seconds: 1),
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
                                        .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 1),
                                        backgroundColor: kCustomGreen,
                                        content: Text('${product.productName} eliminato')));
                                  }else{
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text('Si è verificato un problema durante la cancellazione del prodotto. Err:'), backgroundColor: Colors.red,));
                                  }
                                },
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          TextEditingController controller = TextEditingController(text: product.amountHundred! > 0 ? product.amountHundred!.toString() : '');
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
                                                                color: kCustomGrey,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    '  Configura prodotto',
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
                                                            buildProductRow(product),
                                                            const Divider(color: Colors.grey),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                ' Q/100 è un valore che si riferisce alla quantità (del prodotto preso in considerazione) di cui si ha bisogno per servire 100 persone. Ex: 2 Litri Aperol per 100 persone',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                  getProportionateScreenWidth(8),
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? Text('') :
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  ' Q/100',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                    getProportionateScreenWidth(17),
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: ConstrainedBox(
                                                                    constraints: BoxConstraints.loose(Size(
                                                                        getProportionateScreenWidth(100),
                                                                        getProportionateScreenWidth(80))),
                                                                    child: CupertinoTextField(
                                                                      controller: controller,
                                                                      onChanged: (text) {

                                                                      },
                                                                      textInputAction: TextInputAction.next,
                                                                      style: TextStyle(
                                                                        color: kCustomGrey,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: getProportionateScreenHeight(22),
                                                                      ),
                                                                      keyboardType: const TextInputType.numberWithOptions(
                                                                          decimal: true, signed: false),
                                                                      clearButtonMode: OverlayVisibilityMode.never,
                                                                      textAlign: TextAlign.center,
                                                                      autocorrect: false,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SizedBox(
                                                                width: getProportionateScreenWidth(400),
                                                                height: getProportionateScreenHeight(55),
                                                                child: OutlinedButton(
                                                                  onPressed: () async {
                                                                    Navigator.of(context).pop(false);
                                                                    Response responseAmountHundredSave = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageAmounthundredSaveconfigurationPut(
                                                                        storageProductId: product.storageProductId!.toInt(),
                                                                        qHundredAmount: double.parse(controller.text));

                                                                    if(responseAmountHundredSave.isSuccessful){
                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        backgroundColor: kCustomGreen,
                                                                        duration: Duration(milliseconds: 1000),
                                                                        content: Text(
                                                                            'Operazione eseguita con successo'),
                                                                      ));
                                                                      dataBundleNotifier.refreshCurrentBranchDataWithStorageTrakingId(dataBundleNotifier.getCurrentStorage().storageId!.toInt());

                                                                    }else{
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                        backgroundColor: kCustomGreen,
                                                                        duration: Duration(milliseconds: 1000),
                                                                        content: Text(
                                                                            'Errore durante l\'operazione. Riprova fra due minuti. Err: ' + responseAmountHundredSave.error.toString()),
                                                                      ));
                                                                    }

                                                                  },
                                                                  style: ButtonStyle(
                                                                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                                                                    backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                                                                    side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                                                  ),
                                                                  child: Text('Salva configurazione Q/100', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 40),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                        },
                                        child: buildProductRow(product)
                                      ),
                                      const Divider(color: kCustomWhite, height: 4, endIndent: 80,),
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

  retrieveListSuppliersBis(List<Supplier> currentListSuppliers) {
    List<String> currentListNameSuppliers = [];
    currentListSuppliers.forEach((element) {
      currentListNameSuppliers.add(element.name!);
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
                  ? kCustomGrey
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
                          currentStorageElement.name ? Colors.green : kCustomGrey, width: getProportionateScreenWidth(25),), onPressed: () {  }, ),
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
                            color: kCustomGrey,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: kCustomGrey,
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

  getButtonBottonBar(DataBundleNotifier dataBundleNotifier) {
    return ButtonBar(

      alignment: MainAxisAlignment.spaceAround,
      children: [
        dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? Text('') : SizedBox(
          width: getProportionateScreenWidth(170),
          height: getProportionateScreenHeight(60),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pinkAccent.shade400,
            ),
            child: Text('CREA ED AGGIUNGI\nNUOVO PRODOTTO', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
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
            child: Text('AGGIUNGI PRODOTTI DA\nCATALOGO FORNITORI', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
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
                                    color: kCustomGrey,
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
              backgroundColor: kPinaColor,
            ),
            child: Text('EFFETTUA\nORDINE', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold),),
            onPressed: () {
              dataBundleNotifier.clearAmountOrderFromCurrentStorageProductList();
              Navigator.pushNamed(context, OrderFromStorageWidget.routeName);
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
            child: Text('SPOSTA PRODOTTI\nIN ALTRO MAGAZZINO', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold),),
            onPressed: () {
              //Navigator.pushNamed(context, MoveProductToStorageScreen.routeName);
            },
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(170),
          height: getProportionateScreenHeight(60),

          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kCustomGreen,
              ),
              child: Text('EFFETTUA\nCARICO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
              onPressed: (){
                dataBundleNotifier.clearAmountOrderFromCurrentStorageProductList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoadUnloadScreen(
                        isLoad: true,
                        isUnLoad: false
                    ),
                  ),
                );
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
              child: Text('EFFETTUA\nSCARICO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
              onPressed: (){
                dataBundleNotifier.clearAmountOrderFromCurrentStorageProductList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoadUnloadScreen(
                      isLoad: false,
                      isUnLoad: true
                    ),
                  ),
                );

              }
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(170),
          height: getProportionateScreenHeight(60),
          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text('SVUOTA\nMAGAZZINO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(12)), ),
              onPressed: () async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Conferma operazione"),
                      content: const Text("Impostare la giacenza a 0 per tutti i prodotti presenti in magazzino?"),
                      actions: <Widget>[
                        OutlinedButton(
                            onPressed: () async {
                              Response apiV1AppStorageEmptystoragePut = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageEmptystoragePut(storageId: dataBundleNotifier.getCurrentStorage().storageId!.toInt());
                              if(apiV1AppStorageEmptystoragePut.isSuccessful){
                                dataBundleNotifier.refreshCurrentBranchDataWithStorageTrakingId(dataBundleNotifier.getCurrentStorage().storageId!.toInt());
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kCustomGreen,
                                    content: Text('Magazzino svuotato correttamente')));
                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kRed,
                                    content: Text('Errore durante l\'operazione. Err: ' + apiV1AppStorageEmptystoragePut.error.toString())));
                              }
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Svuota magazzino", style: TextStyle(color: kRed),)
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  },
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
              child: Text('IMPOSTA GIACENZA 0\nI PRODOTTI IN NEGATIVO', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(11)), ),
              onPressed: () async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Conferma operazione"),
                      content: const Text("Impostare la giacenza a 0 per tutti i prodotti presenti che abbiano un valore in giacenza negativo?"),
                      actions: <Widget>[
                        OutlinedButton(
                            onPressed: () async {
                              Response apiV1AppStorageSetstockzerotonegativeproductsPut = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageSetstockzerotonegativeproductsPut(storageId: dataBundleNotifier.getCurrentStorage().storageId!.toInt());
                              if(apiV1AppStorageSetstockzerotonegativeproductsPut.isSuccessful){
                                dataBundleNotifier.refreshCurrentBranchDataWithStorageTrakingId(dataBundleNotifier.getCurrentStorage().storageId!.toInt());
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kCustomGreen,
                                    content: Text('Impostazione della giacenza a 0 per i prodotti con stock in negativo eseguita correttamente')));
                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kRed,
                                    content: Text('Errore durante l\'operazione. Err: ' + apiV1AppStorageSetstockzerotonegativeproductsPut.error.toString())));
                              }
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Imposta a 0", style: TextStyle(color: kCustomGreen),)
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  },
                );
              }),
        ),
      ],
    );
  }

  buildProductRow(RStorageProduct product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: getProportionateScreenWidth(200),
                child: Text(' ' + product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(18)))),
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
                      Text(product.stock!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.bold, color: product.stock! >= 0 ? kCustomGreen : kPinaColor, fontSize: getProportionateScreenHeight(20))),
                      Text(product.unitMeasure!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(15))),
                      Text('q/100: ' + product.amountHundred!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: getProportionateScreenHeight(8))),
                    ],
                  ),
                ))),
      ],
    );
  }
}
