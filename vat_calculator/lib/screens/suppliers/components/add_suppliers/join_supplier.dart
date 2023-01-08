import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../swagger/swagger.models.swagger.dart';
import '../../../home/main_page.dart';

class JoinSupplierScreen extends StatefulWidget {
  JoinSupplierScreen({Key? key}) : super(key: key);

  static String routeName = 'joinsupplier';

  @override
  State<JoinSupplierScreen> createState() => _JoinSupplierScreenState();
}

class _JoinSupplierScreenState extends State<JoinSupplierScreen> {

  static TextEditingController supplierCodeControllerSearch = TextEditingController();

  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType> errorController = StreamController();

  String currentPassword = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(

              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.clear), onPressed: () { supplierCodeControllerSearch.clear(); },),
                )
              ],
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, SuppliersScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: kCustomGrey),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Associa Fornitore',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(19),
                  color: kCustomGrey,
                ),
              ),
              elevation: 0,
            ),
            body: _buildInputPasswordForEventWidget(dataBundleNotifier),
          );
        });
  }


  Widget _buildInputPasswordForEventWidget(DataBundleNotifier dataBundleNotifier) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text('Immetti qui il codice del fornitore', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey)),
          SizedBox(height: getProportionateScreenHeight(30),),
          Form(
            key: formKey,
            child: PinCodeTextField(
              appContext: context,
              length: 8,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              textStyle: const TextStyle(color: Colors.black),
              pinTheme: PinTheme(
                inactiveColor: kCustomGrey,
                selectedColor: kCustomBordeaux,
                activeColor: kCustomGrey,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(4),
                fieldHeight: getProportionateScreenHeight(50),
                fieldWidth: getProportionateScreenHeight(50),
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              errorAnimationController: errorController,
              controller: supplierCodeControllerSearch,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.white,
                  blurRadius: 1,
                )
              ],
              onCompleted: (code) async {
                formKey.currentState?.validate();
                print('Retrieve Supplier model by code : ' + code);
                Response apiV1AppSuppliersFindbycodeGet = await dataBundleNotifier.getSwaggerClient().apiV1AppSuppliersFindbycodeGet(suppliercode: code);

                if(apiV1AppSuppliersFindbycodeGet.isSuccessful){

                  if(apiV1AppSuppliersFindbycodeGet.body == null){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: kCustomBordeaux,
                      duration: Duration(seconds: 3),
                      content: Text('Non ho trovato Fornitori con il seguente codice: ${code}'),
                    ));
                    clearControllers();
                  }else{
                    Supplier supplier = apiV1AppSuppliersFindbycodeGet.body;
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              height: getProportionateScreenHeight(550),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(' Aggiungere il presente fornitore alla tua lista?', style: TextStyle(fontSize: getProportionateScreenHeight(15), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                        IconButton(icon: Icon(Icons.clear, size: getProportionateScreenHeight(30)), color: kCustomGrey, onPressed: (){
                                          clearControllers();
                                          Navigator.of(context).pop();
                                        },)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Fornitore: ', style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey, fontWeight: FontWeight.w600)),
                                                  Text(supplier.name!, style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Email: ', style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey, fontWeight: FontWeight.w600)),
                                                  Text(supplier.email!, style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Telefono: ', style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey, fontWeight: FontWeight.w600)),
                                                  Text(supplier.phoneNumber!, style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Codice: ', style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey, fontWeight: FontWeight.w600)),
                                                  Text(supplier.supplierCode!, style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Indirizzo: ', style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey, fontWeight: FontWeight.w600)),
                                                  Text(supplier.address!, style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Città: ', style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey, fontWeight: FontWeight.w600)),
                                                  Text(supplier.city!, style: TextStyle(fontSize: getProportionateScreenHeight(17), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              SizedBox(height: getProportionateScreenHeight(55),),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: getProportionateScreenWidth(400),
                                          height: getProportionateScreenHeight(55),
                                          child: OutlinedButton(
                                            onPressed: () async {

                                              Response responseLinkBranchSupp = await dataBundleNotifier.getSwaggerClient().apiV1AppSuppliersConnectbranchsupplierGet(
                                                  branchId: dataBundleNotifier.getCurrentBranch().branchId!.toInt(),
                                                  supplierId: supplier.supplierId!.toInt());


                                              if(responseLinkBranchSupp.isSuccessful){

                                                dataBundleNotifier.refreshCurrentBranchData();

                                                Navigator.pushNamed(context, HomeScreenMain.routeName);
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  backgroundColor: kCustomGreen,
                                                  duration: const Duration(milliseconds: 2600),
                                                  content: Text(
                                                      'Complimenti. Hai collegato il fornitore ${supplier.name} alla tua attività!'),
                                                ));
                                              }else{
                                                Navigator.of(context).pop(false);
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  backgroundColor: kCustomBordeaux,
                                                  duration: const Duration(milliseconds: 2600),
                                                  content: Text(
                                                      'Si è verificato un errore durante l\'operazione. Err: ' + responseLinkBranchSupp.error!.toString()),
                                                ));
                                              }

                                            },
                                            style: ButtonStyle(
                                              elevation: MaterialStateProperty.resolveWith((states) => 5),
                                              backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                                              side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                            ),
                                            child: Text('Aggiungi Fornitore', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(18)),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: kCustomBordeaux,
                    duration: Duration(seconds: 3),
                    content: Text('Ho riscontrato un errore durante l\'operzione. Riprovare fra un paio di minuti. Err: ' + apiV1AppSuppliersFindbycodeGet!.error.toString()),
                  ));
                  clearControllers();
                }

              },
              onChanged: (value) {
                setState(() {
                  currentPassword = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void clearControllers() {
    setState(() {
      supplierCodeControllerSearch.clear();
    });
  }
}



