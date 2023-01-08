import 'dart:io';

import 'package:chopper/chopper.dart';
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

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({Key? key}) : super(key: key);

  static String routeName = 'suppliers';

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  String _filter = '';

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
                        color: kCustomGreen ,
                          child: const Text('Aggiungi nuovo fornitore'), onPressed: () {
                        Navigator.pushNamed(context, SupplierChoiceCreationEnjoy.routeName);
                      }),
                    ),
                  ],
                ),
              ),
            ) : const Text(''),
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
              Text(
                'Fornitori',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  color: kCustomGrey,
                  fontWeight: FontWeight.w600
                ),
              ),
              Text(
                'Gestione fornitori',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: kCustomGrey,
                ),
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
                              color: kCustomGrey,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              height: getProportionateScreenHeight(50),
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
       children: [
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
         buildWorkstationListWidget(dataBundleNotifier.getCurrentBranch().suppliers!, dataBundleNotifier),
       ],
      )
    );
  }

  buildWorkstationListWidget(List<Supplier> supplierList, DataBundleNotifier dataBundleNotifier) {


    return SizedBox(
      height: supplierList.where((element) => element.name!.contains(_filter)).length * getProportionateScreenHeight(120),
      child: ListView.builder(
        itemCount: supplierList.where((element) => element.name!.contains(_filter)).length,
        itemBuilder: (context, index) {
          Supplier supplier = supplierList.where((element) => element.name!.contains(_filter)).toList()[index];
          return Dismissible(
            background: Container(
              color: kCustomBordeaux,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Icon(Icons.delete, color: Colors.white, size: getProportionateScreenHeight(40)),
                  )
                ],
              ),
            ),
            key: Key(supplier.supplierId!.toString()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Conferma operazione"),
                    content: Text("Eliminare ${supplier.name} dalla lista dei tuoi fornitori?"),
                    actions: <Widget>[
                      OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Elimina", style: TextStyle(color: kRed),)
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Indietro"),
                      ),
                    ],
                  );
                },
              );
            },
            resizeDuration: const Duration(seconds: 1),
            onDismissed: (direction) async {
              print('Delete supplier : ' + supplier.toString());

              Response deleteSupplier = await dataBundleNotifier.getSwaggerClient()
                  .apiV1AppSuppliersDeleteDelete(supplierId: supplier.supplierId!.toInt(), branchId: supplier.branchId!.toInt());
              if(deleteSupplier.isSuccessful){
                dataBundleNotifier.removeSupplierFromCurrentBranch(supplier.supplierId!);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: kCustomGreen,
                    content: Text('Fornitore eliminato con successo')));
              }else{
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    duration: Duration(seconds: 3),
                    backgroundColor: kCustomBordeaux,
                    content: Text('Ho riscontrato un problema durante l\'eliminazione del fornitore. Riprova fra 2 minuti o contatta l\'amministratore del sistema')));
              }
            },
            child: ListTile(
              title: Column(
                children: [
                  ListTile(
                    leading: ClipRect(
                      child: SvgPicture.asset(
                        'assets/icons/supplier.svg',
                        height: getProportionateScreenHeight(40),
                        color: kCustomGrey,
                      ),
                    ),
                    onTap: (){
                      dataBundleNotifier.setCurrentSupplier(supplier);
                      Navigator.pushNamed(context, EditSuppliersScreen.routeName);

                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(supplier.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20), color: kCustomGrey)),
                          Text(supplier.supplierCode! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kCustomGrey)),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: kCustomWhite, height: 4, endIndent: 80,),
                ],
              ),
            ),
          );
        },
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
          color: kCustomGrey,
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
                                  fontSize: getProportionateScreenWidth(8),
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
                child: Icon(Icons.arrow_forward_ios, size: getProportionateScreenHeight(25), color: kCustomGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
