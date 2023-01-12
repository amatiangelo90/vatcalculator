import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/product_order_choice_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_product.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import '../suppliers_screen.dart';
import 'edit_product.dart';

class EditSuppliersScreen extends StatefulWidget {
  const EditSuppliersScreen({Key? key}) : super(key: key);

  static String routeName = 'editsupplier';

  @override
  State<EditSuppliersScreen> createState() => _EditSuppliersScreenState();
}

class _EditSuppliersScreenState extends State<EditSuppliersScreen> {

  bool isEditingEnabled = true;
  String filter = '';
  late TextEditingController controllerSupplierName;
  late TextEditingController controllerAddress;
  late TextEditingController controllerMobileNo;
  late TextEditingController controllerCity;
  late TextEditingController controllerCap;
  late TextEditingController controllerEmail;
  late TextEditingController controllerPIva;

  @override
  Widget build(BuildContext context) {



    final kPages = <Widget>[
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          controllerSupplierName = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().name!);
          controllerAddress = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().address!);
          controllerMobileNo = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().phoneNumber!);
          controllerCity = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().city!);
          controllerCap = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().cap!);
          controllerEmail = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().email!);
          controllerPIva = TextEditingController(text: dataBundleNotifier.getCurrentSupplier().vatNumber!);

          return Scaffold(
            bottomSheet: dataBundleNotifier.getCurrentBranch().userPriviledge != BranchUserPriviledge.employee ? Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                text: 'Crea Prodotto',
                press: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      AddProductScreen(supplier: dataBundleNotifier.getCurrentSupplier()),),);
                },
                color: kCustomGreen, textColor: Colors.white,
              ),
            ) : const SizedBox(height: 0,),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: CupertinoTextField(
                      textInputAction: TextInputAction.next,
                      restorationId: 'Ricerca prodotto',
                      keyboardType: TextInputType.text,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      placeholder: 'Ricerca prodotto',
                      onChanged: (currentText) {
                        setState((){
                          filter = currentText;
                        });
                      },
                    ),
                  ),
                  buildProductPage(dataBundleNotifier.getCurrentSupplier().productList!, dataBundleNotifier),
                ],
              ),
            ),
          );
        },
      ),
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, _){
          return Scaffold(
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                text: 'Crea Ordine',
                press: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoiceOrderProductScreen(
                        currentSupplier: dataBundleNotifier.getCurrentSupplier(),
                      ),
                    ),
                  );
                },
                color: kCustomGreen, textColor: Colors.white,
              ),
            ),
            body: const Center(child: Text('Ordini')),
          );
        },
      ),
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: DefaultButton(
                      text: 'Modifica Fornitore',
                      color: kCustomGreen,
                      press: () async {
                        if(controllerSupplierName.text == null || controllerSupplierName.text == ''){
                          print('Il nome del fornitore è obbligatorio');
                          buildShowErrorDialog('Il nome del fornitore è obbligatorio');
                        }else if(controllerEmail.text == null || controllerEmail.text == ''){
                          print('L\'indirizzo email è obbligatorio');
                          buildShowErrorDialog('L\'indirizzo email è obbligatorio');
                        }else if(controllerMobileNo.text == null || controllerMobileNo.text == ''){
                          print('Inserire un numero di cellulare');
                          buildShowErrorDialog('Inserire un numero di cellulare');
                        }else{
                          KeyboardUtil.hideKeyboard(context);
                          try{


                            final snackBar =
                            SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kCustomGreen,
                                content: Text('Fornitore ' + controllerSupplierName.text +' aggiornato',
                                )
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pushNamed(context, SuppliersScreen.routeName);
                          }catch(e){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 5000),
                                backgroundColor: Colors.red,
                                content: Text('Impossibile creare fornitore. Riprova più tardi. Errore: $e', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                          }
                        }

                      }, textColor: Colors.white,),
                  ),
                ),
              ],
            ) : const SizedBox(width: 0,),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Dettagli Fornitore'),
                      ),
                      Row(
                        children: const [
                          Text('Nome*'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        restorationId: 'Nome Attività',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerSupplierName,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Nome Attività',
                      ),
                      Row(
                        children: const [
                          Text('Email*'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Email',
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Email',
                      ),
                      Row(
                        children: const [
                          Text('Cellulare*'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cellulare',
                        keyboardType: TextInputType.number,
                        controller: controllerMobileNo,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Cellulare',
                      ),
                      Row(
                        children: const [
                          Text('Partita Iva'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Partita Iva',
                        keyboardType: TextInputType.number,
                        controller: controllerPIva,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Partita Iva',
                      ),
                      Row(
                        children: const [
                          Text('Indirizzo'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Indirizzo',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerAddress,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Indirizzo',
                      ),
                      Row(
                        children: const [
                          Text('Città'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Città',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerCity,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Città',
                      ),
                      Row(
                        children: const [
                          Text('Cap'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cap',
                        keyboardType: TextInputType.number,
                        controller: controllerCap,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Cap',
                      ),
                      dataBundleNotifier.getUserEntity().userId == dataBundleNotifier.getCurrentSupplier().createdByUserId ?
                      const Text('*campo obbligatorio') : const SizedBox(width: 0,),
                      SizedBox(height: getProportionateScreenHeight(50),),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ];

    final kTab = <Tab>[
      const Tab(child: Text('Catalogo', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold),),),
      const Tab(child: Text('Ordini', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold),)),
      const Tab(child: Text('Dettagli', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold),)),
    ];

    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return DefaultTabController(
            length: kTab.length,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => {
                        Navigator.pop(context),
                      }
                  ),
                  iconTheme: const IconThemeData(color: kCustomGrey),
                  backgroundColor: Colors.white,
                  title: Text(
                    dataBundleNotifier.getCurrentSupplier().name!,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: kCustomGrey,
                    ),
                  ),
                  elevation: 0,
                  actions: [
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/Phone.svg',
                          color: kCustomGrey,
                          height: getProportionateScreenHeight(23),
                        ),
                        onPressed: () => {
                          launch('tel://${getRefactoredNumber(dataBundleNotifier.getCurrentSupplier().phoneNumber!)}')
                        }
                    ),
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/ws.svg',
                          height: getProportionateScreenHeight(25),
                        ),
                        onPressed: () {
                          String whatsappUrl = 'https://api.whatsapp.com/send/?phone=${getRefactoredNumber(dataBundleNotifier.getCurrentSupplier().phoneNumber!)}';
                          print(whatsappUrl);
                          launch(whatsappUrl);
                        }
                    ),
                    dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const SizedBox(height: 0,) : IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/remove-icon.svg',
                          color: kCustomBordeaux,
                          height: getProportionateScreenHeight(26),
                        ),
                        onPressed: () async {
                          Widget cancelButton = TextButton(
                            child: const Text("Indietro", style: TextStyle(color: kCustomGrey),),
                            onPressed:  () {
                              Navigator.of(context).pop();
                            },
                          );

                          Widget continueButton = TextButton(
                            child: const Text("Elimina", style: TextStyle(color: kPinaColor)),
                            onPressed:  () async {


                              print('Delete supplier : ' + dataBundleNotifier.getCurrentSupplier().toString());

                              Response deleteSupplier = await dataBundleNotifier.getSwaggerClient()
                                  .apiV1AppSuppliersDeleteDelete(supplierId: dataBundleNotifier.getCurrentSupplier().supplierId!.toInt(),
                                  branchId: dataBundleNotifier.getCurrentSupplier().branchId!.toInt());

                              if(deleteSupplier.isSuccessful){
                                dataBundleNotifier.removeSupplierFromCurrentBranch(dataBundleNotifier.getCurrentSupplier().supplierId!);
                                Navigator.pushNamed(context, SuppliersScreen.routeName);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kCustomGreen,
                                    content: Text('Fornitore eliminato con successo')));
                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: kCustomBordeaux,
                                    content: Text('Ho riscontrato un problema durante l\'eliminazione del fornitore. Riprova fra 2 minuti o contatta l\'amministratore del sistema')));
                              }

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
                                                color: kCustomGrey,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('  Elimina Fornitore?',
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
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text('Eliminare il fornitore ' + dataBundleNotifier.getCurrentSupplier().name! + '?', textAlign: TextAlign.center,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                          );


                        }
                    ),
                    SizedBox(width: 5,),
                  ],
                  bottom: TabBar(
                    tabs: kTab,
                    indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: kCustomGrey),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: kPages,
                )
            ),
          );
        });
  }

  updateisEditingEnabled() {
    setState(() {
      if(isEditingEnabled){
        isEditingEnabled = false;
      }else{
        isEditingEnabled = true;
      }
    });
  }

  buildProductPage(List<Product> products,
      DataBundleNotifier dataBundleNotifier) {



    return SizedBox(
      height: products!.where((element) => element.name!.toLowerCase().contains(filter.toLowerCase()))!.length! * getProportionateScreenHeight(100),
      child: ListView.builder(
        itemCount: products!.where((element) => element.name!.toLowerCase().contains(filter.toLowerCase()))!.length,
        itemBuilder: (context, index) {
          Product prod = products!.where((element) => element.name!.toLowerCase().contains(filter.toLowerCase()))!.toList()[index];
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
            key: Key(prod.productId!.toString()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Conferma operazione"),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Sei sicuro di voler eliminare il prodotto"
                          " ${prod.name}?"),
                    ),
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
            resizeDuration: const Duration(seconds: 1),
            onDismissed: (direction) async {
              print('Delete product with id: ' + prod.productId!.toString());
              try {
                Response responseDeleteProd = await dataBundleNotifier.getSwaggerClient().apiV1AppProductsDeleteDelete(product: prod);

                if(responseDeleteProd.isSuccessful){
                  dataBundleNotifier.removeProductFromCurrentSupplier(prod.productId!.toInt());
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration:
                          const Duration(milliseconds: 1000),
                          backgroundColor: kCustomGreen,
                          content: Text(
                            'Prodotto ${prod.name} eliminato!',
                            style: const TextStyle(color: Colors.white),
                          )));

                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration:
                          const Duration(milliseconds: 1000),
                          backgroundColor: kCustomGreen,
                          content: Text(
                            'Ho riscontrato problemi durante l\'eliminazione del prodotto ${prod.name}. Err: ' + responseDeleteProd.error.toString(),
                            style: const TextStyle(color: Colors.white),
                          )));

                }



              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        duration:
                        const Duration(milliseconds: 3000),
                        backgroundColor: kCustomBordeaux,
                        content: Text(
                          'Ho riscontrato problemi durante l\'operazione. Err: ' + e.toString(),
                          style: TextStyle(color: Colors.white),
                        )));
              }
            },
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    EditProductScreen(product: prod),),);
              },
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: getProportionateScreenWidth(170),
                              child: Text(prod.name!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(18)))),
                          Text(prod.unitMeasure! == ProductUnitMeasure.altro ? prod.unitMeasureOTH! : productUnitMeasureToJson(prod.unitMeasure!).toString(), style: TextStyle(fontWeight: FontWeight.w500, color: kCustomGrey, fontSize: getProportionateScreenHeight(16))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? '*** €' : prod.price!.toStringAsFixed(2).replaceAll('.00', '') + ' €', style: TextStyle(fontWeight: FontWeight.w500, color: kCustomGrey, fontSize: getProportionateScreenHeight(18))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  getRefactoredNumber(String tel) {
    if(tel.contains('+39')){
      return tel.replaceAll('+39', '');
    }else if(tel.contains('0039')){
      return tel.replaceAll('0039', '');
    }else{
      return tel;
    }
  }
  void buildShowErrorDialog(String text) {
    Widget cancelButton = TextButton(
      child: const Text("Indietro", style: TextStyle(color: kCustomGrey),),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actions: [
            cancelButton
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
                height: getProportionateScreenHeight(150),
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
                          color: kPinaColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  Errore ',style: TextStyle(
                                  fontSize: getProportionateScreenWidth(14),
                                  fontWeight: FontWeight.bold,
                                  color: kCustomWhite,
                                ),),
                                IconButton(icon: const Icon(
                                  Icons.clear,
                                  color: kCustomWhite,
                                ), onPressed: () { Navigator.pop(context); },),

                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text(text,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
    );
  }

  void clearControllers() {
    if(controllerSupplierName != null){
      controllerSupplierName.clear();
    }
    if(controllerAddress != null){
      controllerAddress.clear();
    }
    if(controllerMobileNo != null){
      controllerMobileNo.clear();
    }
    if(controllerCity != null){
      controllerCity.clear();
    }
    if(controllerCap != null){
      controllerCap.clear();
    }
    if(controllerEmail != null){
      controllerEmail.clear();
    }
    if(controllerPIva != null){
      controllerPIva.clear();
    }
  }
}