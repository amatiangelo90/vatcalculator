import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../swagger/swagger.models.swagger.dart';

class AddSupplierFromOtherBranchWidget extends StatelessWidget {
  const AddSupplierFromOtherBranchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        List<int> listIdsSuppliers = [];

        dataBundleNotifier.getCurrentBranch().suppliers!.forEach((supp) {
          listIdsSuppliers.add(supp.supplierId!.toInt());
        });

        List<Widget> listWidget = [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seleziona i fornitori non ancora associati alla presente attività.', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(10)),),
          )
        ];


        if(dataBundleNotifier.getUserEntity().branchList!.length! > 1){

          for (Branch branch in dataBundleNotifier.getUserEntity().branchList!) {
            if(branch.branchId != dataBundleNotifier.getCurrentBranch().branchId){
              listWidget.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 5, 13, 2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: kCustomGreen,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text(branch.name!, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
                  ),
                ),
              );

              for (var supplier in branch.suppliers!) {
                if(!listIdsSuppliers.contains(supplier.supplierId)){
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
                                  child: Text(supplier.name!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey,fontSize: getProportionateScreenHeight(18)),)),
                              Text(' - Email: ' + supplier.email!, style: TextStyle(fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold,),),
                              Text(' - Cel: ' + supplier.phoneNumber!, style: TextStyle(fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold,),),
                              Text(' - Codice: ' + supplier.supplierCode!, style: TextStyle(fontSize: getProportionateScreenHeight(12), fontWeight: FontWeight.bold,),),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              Response linkBranchSuppResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppSuppliersConnectbranchsupplierGet(
                                  branchId: dataBundleNotifier.getCurrentBranch().branchId!.toInt(),
                                  supplierId: supplier.supplierId!.toInt());

                              if(linkBranchSuppResponse.isSuccessful){
                                dataBundleNotifier.addSupplierToCurrentBranch(supplier);

                              }else{
                                Navigator.of(context).pop(false);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: kCustomBordeaux,
                                  duration: const Duration(seconds: 5),
                                  content: Text('Ci sono stati problemi durante l\'operazione. Err: ' + linkBranchSuppResponse.error!.toString()),
                                ));
                              }
                            }, icon: Icon(Icons.arrow_forward_sharp, color: kCustomGrey, size: getProportionateScreenHeight(20)),
                          ),
                        ],
                      ),
                    ),
                  );
                  listWidget.add(Divider(height: 2, color: Colors.grey.withOpacity(0.3), indent: 20, endIndent: 2,));
                }

              }
            }
          }

        }else{
          listWidget.add(
              Center(child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Non hai altre attività dalle quali poter scegliere un fornitore',style: TextStyle(fontSize: getProportionateScreenHeight(18), color: kCustomBordeaux, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),)
          );
        }

        return Column(children: listWidget,);
      },
    );
  }
}
