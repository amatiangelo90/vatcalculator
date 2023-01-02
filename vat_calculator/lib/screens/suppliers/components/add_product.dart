import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';
import 'package:chopper/chopper.dart';

class AddProductScreen extends StatefulWidget {
  static String routeName = 'addproduct';
  const AddProductScreen({Key? key, required this.supplier}) : super(key: key);

  final Supplier supplier;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  late TextEditingController _nameController;
  late TextEditingController _unitMeasureController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _unitMeasureController = TextEditingController();
    _priceController = TextEditingController();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

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
              iconTheme: const IconThemeData(color: kCustomGrey),
              backgroundColor: kCustomWhite,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Crea nuovo prodotto',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(19),
                      color: kCustomGrey,
                    ),
                  ),
                ],
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const SizedBox(width: 11,),
                      Text('   Nome', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                      Text('   Unità di Misura', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                                        title: Text(ProductUnitMeasure.kg.name, style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                        onTap: () {
                                          setState(() {
                                            currentUnitMeasure = ProductUnitMeasure.kg.name;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(FontAwesomeIcons.box, color: kCustomGrey),
                                        title: Text(ProductUnitMeasure.pezzi.name, style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                        onTap: () {
                                          setState(() {
                                            currentUnitMeasure = ProductUnitMeasure.pezzi.name;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(FontAwesomeIcons.boxes, color: kCustomGrey),
                                        title: Text(ProductUnitMeasure.cartoni.name, style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                        onTap: () {
                                          setState(() {
                                            currentUnitMeasure = ProductUnitMeasure.cartoni.name;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(FontAwesomeIcons.wineBottle, color: kCustomGrey),
                                        title: Text(ProductUnitMeasure.bottiglia.name, style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                        onTap: () {
                                          setState(() {
                                            currentUnitMeasure = ProductUnitMeasure.bottiglia.name;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading:const Icon(Icons.one_x_mobiledata, size: 30, color: kCustomGrey),
                                        title: Text(ProductUnitMeasure.unita.name, style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                        onTap: () {
                                          setState(() {
                                            currentUnitMeasure = ProductUnitMeasure.unita.name;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(FontAwesomeIcons.adn, color: kCustomGrey),
                                        title: Text(ProductUnitMeasure.altro.name, style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                        onTap: () {
                                          setState(() {
                                            currentUnitMeasure = ProductUnitMeasure.altro.name;
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
                  currentUnitMeasure == ProductUnitMeasure.altro.name ? Padding(
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
                      Text('   Prezzo Lordo', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
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
                  const SizedBox(height: 20,),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(color: kCustomGreen,
                press: () async {
                  if(_nameController.text.isEmpty || _nameController.text == ''){
                    buildSnackBar(text: 'Inserire il nome del prodotto', color: kRed);
                  }else if(_priceController.text.isEmpty || _priceController.text == ''){
                    buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text, color: kRed);
                  }else if(currentUnitMeasure == 'Seleziona unità di misura'){
                    buildSnackBar(text: 'Selezionare unità di misura valida', color: kRed);
                  }else if(currentUnitMeasure == ProductUnitMeasure.altro.name && (_unitMeasureController.text == '' || _unitMeasureController.text.isEmpty)){
                    buildSnackBar(text: 'Specificare unità di misura', color: kRed);
                  }else if(double.tryParse(_priceController.text.replaceAll(',', '.')) == null){
                    buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kRed);
                  }else if(currentIva == 'Seleziona aliquota applicata'){
                    buildSnackBar(text: 'Selezionare un valore per Aliquota', color: kRed);
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
                          supplierId: widget.supplier.supplierId!.toInt(),
                        )
                    );

                    if(apiV1AppProductsSavePost.isSuccessful){
                      buildSnackBar(text: 'Prodotto creato correttamente', color: Colors.green);
                      dataBundleNotifier.addSavedProductToSupplierList(apiV1AppProductsSavePost.body, widget.supplier.supplierId!.toInt());
                      Navigator.of(context).pop();
                    }else{
                      buildSnackBar(text: 'Errore durante la creazione del prodotto. Err: ' + apiV1AppProductsSavePost.error.toString(), color: kRed);
                    }
                  }
                },
                text: 'Crea ' + _nameController.text, textColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void buildSnackBar({@required String? text, @required Color? color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text!, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }
}
