import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../components/light_colors.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = 'editproduct';
  const EditProductScreen({Key key, this.product, this.supplier, }) : super(key: key);

  final ProductModel product;
  final SupplierModel supplier;

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
      name: widget.product.nome,
      category: widget.product.categoria,
      descr: widget.product.descrizione,
      price: widget.product.prezzo_lordo,
      currentIva : widget.product.iva_applicata.toString(),
      unitMeasure: widget.product.unita_misura);
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
                  child: DefaultButton(color: LightColors.kGreen,
                    press: () async {
                      if(_nameController.text.isEmpty || _nameController.text == ''){
                        buildSnackBar(text: 'Inserire il nome del prodotto', color: LightColors.kRed);
                      }else if(_currentUnitMeasure == 'Seleziona unità di misura'){
                        buildSnackBar(text: 'Selezionare unità di misura valida', color: LightColors.kRed);
                      }else if(_currentUnitMeasure == 'Altro' && (_unitMeasureController.text == '' || _unitMeasureController.text.isEmpty)){
                        buildSnackBar(text: 'Specificare unità di misura', color: LightColors.kRed);
                      }else if(_priceController.text.isEmpty || _priceController.text == ''){
                        buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text, color: LightColors.kRed);
                      }else if(double.tryParse(_priceController.text.replaceAll(',', '.')) == null){
                        buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: LightColors.kRed);
                      } else{

                        ProductModel productModel = ProductModel(
                          pkProductId: widget.product.pkProductId,
                          nome: _nameController.text,
                          categoria: _categoryController.text,
                          codice: const Uuid().v1(),
                          descrizione: _descriptionController.text,
                          iva_applicata: int.parse(_currentIva),
                          prezzo_lordo: double.parse(_priceController.text.replaceAll(',', '.')),
                          unita_misura: _currentUnitMeasure == 'Altro' ? _unitMeasureController.text : _currentUnitMeasure,
                        );

                        ClientVatService vatService = ClientVatService();
                        Response performUpdateProduct = await vatService.performUpdateProduct(
                            product: productModel
                        );
                        if(performUpdateProduct != null && performUpdateProduct.statusCode == 200){
                          List<ProductModel> retrieveProductsBySupplier = await vatService.retrieveProductsBySupplier(widget.supplier);
                          dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                          buildSnackBar(text: 'Prodotto ' + productModel.nome + ' aggiornato correttamente', color: Colors.green.shade700);
                          Navigator.of(context).pop();
                        }else{
                          buildSnackBar(text: 'Si sono verificati problemi durante l\'aggiornamento del prodotto. Riprova più tardi.', color: kPinaColor);
                        }
                      }
                    },
                    text: 'Modifica',
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
                backgroundColor: kPrimaryColor,
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
                        ProductModel productModel = ProductModel(
                          pkProductId: widget.product.pkProductId,
                          nome: _nameController.text,
                          categoria: _categoryController.text,
                          codice: const Uuid().v1(),
                          descrizione: _descriptionController.text,
                          iva_applicata: int.parse(_currentIva),
                          prezzo_lordo: double.parse(_priceController.text),
                          unita_misura: _currentUnitMeasure == 'Altro' ? _unitMeasureController.text : _currentUnitMeasure,
                        );

                        print(productModel.toMap().toString());

                        ClientVatService vatService = ClientVatService();
                        Response perforDelteProduct = await vatService.performDeleteProduct(
                            product: productModel,
                            actionModel: ActionModel(
                                date: DateTime.now().millisecondsSinceEpoch,
                                description: 'Ha eliminato il prodotto ${productModel.nome} dal catalogo del fornitore ${widget.supplier.nome}',
                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                type: ActionType.PRODUCT_DELETE
                            )
                        );
                        if(perforDelteProduct != null && perforDelteProduct.statusCode == 200){
                          List<ProductModel> retrieveProductsBySupplier = await vatService.retrieveProductsBySupplier(widget.supplier);
                          dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                          buildSnackBar(text: 'Prodotto eliminato correttamente', color: Colors.green.shade700);
                          Navigator.of(context).pop();
                        }else{
                          buildSnackBar(text: 'Si sono verificati problemi durante l\'aggiornamento del prodotto. Riprova più tardi.', color: LightColors.kRed);
                        }
                      },
                      icon: SvgPicture.asset('assets/icons/Trash.svg', color: LightColors.kRed, height: getProportionateScreenHeight(29)),
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
                                              _currentUnitMeasure = 'Kg';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(FontAwesomeIcons.box, color: kPrimaryColor),
                                          title: Text('Pezzi', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Pezzi';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(FontAwesomeIcons.boxes, color: kPrimaryColor),
                                          title: Text('Cartoni', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Cartoni';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(FontAwesomeIcons.wineBottle, color: kPrimaryColor),
                                          title: const Text('Bottiglia', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Bottiglia';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading:const Icon(Icons.one_x_mobiledata, size: 30, color: kPrimaryColor),
                                          title: const Text('Unita', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
                                          onTap: () {
                                            setState(() {
                                              _currentUnitMeasure = 'Unita';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(FontAwesomeIcons.adn, color: kPrimaryColor),
                                          title: Text('Altro', style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor)),
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
                            Text('', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                            Text(_currentUnitMeasure, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                            Icon(Icons.keyboard_arrow_down_sharp, color: kPrimaryColor,)
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
                        Text('   Prezzo Lordo', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                                              _currentIva = '4';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Text('5%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
                                          title: Text(''),
                                          onTap: () {
                                            setState(() {
                                              _currentIva = '5';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Text('10%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
                                          title: Text(''),
                                          onTap: () {
                                            setState(() {
                                              _currentIva = '10';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Text('22%',style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor, fontSize: getProportionateScreenHeight(22))),
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
                            Text('', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
                            Text(_currentIva, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700),),
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
                  ],
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

  void setInitialState({
    @required String currentIva,
    @required String name,
    @required double price,
    @required String unitMeasure,
    @required String category,
    @required String descr}) {

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
