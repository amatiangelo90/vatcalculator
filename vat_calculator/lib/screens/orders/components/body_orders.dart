import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../size_config.dart';

class OrdersScreenBody extends StatefulWidget {
  const OrdersScreenBody({Key key}) : super(key: key);

  @override
  _OrdersScreenBodyState createState() => _OrdersScreenBodyState();
}

class _OrdersScreenBodyState extends State<OrdersScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Container(
                child: dataBundleNotifier.currentListSuppliers.isEmpty ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ciao, non hai ancora configurato nessun fornitore per " + dataBundleNotifier.currentBranch.companyName + '. Che ne dici di importare quelli configurati sul tuo account FattureInCloud?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.6,
                        child: DefaultButton(
                          text: "Importa Lista Fornitori",
                          press: () async {
                            EasyLoading.show();
                            ClientVatService clientService = ClientVatService();
                            FattureInCloudClient fattureInCloudClient = FattureInCloudClient();
                            List<ResponseAnagraficaFornitori> listRichiestaFornitori
                            = await fattureInCloudClient.performRichiestaFornitori(
                                dataBundleNotifier.currentBranch.apiUidOrPassword, dataBundleNotifier.currentBranch.apiKeyOrUser);
                            ClientVatService clientVatService = ClientVatService();

                            listRichiestaFornitori.forEach((currentFornitore) {
                              currentFornitore.fkBranchId = dataBundleNotifier.currentBranch.pkBranchId;
                              clientVatService.performSaveSupplier(currentFornitore);
                            });
                            if(dataBundleNotifier.currentBranch != null){
                              List<ResponseAnagraficaFornitori> _suppliersModelList = await clientService.retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                              dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList);
                            }
                            EasyLoading.dismiss();
                          },
                        ),
                      ),
                    ],
                  ),
                ) : Text('asd'),
            );
          }
        );
  }
}
