import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/orders/components/screens/orders_utils.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../orders_screen.dart';

class DraftOrderConfirmationScreen extends StatefulWidget {
  const DraftOrderConfirmationScreen({Key key, this.currentSupplier, this.draftOrder}) : super(key: key);

  static String routeName = 'draftordersendscreen';

  final ResponseAnagraficaFornitori currentSupplier;
  final OrderModel draftOrder;

  @override
  State<DraftOrderConfirmationScreen> createState() => _DraftOrderConfirmationScreenState();
}

class _DraftOrderConfirmationScreenState extends State<DraftOrderConfirmationScreen> {

  String code = DateTime.now().microsecondsSinceEpoch.toString().substring(3,16);
  String _selectedStorage = 'Seleziona Magazzino';
  StorageModel currentStorageModel;

  DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {

        return LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.9,
          overlayWidget: const LoaderOverlayWidget(message: 'Invio ordine in corso...',),
          child: Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: 'Conferma ed Invia',
                press: () async {

                  try{
                    print('Performing send order ...');
                    context.loaderOverlay.show();
                    dataBundleNotifier.currentProdOrderModelList.forEach((element) async {
                      if(element.pkOrderProductId == 0){
                        await dataBundleNotifier.getclientServiceInstance().performSaveProductIntoOrder(element.amount, element.pkProductId, widget.draftOrder.pk_order_id);
                      }else{
                        await dataBundleNotifier.getclientServiceInstance().updateProductAmountIntoOrder(element.pkOrderProductId, element.amount, element.pkProductId, widget.draftOrder.pk_order_id);
                      }
                    });

                    if(_selectedStorage == 'Seleziona Magazzino'){
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.ERROR,
                        body: const Center(child: Text(
                          'Selezionare il magazzino',
                        ),),
                        title: 'This is Ignored',
                        desc:   'This is also Ignored',
                        btnOkOnPress: () {},
                      ).show();
                    }else if(currentStorageModel == null){
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.ERROR,
                        body: const Center(child: Text(
                          'Selezionare il magazzino',
                        ),),
                        title: 'This is Ignored',
                        desc:   'This is also Ignored',
                        btnOkOnPress: () {},
                      ).show();
                    }else if(currentDate == null) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.RIGHSLIDE,
                        dialogType: DialogType.ERROR,
                        body: const Center(child: Text(
                          'Selezionare la data di consegna',
                        ),),
                        title: 'This is Ignored',
                        desc:   'This is also Ignored',
                        btnOkOnPress: () {},
                      ).show();
                    }else{

                      Response sendEmailResponse = await dataBundleNotifier.getEmailServiceInstance().sendEmailByKontumServiceApi(
                          supplierName: widget.currentSupplier.nome,
                          branchName: dataBundleNotifier.currentBranch.companyName,

                          message: OrderUtils.buildMessageFromCurrentOrderListFromDraft(
                            orderId: code,
                            branchName: dataBundleNotifier.currentBranch.companyName,
                            orderProductList: dataBundleNotifier.currentProdOrderModelList,
                            deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString(),
                            supplierName: widget.currentSupplier.nome,
                            currentUserName: dataBundleNotifier.dataBundleList[0].firstName + ' ' + dataBundleNotifier.dataBundleList[0].lastName,
                            storageAddress: currentStorageModel.address,
                            storageCap: currentStorageModel.cap,
                            storageCity: currentStorageModel.city,
                          ),
                          orderCode: code,
                          supplierEmail: widget.currentSupplier.mail,
                          userEmail: dataBundleNotifier.dataBundleList[0].email,
                          userName: dataBundleNotifier.dataBundleList[0].firstName,
                          addressBranch: currentStorageModel.address,
                          addressBranchCap: currentStorageModel.cap,
                          addressBranchCity: currentStorageModel.city,
                          branchNumber: dataBundleNotifier.dataBundleList[0].phone,
                          deliveryDate: getDayFromWeekDay(currentDate.weekday) + ' ' + currentDate.day.toString() + '/' + currentDate.month.toString() + '/' + currentDate.year.toString());

                      print('sendEmailResponse.statusCode: ' + sendEmailResponse.statusCode.toString());
                      if (sendEmailResponse.statusCode == 200) {
                        await dataBundleNotifier
                            .getclientServiceInstance()
                            .updateOrderStatus(
                            orderModel: OrderModel(
                                pk_order_id: widget.draftOrder.pk_order_id,
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
                        dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
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
                                    height: height - 350,
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
                                              color: kPinaColor,
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
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text('E\' stato riscontrato un errore durate l\''
                                                    'invio dell\'ordine. Controlla che la mail ['+ widget.currentSupplier.mail +'] sia corretta oppure riprova fra '
                                                    'un paio di minuti.\n\n' , textAlign: TextAlign.center,),

                                                const Text('Se non disponi della mail puoi inviare il presente ordine tramite what\'s app.  ' , textAlign: TextAlign.center,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ));
                      }
                    }
                  }catch(e){
                    print('Errore da gestire');
                    context.loaderOverlay.show();
                  }finally{
                    context.loaderOverlay.show();
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
          ),
        );
      },
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
                  Text(widget.currentSupplier.nome, style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenHeight(25), color: Colors.yellow.shade800.withOpacity(0.9)),),
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
                      const Text('  In data: ', style: TextStyle(fontWeight: FontWeight.bold),),
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
                          color: Colors.black.withOpacity(0.8),
                          onPressed: () => _selectDate(context),
                        ) : SizedBox(height: 0,),
                        currentDate == null
                            ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(''),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              child:
                              Text(buildDateFromMilliseconds(currentDate.millisecondsSinceEpoch), style: TextStyle(color: kCustomYellow800),),
                              color: Colors.black.withOpacity(0.8),
                              onPressed: () => _selectDate(context),
                            )
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

    if(dataBundleNotifier.currentProdOrderModelList.isEmpty){
      list.add(Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
          const Center(child: Text('Nessun prodotto registrato')),
        ],
      ),);
      return list;
    }
    list.add(Center(child: Text(supplier.nome)));

    dataBundleNotifier.currentProdOrderModelList.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount.toString());

      if(currentProduct.amount != 0){
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
                      Text(currentProduct.prezzo_lordo.toString() + ' €', style: TextStyle( fontSize: getProportionateScreenWidth(12))),
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
    return getDayFromWeekDay(dateTime.weekday) + ' ' + dateTime.day.toString() + ' ' + getMonthFromMonthNumber(dateTime.month) + ' ' + dateTime.year.toString();
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
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              backgroundColor: Colors.black,
              dialogBackgroundColor: Colors.black,
              colorScheme: ColorScheme.dark(
                onSurface: kCustomYellow800,
                primary: kCustomYellow800,
                secondary: Colors.black.withOpacity(0.9),
                onSecondary: Colors.grey.withOpacity(0.9),
                background: Colors.black.withOpacity(0.9),
                onBackground: Colors.black.withOpacity(0.9),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: kCustomYellow800, // button// text color
                ),
              ),
            ),
            child: child,
          );
        },

        helpText: "Seleziona data consegna",
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
