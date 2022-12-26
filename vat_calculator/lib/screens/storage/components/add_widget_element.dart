import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';

class AddElementWidget extends StatelessWidget {
  const AddElementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        List<Widget> listWidget = [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seleziona i prodotti non ancora presenti dal catalogo dei fornitori', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenHeight(10)),),
          )
        ];

        if(dataBundleNotifier.getProdToAddToCurrentStorage().isNotEmpty){

          dataBundleNotifier.getProdToAddToCurrentStorage().forEach((key, value) {
            listWidget.add(
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 5, 13, 2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text(dataBundleNotifier.getCurrentBranch().suppliers!.where((element) => element.supplierId == key).first.name!, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
                ),
              ),
            );
            value.forEach((element) {
              listWidget.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(element.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17)),),
                          Text(productUnitMeasureToJson(element.unitMeasure)!, style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kPrimaryColor, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                      IconButton(onPressed: () async {

                        Response apiV1AppStorageInsertproductGet = await dataBundleNotifier.getSwaggerClient().apiV1AppStorageInsertproductGet(
                            storageId: dataBundleNotifier.getCurrentStorage().storageId!.toInt(),
                            productId: element.productId!.toInt());

                        if(apiV1AppStorageInsertproductGet.isSuccessful){
                          dataBundleNotifier.addProductToCurrentStorage(apiV1AppStorageInsertproductGet.body);

                        }else{
                          print(apiV1AppStorageInsertproductGet.error.toString());

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: kPinaColor,
                            content: Text('Ho riscontrato degli errori durante il salvagaggio. Error: ' + apiV1AppStorageInsertproductGet.error.toString()),
                          ));
                        }
                      }, icon: Icon(Icons.arrow_forward_sharp, color: kPrimaryColor, size: getProportionateScreenHeight(20)),

                      ),
                    ],
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
