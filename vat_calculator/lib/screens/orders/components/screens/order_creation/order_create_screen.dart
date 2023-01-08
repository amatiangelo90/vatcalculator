import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../../../swagger/swagger.models.swagger.dart';
import '../../../../home/main_page.dart';
import 'product_order_choice_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  static String routeName = 'create_order_screen';

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {

  String _filter = '';

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
                    Navigator.pushNamed(context, HomeScreenMain.routeName);
                  }),
              iconTheme: const IconThemeData(color: kCustomGrey),
              backgroundColor: kCustomWhite,
              centerTitle: true,

              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Crea Ordine',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          color: kCustomGrey,
                        ),
                      ),
                      Text(
                        'Seleziona Fornitore',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(12),
                          color: kBeigeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              elevation: 0,
            ),
            body: Container(
              color: kCustomWhite,
              child: dataBundleNotifier.getCurrentBranch().suppliers!.isNotEmpty
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
                        }, textColor: kCustomWhite, color: Color(0xff121212),
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
            setState((){
              _filter = currentText;
            });
          },
        ),
      ),
    );
    for (var supplier in dataBundleNotifier.getCurrentBranch().suppliers!.where((element) => element.name!.contains(_filter))) {
      listout.add(
        GestureDetector(
          onTap: () async {
            dataBundleNotifier.resetBasket(supplier.productList!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChoiceOrderProductScreen(
                  currentSupplier: supplier
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
                color: kCustomGrey,
              ),
              child: buildSupplierRow(dataBundleNotifier, supplier, kCustomGrey),
            ),
          ),
        ),
      );
    }

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

  buildSupplierRow(DataBundleNotifier dataBundleNotifier, Supplier supplier, Color color) {
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
                    supplier.name!,
                    style: TextStyle(
                        color: kCustomGrey,
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
                      Text('  #' + supplier.supplierCode!,
                          style: TextStyle(
                              color: color,
                              fontSize: getProportionateScreenWidth(10),
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
            child: Icon(Icons.arrow_forward_ios, size: getProportionateScreenHeight(25), color: kCustomGrey),
          ),
        ],
      ),
    );
  }
}
