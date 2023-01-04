import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';

class AddElementIntoWorkstationWidget extends StatelessWidget {
  const AddElementIntoWorkstationWidget({Key? key, required this.workstationModel}) : super(key: key);

  final Workstation workstationModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        List<Widget> listWidget = [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seleziona i prodotti dal magazzino di riferimento', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(10)),),
          )
        ];

        if(dataBundleNotifier.getStorageById(dataBundleNotifier.getCurrentEvent().storageId!)!.products!.isNotEmpty){

          dataBundleNotifier.getStorageById(dataBundleNotifier.getCurrentEvent().storageId!)!.products!.forEach((product) {
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
                        SizedBox(
                            width: getProportionateScreenWidth(250),
                            child: Text(product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey,fontSize: getProportionateScreenHeight(17)),)),
                        Row(
                          children: [
                            Text(product.stock.toString(), style: TextStyle(fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold, color: product.stock! > 0 ? kCustomGreen : kCustomBordeaux),),
                            Text(' x ' + product.unitMeasure!, style: TextStyle(fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold,),),
                          ],
                        ),
                      ],
                    ),
                    IconButton(onPressed: () async {

                      print('Save product into workstation. '
                          'Product id : ${product.productId!.toInt()}, storage id ${dataBundleNotifier.getCurrentEvent().storageId!.toInt()}, workstation id : ${workstationModel.workstationId!.toInt().toString()}' );
                      Response apiV1AppStorageInsertproductGet = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationInsertproductGet(
                        workstationId: workstationModel.workstationId!.toInt(),
                        storageId: dataBundleNotifier.getCurrentEvent().storageId!.toInt(),
                        productId: product.productId!.toInt()
                      );

                      if(apiV1AppStorageInsertproductGet.isSuccessful){


                      }else{
                        print(apiV1AppStorageInsertproductGet.error.toString());

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Ho riscontrato degli errori durante il salvataggio. Error: ' + apiV1AppStorageInsertproductGet.error.toString()),
                        ));
                      }
                    }, icon: Icon(Icons.arrow_forward_sharp, color: kCustomGrey, size: getProportionateScreenHeight(20)),

                    ),
                  ],
                ),
              ),
            );
            listWidget.add(Divider(height: 2, color: Colors.grey.withOpacity(0.3), indent: 20, endIndent: 2,));
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
