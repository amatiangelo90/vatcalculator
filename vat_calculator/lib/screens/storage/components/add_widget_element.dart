import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../client/vatservice/model/action_model.dart';
import '../../../client/vatservice/model/product_model.dart';
import '../../../client/vatservice/model/save_product_into_storage_request.dart';
import '../../../client/vatservice/model/utils/action_type.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class AddElementWidget extends StatelessWidget {
  const AddElementWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        List<Widget> listWidget = [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seleziona i prodotti non anora presenti dal catalogo dei fornitori', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(10)),),
          )
        ];

        if(dataBundleNotifier.productToAddToStorage.isNotEmpty){
          Map<String, List<ProductModel>> mapSupplierListProduct = {};

          dataBundleNotifier.productToAddToStorage.forEach((product) {
            if(mapSupplierListProduct.containsKey(dataBundleNotifier.retrieveSupplierById(product.fkSupplierId))){
              mapSupplierListProduct[dataBundleNotifier.retrieveSupplierById(product.fkSupplierId)].add(product);
            }else{
              mapSupplierListProduct[dataBundleNotifier.retrieveSupplierById(product.fkSupplierId)] = [product];
            }
          });
          mapSupplierListProduct.forEach((key, value) {
            //print('Build list for current supplier : ' + key.toString());
            listWidget.add(
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 5, 13, 2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text(key, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
                ),
              ),
            );
            value.forEach((element) {
              listWidget.add(
                GestureDetector(
                  onTap: (){
                    dataBundleNotifier.getclientServiceInstance().performSaveProductIntoStorage(
                        saveProductToStorageRequest: SaveProductToStorageRequest(
                            fkStorageId: dataBundleNotifier.currentStorage.pkStorageId,
                            fkProductId: element.pkProductId,
                            available: 'true',
                            stock: 0,
                            dateTimeCreation: DateTime.now().millisecondsSinceEpoch,
                            dateTimeEdit: DateTime.now().millisecondsSinceEpoch,
                            pkStorageProductCreationModelId: 0,
                            user: dataBundleNotifier.userDetailsList[0].firstName
                        ),
                        actionModel: ActionModel(
                            date: DateTime.now().millisecondsSinceEpoch,
                            description: 'Ha aggiunto ${element.nome} (${dataBundleNotifier.getSupplierName(element.fkSupplierId)}) al magazzino ${dataBundleNotifier.currentStorage.name}.',
                            fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                            user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                            type: ActionType.ADD_PRODUCT_TO_STORAGE
                        )
                    );

                    dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();
                    dataBundleNotifier.removeProductToAddToStorage(element);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 400),
                        content: Text('${element.nome} aggiunto')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(element.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17)),),
                            Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGreenAccent,fontWeight: FontWeight.bold,),),
                          ],
                        ),
                        SvgPicture.asset('assets/icons/rightarrow.svg', width: getProportionateScreenHeight(25), color: kCustomGreenAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              listWidget.add(Divider(height: 2, color: Colors.grey.withOpacity(0.3), indent: 20, endIndent: 2,));
            });
          });
        }else{
          listWidget.add(
              Center(child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Tutti i prodotti presenti nel catalogo dei tuoi fornitori sono già stati assegnati al presente magazzino',style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kCustomBordeaux, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),)
          );
        }

        return Column(children: listWidget,);
      },
    );
  }
}
