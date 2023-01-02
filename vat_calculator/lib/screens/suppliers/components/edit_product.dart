import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = 'editproduct';
  const EditProductScreen({Key? key,required this.product}) : super(key: key);

  final Product product;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  String _currentIva = '0';
  String _currentUnitMeasure = 'Seleziona unità di misura';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitMeasureController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  @override
  void initState() {

    setInitialState(
      name: widget.product.name!,
      category: widget.product.category!,
      descr: widget.product.description!,
      price: widget.product.price!,
      currentIva : widget.product.vatApplied!.toString(),
      unitMeasure: widget.product.unitMeasure!.name);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(

              backgroundColor: kCustomWhite,
              bottomSheet: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 4, 15, 20),
                  child: DefaultButton(color: kCustomGreen,
                    press: () async {
                      if(_nameController.text.isEmpty || _nameController.text == ''){
                        buildSnackBar(text: 'Inserire il nome del prodotto', color: kRed);
                      }else if(_currentUnitMeasure == 'Seleziona unità di misura'){
                        buildSnackBar(text: 'Selezionare unità di misura valida', color: kRed);
                      }else if(_currentUnitMeasure == 'Altro' && (_unitMeasureController.text == '' || _unitMeasureController.text.isEmpty)){
                        buildSnackBar(text: 'Specificare unità di misura', color: kRed);
                      }else if(_priceController.text.isEmpty || _priceController.text == ''){
                        buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text, color: kRed);
                      }else if(double.tryParse(_priceController.text.replaceAll(',', '.')) == null){
                        buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kRed);
                      } else{

                        Response updateProdRespo = await dataBundleNotifier.getSwaggerClient().apiV1AppProductsUpdatePut(
                          product: Product(
                            productId: widget.product.productId!.toInt(),
                            name: _nameController.text,
                            category: _categoryController.text,
                            code: widget.product.code,
                            description: _descriptionController.text,
                            vatApplied: int.parse(_currentIva),
                            price: double.parse(_priceController.text.replaceAll(',', '.')),
                            unitMeasureOTH: _currentUnitMeasure == 'Altro' ? _currentUnitMeasure : '',
                            unitMeasure: _currentUnitMeasure == 'Altro' ? ProductUnitMeasure.altro : productUnitMeasureFromJson(_currentUnitMeasure!),
                          )
                        );


                        if(updateProdRespo.isSuccessful){
                          print('Prodotto aggiornato!');
                          buildSnackBar(text: 'Prodotto aggiornato.', color: kCustomGreen);
                        }else{
                          buildSnackBar(text: 'Errore durante l\'aggiornamento del prodotto. Err: ' + updateProdRespo.error!.toString(), color: kRed);
                        }


                      }
                    },
                    text: 'Modifica', textColor: Colors.white,
                  ),
                ),
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      Navigator.of(context).pop(),
                    }
                ),

                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: kCustomGrey,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      'Modifica prodotto',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        color: Colors.white,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ],
                ),
                elevation: 2,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: IconButton(
                      onPressed: () async {

             //          if(perforDelteProduct != null && perforDelteProduct.statusCode == 200){
             //            List<ProductModel> retrieveProductsBySupplier = await vatService.retrieveProductsBySupplier(widget.supplier);
             //            dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
             //            buildSnackBar(text: 'Prodotto eliminato correttamente', color: Colors.green.shade700);
             //            Navigator.of(context).pop();
             //          }else{
             //            buildSnackBar(text: 'Si sono verificati problemi durante l\'aggiornamento del prodotto. Riprova più tardi.', color: LightColors.kRed);
             //          }
                      },
                      icon: SvgPicture.asset('assets/icons/Trash.svg', color: kRed, height: getProportionateScreenHeight(29)),
                    ),
                  ),
                ],
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
                                          title: Text('Kg', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Kg';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(FontAwesomeIcons.box, color: kCustomGrey),
                                          title: Text('Pezzi', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Pezzi';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(FontAwesomeIcons.boxes, color: kCustomGrey),
                                          title: Text('Cartoni', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Cartoni';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(FontAwesomeIcons.wineBottle, color: kCustomGrey),
                                          title: const Text('Bottiglia', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Bottiglia';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading:const Icon(Icons.one_x_mobiledata, size: 30, color: kCustomGrey),
                                          title: const Text('Unita', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Unita';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(FontAwesomeIcons.adn, color: kCustomGrey),
                                          title: Text('Altro', style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Altro';
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
                            Text(_currentUnitMeasure, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w700),),
                            Icon(Icons.keyboard_arrow_down_sharp, color: kCustomGrey,)
                          ],
                        )),
                      ),
                    ),
                    _currentUnitMeasure == 'Altro' ? Padding(
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
                    ),Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *0.05,
                        child: CupertinoTextField(
                          controller: _priceController,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                                              _currentIva = '4';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Text('5%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                                          title: Text(''),
                                          onTap: () {
                                            setState(() {
                                              _currentIva = '5';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Text('10%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                                          title: Text(''),
                                          onTap: () {
                                            setState(() {
                                              _currentIva = '10';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Text('22%',style: TextStyle(fontWeight: FontWeight.w800, color: kCustomGrey, fontSize: getProportionateScreenHeight(22))),
                                          title: Text(''),
                                          onTap: () {
                                            setState(() {
                                              _currentIva = '22';
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
                            Text(_currentIva, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w700),),
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
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

  void setInitialState({
    required String currentIva,
    required String name,
    required double price,
    required String unitMeasure,
    required String category,
    required String descr}) {

    setState((){

      if(['Kg', 'Pezzi', 'Cartoni', 'Bottiglia', 'Unita'].contains(unitMeasure)){
        _currentUnitMeasure = unitMeasure;
      }else{
        _currentUnitMeasure = 'Altro';
        _unitMeasureController.text = unitMeasure;
      }
      _currentUnitMeasure = unitMeasure;
      _currentIva = currentIva;
      _nameController.text = name;

      _priceController.text = price.toString();
      _categoryController.text = category;
      _descriptionController.text = descr;
    });
  }
}
