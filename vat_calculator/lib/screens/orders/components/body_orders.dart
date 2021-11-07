import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import 'package:vat_calculator/screens/suppliers/components/supplier_add_screen.dart';

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
                      dataBundleNotifier.currentBranch == null ?
                      Column(
                        children: [
                          Text(
                            "Sembra che tu non abbia configurato ancora nessuna attività. ",
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
                              text: "Crea Attività",
                              press: () async {
                                Navigator.pushNamed(context, CompanyRegistration.routeName);
                              },
                            ),
                          ),
                        ],
                      ) : Column(
                        children: [
                          Text(
                            "Ciao, non hai ancora configurato nessun fornitore per " + dataBundleNotifier.currentBranch.companyName + '.'
                                ' Che ne dici di importare quelli presenti sul tuo account FattureInCloud?',
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
                                //EasyLoading.show();
                                ClientVatService clientService = ClientVatService();
                                FattureInCloudClient fattureInCloudClient = FattureInCloudClient();
                                List<ResponseAnagraficaFornitori> listRichiestaFornitori
                                = await fattureInCloudClient.performRichiestaFornitori(
                                    dataBundleNotifier.currentBranch.apiUidOrPassword, dataBundleNotifier.currentBranch.apiKeyOrUser);
                                print(listRichiestaFornitori.length);

                                listRichiestaFornitori.forEach((currentFornitore) {
                                  currentFornitore.fkBranchId = dataBundleNotifier.currentBranch.pkBranchId;
                                  clientService.performSaveSupplier(currentFornitore);
                                });

                                if(dataBundleNotifier.currentBranch != null){
                                  List<ResponseAnagraficaFornitori> _suppliersModelList = await clientService.retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                                  dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList);
                                  sleep(Duration(seconds: 2));
                                  List<ResponseAnagraficaFornitori> _suppliersModelList2 = await clientService.retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                                  dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList2);
                                }
                                //EasyLoading.dismiss();
                              },
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Text(
                            'oppure inizia a creare la tua lista fornitori',
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
                              text: "Crea Fornitore",
                              press: () async {
                                Navigator.pushNamed(context, AddSupplierScreen.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ) : SingleChildScrollView(
                  child: buildListFornitori(dataBundleNotifier.currentListSuppliers),
                  scrollDirection: Axis.vertical,
                ),
            );
          }
        );
  }

  buildListFornitori(List<ResponseAnagraficaFornitori> currentListSuppliers) {

    List<Widget> list = [];
    currentListSuppliers.forEach((element) {
      list.add(Text(element.nome));
    });

    return Column(
      children: list,
    );

  }
}
