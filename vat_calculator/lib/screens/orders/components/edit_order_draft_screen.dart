import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/size_config.dart';

class EditDraftOrderScreen extends StatefulWidget {
  const EditDraftOrderScreen({Key key, this.orderModel, this.productList, }) : super(key: key);

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
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return  Scaffold(
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoButton(child: Text('Invia', style: const TextStyle(color: Colors.green),), onPressed: () async {

              if(currentDate == null){
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 5000),
                    backgroundColor: Colors.red,
                    content: Text('Selezionare la data di consegna ordine', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));

              }else{
                await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                  OrderModel(
                      pk_order_id: widget.orderModel.pk_order_id,
                      status: OrderState.SENT,
                      delivery_date: currentDate.millisecondsSinceEpoch
                  ),
                );
                dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersScreen(
                      initialIndex: 1,
                    ),
                  ),
                );
              }
            }),
            CupertinoButton(child: Text('Cancella Bozza', style: const TextStyle(color: kPinaColor),), onPressed: () async {
              await dataBundleNotifier.getclientServiceInstance().deleteOrder(
                  widget.orderModel
              );

              dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersScreen(
                    initialIndex: 1,
                  ),
                ),
              );
            }),
          ],
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kBeigeColor,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text(
            'Dettaglio Ordine', style: TextStyle(color: kPrimaryColor),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 8, 100),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.45,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Card(
                        child: Column(
                          children: [
                            Text('# ' + widget.orderModel.code, style: TextStyle(fontWeight: FontWeight.bold),),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CupertinoButton(
                                    child: Text('Seleziona data consegna'),
                                    color: Colors.blueAccent,
                                    onPressed: () => _selectDate(context),
                                  ),
                                  Text('Data consegna'),
                                  currentDate == null ? Text(''
                                      'Nessuna Data selezionata')
                                      : Text('Data consegna : ' + currentDate.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('Carrello', style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.bold)),
                  ],
                ),

                buildProductListWidget(widget.productList, dataBundleNotifier),
                const Divider(height: 40,indent: 20, endIndent: 20,),
              ],
            ),
          ),
        ),
      );
  }
    );
  }

  buildProductListWidget(List<ProductOrderAmountModel> productList, DataBundleNotifier dataBundleNotifier) {

    List<Row> rows = [];
    productList.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.amount.toString());
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(element.amount <= 0){
                      }else{
                        element.amount --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(getProportionateScreenWidth(70), getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    onChanged: (text) {
                      if( double.tryParse(text) != null){
                        element.amount = double.parse(text);
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text('Immettere un valore numerico corretto per ' + element.nome),
                        ));
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
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
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
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
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
  }
}
