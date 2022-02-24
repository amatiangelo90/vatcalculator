import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class AddProductScreen extends StatefulWidget {
  static String routeName = 'addproduct';
  const AddProductScreen({Key key, this.supplier}) : super(key: key);

  final ResponseAnagraficaFornitori supplier;


  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  bool _selectedValue4 = false;
  bool _selectedValue5 = false;
  bool _selectedValue10 = false;
  bool _selectedValue22 = false;

  bool _litresUnitMeasure = false;
  bool _kgUnitMeasure = false;
  bool _packagesUnitMeasure = false;
  bool _otherUnitMeasure = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _unitMeasureController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          backgroundColor: kCustomWhite,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => {
                  Navigator.of(context).pop(),
                }
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Crea nuovo prodotto',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                    color: kCustomWhite,
                  ),
                ),
              ],
            ),
            elevation: 2,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Nome', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                    Text('   Unità di Misura', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _litresUnitMeasure = true;
                              _kgUnitMeasure = false;
                              _packagesUnitMeasure = false;
                              _otherUnitMeasure = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              color: _litresUnitMeasure ? kBeigeColor : Colors.white,
                              border: Border.all(
                                width: 0.2,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                            ),
                            child: Center(child: Text('litri', style: TextStyle(color: kPrimaryColor),)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _litresUnitMeasure = false;
                              _kgUnitMeasure = true;
                              _packagesUnitMeasure = false;
                              _otherUnitMeasure = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: kBeigeColor,
                              ),
                              color: _kgUnitMeasure ? kBeigeColor : Colors.white,
                            ),
                            child: const Center(child: Text('kg', style: TextStyle(color:kPrimaryColor))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _litresUnitMeasure = false;
                              _kgUnitMeasure = false;
                              _packagesUnitMeasure = true;
                              _otherUnitMeasure = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              color: _packagesUnitMeasure ? kBeigeColor : Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: kBeigeColor,
                              ),
                            ),
                            child: const Center(child: Text('Pacchi', style: TextStyle(color:kPrimaryColor))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _litresUnitMeasure = false;
                              _kgUnitMeasure = false;
                              _packagesUnitMeasure = false;
                              _otherUnitMeasure = true;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: kBeigeColor,
                              ),
                              color: _otherUnitMeasure ? kBeigeColor : Colors.white,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                            ),
                            child: Center(child: Text('Altro', style: const TextStyle(color:kPrimaryColor),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _otherUnitMeasure ? Padding(
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
                    Text('   Prezzo Lordo', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *0.05,
                    child: CupertinoTextField(
                      controller: _priceController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      autocorrect: false,
                    ),
                  ),
                ),

                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Iva Applicata', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedValue4 = true;
                              _selectedValue5 = false;
                              _selectedValue10 = false;
                              _selectedValue22 = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              color: _selectedValue4 ? kBeigeColor : Colors.white,
                              border: Border.all(
                                width: 0.2,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                            ),
                            child: Center(child: Text('4%', style: TextStyle(color: kPrimaryColor),)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedValue4 = false;
                              _selectedValue5 = true;
                              _selectedValue10 = false;
                              _selectedValue22 = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: kBeigeColor,
                              ),
                              color: _selectedValue5 ? kBeigeColor : Colors.white,
                            ),
                            child: Center(child: const Text('5%', style: TextStyle(color:kPrimaryColor))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedValue4 = false;
                              _selectedValue5 = false;
                              _selectedValue10 = true;
                              _selectedValue22 = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              color: _selectedValue10 ? kBeigeColor : Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: kBeigeColor,
                              ),
                            ),
                            child: Center(child: Text('10%', style: TextStyle(color:kPrimaryColor))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedValue4 = false;
                              _selectedValue5 = false;
                              _selectedValue10 = false;
                              _selectedValue22 = true;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.05,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: kBeigeColor,
                              ),
                              color: _selectedValue22 ? kBeigeColor : Colors.white,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                            ),
                            child: Center(child: Text('22%', style: TextStyle(color:kPrimaryColor),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 11,),
                    Text('   Categoria', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                    Text('   Descrizione', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                const SizedBox(height: 20,),
              ],
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: DefaultButton(color: Colors.green.shade700.withOpacity(0.8),
              press: () async {
                if(_nameController.text.isEmpty || _nameController.text == ''){
                  buildSnackBar(text: 'Inserire il nome del prodotto', color: kPinaColor);
                }else if(!_litresUnitMeasure && !_otherUnitMeasure && !_kgUnitMeasure && !_packagesUnitMeasure){
                  buildSnackBar(text: 'Unità di misura del prodotto obbligatoria', color: kPinaColor);
                } else if(_otherUnitMeasure && (_unitMeasureController.text.isEmpty || _unitMeasureController.text == '')){
                  buildSnackBar(text: 'Specificare unità di misura', color: kPinaColor);
                }else if(_priceController.text.isEmpty || _priceController.text == ''){
                  buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text);
                }else if(double.tryParse(_priceController.text) == null){
                  buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kPinaColor);
                } else{

                  //EasyLoading.show();
                  ProductModel productModel = ProductModel(
                      nome: _nameController.text,
                      categoria: _categoryController.text,
                      codice: const Uuid().v1(),
                      descrizione: _descriptionController.text,
                      iva_applicata: _selectedValue4 ? 4 : _selectedValue5 ? 5 : _selectedValue10 ? 10 : _selectedValue22 ? 22 : 0,
                      prezzo_lordo: double.parse(_priceController.text),
                      unita_misura: _litresUnitMeasure ? 'litri' : _kgUnitMeasure ? 'kg' : _packagesUnitMeasure ? 'pacchi' : _otherUnitMeasure ? _unitMeasureController.text : '',
                      fkSupplierId: widget.supplier.pkSupplierId
                  );

                  print(productModel.toMap().toString());

                  ClientVatService vatService = ClientVatService();
                  Response performSaveProduct = await vatService.performSaveProduct(
                      product: productModel,
                      actionModel: ActionModel(
                          date: DateTime.now().millisecondsSinceEpoch,
                          description: 'Ha aggiunto ${productModel.nome} al catalogo prodotti del fornitore ${dataBundleNotifier.getSupplierName(productModel.fkSupplierId)} ',
                          fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                          user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                          type: ActionType.PRODUCT_CREATION
                      )
                  );
                  sleep(const Duration(seconds: 1));


                  if(performSaveProduct != null && performSaveProduct.statusCode == 200){

                    List<ProductModel> retrieveProductsBySupplier = await vatService.retrieveProductsBySupplier(widget.supplier);
                    dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                    //EasyLoading.dismiss();
                    clearAll();
                    buildSnackBar(text: 'Prodotto ' + productModel.nome + ' salvato per fornitore ' + widget.supplier.nome, color: Colors.green.shade700);
                  }else{
                    //EasyLoading.dismiss();
                    buildSnackBar(text: 'Si sono verificati problemi durante il salvataggio. Risposta servizio: ' + performSaveProduct.toString(), color: kPinaColor);
                  }

                }
              },
              text: 'Crea ' + _nameController.text,
            ),
          ),
        );
      },
    );
  }

  void buildSnackBar({@required String text, @required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

  void setInitialState(bool vat4,
      bool vat5,
      bool vat10,
      bool vat22,
      bool litres,
      bool kg,
      bool pack,
      bool other,
      String name,
      double price,
      String category,
      String descr) {
    setState((){
      _selectedValue4 = false;
      _selectedValue5 = false;
      _selectedValue10 = false;
      _selectedValue22 = false;

      _litresUnitMeasure = false;
      _kgUnitMeasure = false;
      _packagesUnitMeasure = false;
      _otherUnitMeasure = false;

      _nameController.clear();
      _unitMeasureController.clear();
      _priceController.clear();
      _categoryController.clear();
      _descriptionController.clear();
    });
  }

  void clearAll() {
    setState((){
      _selectedValue4 = false;
      _selectedValue5 = false;
      _selectedValue10 = false;
      _selectedValue22 = false;

      _litresUnitMeasure = false;
      _kgUnitMeasure = false;
      _packagesUnitMeasure = false;
      _otherUnitMeasure = false;

      _nameController.clear();
      _unitMeasureController.clear();
      _priceController.clear();
      _categoryController.clear();
      _descriptionController.clear();
    });
  }
}
