import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/light_colors.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class AddProductScreen extends StatefulWidget {
  static String routeName = 'addproduct';
  const AddProductScreen({Key key, this.supplier}) : super(key: key);

  final SupplierModel supplier;


  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _unitMeasureController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String currentUnitMeasure = 'Seleziona unità di misura';
  String currentIva = 'Seleziona aliquota applicata';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
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
                      fontSize: getProportionateScreenWidth(19),
                      color: Colors.white,
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
                      Text('   Nome', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                      Text('   Unità di Misura', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                                      leading: Icon(FontAwesomeIcons.weightHanging, color: kPrimaryColor),
                                      title: Text('Kg', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                      onTap: () {
                                        setState(() {
                                          currentUnitMeasure = 'Kg';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(FontAwesomeIcons.box, color: kPrimaryColor),
                                      title: Text('Pezzi', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                      onTap: () {
                                        setState(() {
                                          currentUnitMeasure = 'Pezzi';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(FontAwesomeIcons.boxes, color: kPrimaryColor),
                                      title: Text('Cartoni', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                      onTap: () {
                                        setState(() {
                                          currentUnitMeasure = 'Cartoni';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(FontAwesomeIcons.wineBottle, color: kPrimaryColor),
                                      title: const Text('Bottiglia', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                      onTap: () {
                                        setState(() {
                                          currentUnitMeasure = 'Bottiglia';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading:const Icon(Icons.one_x_mobiledata, size: 30, color: kPrimaryColor),
                                      title: const Text('Unità', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                      onTap: () {
                                        setState(() {
                                          currentUnitMeasure = 'Unità';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(FontAwesomeIcons.adn, color: kPrimaryColor),
                                      title: Text('Altro', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
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
                          Text('', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                          Text(currentUnitMeasure, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                          Icon(Icons.keyboard_arrow_down_sharp, color: kPrimaryColor,)
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
                      Text('   Prezzo Lordo', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                        clearButtonMode: OverlayVisibilityMode.editing,
                        autocorrect: false,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      const SizedBox(width: 11,),
                      Text('   Iva Applicata', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                                        leading: Text('4%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
                                        title: Text(''),
                                        onTap: () {
                                          setState(() {
                                            currentIva = '4';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Text('5%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
                                        title: Text(''),
                                        onTap: () {
                                          setState(() {
                                            currentIva = '5';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Text('10%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
                                        title: Text(''),
                                        onTap: () {
                                          setState(() {
                                            currentIva = '10';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Text('22%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
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
                          Text('', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                          Text(currentIva, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                          Icon(Icons.keyboard_arrow_down_sharp, color: kPrimaryColor,)
                        ],
                      )),
                    ),
                  ),

                  Row(
                    children: [
                      const SizedBox(width: 11,),
                      Text('   Categoria', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                      Text('   Descrizione', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(color: LightColors.kBlue,
                press: () async {
                  if(_nameController.text.isEmpty || _nameController.text == ''){
                    buildSnackBar(text: 'Inserire il nome del prodotto', color: LightColors.kRed);
                  }else if(_priceController.text.isEmpty || _priceController.text == ''){
                    buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text, color: LightColors.kRed);
                  }else if(currentUnitMeasure == 'Seleziona unità di misura'){
                    buildSnackBar(text: 'Selezionare unità di misura valida', color: LightColors.kRed);
                  }else if(currentUnitMeasure == 'Altro' && (_unitMeasureController.text == '' || _unitMeasureController.text.isEmpty)){
                    buildSnackBar(text: 'Specificare unità di misura', color: LightColors.kRed);
                  }else if(double.tryParse(_priceController.text.replaceAll(',', '.')) == null){
                    buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: LightColors.kRed);
                  }else if(currentIva == 'Seleziona aliquota applicata'){
                    buildSnackBar(text: 'Selezionare un valore per Aliquota', color: LightColors.kRed);
                  } else{

                    //EasyLoading.show();
                    ProductModel productModel = ProductModel(
                        nome: _nameController.text,
                        categoria: _categoryController.text,
                        codice: const Uuid().v1(),
                        descrizione: _descriptionController.text,
                        iva_applicata: int.parse(currentIva),
                        prezzo_lordo: double.parse(_priceController.text.replaceAll(',', '.')),
                        unita_misura: currentUnitMeasure == 'Altro' ? _unitMeasureController.text : currentUnitMeasure,
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
      currentIva = 'Seleziona aliquota applicata';
      currentUnitMeasure = 'Seleziona unità di misura';
      _nameController.clear();
      _unitMeasureController.clear();
      _priceController.clear();
      _categoryController.clear();
      _descriptionController.clear();
    });
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
}
