import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/supplier_add_screen.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({Key key}) : super(key: key);

  static String routeName = 'suppliers';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
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
            body: buildListSuppliers(dataBundleNotifier.currentListSuppliers),
          );
        });
  }

  Widget buildListSuppliers(List<ResponseAnagraficaFornitori> currentListSuppliers) {
    List<Widget> listout = [];
    currentListSuppliers.forEach((supplier) {
      listout.add(Text(supplier.nome));
    });
    return Column(
      children: listout,
    );
  }

}
