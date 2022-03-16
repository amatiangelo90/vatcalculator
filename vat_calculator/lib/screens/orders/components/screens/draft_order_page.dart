import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../main_page.dart';
import '../../orders_screen.dart';
import '../edit_order_draft_screen.dart';

class DraftOrderPage extends StatefulWidget {
  const DraftOrderPage({Key key}) : super(key: key);

  static String routeName = 'draft_order_screen';

  @override
  State<DraftOrderPage> createState() => _DraftOrderPageState();
}

class _DraftOrderPageState extends State<DraftOrderPage> {

  int timeToRefresh = 1500;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {

          Timer(Duration(milliseconds: timeToRefresh), (){
            setState(() {
              timeToRefresh = 5000000;
            });
          } );

      return RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.delayed(const Duration(milliseconds: 500));
        },
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            elevation: 5,
            backgroundColor: kPrimaryColor,
            title: Text('Bozze Ordini', style: TextStyle(
              fontSize: getProportionateScreenWidth(17),
              color: kCustomOrange,
            ),),
            centerTitle: true,
            titleTextStyle: TextStyle(color: kCustomWhite, fontSize: getProportionateScreenWidth(15)),
            leading: GestureDetector(
                child: const Icon(Icons.arrow_back_ios, color: kCustomWhite,),
              onTap: (){
                dataBundleNotifier.onItemTapped(0);
                Navigator.pushNamed(context, HomeScreenMain.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(child: buildRowItems(dataBundleNotifier)),
              ],
            ),
          ),
        ),
      );
    });
  }

  String calculatePriceFromProductList(
      List<ProductOrderAmountModel> orderIdProductListMap) {
    double total = 0.0;

    orderIdProductListMap.forEach((currentProduct) {
      total = total + (currentProduct.amount * currentProduct.prezzo_lordo);
    });

    return total.toStringAsFixed(2);
  }

  SingleChildScrollView buildRowItems(DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [];
    if(dataBundleNotifier.currentDraftOrdersList.isNotEmpty){
      dataBundleNotifier.currentDraftOrdersList.forEach((currentOrder) {
        list.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              elevation: 14,
              child: dataBundleNotifier.orderIdProductListMap[currentOrder.pk_order_id] == null
                  ? const SizedBox(
                width: 0,
              )
                  : Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: SvgPicture.asset('assets/icons/Trash.svg', width: getProportionateScreenWidth(20),),
                          color: Colors.red,
                          onPressed: () {
                            Widget cancelButton = TextButton(
                              child: Text("Indietro", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(20))),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            );

                            Widget continueButton = TextButton(
                              child: Text("Elimina", style: TextStyle(color: kPinaColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(20))),
                              onPressed:  () async {

                                ActionModel actionModel = ActionModel(
                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                  description: 'Ha cancellato ordine #${currentOrder.code} con stato ${currentOrder.status} per fornitore ${dataBundleNotifier.getSupplierName(currentOrder.fk_supplier_id)}.',
                                  date: DateTime.now().millisecondsSinceEpoch,
                                    type: ActionType.ORDER_DELETE
                                );

                                await dataBundleNotifier.getclientServiceInstance().deleteOrder(orderModel: currentOrder, actionModel: actionModel);
                                dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                                Navigator.of(context).pop();
                              },
                            );
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog (
                                  actions: [
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        cancelButton,
                                        continueButton,
                                      ],
                                    ),
                                  ],
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Builder(
                                    builder: (context) {
                                      var width = MediaQuery.of(context).size.width;
                                      return SizedBox(
                                        width: width - 90,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10.0),
                                                      topLeft: Radius.circular(10.0) ),
                                                  color: kPrimaryColor,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('  Elimina ordine?',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: getProportionateScreenWidth(15),
                                                          fontWeight: FontWeight.bold,
                                                          color: kCustomWhite,
                                                        )),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ), onPressed: () { Navigator.pop(context); },),

                                                  ],
                                                ),
                                              ),
                                              const Text(''),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('Stai eliminando bozza di ordine con codice #${currentOrder.code.toString()} per fornitore ${dataBundleNotifier.getSupplierName(currentOrder.fk_supplier_id)}.',
                                                  textAlign: TextAlign.center,),
                                              ),
                                              const Text(''),
                                              Text('Continuare?', style: TextStyle(fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                            );
                          },
                        ),
                      ),
                    ],),
                  Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('    ' + dataBundleNotifier.getSupplierName(currentOrder.fk_supplier_id),style: TextStyle(fontSize: getProportionateScreenHeight(19)),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '      #' + currentOrder.code,
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(13)),
                          ), ],
                      ),
                      Divider(
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Prodotti',
                                style: TextStyle(
                                    fontSize: getProportionateScreenHeight(13)),
                              ),
                              Text(dataBundleNotifier.orderIdProductListMap[
                              currentOrder.pk_order_id]
                                  .length
                                  .toString(),
                                style: TextStyle(
                                    color: kPinaColor,
                                    fontSize: getProportionateScreenHeight(14)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Prezzo Stimato ',
                                style: TextStyle(
                                    fontSize: getProportionateScreenHeight(13)),
                              ),
                              Text(
                                '€ ' +
                                    calculatePriceFromProductList(
                                        dataBundleNotifier.orderIdProductListMap[
                                        currentOrder.pk_order_id]),
                                style: TextStyle(
                                    color: kPinaColor,
                                    fontSize: getProportionateScreenHeight(14)),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Text(
                            'Mostra Dettagli',
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(13)),
                          ),
                          children: [
                            buildProductListWidget(dataBundleNotifier.orderIdProductListMap[
                            currentOrder.pk_order_id], dataBundleNotifier),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: getProportionateScreenWidth(500),
                        child: CupertinoButton(
                          child: Text(
                            'Modifica ed Inoltra',
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(13)),
                          ),
                          pressedOpacity: 0.9,
                          color: kCustomOrange,
                          onPressed: () async {

                            List<ProductModel> retrieveProductsBySupplier = await dataBundleNotifier
                                .getclientServiceInstance()
                                .retrieveProductsBySupplier(dataBundleNotifier.retrieveSupplierFromSupplierListById(currentOrder.fk_supplier_id));

                            retrieveProductsBySupplier.forEach((element) {
                              element.prezzo_lordo = 0.0;
                            });
                            dataBundleNotifier.addAllCurrentProductSupplierList(retrieveProductsBySupplier);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDraftOrderScreen(
                                  orderModel: currentOrder,
                                  productList: dataBundleNotifier.orderIdProductListMap[
                                  currentOrder.pk_order_id],
                                ),
                              ),
                            );
                          },
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          color: Colors.orange,

                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }else{
      list.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getProportionateScreenHeight(300),),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(child: Text('Nessuna bozza presente', style: TextStyle(color: Colors.white),)),
            ),

            CupertinoButton(
                color: kCustomOrange,
                child: Text('Torna alla pagina Ordini'), onPressed: (){
              dataBundleNotifier.onItemTapped(2);
              Navigator.pop(context);
            }),
          ],
        ),
      );
    }


    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: list,
      ),
    );
  }

  buildProductListWidget(List<ProductOrderAmountModel> productList,
      DataBundleNotifier dataBundleNotifier) {

    List<Row> rows = [];
    productList.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.amount.toString());
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(element.nome, overflow: TextOverflow.clip, style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                ),
                Row(
                  children: [
                    Text(element.unita_misura, style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(FontAwesomeIcons.dotCircle, size: getProportionateScreenWidth(3),),
                    ),
                    Text(element.prezzo_lordo.toString() + ' €', style: TextStyle(fontSize: getProportionateScreenWidth(8)),),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    enabled: false,
                    controller: controller,
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });

    rows.add(
      Row(
        children: [
          SizedBox(height: 10,),
        ],
      ),
    );
    return Column(
      children: rows,
    );
  }

  String getNiceNumber(String string) {
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
  }
}
