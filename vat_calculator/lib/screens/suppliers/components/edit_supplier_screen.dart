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
  const EditSuppliersScreen({Key? key, required this.currentSupplier}) : super(key: key);

  final Supplier currentSupplier;
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

    String whatsappUrl = 'https://api.whatsapp.com/send/?phone=${getRefactoredNumber(widget.currentSupplier.phoneNumber!)}';

    final kPages = <Widget>[
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          controllerSupplierName = TextEditingController(text: widget.currentSupplier.name!);
          controllerAddress = TextEditingController(text: widget.currentSupplier.address!);
          controllerMobileNo = TextEditingController(text: widget.currentSupplier.phoneNumber!);
          controllerCity = TextEditingController(text: widget.currentSupplier.city!);
          controllerCap = TextEditingController(text: widget.currentSupplier.cap!);
          controllerEmail = TextEditingController(text: widget.currentSupplier.email!);
          controllerPIva = TextEditingController(text: widget.currentSupplier.vatNumber!);
          return Scaffold(
            bottomSheet: dataBundleNotifier.getCurrentBranch().userPriviledge != BranchUserPriviledge.employee ? Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                text: 'Crea Prodotto',
                press: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      AddProductScreen(supplier: widget.currentSupplier),),);
                },
                color: kCustomGreen, textColor: Colors.white,
              ),
            ) : const SizedBox(height: 0,),
            body: Column(
              children:  buildProductPage(widget.currentSupplier.productList!, dataBundleNotifier),
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
                        currentSupplier: widget.currentSupplier,
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
        builder: (context, dataBundleNotifier, _){
          return Container(
            color: Color(0XD00A2227),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50.0,

                      decoration: BoxDecoration(
                        color: kLavender,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {

                        },
                        child: const Center(
                          child: Text(
                            'MOSTRA STORICO',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? Row(
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
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
                        enabled: dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cap',
                        keyboardType: TextInputType.number,
                        controller: controllerCap,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Cap',
                      ),
                      dataBundleNotifier.getUserEntity().userId == widget.currentSupplier.createdByUserId ?
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
      const Tab(child: Text('Catalogo'),),
      const Tab(child: Text('Ordini')),
      const Tab(child: Text('Fatture')),
      const Tab(child: Text('Dettagli')),
    ];

    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return DefaultTabController(
            length: kTab.length,
            child: Scaffold(
                backgroundColor: kCustomWhite,
                appBar: AppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => {
                        Navigator.pop(context),
                      }
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: kCustomGrey,
                  title: Text(
                    widget.currentSupplier.name!,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: Colors.white,
                    ),
                  ),
                  elevation: 2,
                  actions: [
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/Phone.svg',
                          color: kCustomWhite,
                          height: getProportionateScreenHeight(23),
                        ),
                        onPressed: () => {
                          launch('tel://${getRefactoredNumber(widget.currentSupplier.phoneNumber!)}')
                        }
                    ),
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/ws.svg',
                          height: getProportionateScreenHeight(25),
                        ),
                        onPressed: () {
                          print(whatsappUrl);
                          launch(whatsappUrl);
                        }
                    ),
                    dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? SizedBox(height: 0,) : IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/remove-icon.svg',
                          color: Colors.red,
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
                              print('asdasdasdasd');

                              Response supplierDeleted = await dataBundleNotifier.getSwaggerClient().apiV1AppSuppliersDeleteDelete(
                                  supplier: Supplier(
                                      branchId: widget.currentSupplier.branchId!.toInt(),
                                      supplierId: widget.currentSupplier.supplierId!.toInt()
                                  )
                              );

                              if(supplierDeleted.isSuccessful){
                                dataBundleNotifier.refreshCurrentBranchData();
                                Navigator.pushNamed(context, SuppliersScreen.routeName);
                              }else{

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
                                                child: Text('Eliminare il fornitore ' + widget.currentSupplier.name! + '?', textAlign: TextAlign.center,),
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
                    indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: Colors.white),
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

  buildProductPage(List<Product> products, DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [];

    if(products!.isEmpty){
      list.add(Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato')),
        ],
      ),);
      return list;
    }

    list.add(
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
    );
    for (var currentProduct in products) {
      if(filter == '' || currentProduct.name!.contains(filter)){
        list.add(GestureDetector(
          onTap: (){
            if(dataBundleNotifier.getCurrentBranch().userPriviledge != BranchUserPriviledge.employee){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(
                  product: currentProduct
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: Text(currentProduct.name!, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.w800),)),
                    Text(productUnitMeasureToJson(currentProduct.unitMeasure).toString(), style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenWidth(10), fontWeight: FontWeight.w800)),
                  ],
                ),
                dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? Text('€ ***') : Text('€ ' + currentProduct.price.toString(), style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ));
      }
    }

    list.add(Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(' --- '),
        ),
        SizedBox(height: 80,),

      ],
    ));
    return list;
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