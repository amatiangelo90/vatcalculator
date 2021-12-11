import 'package:chips_choice/chips_choice.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/save_product_into_storage_request.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/size_config.dart';

import '../storage_screen.dart';

class DismissableWidgetProducts extends StatefulWidget {
  const DismissableWidgetProducts({Key key}) : super(key: key);

  @override
  _DismissableWidgetProductsState createState() => _DismissableWidgetProductsState();
}

class _DismissableWidgetProductsState extends State<DismissableWidgetProducts> {

  String supplierChoiced = '';
  List<String> suppliersList;

  retrieveListSuppliers(List<ResponseAnagraficaFornitori> currentListSuppliers) {
    List<String> currentListNameSuppliers = ['Tutti i prodotti'];
    currentListSuppliers.forEach((element) {
      currentListNameSuppliers.add(element.nome);
    });
    return currentListNameSuppliers;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {

          suppliersList = retrieveListSuppliers(dataBundleNotifier.currentListSuppliers);

          return dataBundleNotifier.productToAddToStorage.isEmpty ?
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(''),
              const Text('Nessun prodotto da aggiungere. Configurane di nuovi assegnandoli ai tuoi fornitori.', textAlign: TextAlign.center,),
              const Text(''),
              Padding(
                padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(30), 5, getProportionateScreenWidth(30), 5),
                child: DefaultButton(
                  text: "Fornitori",
                  press: () async {
                    Navigator.pushNamed(context, SuppliersScreen.routeName);
                  },
                ),
              ),
              SizedBox(width: 0,),
            ],
          ) :
          Column(
            children: [
              Content(
                child: ChipsChoice<String>.single(
                  choiceActiveStyle: C2ChoiceStyle(
                    color: Colors.green.shade700.withOpacity(0.8),
                    elevation: 2,
                    showCheckmark: false,
                  ),
                  value: supplierChoiced,
                  onChanged: (val) => setState(() {
                    supplierChoiced = val;
                    dataBundleNotifier.filterProductToAddToStorageBySupplier(val);
                  }),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: suppliersList,
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: dataBundleNotifier.productToAddToStorage.length,
                itemBuilder: (context, index) {
                  final item = dataBundleNotifier.productToAddToStorage[index].nome.toString();
                  return Dismissible(
                    key: Key(item),
                    onDismissed: (direction) {
                      dataBundleNotifier.getclientServiceInstance().performSaveProductIntoStorage(
                          saveProductToStorageRequest: SaveProductToStorageRequest(
                            fkStorageId: dataBundleNotifier.currentStorage.pkStorageId,
                            fkProductId: dataBundleNotifier.productToAddToStorage[index].pkProductId,
                            available: 'true',
                            stock: 0,
                            dateTimeCreation: DateTime.now().millisecondsSinceEpoch,
                            dateTimeEdit: DateTime.now().millisecondsSinceEpoch,
                            pkStorageProductCreationModelId: 0,
                            user: dataBundleNotifier.dataBundleList[0].firstName
                          ),
                          actionModel: ActionModel(
                              date: DateTime.now().millisecondsSinceEpoch,
                              description: 'Ha aggiunto ${dataBundleNotifier.productToAddToStorage[index].nome} (${dataBundleNotifier.getSupplierName(dataBundleNotifier.productToAddToStorage[index].fkSupplierId)}) al magazzino ${dataBundleNotifier.currentStorage.name}.',
                              fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                              user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                              type: ActionType.ADD_PRODUCT_TO_STORAGE
                          )
                      );

                      dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                      setState(() {
                        dataBundleNotifier.productToAddToStorage.removeAt(index);
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 400),
                          content: Text('$item aggiunto')));
                    },
                    background: Container(child: Center(child: const Text('Aggiungi al magazzino')),color: kBeigeColor),
                    child: ListTile(
                      title: Text(item),
                    ),
                  );
                },
              ),
            ],
          );
        }
    );
  }
}
