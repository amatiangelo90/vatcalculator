import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/item_menu.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/edit_supplier_screen.dart';
import 'components/supplier_add_screen.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({Key key}) : super(key: key);

  static String routeName = 'suppliers';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kCustomWhite,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Fornitori',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: kCustomWhite,
                    ),
                  ),
                ],
              ),
              elevation: 2,
              actions: [
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => {
                      Navigator.pushNamed(context, AddSupplierScreen.routeName),
                    }
                ),
              ],
            ),
            body: Container(
              color: kCustomWhite,
              child: dataBundleNotifier.currentBranch == null ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
              ) : buildListSuppliers(dataBundleNotifier, context),
            ),
          );
        });
  }

  Widget buildListSuppliers(DataBundleNotifier currentListSuppliers, context) {
    List<Widget> listout = [];


    listout.add(currentListSuppliers.currentListSuppliers.isNotEmpty ? const Text('La tua lista fornitori') : const Text('Non hai ancora fornitori'));
    currentListSuppliers.currentListSuppliers.forEach((supplier) {
      listout.add(ItemMenu(
        text: supplier.nome,
        icon: 'assets/icons/supplier.svg',
        press: () async {
          EasyLoading.show();

          ClientVatService clientVatService = ClientVatService();
          List<ProductModel> retrieveProductsBySupplier = await clientVatService.retrieveProductsBySupplier(supplier);
          currentListSuppliers.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
          EasyLoading.dismiss();
          Navigator.push(context,  MaterialPageRoute(builder: (context) => EditSuppliersScreen(currentSupplier: supplier,),),);
        },
        showArrow: true,
        backgroundColor: kBeigeColor,
      ),);
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: listout,
      ),
    );
  }

}
