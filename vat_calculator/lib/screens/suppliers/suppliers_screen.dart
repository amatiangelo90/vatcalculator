import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.enums.swagger.dart';
import '../../swagger/swagger.models.swagger.dart';
import '../home/main_page.dart';
import 'components/edit_supplier_screen.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({Key? key}) : super(key: key);

  static String routeName = 'suppliers';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        bottomSheet:
            dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const SizedBox(width: 0,) :
            dataBundleNotifier.getCurrentBranch().suppliers!.isNotEmpty ? Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(Platform.isAndroid ? 13.0 : 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: CupertinoButton(
                        color: kPrimaryColor,
                          child: const Text('Aggiungi nuovo fornitore'), onPressed: () {
                        Navigator.pushNamed(context, SupplierChoiceCreationEnjoy.routeName);
                      }),
                    ),
                  ],
                ),
              ),
            ) : const Text(''),
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                    Navigator.pushNamed(context, HomeScreenMain.routeName);
                  }),
          iconTheme: const IconThemeData(color: kPrimaryColor),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'Fornitori',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600
                ),
              ),
              Text(
                'Gestione fornitori',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: dataBundleNotifier.getCurrentBranch().suppliers!.isNotEmpty
                  ? buildListSuppliers(dataBundleNotifier, context)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(''),
                          Text(
                            "Non hai ancora creato nessun fornitore. ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              height: 80,
                              width: SizeConfig.screenWidth * 0.9,
                              child: DefaultButton(
                                color: kCustomGreen,
                                text: "Crea Fornitore",
                                press: () async {
                                  Navigator.pushNamed(context, SupplierChoiceCreationEnjoy.routeName);
                                }, textColor: kCustomWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      );
    });
  }

  Widget buildListSuppliers(DataBundleNotifier dataBundleNotifier, context) {
    List<Widget> listout = [];
    listout.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        child: CupertinoTextField(
          textInputAction: TextInputAction.next,
          restorationId: 'Ricerca Fornitore',
          keyboardType: TextInputType.text,
          clearButtonMode: OverlayVisibilityMode.editing,
          placeholder: 'Ricerca Fornitore per nome o codice',
          onChanged: (currentText) {
            dataBundleNotifier.filterCurrentListSupplierByName(currentText);
          },
        ),
      ),
    );
    listout.add(
        Divider(color: Colors.grey.withOpacity(0.5), height: 0, indent: getProportionateScreenHeight(25),)
    );
    for (var supplier in dataBundleNotifier.getCurrentBranch().suppliers!) {
      listout.add(
        GestureDetector(
          onTap: () async {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditSuppliersScreen(
                  currentSupplier: supplier,
                ),
              ),
            );
          },
          child: buildSupplierRow(dataBundleNotifier, supplier, kPrimaryColor),
        ),
      );
    }

    listout.add(SizedBox(
      height: getProportionateScreenHeight(100),
    ));
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: listout,
      ),
    );
  }


  buildSupplierRow(DataBundleNotifier dataBundleNotifier, Supplier supplier, Color color) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        padding: const EdgeInsets.only(left: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kPrimaryColor,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: getProportionateScreenWidth(10)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.name!,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(17),
                            overflow: TextOverflow.fade,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/supplier.svg',
                            color: color,
                            width: getProportionateScreenWidth(20),
                          ),
                          Text('  #' + supplier.code!,
                              style: TextStyle(
                                  color: color,
                                  fontSize: getProportionateScreenWidth(12),
                                  fontWeight: FontWeight.bold
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 10, 25),
                child: Icon(Icons.arrow_forward_ios, size: getProportionateScreenHeight(25), color: kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
