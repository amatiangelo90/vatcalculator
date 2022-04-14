import 'dart:io';

import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../client/fattureICloud/model/response_fornitori.dart';
import '../../../client/vatservice/model/action_model.dart';
import '../../../client/vatservice/model/product_model.dart';
import '../../../client/vatservice/model/save_product_into_storage_request.dart';
import '../../../client/vatservice/model/utils/action_type.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../models/databundlenotifier.dart';
import '../../../size_config.dart';
import '../../suppliers/components/add_suppliers/add_supplier_choice.dart';

class CreateAndAddProductScreen extends StatefulWidget {
  const CreateAndAddProductScreen({Key key, @required this.callBackFunction}) : super(key: key);

  final Function callBackFunction;

  static String routeName = 'createandaddproductscreen';
  @override
  State<CreateAndAddProductScreen> createState() => _CreateAndAddProductScreenState();
}

class _CreateAndAddProductScreenState extends State<CreateAndAddProductScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitMeasureController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _selectedValue4 = false;
  bool _selectedValue5 = false;
  bool _selectedValue10 = false;
  bool _selectedValue22 = false;

  bool _bottlesUnitMeasure = false;
  bool _kgUnitMeasure = false;
  bool _packagesUnitMeasure = false;
  bool _otherUnitMeasure = false;

  String _selectedSupplier = 'Seleziona Fornitore';


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(

          bottomSheet: Container(
            color: kPrimaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(330),
                    child: CupertinoButton(
                      color: kCustomGreenAccent,
                      onPressed: () async {
                        if(_nameController.text.isEmpty || _nameController.text == ''){
                          buildSnackBar(text: 'Inserire il nome del prodotto', color: kPinaColor);
                        }else if(!_bottlesUnitMeasure && !_otherUnitMeasure && !_kgUnitMeasure && !_packagesUnitMeasure){
                          buildSnackBar(text: 'Unità di misura del prodotto obbligatoria', color: kPinaColor);
                        } else if(_otherUnitMeasure && (_unitMeasureController.text.isEmpty || _unitMeasureController.text == '')){
                          buildSnackBar(text: 'Specificare unità di misura', color: kPinaColor);
                        }else if(_priceController.text.isEmpty || _priceController.text == ''){
                          buildSnackBar(text: 'Immettere il prezzo per ' + _nameController.text);
                        }else if(double.tryParse(_priceController.text.replaceAll(",", ".")) == null){
                          buildSnackBar(text: 'Valore non valido per il prezzo. Immettere un numero corretto.', color: kPinaColor);
                        }else if(_selectedSupplier == 'Seleziona Fornitore'){
                          buildSnackBar(text: 'Selezionare un fornitore a cui associare il prodotto da creare', color: kPinaColor);
                        } else{

                          SupplierModel currentSupplierToSaveProduct = dataBundleNotifier.retrieveSupplierFromSupplierListByIdName(_selectedSupplier);
                          ProductModel productModel = ProductModel(
                              nome: _nameController.text,
                              categoria: '',
                              codice: const Uuid().v1(),
                              descrizione: '',
                              iva_applicata: _selectedValue4 ? 4 : _selectedValue5 ? 5 : _selectedValue10 ? 10 : _selectedValue22 ? 22 : 0,
                              prezzo_lordo: double.parse(_priceController.text.replaceAll(",", ".")),
                              unita_misura: _bottlesUnitMeasure ? 'bottiglia' : _kgUnitMeasure ? 'kg' : _packagesUnitMeasure ? 'pacchi' : _otherUnitMeasure ? _unitMeasureController.text : '',
                              fkSupplierId: currentSupplierToSaveProduct.pkSupplierId
                          );

                          print(productModel.toMap().toString());

                          Response performSaveProduct = await dataBundleNotifier.getclientServiceInstance().performSaveProduct(
                              product: productModel,
                              actionModel: ActionModel(
                                  date: DateTime.now().millisecondsSinceEpoch,
                                  description: 'Ha aggiunto ${productModel.nome} al catalogo prodotti del fornitore ${currentSupplierToSaveProduct.nome} ',
                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  type: ActionType.PRODUCT_CREATION
                              )
                          );
                          sleep(const Duration(milliseconds: 600));


                          if(performSaveProduct != null && performSaveProduct.statusCode == 200){
                            List<ProductModel> retrieveProductsBySupplier = await dataBundleNotifier.getclientServiceInstance().retrieveProductsBySupplier(currentSupplierToSaveProduct);
                            dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
                            clearAll();


                            dataBundleNotifier.getclientServiceInstance().performSaveProductIntoStorage(
                                saveProductToStorageRequest: SaveProductToStorageRequest(
                                    fkStorageId: dataBundleNotifier.currentStorage.pkStorageId,
                                    fkProductId: performSaveProduct.data,
                                    available: 'true',
                                    stock: 0,
                                    dateTimeCreation: DateTime.now().millisecondsSinceEpoch,
                                    dateTimeEdit: DateTime.now().millisecondsSinceEpoch,
                                    pkStorageProductCreationModelId: 0,
                                    user: dataBundleNotifier.userDetailsList[0].firstName
                                ),
                                actionModel: ActionModel(
                                    date: DateTime.now().millisecondsSinceEpoch,
                                    description: 'Ha aggiunto ${productModel.nome} al magazzino ${dataBundleNotifier.currentStorage.name}.',
                                    fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                    user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                    type: ActionType.ADD_PRODUCT_TO_STORAGE
                                )
                            );
                            dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                            buildSnackBar(text: 'Prodotto ' + productModel.nome + ' salvato per fornitore ' + currentSupplierToSaveProduct.nome + ' ed inserito nel magazzino ${dataBundleNotifier.currentStorage.name}', color: Colors.green.shade700);
                            dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                            widget.callBackFunction();
                          }else{
                            buildSnackBar(text: 'Si sono verificati problemi durante il salvataggio. Risposta servizio: ' + performSaveProduct.toString(), color: kPinaColor);
                          }

                        }
                      },
                      child: Text('Crea ' + _nameController.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                }),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Column(
              children: [
                Text(dataBundleNotifier.currentStorage.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(17)),),
                Text('  --  Crea ed aggiungi prodotti al magazzino  --  ', textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontSize: getProportionateScreenHeight(10)),),
              ],
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                dataBundleNotifier.currentListSuppliers.isEmpty ? Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text('Non hai ancora configurato nessun fornitore'),
                      SizedBox(height: 50),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.6,
                        child: DefaultButton(
                          text: "Crea Fornitore",
                          press: () async {
                            Navigator.pushNamed(context, SupplierChoiceCreationEnjoy.routeName);
                          },
                        ),
                      ),
                    ],
                  ),
                ) :
                buildWidgetRowForProduct(dataBundleNotifier),
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
        duration: const Duration(milliseconds: 2500),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

  void clearAll() {
    setState((){
      _selectedValue4 = false;
      _selectedValue5 = false;
      _selectedValue10 = false;
      _selectedValue22 = false;

      _bottlesUnitMeasure = false;
      _kgUnitMeasure = false;
      _packagesUnitMeasure = false;
      _otherUnitMeasure = false;

      _nameController.clear();
      _unitMeasureController.clear();
      _priceController.clear();
    });
  }

  void setCurrentSupplier(String supplier, DataBundleNotifier dataBundleNotifier) {
    setState(() {
      _selectedSupplier = supplier;
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
              items: dataBundleNotifier.currentListSuppliers.map((SupplierModel supplier) {
                return supplier.pkSupplierId.toString() + ' - ' + supplier.nome;
              }).toList(),
              selected: _selectedSupplier,
              onChanged: (storage) {
                setCurrentSupplier(storage, dataBundleNotifier);
              },
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 11,),
            Text('   Nome', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.04,
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
            Text('   Unità di Misura', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold)),
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
                      _bottlesUnitMeasure = true;
                      _kgUnitMeasure = false;
                      _packagesUnitMeasure = false;
                      _otherUnitMeasure = false;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.04,
                    decoration: BoxDecoration(
                      color: _bottlesUnitMeasure ? kCustomGreenAccent : Colors.white,
                      border: Border.all(
                        width: 0.2,
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                    ),
                    child: Center(child: Text('bottiglia', style: TextStyle(color: _bottlesUnitMeasure ? Colors.white : kPrimaryColor,),)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _bottlesUnitMeasure = false;
                      _kgUnitMeasure = true;
                      _packagesUnitMeasure = false;
                      _otherUnitMeasure = false;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.04,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.1,
                        color: kBeigeColor,
                      ),
                      color: _kgUnitMeasure ? kCustomGreenAccent : Colors.white,
                    ),
                    child: Center(child: Text('kg', style: TextStyle(color: _kgUnitMeasure ? Colors.white : kPrimaryColor,))),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _bottlesUnitMeasure = false;
                      _kgUnitMeasure = false;
                      _packagesUnitMeasure = true;
                      _otherUnitMeasure = false;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.04,
                    decoration: BoxDecoration(
                      color: _packagesUnitMeasure ? kCustomGreenAccent : Colors.white,
                      border: Border.all(
                        width: 0.1,
                        color: kBeigeColor,
                      ),
                    ),
                    child: Center(child: Text('Pacchi', style: TextStyle(color: _packagesUnitMeasure ? Colors.white : kPrimaryColor,))),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _bottlesUnitMeasure = false;
                      _kgUnitMeasure = false;
                      _packagesUnitMeasure = false;
                      _otherUnitMeasure = true;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.04,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.1,
                        color: kBeigeColor,
                      ),
                      color: _otherUnitMeasure ? kCustomGreenAccent : Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                    ),
                    child: Center(child: Text('Altro', style: TextStyle(color: _otherUnitMeasure ? Colors.white : kPrimaryColor,),)),
                  ),
                ),
              ),
            ],
          ),
        ),
        _otherUnitMeasure ? Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.04,
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
            Text('   Prezzo Lordo', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.bold)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.04,
            child: CupertinoTextField(
              controller: _priceController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
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
