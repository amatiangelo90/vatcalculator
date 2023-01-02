import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../models/databundlenotifier.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';
import '../../suppliers/components/add_suppliers/add_supplier_choice.dart';

class CreateAndAddProductScreen extends StatefulWidget {
  const CreateAndAddProductScreen({Key? key}) : super(key: key);

  static String routeName = 'createandaddproductscreen';
  @override
  State<CreateAndAddProductScreen> createState() => _CreateAndAddProductScreenState();
}

class _CreateAndAddProductScreenState extends State<CreateAndAddProductScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _unitMeasureController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String currentUnitMeasure = 'Seleziona unità di misura';
  String currentIva = 'Seleziona aliquota applicata';

  String _selectedSupplierName = 'Seleziona Fornitore';
  Supplier _supplierSelected = Supplier(supplierId: 0);


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(

            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: getProportionateScreenWidth(500),
                height:  getProportionateScreenWidth(50),
                child: OutlinedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                    side: MaterialStateProperty.resolveWith((states) => const BorderSide(width: 0.5, color: kCustomGreen),),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  onPressed: () async {
                    if(_nameController.text.isEmpty || _nameController.text == ''){
                      buildSnackBar(text: 'Inserire il nome del prodotto', color: kRed);
                    }else if(_priceController.text.isEmpty || _priceController.text == ''){
                      buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text, color: kRed);
                    }else if(double.tryParse(_priceController.text.replaceAll(",", ".")) == null){
                      buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kRed);
                    }else if(currentUnitMeasure == 'Seleziona unità di misura'){
                      buildSnackBar(text: 'Selezionare unità di misura valida', color: kRed);
                    }else if(currentUnitMeasure == 'Altro' && (_unitMeasureController.text == '' || _unitMeasureController.text.isEmpty)){
                      buildSnackBar(text: 'Specificare unità di misura', color: kRed);
                    }else if(currentIva == 'Seleziona aliquota applicata'){
                      buildSnackBar(text: 'Selezionare un valore per Aliquota', color: kRed);
                    }else if(_selectedSupplierName == 'Seleziona Fornitore' && _supplierSelected.supplierId == 0){
                      buildSnackBar(text: 'Selezionare un fornitore a cui associare il prodotto da creare', color: kRed);
                    } else{
                      Response apiV1AppProductsSavePost = await dataBundleNotifier.getSwaggerClient().apiV1AppProductsSavePost(
                          product: Product(
                            name: _nameController.text,
                            category: _categoryController.text,
                            code: const Uuid().v1(),
                            description: _descriptionController.text,
                            vatApplied: int.parse(currentIva),
                            price: double.parse(_priceController.text.replaceAll(',', '.')),
                            unitMeasureOTH: _unitMeasureController.text,
                            unitMeasure: productUnitMeasureFromJson(currentUnitMeasure),
                            supplierId: _supplierSelected.supplierId!.toInt(),
                          )
                      );

                      if(apiV1AppProductsSavePost.isSuccessful){
                        buildSnackBar(text: 'Prodotto creato correttamente', color: Colors.green);
                        Product prodResponse = apiV1AppProductsSavePost.body;

                        Response apiV1AppStorageInsertproductGet = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageInsertproductGet(
                            storageId: dataBundleNotifier.getCurrentStorage().storageId!.toInt(),
                            productId: prodResponse.productId!.toInt());

                        if(apiV1AppStorageInsertproductGet.isSuccessful){
                          buildSnackBar(text: 'Prodotto aggiunto correttamente ', color: kCustomGreen);
                          dataBundleNotifier.refreshCurrentBranchData();
                          Navigator.of(context).pop();
                        }else{
                          buildSnackBar(text: 'Errore durante la creazione del prodotto. Err: ' + apiV1AppProductsSavePost.error.toString(), color: kRed);
                        }
                      }else{
                        buildSnackBar(text: 'Errore durante la creazione del prodotto. Err: ' + apiV1AppProductsSavePost.error.toString(), color: kRed);
                      }
                    }
                  }, child: Text('Crea prodotto', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(17)),),
                ),
              ),
            ),

            appBar: AppBar(
              backgroundColor: kCustomGrey,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dataBundleNotifier.getCurrentStorage()!.name!, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(17)),),
                  Text('Crea ed aggiungi prodotti al magazzino',  style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(10)),),
                ],
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  dataBundleNotifier.getCurrentBranch().suppliers!.isEmpty ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Text('Non hai ancora configurato nessun fornitore'),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.6,
                          child: DefaultButton(
                            text: "Crea Fornitore",
                            press: () async {
                              Navigator.pushNamed(context, SupplierChoiceCreationEnjoy.routeName);
                            }, textColor: kCustomGrey,color: kCustomBordeaux,
                          ),
                        ),
                      ],
                    ),
                  ) :
                  buildWidgetRowForProduct(dataBundleNotifier),
                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void buildSnackBar({required String text, required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2500),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

  void clearAll() {
    setState((){
      currentIva = 'Seleziona aliquota applicata';
      currentUnitMeasure = 'Seleziona unità di misura';
      _nameController.clear();
      _unitMeasureController.clear();
      _priceController.clear();
      _categoryController.clear();
      _descriptionController.clear();
    });
  }

  void setCurrentSupplier(Supplier supplier) {
    setState(() {
      _selectedSupplierName = supplier.name!;
      _supplierSelected = supplier;
    });
  }

  buildWidgetRowForProduct(DataBundleNotifier dataBundleNotifier) {

    List<Widget> listWidget = [];

    listWidget.add(Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Center(
            child: DropdownWithSearch(
              title: 'Seleziona Fornitore',
              placeHolder: 'Ricerca Fornitore',
              disabled: false,
              items: dataBundleNotifier.getCurrentBranch().suppliers!.map((Supplier supplier) {
                return supplier.name;
              }).toList(),
              selected: _selectedSupplierName,
              onChanged: (String supplier) {
                setCurrentSupplier(dataBundleNotifier.getCurrentBranch().suppliers!.where((element) => element.name == supplier).first);
              }, label: '',
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Nome', style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            child: CupertinoTextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Unità di Misura', style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            width: MediaQuery.of(context).size.width - 7,
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white),),
                onPressed: (){
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder( // <-- SEE HERE
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(FontAwesomeIcons.weightHanging, color: kCustomGrey),
                              title: Text('Kg', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                              onTap: () {
                                setState(() {
                                  currentUnitMeasure = 'Kg';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(FontAwesomeIcons.boxOpen, color: kCustomGrey),
                              title: Text('Cartoni', style: const TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                              onTap: () {
                                setState(() {
                                  currentUnitMeasure = 'Cartoni';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.wineBottle, color: kCustomGrey),
                              title: Text('Bottiglia', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                              onTap: () {
                                setState(() {
                                  currentUnitMeasure = 'Bottiglia';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.one_x_mobiledata, size: 30, color: kCustomGrey),
                              title: Text('Unita', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                              onTap: () {
                                setState(() {
                                  currentUnitMeasure = 'Unita';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.adn, color: kCustomGrey),
                              title: Text('Altro', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                              onTap: () {
                                setState(() {
                                  currentUnitMeasure = 'Altro';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: 30,)
                          ],
                        );
                      });

                }, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w700),),
                Text(currentUnitMeasure, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w700),),
                Icon(Icons.keyboard_arrow_down_sharp, color: kCustomGrey,)
              ],
            )),
          ),
        ),
        currentUnitMeasure == 'Altro' ? Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            child: CupertinoTextField(
              controller: _unitMeasureController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
            ),
          ),
        ) : const SizedBox(width: 0,),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Prezzo Lordo', style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            child: CupertinoTextField(
              onEditingComplete: (){
                FocusScope.of(context).unfocus;
              },
              controller: _priceController,
              textInputAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Iva Applicata', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            width: MediaQuery.of(context).size.width - 7,
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white),),
                onPressed: (){
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Text('4%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                              title: Text(''),
                              onTap: () {
                                setState(() {
                                  currentIva = '4';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Text('5%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                              title: Text(''),
                              onTap: () {
                                setState(() {
                                  currentIva = '5';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Text('10%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                              title: Text(''),
                              onTap: () {
                                setState(() {
                                  currentIva = '10';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Text('22%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                              title: Text(''),
                              onTap: () {
                                setState(() {
                                  currentIva = '22';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: 30,)
                          ],
                        );
                      });

                }, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w700),),
                Text(currentIva, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w700),),
                Icon(Icons.keyboard_arrow_down_sharp, color: kCustomGrey,)
              ],
            )),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Categoria', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            child: CupertinoTextField(
              controller: _categoryController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Descrizione', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.05,
            child: CupertinoTextField(
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
            ),
          ),
        ),
        SizedBox(height: 20,),
      ],
    ),
    );

    listWidget.add(const Divider(color: Colors.grey, endIndent: 40, indent: 40, height: 60,));
    return Column(children: listWidget,);
  }
}
