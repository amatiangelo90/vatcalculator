
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/send_draft_order_screen.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/size_config.dart';

class EditDraftOrderScreen extends StatefulWidget {
  const EditDraftOrderScreen({
    Key key,
    this.orderModel,
    this.productList,
  }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  State<EditDraftOrderScreen> createState() => _EditDraftOrderScreenState();
}

class _EditDraftOrderScreenState extends State<EditDraftOrderScreen> {
  DateTime currentDate = DateTime.now();



  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    const double _initFabHeight = 80.0;
    double _fabHeight = 0;
    double _panelHeightOpen = 0;
    double _panelHeightClosed = 55.0;


    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          _panelHeightOpen = MediaQuery.of(context).size.height * .75;
      return LoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 0.9,
        overlayWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(130),
                width: getProportionateScreenWidth(250),
                child: Card(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          SpinKitRing(
                            lineWidth: 3,
                            color: kPrimaryColor,
                            size: getProportionateScreenHeight(50),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(4),
                          ),
                          const Text('Invio ordine in corso..'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: Scaffold(
          bottomSheet: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: 'Procedi',
                press: () async {
                  int productsAmountsDiffentThan0 = 0;
                  widget.productList.forEach((element) {
                    if(element.amount != 0){
                      productsAmountsDiffentThan0 = productsAmountsDiffentThan0 + 1;
                    }
                  });
                  if(productsAmountsDiffentThan0 == 0){
                    buildSnackBar(text: 'Selezionare quantità per almeno un prodotto', color: kPinaColor);
                  }else{

                    dataBundleNotifier.setCurrentProductListToSendDraftOrder(widget.productList);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DraftOrderConfirmationScreen(
                          draftOrder: widget.orderModel,
                          currentSupplier: dataBundleNotifier.retrieveSupplierFromSupplierListById(widget.orderModel.fk_supplier_id)
                        ),
                      ),
                    );
                  }
                },
                color: kCustomOrange,
              ),
            ),
          ),

          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.save, size: getProportionateScreenHeight(35),),
                  color: Colors.green.withOpacity(0.6),
                  onPressed: () async {

                  }
              ),
              IconButton(
                icon: Icon(Icons.delete_forever_rounded, size: getProportionateScreenHeight(35),),
                  color: Colors.red.shade800,
                  onPressed: () async {
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
                            description: 'Ha cancellato ordine #${widget.orderModel.code} con stato ${widget.orderModel.status} per fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                            date: DateTime.now().millisecondsSinceEpoch,
                            type: ActionType.ORDER_DELETE
                        );

                        await dataBundleNotifier.getclientServiceInstance().deleteOrder(orderModel: widget.orderModel, actionModel: actionModel);
                        dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                        Navigator.pushNamed(context, OrdersScreen.routeName);
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
                                            ), onPressed: () {
                                              Navigator.pop(context);

                                              },),

                                          ],
                                        ),
                                      ),
                                      const Text(''),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Stai eliminando bozza di ordine con codice #${widget.orderModel.code.toString()} per fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                          textAlign: TextAlign.center,),
                                      ),
                                      const Text(''),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                    );
                  }
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            automaticallyImplyLeading: true,
            title: Column(
              children: [
                Text(
                  dataBundleNotifier.retrieveSupplierFromSupplierListById(widget.orderModel.fk_supplier_id)
                      != null ?
                  dataBundleNotifier.retrieveSupplierFromSupplierListById(widget.orderModel.fk_supplier_id).nome : '',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    color: kCustomWhite,
                  ),
                ),
                Text(
                  'Bozza Ordine',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(10),
                    color: kCustomWhite,
                  ),
                ),
              ],
            ),
            elevation: 2,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 8, 100),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Carrello',
                                  style: TextStyle(
                                      color: kPinaColor,
                                      fontSize: getProportionateScreenHeight(20),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          buildProductListWidget(dataBundleNotifier),
                          const Divider(
                            height: 40,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 2, getProportionateScreenHeight(50)),
                child: SlidingUpPanel(
                  maxHeight: _panelHeightOpen,
                  minHeight: _panelHeightClosed,
                  parallaxEnabled: true,
                  parallaxOffset: .3,
                  panelBuilder: (sc) => _panel(sc, dataBundleNotifier),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  onPanelSlide: (double pos) => setState(() {
                    _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  buildProductListWidget(DataBundleNotifier dataBundleNotifier) {
    List<Row> rows = [];
    widget.productList.forEach((element) {

      TextEditingController controller =
          TextEditingController(text: element.amount.toString());
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  child: Text(
                    element.nome,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      element.unita_misura,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        FontAwesomeIcons.dotCircle,
                        size: getProportionateScreenWidth(3),
                      ),
                    ),
                    Text(
                      element.prezzo_lordo.toString() + ' €',
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(8)),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (element.amount < 0) {
                      } else if(element.amount == 1 || element.amount == 0) {
                        if(element.pkOrderProductId != 0){
                          dataBundleNotifier.getclientServiceInstance().removeProductFromOrder(element);
                        }
                        widget.productList.remove(element);
                      }else {
                        element.amount--;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.minus,
                      color: kPinaColor,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                      getProportionateScreenWidth(70),
                      getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      if (double.tryParse(text) != null) {
                        element.amount = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  element.nome),
                        ));
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      element.amount = element.amount + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus,
                        color: Colors.green.shade900),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });

    return Column(
      children: rows,
    );
  }

  String getNiceNumber(String string) {
    if (string.contains('.00')) {
      return string.replaceAll('.00', '');
    } else if (string.contains('.0')) {
      return string.replaceAll('.0', '');
    } else {
      return string;
    }
  }

  Widget _panel(ScrollController sc, DataBundleNotifier dataBundleNotifier) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 35,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(const Radius.circular(12.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Aggiungi altri prodotti dal catalogo",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: getProportionateScreenHeight(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildRemainingProductListForCurrentSuplier(dataBundleNotifier),
        ],
      ),
    );
  }

  buildRemainingProductListForCurrentSuplier(DataBundleNotifier dataBundleNotifier) {

    List<int> productAlreadyPresent = [];
    List<ProductModel> productAll = [];

    dataBundleNotifier.currentProductModelListForSupplier.forEach((product) {
      productAll.add(product);
    });
    widget.productList.forEach((productAlreadyInDraftOrder) {
      productAlreadyPresent.add(productAlreadyInDraftOrder.pkProductId);
    });

    productAll.removeWhere((element) => productAlreadyPresent.contains(element.pkProductId));

    List<Widget> widgetList = [
      Padding(
        padding: const EdgeInsets.fromLTRB(13, 15, 13, 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black54.withOpacity(0.7),
          ),
          width: MediaQuery.of(context).size.width,
          child: Text(dataBundleNotifier.retrieveSupplierFromSupplierListById(widget.orderModel.fk_supplier_id).nome, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite),),
        ),
      ),
    ];

    if(productAll.isEmpty){
      widgetList.add(
        const Padding(
          padding: EdgeInsets.all(28.0),
          child: Text('Tutti i prodotti del catalogo sono già presenti nell\'ordine', textAlign: TextAlign.center,),
        ),
      );
    }
    productAll.forEach((productToAdd) {
      widgetList.add(
        GestureDetector(
          onTap: (){
            setState((){
              widget.productList.add(
                ProductOrderAmountModel(
                    pkProductId: productToAdd.pkProductId,
                    amount: 0.0,
                    nome: productToAdd.nome,
                    fkOrderId: widget.orderModel.pk_order_id,
                    iva_applicata: productToAdd.iva_applicata,
                    categoria: productToAdd.categoria,
                    unita_misura: productToAdd.unita_misura,
                    fkSupplierId: productToAdd.fkSupplierId,
                    descrizione: productToAdd.descrizione,
                    prezzo_lordo: productToAdd.prezzo_lordo,
                    codice: productToAdd.codice,
                    pkOrderProductId: 0
                ),
              );
            });

          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productToAdd.nome, style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(productToAdd.unita_misura, style: TextStyle(fontSize: getProportionateScreenHeight(10)),),
                  ],
                ),
                SvgPicture.asset('assets/icons/rightarrow.svg', width: getProportionateScreenHeight(25), color: Colors.greenAccent.shade700.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return Column(
      children: widgetList,
    );
  }

  void buildSnackBar({@required String text, @required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: Text(text, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
  }

}
