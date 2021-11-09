import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_product.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

import 'edit_product.dart';

class EditSuppliersScreen extends StatefulWidget {
  const EditSuppliersScreen({Key key, this.currentSupplier}) : super(key: key);

  final ResponseAnagraficaFornitori currentSupplier;
  static String routeName = 'editsupplier';

  @override
  State<EditSuppliersScreen> createState() => _EditSuppliersScreenState();
}

class _EditSuppliersScreenState extends State<EditSuppliersScreen> {

  bool isEditingEnabled = true;

  @override
  Widget build(BuildContext context) {

    String whatsappUrl = 'https://api.whatsapp.com/send/?phone=${getRefactoredNumber(widget.currentSupplier.tel)}';

    TextEditingController controllerSupplierName = TextEditingController(text: widget.currentSupplier.nome);
    TextEditingController controllerAddress = TextEditingController(text: widget.currentSupplier.indirizzo_via);
    TextEditingController controllerMobileNo = TextEditingController(text: widget.currentSupplier.tel);
    TextEditingController controllerCity = TextEditingController(text: widget.currentSupplier.indirizzo_citta);
    TextEditingController controllerCap = TextEditingController(text: widget.currentSupplier.indirizzo_cap);
    TextEditingController controllerEmail = TextEditingController(text: widget.currentSupplier.mail);
    TextEditingController controllerPIva = TextEditingController(text: widget.currentSupplier.piva);

    final kPages = <Widget>[
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(15.0),
              child: DefaultButton(
                text: 'Crea Prodotto',
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(supplier: widget.currentSupplier,),),);
                },
                color: kPrimaryColor,
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
      const Center(child: Text('Ordini')),
      Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            bottomSheet: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                      color: kPrimaryColor,
                      child: const Text('Modifica Azienda'),
                      onPressed: () async {
                        if(controllerSupplierName.text == null || controllerSupplierName.text == ''){
                          print('Il nome del fornitore è obbligatorio');
                          CoolAlert.show(
                            onConfirmBtnTap: (){},
                            confirmBtnColor: kPinaColor,
                            backgroundColor: kPinaColor,
                            context: context,
                            title: 'Errore',
                            type: CoolAlertType.error,
                            text: 'Il nome del fornitore è obbligatorio',
                            autoCloseDuration: Duration(seconds: 2),
                            onCancelBtnTap: (){},
                          );

                        }else if(controllerEmail.text == null || controllerEmail.text == ''){
                          print('L\'indirizzo email è obbligatorio');
                          CoolAlert.show(
                              onConfirmBtnTap: (){},
                              backgroundColor: kPinaColor,
                              context: context,
                              title: 'Errore',
                              type: CoolAlertType.error,
                              text: 'L\'indirizzo email è obbligatorio',
                              autoCloseDuration: Duration(seconds: 3),
                              onCancelBtnTap: (){}
                          );
                        }else if(controllerMobileNo.text == null || controllerMobileNo.text == ''){
                          print('Cellulare obbligatorio');
                          CoolAlert.show(
                              onConfirmBtnTap: (){},
                              backgroundColor: kPinaColor,
                              context: context,
                              title: 'Errore',
                              type: CoolAlertType.error,
                              text: 'Inserire il numero di cellulare',
                              autoCloseDuration: Duration(seconds: 3),
                              onCancelBtnTap: (){}
                          );
                        }else{
                          KeyboardUtil.hideKeyboard(context);
                          try{
                            //updateProviderData(dataBundleNotifier, context);
                          }catch(e){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 5000),
                                backgroundColor: Colors.red,
                                content: Text('Impossibile creare fornitore. Riprova più tardi. Errore: $e', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                          }
                        }

                      }),
                ),
              ],
            ) : const SizedBox(width: 0,),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                autovalidate: false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
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
                        enabled: dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ? true : false,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cap',
                        keyboardType: TextInputType.number,
                        controller: controllerCap,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: 'Cap',
                      ),
                      dataBundleNotifier.dataBundleList[0].id.toString() == widget.currentSupplier.id ?
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
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      widget.currentSupplier.nome,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        color: kCustomWhite,
                      ),
                    ),
                  ],
                ),
                elevation: 2,
                actions: [
                  IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () => {
                        launch('tel://${getRefactoredNumber(widget.currentSupplier.tel)}')
                      }
                  ),

                  IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () => {
                        launch(whatsappUrl)
                      }
                  ),
                ],
                bottom: TabBar(
                  tabs: kTab,
                  indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: kPinaColor),
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

    dataBundleNotifier.currentProductModelListForSupplier.forEach((currentProduct) {
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: currentProduct,supplier: widget.currentSupplier,),),);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(currentProduct.nome, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15)),),
                   Text(currentProduct.unita_misura, style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                 ],
               ),
               Text(currentProduct.prezzo_lordo.toString()),
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
    if(tel.contains('+39') || tel.contains('0039')){
      return tel;
    }
    return '+39' + tel;
  }
}