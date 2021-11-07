import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/components/default_button.dart';
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



    String whatsappUrl = 'https://api.whatsapp.com/send/?phone=${widget.currentSupplier.tel}';
    TextEditingController nameController = TextEditingController(text: widget.currentSupplier.nome);
    TextEditingController addressController = TextEditingController(text: widget.currentSupplier.indirizzo_via);
    TextEditingController numberController = TextEditingController(text: widget.currentSupplier.tel);
    TextEditingController addressCityController = TextEditingController(text: widget.currentSupplier.indirizzo_citta);
    TextEditingController addressCapController = TextEditingController(text: widget.currentSupplier.indirizzo_cap);
    TextEditingController emailController = TextEditingController(text: widget.currentSupplier.mail);

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
      Center(child: const Text('Ordini')),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            isEditingEnabled ? Row(
              children: const [
                SizedBox(width: 10,),
                Text('Nome'),
              ],
            ) : const SizedBox(width: 0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
              child: CupertinoTextField(
                enabled: isEditingEnabled,
                controller: nameController,
                textInputAction: TextInputAction.next,
                restorationId: 'Nome',
                keyboardType: TextInputType.text,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
              ),
            ),
            isEditingEnabled ? Row(
              children: const [
                SizedBox(width: 10,),
                Text('Email'),
              ],
            ) : const SizedBox(width: 0,),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
              child: CupertinoTextField(
                enabled: isEditingEnabled,
                controller: emailController,
                textInputAction: TextInputAction.next,
                restorationId: 'Email',
                keyboardType: TextInputType.text,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
              ),
            ),
            isEditingEnabled ? Row(
              children: const [
                SizedBox(width: 10,),
                Text('Cellulare'),
              ],
            ) : const SizedBox(width: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 0,),
                const Text('+39', style: TextStyle(color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 33,
                    child: SizedBox(
                      width:  MediaQuery.of(context).size.width *0.9,
                      height: MediaQuery.of(context).size.height *0.05,
                      child: CupertinoTextField(
                        enabled: isEditingEnabled,
                        controller: numberController,
                        textInputAction: TextInputAction.next,
                        restorationId: 'Cell.',
                        keyboardType: TextInputType.number,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isEditingEnabled ? Row(
              children: const [
                SizedBox(width: 10,),
                Text('Via'),
              ],
            ) : const SizedBox(width: 0,),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
              child: SizedBox(
                width:  MediaQuery.of(context).size.width *0.9,
                height: MediaQuery.of(context).size.height *0.05,
                child: CupertinoTextField(
                  enabled: isEditingEnabled,
                  controller: addressController,
                  textInputAction: TextInputAction.next,
                  restorationId: 'Via',
                  keyboardType: TextInputType.text,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                ),
              ),
            ),
            isEditingEnabled ? Row(
              children: const [
                SizedBox(width: 10,),
                Text('Città'),
              ],
            ) : const SizedBox(width: 0,),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
              child: SizedBox(
                width:  MediaQuery.of(context).size.width *0.9,
                height: MediaQuery.of(context).size.height *0.05,
                child: CupertinoTextField(
                  enabled: isEditingEnabled,
                  controller: addressCityController,
                  textInputAction: TextInputAction.next,
                  restorationId: 'Città',
                  keyboardType: TextInputType.text,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                ),
              ),
            ),
            isEditingEnabled ? Row(
              children: const [
                SizedBox(width: 10,),
                Text('CAP'),
              ],
            ) : const SizedBox(width: 0,),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
              child: SizedBox(
                width:  MediaQuery.of(context).size.width *0.9,
                height: MediaQuery.of(context).size.height *0.05,
                child: CupertinoTextField(
                  enabled: isEditingEnabled,
                  controller: addressCapController,
                  textInputAction: TextInputAction.next,
                  restorationId: 'CAP',
                  keyboardType: TextInputType.text,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autocorrect: false,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 3,
                    child: const DefaultButton(
                      color: kWinterGreen,
                      text: 'Aggiorna',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 3,
                    child: const DefaultButton(
                      color: kPinaColor,
                      text: 'Cancella',
                    ),
                  ),
                ],
              ),
            ),
          ],

        ),
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
                        launch('tel://${widget.currentSupplier.tel}')
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
}