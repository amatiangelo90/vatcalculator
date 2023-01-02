import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_screen.dart';

import '../../../size_config.dart';

class OrdersScreenBody extends StatefulWidget {
  const OrdersScreenBody({Key? key}) : super(key: key);

  @override
  _OrdersScreenBodyState createState() => _OrdersScreenBodyState();
}

class _OrdersScreenBodyState extends State<OrdersScreenBody> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Container(
                child: dataBundleNotifier.getUserEntity().branchList!.isEmpty ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dataBundleNotifier.getCurrentBranch().branchId == 0 ?
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
                            child: CreateBranchButton(),
                          ),
                        ],
                      ) : Column(
                        children: [
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
                              }, textColor: kCustomBlue, color: kCustomGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ) : Text('empty list')
            );
          }
        );
  }
}
