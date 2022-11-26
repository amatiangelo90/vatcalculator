import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../../main_page.dart';
import 'product_order_choice_screen.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  static String routeName = 'create_order_screen';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kCustomWhite,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    dataBundleNotifier.onItemTapped(0);
                    Navigator.pushNamed(context, HomeScreenMain.routeName);
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,

              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Crea Ordine',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Seleziona Fornitore',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(12),
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              elevation: 5,
            ),
            body: Container(
              color: kCustomWhite,
              child: dataBundleNotifier.currentBranch == null
                  ? Column(
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
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.6,
                    child: CreateBranchButton(),
                  ),
                ],
              )
                  : dataBundleNotifier.currentListSuppliers.isNotEmpty
                  ? buildListSuppliers(dataBundleNotifier, context)
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Non hai ancora creato nessun fornitore. ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(13),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.6,
                      child: DefaultButton(
                        text: "Crea Fornitore",
                        press: () async {
                          Navigator.pushNamed(
                              context, SupplierChoiceCreationEnjoy.routeName);
                        }, textColor: Color(0xff121212), color: Color(0xff121212),
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
    dataBundleNotifier.currentListSuppliersDuplicated.forEach((supplier) {
      listout.add(
          GestureDetector(
          onTap: () async {
            List<ProductModel> retrieveProductsBySupplier = await dataBundleNotifier
                .getclientServiceInstance()
                .retrieveProductsBySupplier(supplier);

            dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
              dataBundleNotifier.clearOrdersDetailsObject();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoiceOrderProductScreen(
                    currentSupplier: supplier,
                  ),
                ),
              );

          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
            child: Container(
              padding: const EdgeInsets.only(left: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kPrimaryColor,
              ),
              child: buildSupplierRow(dataBundleNotifier, supplier, kPrimaryColor),
            ),
          ),
        ),
      );
    });

    listout.add(SizedBox(
      height: getProportionateScreenHeight(50),
    ));
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: listout,
      ),
    );
  }

  buildSupplierRow(DataBundleNotifier dataBundleNotifier, SupplierModel supplier, Color color) {
    return Container(
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
                    supplier.nome,
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
                      Text('  #' + supplier.extra,
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
            padding: const EdgeInsets.fromLTRB(0, 25, 30, 25),
            child: Icon(Icons.arrow_forward_ios, size: getProportionateScreenHeight(25), color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
