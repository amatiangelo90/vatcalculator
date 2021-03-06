import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/deposit_order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/product_order_choice_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_product.dart';
import '../../../client/vatservice/model/utils/privileges.dart';
import '../../../components/light_colors.dart';
import '../../orders/components/unpaidmanager/order_unpaid_card.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

import '../../orders/components/unpaidmanager/unpaid_order_manager_screen.dart';
import '../suppliers_screen.dart';
import 'edit_product.dart';

class EditSuppliersScreen extends StatefulWidget {
  const EditSuppliersScreen({Key key, this.currentSupplier}) : super(key: key);

  final SupplierModel currentSupplier;
  static String routeName = 'editsupplier';

  @override
  State<EditSuppliersScreen> createState() => _EditSuppliersScreenState();
}

class _EditSuppliersScreenState extends State<EditSuppliersScreen> {

  bool isEditingEnabled = true;
  TextEditingController controllerSupplierName;
  TextEditingController controllerAddress;
  TextEditingController controllerMobileNo;
  TextEditingController controllerCity;
  TextEditingController controllerCap;
  TextEditingController controllerEmail;
  TextEditingController controllerPIva;

  @override
  Widget build(BuildContext context) {

    String whatsappUrl = 'https://api.whatsapp.com/send/?phone=${getRefactoredNumber(widget.currentSupplier.tel)}';

    final kPages = <Widget>[
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          controllerSupplierName = TextEditingController(text: widget.currentSupplier.nome);
          controllerAddress = TextEditingController(text: widget.currentSupplier.indirizzo_via);
          controllerMobileNo = TextEditingController(text: widget.currentSupplier.tel);
          controllerCity = TextEditingController(text: widget.currentSupplier.indirizzo_citta);
          controllerCap = TextEditingController(text: widget.currentSupplier.indirizzo_cap);
          controllerEmail = TextEditingController(text: widget.currentSupplier.mail);
          controllerPIva = TextEditingController(text: widget.currentSupplier.piva);
          return Scaffold(
            bottomSheet: dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? SizedBox(height: 0,) : Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                text: 'Crea Prodotto',
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(supplier: widget.currentSupplier,),),);
                },
                color: LightColors.kBlue,
              ),
            ),
            body: FutureBuilder(
              initialData: <Widget>[
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
              future: buildProductPage(dataBundleNotifier),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: snapshot.data,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
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


                  List<ProductModel> retrieveProductsBySupplier = await dataBundleNotifier
                      .getclientServiceInstance()
                      .retrieveProductsBySupplier(widget.currentSupplier);

                  retrieveProductsBySupplier.forEach((element) {
                    element.prezzo_lordo = 0.0;
                  });
                  dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                  dataBundleNotifier.clearOrdersDetailsObject();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoiceOrderProductScreen(
                        currentSupplier: widget.currentSupplier,
                      ),
                    ),
                  );
                },
                color: Colors.deepOrangeAccent.shade700.withOpacity(0.6),
              ),
            ),
            body: Center(child: const Text('Ordini')),
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
                        color: LightColors.kLavender,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlatButton(

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
                  buildUnpaidOrderScreen(dataBundleNotifier),
                ],
              ),
            ),
          );
        },
      ),
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: DefaultButton(
                      text: 'Modifica Fornitore',
                        color: Colors.orange.shade700.withOpacity(0.8),
                        press: () async {
                          if(controllerSupplierName.text == null || controllerSupplierName.text == ''){
                            print('Il nome del fornitore ?? obbligatorio');
                            buildShowErrorDialog('Il nome del fornitore ?? obbligatorio');
                          }else if(controllerEmail.text == null || controllerEmail.text == ''){
                            print('L\'indirizzo email ?? obbligatorio');
                            buildShowErrorDialog('L\'indirizzo email ?? obbligatorio');
                          }else if(controllerMobileNo.text == null || controllerMobileNo.text == ''){
                            print('Inserire un numero di cellulare');
                            buildShowErrorDialog('Inserire un numero di cellulare');
                          }else{
                            KeyboardUtil.hideKeyboard(context);
                            try{
                              SupplierModel supplier = SupplierModel(
                                pkSupplierId: widget.currentSupplier.pkSupplierId,
                                cf: '',
                                extra: widget.currentSupplier.extra,
                                fax: '',
                                id: widget.currentSupplier.id,
                                indirizzo_cap: controllerCap.text,
                                indirizzo_citta: controllerCity.text,
                                indirizzo_extra: '',
                                indirizzo_provincia: '',
                                indirizzo_via: controllerAddress.text,
                                mail: controllerEmail.text,
                                nome: controllerSupplierName.text,
                                paese: 'Italia',
                                pec: '',
                                piva: controllerPIva.text,
                                referente: '',
                                tel: controllerMobileNo.text,
                                fkBranchId: widget.currentSupplier.fkBranchId,
                              );

                              await dataBundleNotifier.getclientServiceInstance().performEditSupplier(
                                  anagraficaFornitore: supplier,
                                  actionModel: ActionModel(
                                      date: DateTime.now().millisecondsSinceEpoch,
                                      description: 'Ha aggiornato il fornitore ${supplier.nome}. Dettaglio ${supplier.toMap()}',
                                      fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                      user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                      type: ActionType.SUPPLIER_EDIT
                                  )
                              );
                              List<SupplierModel> _suppliersList = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);

                              dataBundleNotifier.addCurrentSuppliersList(_suppliersList);
                              dataBundleNotifier.clearAndUpdateMapBundle();
                              final snackBar =
                              SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.green,
                                  content: Text('Fornitore ' + controllerSupplierName.text +' aggiornato',
                                  )
                              );

                              clearControllers();
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              Navigator.pushNamed(context, SuppliersScreen.routeName);
                            }catch(e){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 5000),
                                  backgroundColor: Colors.red,
                                  content: Text('Impossibile creare fornitore. Riprova pi?? tardi. Errore: $e', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                            }
                          }

                        }),
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
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
                        restorationId: 'Nome Attivit??',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerSupplierName,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Nome Attivit??',
                      ),
                      Row(
                        children: const [
                          Text('Email*'),
                        ],
                      ),
                      CupertinoTextField(
                        textInputAction: TextInputAction.next,
                        restorationId: 'Email',
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Indirizzo',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerAddress,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Indirizzo',
                      ),
                      Row(
                        children: const [
                          Text('Citt??'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Citt??',
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerCity,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Citt??',
                      ),
                      Row(
                        children: const [
                          Text('Cap'),
                        ],
                      ),
                      CupertinoTextField(
                        enabled: dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cap',
                        keyboardType: TextInputType.number,
                        controller: controllerCap,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Cap',
                      ),
                      dataBundleNotifier.userDetailsList[0].id.toString() == widget.currentSupplier.id ?
                      const Text('*campo obbligatorio') : SizedBox(width: 0,),
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
                backgroundColor: kPrimaryColor,
                title: Text(
                  widget.currentSupplier.nome,
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
                        launch('tel://${getRefactoredNumber(widget.currentSupplier.tel)}')
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
                  dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? SizedBox(height: 0,) : IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/remove-icon.svg',
                        color: Colors.red,
                        height: getProportionateScreenHeight(26),
                      ),
                      onPressed: () async {
                        Widget cancelButton = TextButton(
                          child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
                          onPressed:  () {
                            Navigator.of(context).pop();
                          },
                        );

                        Widget continueButton = TextButton(
                          child: const Text("Elimina", style: TextStyle(color: kPinaColor)),
                          onPressed:  () async {
                            SupplierModel requestRemoveSupplierFromBranch = widget.currentSupplier;
                            requestRemoveSupplierFromBranch.fkBranchId = dataBundleNotifier.currentBranch.pkBranchId;
                            await dataBundleNotifier.getclientServiceInstance().removeSupplierFromCurrentBranch(
                                requestRemoveSupplierFromBranch: requestRemoveSupplierFromBranch,
                                actionModel: ActionModel(
                                    date: DateTime.now().millisecondsSinceEpoch,
                                    description: 'Ha rimosso il fornitore ${widget.currentSupplier.nome} dall\'attivit?? ${dataBundleNotifier.currentBranch.companyName}',
                                    fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                    user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  type: ActionType.SUPPLIER_DELETE
                                )
                            );
                            List<SupplierModel> _suppliersList = await dataBundleNotifier.getclientServiceInstance()
                                .retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                            dataBundleNotifier.addCurrentSuppliersList(_suppliersList);
                            dataBundleNotifier.clearAndUpdateMapBundle();
                            Navigator.pushNamed(context, SuppliersScreen.routeName);
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
                                              color: kPrimaryColor,
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
                                          Center(
                                            child: Text('Vuoi davvero eliminare il fornitore ' + widget.currentSupplier.nome + '?', textAlign: TextAlign.center,),
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

  Future buildProductPage(DataBundleNotifier dataBundleNotifier) async {
    List<Widget> list = [];

    if(dataBundleNotifier.currentProductModelListForSupplier.isEmpty){
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
            dataBundleNotifier.filterCurrentListProductByName(currentText);
          },
        ),
      ),
    );
    dataBundleNotifier.currentProductModelListForSupplierDuplicated.forEach((currentProduct) {
      list.add(GestureDetector(
        onTap: (){
          if(dataBundleNotifier.currentBranch.accessPrivilege != Privileges.EMPLOYEE){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: currentProduct,supplier: widget.currentSupplier,),),);
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
                   Text(currentProduct.nome, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(17), fontWeight: FontWeight.w800),),
                   Text(currentProduct.unita_misura, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.w800)),
                 ],
               ),
               dataBundleNotifier.currentBranch.accessPrivilege == Privileges.EMPLOYEE ? Text('??? ***') : Text('??? ' + currentProduct.prezzo_lordo.toString(), style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.w800)),
             ],
          ),
        ),
      ));
    });

    list.add(Column(

      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(' ---'),
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
      child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
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

  Widget buildUnpaidOrderScreen(DataBundleNotifier databundle) {
    List<Widget> list = [];
    databundle.retrievedOrderModelArchiviedNotPaid.forEach((unpaidOrder) {
      list.add(
          Row(
            children: [
              OrderUnpaidCard(
                supplierName: widget.currentSupplier.nome,
                code: unpaidOrder.code.toString(),
                total: unpaidOrder.total.toStringAsFixed(2),
                cardColor: kPrimaryColor,
                function: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UnpaidOrderManagerScreen(
                    supplierName: widget.currentSupplier.nome,
                    orderModel: unpaidOrder,
                  ),),);
                },
                orderStatus: unpaidOrder.status,
                paidPercent: calculatePercentagePaid(databundle.mapOrderIdDepositOrderList[unpaidOrder.pk_order_id], unpaidOrder.total),
                depositList: databundle.mapOrderIdDepositOrderList[unpaidOrder.pk_order_id],
                order: unpaidOrder,
                mapBundleUserStorageSupplier: databundle.currentMapBranchIdBundleSupplierStorageUsers
              ),
            ],
          ),
      );
    });

    return Column(
      children: list,
    );
  }

  double calculatePercentagePaid(List<DepositOrder> mapOrderIdDepositOrderList, double total) {
    if(total == 0.0 || total == null){
      return 0.0;
    }else{
      double totalPaid = 0.0;

      mapOrderIdDepositOrderList.forEach((element) {
        totalPaid = totalPaid + element.amount;
      });

      return totalPaid/total;
    }

  }
}