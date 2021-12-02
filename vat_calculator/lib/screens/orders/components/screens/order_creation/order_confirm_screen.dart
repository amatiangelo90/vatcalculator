import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/orders_utils.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../orders_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({Key key, this.currentSupplier}) : super(key: key);

  static String routeName = 'orderconfirmationscreen';

  final ResponseAnagraficaFornitori currentSupplier;

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {

  String code = DateTime.now().microsecondsSinceEpoch.toString().substring(3,16);
  String _selectedStorage = 'Seleziona Magazzino';
  StorageModel currentStorageModel;

  DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {

          return Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: 'Conferma ed Invia',
                press: () async {
                  print('Performing send order ...');

                  String code = DateTime.now().microsecondsSinceEpoch.toString().substring(3,16);
                  Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performSaveOrder(
                      orderModel: OrderModel(
                          code: code,
                          details: 'Ordine eseguito da ' + dataBundleNotifier.dataBundleList[0].firstName + ' ' +
                              dataBundleNotifier.dataBundleList[0].lastName + ' per ' +
                              dataBundleNotifier.currentBranch.companyName + '. Da consegnare in ${dataBundleNotifier.currentStorage.address} a ${dataBundleNotifier.currentStorage.city} CAP: ${dataBundleNotifier.currentStorage.cap.toString()}.',
                          total: 0.0,
                          status: OrderState.DRAFT,
                          creation_date: DateTime.now().millisecondsSinceEpoch,
                          delivery_date: null,
                          fk_branch_id: dataBundleNotifier.currentBranch.pkBranchId,
                          fk_storage_id: dataBundleNotifier.currentStorage.pkStorageId,
                          fk_user_id: dataBundleNotifier.dataBundleList[0].id,
                          pk_order_id: 0,
                          fk_supplier_id: widget.currentSupplier.pkSupplierId
                      ),
                      actionModel: ActionModel(
                          date: DateTime.now().millisecondsSinceEpoch,
                          description: 'Ha creato l\'ordine #$code per il fornitore ${widget.currentSupplier.nome} per conto di ' + dataBundleNotifier.currentBranch.companyName,
                          fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                          user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                          type: ActionType.DRAFT_ORDER_CREATION
                      )
                  );

                  if(performSaveOrderId != null){
                    dataBundleNotifier.currentProductModelListForSupplier.forEach((element) {
                      dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(
                          element.prezzo_lordo,
                          element.pkProductId,
                          performSaveOrderId.data
                      );
                    });
                  }

                  if(performSaveOrderId != null){
                    Response sendEmailResponse = await dataBundleNotifier.getEmailServiceInstance().sendEmail(
                        supplierName: widget.currentSupplier.nome,
                        branchName: dataBundleNotifier.currentBranch.companyName,
                        message: OrderUtils.buildMessageFromCurrentOrderList(dataBundleNotifier.currentProductModelListForSupplier),
                        orderCode: code,
                        supplierEmail: widget.currentSupplier.mail,
                        userEmail: dataBundleNotifier.dataBundleList[0].email,
                        userName: dataBundleNotifier.dataBundleList[0].firstName,
                        addressBranch: currentStorageModel.address + ' ' + currentStorageModel.city + ' ' + currentStorageModel.cap.toString(),
                        deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString());

                    if (sendEmailResponse.data == 'OK') {
                      print('Save order as SENT. OrderId: ' + performSaveOrderId.data.toString() );
                      await dataBundleNotifier
                          .getclientServiceInstance()
                          .updateOrderStatus(
                          orderModel: OrderModel(
                              pk_order_id: performSaveOrderId.data,
                              status: OrderState.SENT,
                              delivery_date:
                              currentDate.millisecondsSinceEpoch,
                              closedby: dataBundleNotifier
                                  .retrieveNameLastNameCurrentUser()),
                          actionModel: ActionModel(
                              date: DateTime.now().millisecondsSinceEpoch,
                              description:
                              'Ha inviato l\'ordine #${code} '
                                  'al fornitore ${widget.currentSupplier.nome}. ',
                              fkBranchId: dataBundleNotifier
                                  .currentBranch.pkBranchId,
                              user: dataBundleNotifier
                                  .retrieveNameLastNameCurrentUser(),
                              type: ActionType.SENT_ORDER));
                      dataBundleNotifier
                          .setCurrentBranch(dataBundleNotifier.currentBranch);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersScreen(),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                var height =
                                    MediaQuery.of(context).size.height;
                                var width =
                                    MediaQuery.of(context).size.width;
                                return SizedBox(
                                  height: height - 250,
                                  width: width - 90,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                            BorderRadius.only(
                                                topRight:
                                                Radius.circular(
                                                    10.0),
                                                topLeft:
                                                Radius.circular(
                                                    10.0)),
                                            color: kPrimaryColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    '  Errore invio ordine',
                                                    style: TextStyle(
                                                      fontSize:
                                                      getProportionateScreenWidth(
                                                          20),
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: kCustomWhite,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text('E\' stato riscontrato un errore durate l\'invio dell\'ordine. Controlla che la mail sia giusta oppure riprova fra un paio di minuti. L\'ordine è stato salvato come bozza.' ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // buildDateList(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ));
                    }
                  }



                },
                color: Colors.green.shade900.withOpacity(0.8),
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.black54.withOpacity(0.6),
              centerTitle: true,
              title: Text(
                'Conferma Ordine',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  color: kCustomWhite,
                ),
              ),
              elevation: 2,
            ),
            body: FutureBuilder(
              initialData: <Widget>[
                const Center(
                    child: CircularProgressIndicator(
                      color: kPinaColor,
                    )),
                const SizedBox(),
                Column(
                  children: const [
                    Center(
                      child: Text(
                        'Caricamento prodotti..',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kPrimaryColor,
                            fontFamily: 'LoraFont'),
                      ),
                    ),
                  ],
                ),
              ],
              future: buildProductPage(dataBundleNotifier, widget.currentSupplier),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: snapshot.data,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future buildProductPage(DataBundleNotifier dataBundleNotifier, ResponseAnagraficaFornitori supplier) async {
    List<Widget> list = [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Card(
              child: Column(
                children: [
                  Text(widget.currentSupplier.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(25), color: Colors.deepOrangeAccent),),
                  Text('#' + code, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17)),),
                  Divider(endIndent: 40, indent: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('  Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(dataBundleNotifier.dataBundleList[0].firstName + ' ' + dataBundleNotifier.dataBundleList[0].lastName + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('  Ordine creato il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(buildDateFromMilliseconds(DateTime.now().millisecondsSinceEpoch)  + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Selezionare il magazzino a cui consegnare l\'ordine: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900.withOpacity(0.6), fontSize: 7),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: DropdownWithSearch(
                        title: 'Seleziona Magazzino',
                        placeHolder: 'Ricerca Magazzino',
                        disabled: false,
                        items: dataBundleNotifier.currentStorageList.map((StorageModel storageModel) {
                          return storageModel.pkStorageId.toString() + ' - ' + storageModel.name;
                        }).toList(),
                        selected: _selectedStorage,
                        onChanged: (storage) {
                          setCurrentStorage(storage, dataBundleNotifier);
                        },
                      ),
                    ),
                  ),
                  Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                  _selectedStorage == 'Seleziona Magazzino' ? SizedBox(height: 0,) : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  Da consegnare a: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.companyName + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          currentStorageModel == null ? Text('') : Text(currentStorageModel.address + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                          currentStorageModel == null ? Text('') : Text(currentStorageModel.city + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('  CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                          currentStorageModel == null ? Text('') : Text(currentStorageModel.cap.toString() + '  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                        ],
                      ),
                      Divider(endIndent: 40, indent: 40, height: getProportionateScreenHeight(30),),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        currentDate == null ? CupertinoButton(
                          child:
                          const Text('Seleziona data consegna'),
                          color: Colors.blueAccent,
                          onPressed: () => _selectDate(context),
                        ) : SizedBox(height: 0,),
                        currentDate == null
                            ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(''),
                            )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('  '),
                                const Text('Data Consegna: ', style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(buildDateFromMilliseconds(currentDate.millisecondsSinceEpoch), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange.shade900.withOpacity(0.9)),),
                                IconButton(onPressed: () => _selectDate(context), icon: Icon(Icons.edit, color: Colors.green.shade900.withOpacity(0.9),)),
                              ],
                            ),
                          ],
                        ),
                        currentDate != null && currentStorageModel != null ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Una volta confermato l\'ordine verrà inviata una mail a ${widget.currentSupplier.mail}.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, ),),
                        ) : Text('  '),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    if(dataBundleNotifier.currentProductModelListForSupplier.isEmpty){
      list.add(Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato')),
        ],
      ),);
      return list;
    }
    list.add(Center(child: Text(supplier.nome)));
    dataBundleNotifier.currentProductModelListForSupplierDuplicated.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.prezzo_lordo.toString());

      if(currentProduct.prezzo_lordo != 0){
        list.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentProduct.nome, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(15)),),
                      Text(currentProduct.unita_misura, style: TextStyle( fontSize: getProportionateScreenWidth(12))),
                    ],
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.loose(Size(
                            getProportionateScreenWidth(70),
                            getProportionateScreenWidth(60))),
                        child: CupertinoTextField(
                          controller: controller,
                          enabled: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          clearButtonMode: OverlayVisibilityMode.never,
                          textAlign: TextAlign.center,
                          autocorrect: false,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ));
      }
    });

    list.add(Column(
      children: const [
        SizedBox(height: 80,),
      ],
    ));
    return list;
  }

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString();
  }

  void setCurrentStorage(String storage, DataBundleNotifier dataBundleNotifier) {
    setState(() {
      _selectedStorage = storage;
    });

    currentStorageModel = dataBundleNotifier.retrieveStorageFromStorageListByIdName(storage);
    print(currentStorageModel.toMap());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }
}
