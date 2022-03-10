import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/edit_supplier_screen.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({Key key}) : super(key: key);

  static String routeName = 'suppliers';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
      return Scaffold(
        bottomSheet:
            dataBundleNotifier.currentBranch == null ? SizedBox(width: 0,) :
            dataBundleNotifier.currentListSuppliers.isNotEmpty ? Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 39,
                      child: CupertinoButton(
                        color: Colors.green.withOpacity(0.9),
                          child: const Text('Aggiungi Nuovo'), onPressed: () {
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
              onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'Fornitori',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  color: kCustomGreen,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Pagina gestione fornitori',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          elevation: 2,
        ),
        body: Container(
          color: Colors.white,
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
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 100,
                            width: SizeConfig.screenWidth * 0.9,
                            child: DefaultButton(
                              color: kCustomGreen,
                              text: "Crea Fornitore",
                              press: () async {
                                Navigator.pushNamed(context, SupplierChoiceCreationEnjoy.routeName);
                              },
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
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.circle,
                  color: Colors.blueAccent,
                ),
                Text(' Importati', style: TextStyle(color: kPrimaryColor),),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
                const Text(' Creati dall\'utente', style: TextStyle(color: kPrimaryColor),),
              ],
            ),
          ],
        ),
      ),
    );
    dataBundleNotifier.currentListSuppliersDuplicated.forEach((supplier) {
      listout.add(
        GestureDetector(
          onTap: () async {

            List<ProductModel> retrieveProductsBySupplier =
                await dataBundleNotifier
                    .getclientServiceInstance()
                    .retrieveProductsBySupplier(supplier);

            dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditSuppliersScreen(
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
                color: dataBundleNotifier.userDetailsList[0].id.toString() ==
                        supplier.id
                    ? Colors.green
                    :  Colors.blueAccent,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color:kCustomWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: getProportionateScreenWidth(5)),
                          SvgPicture.asset(
                            'assets/icons/supplier.svg',
                            color: dataBundleNotifier.userDetailsList[0].id.toString() ==
                                supplier.id
                                ? Colors.green
                                :  Colors.blueAccent,
                            width: getProportionateScreenWidth(30),
                          ),
                          SizedBox(width: getProportionateScreenWidth(20)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supplier.nome,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontSize: getProportionateScreenWidth(15)),
                              ),
                              Text('#' + supplier.extra,
                                  style: TextStyle(
                                    color: kBeigeColor,
                                    fontSize: getProportionateScreenWidth(12),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
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
}
