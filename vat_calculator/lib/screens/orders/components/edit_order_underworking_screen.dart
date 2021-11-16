import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key key, this.orderModel, this.productList, }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                    color: Colors.green,
                    child:
                    Text('Ricevuto', style: const TextStyle(color: kCustomWhite),), onPressed: (){

                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                    color: kPinaColor,
                    child: Text('Archivia', style: const TextStyle(color: kCustomWhite),),
                    onPressed: (){

                    }),
              ),
            ],
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.deepOrangeAccent),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            automaticallyImplyLeading: true,
            title: const Text(
              'Dettaglio Ordine', style: TextStyle(color: Colors.deepOrangeAccent),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                            Text('#' + widget.orderModel.code, style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Carrello', style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: SvgPicture.asset('assets/icons/pdf.svg', width: getProportionateScreenWidth(23),),


                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: SvgPicture.asset('assets/icons/edit-cust.svg',
                                width: getProportionateScreenWidth(dataBundleNotifier.editOrder ? 23 : 21),
                                color: dataBundleNotifier.editOrder ? Colors.blueAccent : kPrimaryColor,
                              ),

                              onPressed: (){
                                dataBundleNotifier.switchEditOrder();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                buildProductListWidget(widget.productList, context, dataBundleNotifier),
                SizedBox(height: getProportionateScreenHeight(90),),
              ],
            ),
          ),
        );
      },
    );
  }

  buildProductListWidget(List<ProductOrderAmountModel> productList, context, DataBundleNotifier dataBundleNotifier) {

    List<Widget> tableRowList = [
    ];

    productList.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount.toString());
      tableRowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(currentProduct.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kPrimaryColor),),
                Text(' (' + currentProduct.unita_misura + ')', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),),
              ],
            ),
            Row(
              children: [
                dataBundleNotifier.editOrder ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if(currentProduct.amount <= 0){
                      }else{
                        currentProduct.amount --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ) : SizedBox(height: 0,),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                      getProportionateScreenWidth(70),
                      getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    enabled: dataBundleNotifier.editOrder,
                    onChanged: (text) {
                      if (double.tryParse(text) != null) {
                        currentProduct.amount = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  currentProduct.nome),
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
                dataBundleNotifier.editOrder ? GestureDetector(
                  onTap: () {
                    setState(() {
                      currentProduct.amount  =  currentProduct.amount + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ) : SizedBox(height: 0,),
              ],
            ),
          ],
        ),
      );
      tableRowList.add(Divider(endIndent: 20, indent: 30,),);
    });

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: tableRowList,
      ),
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
