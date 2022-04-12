import 'dart:io';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../client/vatservice/model/action_model.dart';
import '../../../client/vatservice/model/move_product_between_storage_model.dart';
import '../../main_page.dart';

class ProductMoveToOtherStorageConfirmationScreen extends StatefulWidget {
  const ProductMoveToOtherStorageConfirmationScreen({Key key, this.currentSupplier,this.storageList}) : super(key: key);

  static String routeName = 'productmoveconfirmationscreen';

  final SupplierModel currentSupplier;
  final List<StorageModel> storageList;

  @override
  State<ProductMoveToOtherStorageConfirmationScreen> createState() => _ProductMoveToOtherStorageConfirmationScreenState();
}

class _ProductMoveToOtherStorageConfirmationScreenState extends State<ProductMoveToOtherStorageConfirmationScreen> {

  String _selectedStorage = 'Seleziona Magazzino';
  StorageModel currentStorageModel;

  DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {

        return LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.9,
          overlayWidget: const LoaderOverlayWidget(message: 'Invio ordine in corso...',),
          child: Scaffold(
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
              child: DefaultButton(
                text: ''
                    'Conferma ed Invia',
                press: () async {
                  context.loaderOverlay.show();
                  print('Performing send order ...');
                  if(_selectedStorage == 'Seleziona Magazzino'){
                    context.loaderOverlay.hide();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        backgroundColor:kPinaColor,
                        duration: Duration(milliseconds: 1100),
                        content: Text('Selezionare il magazzino a cui assegnare la merce')));
                  }else if(currentStorageModel == null){
                    context.loaderOverlay.hide();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        duration: Duration(milliseconds: 800),
                        content: Text('Selezionare il magazzino')));
                  }else{
                        context.loaderOverlay.show();

                        List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel = [];

                        dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
                          if(element.extra > 0){
                            listMoveProductBetweenStorageModel.add(
                                MoveProductBetweenStorageModel(
                                  amount: element.extra,
                                  pkProductId: element.fkProductId,
                                  storageIdFrom: dataBundleNotifier.currentStorage.pkStorageId,
                                  storageIdTo: currentStorageModel.pkStorageId
                                )
                            );
                          }
                        });

                        Response response = await dataBundleNotifier.getclientServiceInstance()
                            .moveProductBetweenStorage(listMoveProductBetweenStorageModel: listMoveProductBetweenStorageModel,
                          actionModel: ActionModel(

                          )
                        );

                        if(response != null && response.data == 1){
                          dataBundleNotifier.cleanExtraArgsListProduct();
                          dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              duration: Duration(milliseconds: 1200),
                              content: Text('Prodotti spostati correttamente da magazzino ${dataBundleNotifier.currentStorage.name} a ${currentStorageModel.name}')));
                          dataBundleNotifier.onItemTapped(1);
                          Navigator.pushNamed(context, HomeScreenMain.routeName);
                        }else{
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: kPinaColor,
                              duration: Duration(milliseconds: 1200),
                              content: Text('Non sono riuscito a spostare i prodotti da magazzino ${dataBundleNotifier.currentStorage.name} a ${currentStorageModel.name}. Contatta il supporto')));
                        }
                        context.loaderOverlay.hide();
                  }
                },
                color: kCustomGreenAccent,
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Text(
                'Conferma Spostamento Merce',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
              elevation: 5,
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
              future: buildProductPage(dataBundleNotifier, widget.currentSupplier),
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
          ),
        );
      },
    );
  }

  Future buildProductPage(DataBundleNotifier dataBundleNotifier, SupplierModel supplier) async {
    List<Widget> list = [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dataBundleNotifier.currentStorage.name, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 20),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                      Icon(Icons.arrow_circle_down),
                    ],
                  ),
                  Divider(indent: 10, endIndent: 10, height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Selezionare il magazzino a cui assegnare la merce: ', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 10),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: DropdownWithSearch(
                        title: 'Seleziona Magazzino',
                        placeHolder: 'Ricerca Magazzino',
                        disabled: false,
                        items: widget.storageList.map((StorageModel storageModel) {
                          return storageModel.pkStorageId.toString() + ' - ' + storageModel.name + ' (${dataBundleNotifier.retrieveBranchById(storageModel.fkBranchId).companyName})';
                        }).toList(),
                        selected: _selectedStorage,
                        onChanged: (storage) {
                          setCurrentStorage(storage, dataBundleNotifier, widget.storageList);
                        },
                      ),
                    ),
                  ),

                  _selectedStorage == 'Seleziona Magazzino' ? SizedBox(height: 0,) : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentStorageModel == null ? '' : currentStorageModel.name, style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 20),),
                        ],
                      ),
                      Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(20),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          currentStorageModel == null ? Text('') : Text(currentStorageModel.address + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          currentStorageModel == null ? Text('') : Text(currentStorageModel.city + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                          currentStorageModel == null ? Text('') : Text(currentStorageModel.cap.toString() + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    list.add(Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Lista Merce', style: TextStyle(color: Colors.green.shade900.withOpacity(0.8), fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.bold), ),
          ),
          CupertinoButton(
            child: const Text('Modifica', style: TextStyle(color: Colors.black54),),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ));
    dataBundleNotifier.currentStorageProductListForCurrentStorageDuplicated.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.extra.toString());

      if(currentProduct.extra != 0){
        list.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentProduct.productName, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15)),),
                      Text(currentProduct.unitMeasure, style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                    ],
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.loose(Size(
                            getProportionateScreenWidth(70),
                            getProportionateScreenWidth(60))),
                        child: CupertinoTextField(
                          controller: controller,
                          enabled: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          clearButtonMode: OverlayVisibilityMode.never,
                          textAlign: TextAlign.center,
                          autocorrect: false,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )
        );
      }
    });

    list.add(Column(
      children: const [
        SizedBox(height: 80,),
      ],
    ));
    return list;
  }

  void setCurrentStorage(String storage, DataBundleNotifier dataBundleNotifier, List<StorageModel> storageList) {
    setState(() {
      _selectedStorage = storage;

      storageList.forEach((storageItem) {
        if(storage.contains(storageItem.name) &&
            storage.contains(storageItem.pkStorageId.toString())){
          currentStorageModel = storageItem;
        }
      });
    });

  }

}
