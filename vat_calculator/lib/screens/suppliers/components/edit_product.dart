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

class EditProductScreen extends StatefulWidget {
  static String routeName = 'editproduct';
  const EditProductScreen({Key key, this.product, this.supplier, }) : super(key: key);

  final ProductModel product;
  final SupplierModel supplier;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  bool _selectedValue4 = false;
  bool _selectedValue5 = false;
  bool _selectedValue10 = false;
  bool _selectedValue22 = false;

  bool _litresUnitMeasure = false;
  bool _kgUnitMeasure = false;
  bool _packagesUnitMeasure = false;
  bool _otherUnitMeasure = false;

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
      vat4: widget.product.iva_applicata == 4 ? true : false,
      vat5: widget.product.iva_applicata == 5 ? true : false,
      vat10: widget.product.iva_applicata == 10 ? true : false,
      vat22: widget.product.iva_applicata == 22 ? true : false,
      kg: widget.product.unita_misura == 'kg' ? true : false,
      litres: widget.product.unita_misura == 'bottiglia' ? true : false,
      pack: widget.product.unita_misura == 'package' ? true : false,
      other: widget.product.unita_misura != 'package' && widget.product.unita_misura != 'kg' && widget.product.unita_misura != 'bottiglia' ? true : false,
      unitMeasure: widget.product.unita_misura);
  }

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
                    'Modifica prodotto',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              elevation: 2,
              actions: [
              ],
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
                                color: _litresUnitMeasure ? kCustomGreenAccent : Colors.white,
                                border: Border.all(
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                              ),
                              child: Center(child: Text('bottiglia', style: TextStyle(color: _litresUnitMeasure ? Colors.white : kPrimaryColor),)),
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
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                                color: _kgUnitMeasure ? kCustomGreenAccent : Colors.white,
                              ),
                              child: Center(child: Text('kg', style: TextStyle(color: _kgUnitMeasure ? Colors.white : kPrimaryColor))),
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
                                color: _packagesUnitMeasure ? kCustomGreenAccent : Colors.white,
                                border: Border.all(
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Center(child: Text('Pacchi', style: TextStyle(color:_packagesUnitMeasure ? Colors.white : kPrimaryColor))),
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
                                // _unitMeasureController.clear();
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height *0.05,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                                color: _otherUnitMeasure ? kCustomGreenAccent : Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                              ),
                              child: Center(child: Text('Altro', style: TextStyle(color:_otherUnitMeasure ? Colors.white : kPrimaryColor),)),
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
                                color: _selectedValue4 ? kCustomGreenAccent : Colors.white,
                                border: Border.all(
                                  width: 0.2,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                              ),
                              child: Center(child: Text('4%', style: TextStyle(color: _selectedValue4 ? Colors.white : kPrimaryColor),)),
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
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                                color: _selectedValue5 ? kCustomGreenAccent : Colors.white,
                              ),
                              child: Center(child: Text('5%', style: TextStyle(color:_selectedValue5 ? Colors.white : kPrimaryColor))),
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
                                color: _selectedValue10 ? kCustomGreenAccent : Colors.white,
                                border: Border.all(
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Center(child: Text('10%', style: TextStyle(color:_selectedValue10 ? Colors.white : kPrimaryColor))),
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
                                  width: 0.1,
                                  color: Colors.grey,
                                ),
                                color: _selectedValue22 ? kCustomGreenAccent : Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: const Radius.circular(3)),
                              ),
                              child: Center(child: Text('22%', style: TextStyle(color:_selectedValue22 ? Colors.white : kPrimaryColor),)),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 4, 30, 0),
                    child: DefaultButton(color: Colors.green.shade700,
                      press: () async {
                        if(_nameController.text.isEmpty || _nameController.text == ''){
                          buildSnackBar(text: 'Inserire il nome del prodotto', color: kPinaColor);
                        }else if(!_litresUnitMeasure && !_otherUnitMeasure && !_kgUnitMeasure && !_packagesUnitMeasure){
                          buildSnackBar(text: 'Unità di misura del prodotto obbligatoria', color: kPinaColor);
                        } else if(_otherUnitMeasure && (_unitMeasureController.text.isEmpty || _unitMeasureController.text == '')){
                          buildSnackBar(text: 'Specificare unità di misura', color: kPinaColor);
                        }else if(_priceController.text.isEmpty || _priceController.text == ''){
                          buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text);
                        }else if(double.tryParse(_priceController.text.replaceAll(',', '.')) == null){
                          buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kPinaColor);
                        } else{

                          ProductModel productModel = ProductModel(
                            pkProductId: widget.product.pkProductId,
                            nome: _nameController.text,
                            categoria: _categoryController.text,
                            codice: const Uuid().v1(),
                            descrizione: _descriptionController.text,
                            iva_applicata: _selectedValue4 ? 4 : _selectedValue5 ? 5 : _selectedValue10 ? 10 : _selectedValue22 ? 22 : 0,
                            prezzo_lordo: double.parse(_priceController.text.replaceAll(',', '.')),
                            unita_misura: _litresUnitMeasure ? 'bottiglia' : _kgUnitMeasure ? 'kg' : _packagesUnitMeasure ? 'pacchi' : _otherUnitMeasure ? _unitMeasureController.text : '',
                          );

                          print(productModel.toMap().toString());

                          ClientVatService vatService = ClientVatService();
                          Response performUpdateProduct = await vatService.performUpdateProduct(
                              product: productModel
                          );
                          if(performUpdateProduct != null && performUpdateProduct.statusCode == 200){
                            List<ProductModel> retrieveProductsBySupplier = await vatService.retrieveProductsBySupplier(widget.supplier);
                            dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                            //EasyLoading.dismiss();
                            buildSnackBar(text: 'Prodotto ' + productModel.nome + ' aggiornato correttamente', color: Colors.green.shade700);
                            Navigator.of(context).pop();
                          }else{
                            //EasyLoading.dismiss();
                            buildSnackBar(text: 'Si sono verificati problemi durante l\'aggiornamento del prodotto. Riprova più tardi.', color: kPinaColor);
                          }
                        }
                      },
                      text: 'Modifica',
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 4, 30, 0),
                    child: DefaultButton(color: kPinaColor,
                      press: () async {
                        //EasyLoading.show();
                        ProductModel productModel = ProductModel(
                          pkProductId: widget.product.pkProductId,
                          nome: _nameController.text,
                          categoria: _categoryController.text,
                          codice: const Uuid().v1(),
                          descrizione: _descriptionController.text,
                          iva_applicata: _selectedValue4 ? 4 : _selectedValue5 ? 5 : _selectedValue10 ? 10 : _selectedValue22 ? 22 : 0,
                          prezzo_lordo: double.parse(_priceController.text),
                          unita_misura: _litresUnitMeasure ? 'bottiglia' : _kgUnitMeasure ? 'kg' : _packagesUnitMeasure ? 'pacchi' : _otherUnitMeasure ? _unitMeasureController.text : '',
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
                          //EasyLoading.dismiss();
                          buildSnackBar(text: 'Prodotto eliminato correttamente', color: Colors.green.shade700);
                          Navigator.of(context).pop();
                        }else{
                          //EasyLoading.dismiss();
                          buildSnackBar(text: 'Si sono verificati problemi durante l\'aggiornamento del prodotto. Riprova più tardi.', color: kPinaColor);
                        }
                      },
                      text: 'Elimina',
                    ),
                  ),
                ],
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
    @required bool vat4,
    @required bool vat5,
    @required bool vat10,
    @required bool vat22,
    @required bool litres,
    @required bool kg,
    @required bool pack,
    @required bool other,
    @required String name,
    @required double price,
    @required String unitMeasure,
    @required String category,
    @required String descr}) {
    setState((){
      _selectedValue4 = vat4;
      _selectedValue5 = vat5;
      _selectedValue10 = vat10;
      _selectedValue22 = vat22;

      _litresUnitMeasure = litres;
      _kgUnitMeasure = kg;
      _packagesUnitMeasure = pack;
      _otherUnitMeasure = other;

      _nameController.text = name;
      _unitMeasureController.text = unitMeasure;
      _priceController.text = price.toString();
      _categoryController.text = category;
      _descriptionController.text = descr;
    });
  }
}
