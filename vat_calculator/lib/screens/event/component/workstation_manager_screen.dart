import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/move_product_between_storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/product_datasource_events.dart';
import '../../../client/vatservice/client_vatservice.dart';
import '../../../client/vatservice/model/expence_event_model.dart';
import '../../../client/vatservice/model/storage_product_model.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_manager_screen.dart';

class WorkstationManagerScreen extends StatefulWidget {
  const WorkstationManagerScreen({Key key,
    this.eventModel,
    this.workstationModel}) : super(key: key);

  final EventModel eventModel;
  final WorkstationModel workstationModel;

  @override
  State<WorkstationManagerScreen> createState() => _WorkstationManagerScreenState();
}

class _WorkstationManagerScreenState extends State<WorkstationManagerScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loadPaxController = TextEditingController(text: '');
  List<StorageProductModel> currentStorageProductModelList = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Consumer<DataBundleNotifier>(
        builder: (child, dataBundleNotifier, _){
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              key: _scaffoldKey,
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: Colors.lightBlueAccent,
                  indicatorWeight: 2,
                  tabs: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CARICO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('SCARICO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset('assets/icons/Settings.svg', color:Colors.white, height: getProportionateScreenHeight(25),)
                    ),
                  ],
                ),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      Navigator.of(context).pop(),
                    }),
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
                elevation: 5,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.workstationModel.name,
                      style: TextStyle(fontSize: getProportionateScreenHeight(19), color: Colors.white, fontWeight: FontWeight.bold),),
                    Text(
                      'Tipo workstation: ' + widget.workstationModel.type,
                      style: TextStyle(fontSize: getProportionateScreenHeight(10), color: Colors.green, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  buildRefillWorkstationProductsPage(dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId], dataBundleNotifier),
                  buildUnloadWorkstationProductsPage(dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId], dataBundleNotifier),
                  dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? getPriviledgeWarningContainer() : buildConfigurationWorkstationPage(widget.workstationModel, dataBundleNotifier),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildUnloadWorkstationProductsPage(List<WorkstationProductModel> workStationProdModelList, DataBundleNotifier dataBundleNotifier) {
    List<Widget> rows = [
      widget.eventModel.closed == 'Y' ? Container(
        child: SizedBox(
          width: getProportionateScreenWidth(500),
          child: Container(color: kCustomBordeaux, child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(child: Text('EVENTO CHIUSO', style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white),)),
          )),
        ),
      ) : SizedBox(width: 0,),
    ];
    if(workStationProdModelList != null){
      workStationProdModelList.forEach((element) {
        TextEditingController controller;
        bool isError = false;
        if(element.consumed == 0){
          controller = TextEditingController();
        }else{
          controller = TextEditingController(text: element.consumed.toStringAsFixed(2).replaceAll('.00', ''));
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        }
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
                      ' ' + element.productName,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(18), color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          FontAwesomeIcons.dotCircle,
                          color: Colors.white,
                          size: getProportionateScreenWidth(3),
                        ),
                      ),
                      Text(element.refillStock.toStringAsFixed(2).replaceAll('.00', '') + ' x ',
                        style:
                        TextStyle(fontSize: getProportionateScreenWidth(10), color: Colors.grey),
                      ),

                      Text(element.unitMeasure,
                        style:
                        TextStyle(fontSize: getProportionateScreenWidth(10), color: Colors.green),
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
                        if (element.consumed <= 0) {
                        } else {
                          element.consumed--;
                        }
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.minus,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),

                  ConstrainedBox(
                    constraints: BoxConstraints.loose(
                      Size(getProportionateScreenWidth(70),
                        getProportionateScreenWidth(60),),

                    ),
                    child: CupertinoTextField(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0),),
                          border: Border.all(color: isError ? Colors.red : Colors.transparent),
                          color: Colors.white
                      ),
                      controller: controller,
                      onChanged: (text){

                        if(double.tryParse(text.replaceAll(',', '.')) != null){
                          element.consumed = double.parse(text.replaceAll(',', '.'));
                        }
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      clearButtonMode: OverlayVisibilityMode.never,
                      textAlign: TextAlign.center,
                      autocorrect: false,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(element.consumed + 1 > element.refillStock){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                              'Non puoi sforare la quantità di carico di [${element.refillStock.toStringAsFixed(2)} ${element.unitMeasure}] configurata per ${element.productName}'),
                        ));
                      }else{
                        setState(() {
                          element.consumed = element.consumed + 1;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FontAwesomeIcons.plus,
                          color: Colors.lightGreenAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        rows.add(Divider(color: Colors.grey.withOpacity(0.2), indent: 5, endIndent: 10, height: 10,));
      });
    }

    rows.add(Divider(height: getProportionateScreenHeight(100), indent: 30, endIndent: 30,));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
          children: [

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: rows,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 0,),
                Container(
                  color: kPrimaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 15.0),
                    child: DefaultButton(
                      text: 'Effettua Scarico',
                      press: () async {
                        if(widget.eventModel.closed == 'Y'){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: kPinaColor,
                            duration: Duration(milliseconds: 3000),
                            content: Text(
                                'L\'evento ${widget.eventModel.eventName} è chiuso. Non puoi effettuare lo scarico.'),
                          ));
                        }else{
                          try{
                            bool isValid = true;
                            for(WorkstationProductModel workProd in dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId]){

                              if(workProd.refillStock < workProd.consumed){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  backgroundColor: kPinaColor,
                                  duration: Duration(milliseconds: 5000),
                                  content: Text(
                                      'Impossibile effettuare scarico di ${workProd.consumed.toStringAsFixed(2)} ${workProd.unitMeasure} per ${workProd.productName}. La quantità selezionata eccede quella di carico [${workProd.refillStock.toStringAsFixed(2)} ${workProd.unitMeasure}] configurata '),
                                ));
                                isValid = false;
                                break;
                              }
                            }
                            if(isValid){
                              await dataBundleNotifier.getclientServiceInstance().updateWorkstationProductModel(
                                  dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId],
                                  ActionModel(
                                      date: DateTime.now().millisecondsSinceEpoch,
                                      description: 'Ha effettuato scarico per postazione ${widget.workstationModel.name} (${widget.workstationModel.type}) in evento ${widget.eventModel.eventName}',
                                      fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                      user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                      type: ActionType.EVENT_STORAGE_UNLOAD, pkActionId: null
                                  )
                              );
                              dataBundleNotifier.workstationsProductsMapCalculate();
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.green.withOpacity(0.8),
                                duration: Duration(milliseconds: 600),
                                content: Text(
                                    'Scarico per ${widget.workstationModel.name} registrato'),
                              ));
                            }
                          }catch(e){
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: kPinaColor,
                              content: Text(
                                  'Errore durante operazione di scarico bar ' +
                                      e),
                            ));
                          }
                        }

                      },
                      color: kCustomBordeaux,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  buildRefillWorkstationProductsPage(List<WorkstationProductModel> workStationProdModelList, DataBundleNotifier dataBundleNotifier) {

    List<Widget> rows = [
      widget.eventModel.closed == 'Y' ? Container(
        child: SizedBox(
          width: getProportionateScreenWidth(500),
          child: Container(color: kCustomBordeaux, child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(child: Text('EVENTO CHIUSO', style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white),)),
          )),
        ),
      ) : SizedBox(width: 0,),
      SizedBox(
        width: getProportionateScreenWidth(350),
        child: TextButton(
          child: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Aggiungi prodotti', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(15), fontWeight: FontWeight.bold),),
              Icon(Icons.add, color: Colors.white),
            ],
          )),
          onPressed: () async {

            if(widget.eventModel.closed == 'Y'){
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: kPinaColor,
                duration: Duration(milliseconds: 3000),
                content: Text(
                    'L\'evento ${widget.eventModel.eventName} è chiuso. Non puoi aggiungere prodotti alla postazione.'),
              ));
            }else{
              currentStorageProductModelList = await retrieveProductListFromChoicedStorage(dataBundleNotifier.getStorageModelById(widget.eventModel.fkStorageId));
              currentStorageProductModelList.removeWhere((element) => getIdsProductListAlreadyPresent(workStationProdModelList).contains(element.fkProductId));

              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: Builder(
                      builder: (context) {
                        List<DataColumn> kTableColumns = <DataColumn>[
                          const DataColumn(
                            label: Text('Prodotto'),
                          ),
                          const DataColumn(
                            label: Text('Giacenza'),
                            numeric: true,
                          ),
                          const DataColumn(
                            label: Text('Q/100'),
                            numeric: true,
                          ),
                        ];
                        return SizedBox(
                          width: getProportionateScreenWidth(900),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0)),
                                    color: kPrimaryColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '  Lista Prodotti',
                                        style: TextStyle(
                                          fontSize:
                                          getProportionateScreenWidth(17),
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Magazzino di riferimento: ' + dataBundleNotifier.getStorageModelById(widget.eventModel.fkStorageId).name,
                                  style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                PaginatedDataTable(
                                  rowsPerPage: 5,
                                  availableRowsPerPage: const <int>[5],

                                  columns: kTableColumns,
                                  source: ProductDataSourceEvents(currentStorageProductModelList),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(310),
                                  child: CupertinoButton(
                                    onPressed: () async {

                                      currentStorageProductModelList.forEach((element) {
                                        print(element.selected.toString());
                                      });

                                      await dataBundleNotifier
                                          .getclientServiceInstance()
                                          .createRelationBetweenWorkstationsAndProductStorage([widget.workstationModel.pkWorkstationId], getIdsListFromCurrentStorageProductList(currentStorageProductModelList));

                                      List<WorkstationProductModel> workStationProdModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(widget.workstationModel);

                                      //setState(() {
                                      //  dataBundleNotifier.workStationProdModelList.clear();
                                      //  dataBundleNotifier.workStationProdModelList.addAll(workStationProdModelList);
                                      //});

                                      dataBundleNotifier.workstationsProductsMapCalculate();
                                      Navigator.of(context).pop();

                                    },
                                    child: Text('Aggiungi'),
                                    color: kCustomGreenAccent,
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

          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 10),
        child: SizedBox(
          width: getProportionateScreenWidth(350),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            child: Text( loadPaxController.text == '' || loadPaxController.text == '0' ?
            'Configurare numero clienti per carico':
            'Carico per ${loadPaxController.text} persone', style: TextStyle(color: Colors.white)),
            onPressed: () async {
                if(widget.eventModel.closed == 'Y'){
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: kPinaColor,
                duration: Duration(milliseconds: 3000),
                content: Text(
                'L\'evento ${widget.eventModel.eventName} è chiuso. Non puoi eseguire il carico per la postazione corrente.'),
                ));
                }else{
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
                        backgroundColor: kCustomWhite,
                        contentPadding: const EdgeInsets.only(top: 10.0),
                        elevation: 30,

                        content: SizedBox(
                          height: getProportionateScreenHeight(250),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Persone attese all\'evento', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints.loose(Size(
                                              getProportionateScreenWidth(300),
                                              getProportionateScreenWidth(80))),
                                          child: CupertinoTextField(
                                            controller: loadPaxController,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            clearButtonMode: OverlayVisibilityMode.never,
                                            textAlign: TextAlign.center,
                                            autocorrect: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(25),
                                  ),
                                  InkWell(
                                    child: Container(
                                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                        decoration: const BoxDecoration(
                                          color: kCustomGreenAccent,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(25.0),
                                              bottomRight: Radius.circular(25.0)),
                                        ),
                                        child: SizedBox(
                                          width: getProportionateScreenWidth(300),
                                          child: CupertinoButton(child: const Text('Configura', style: TextStyle(fontWeight: FontWeight.bold)), color: kCustomGreenAccent, onPressed: () async {

                                            if (double.tryParse(loadPaxController.text.replaceAll(",", ".")) != null) {
                                              double currentValue = double.parse(loadPaxController.text.replaceAll(",", "."));
                                              setState(() {
                                                workStationProdModelList.forEach((workstationProd) {
                                                  workstationProd.refillStock = workstationProd.amountHunderd * (currentValue/100);
                                                });
                                              });

                                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                backgroundColor: Colors.green.withOpacity(0.9),
                                                duration: Duration(milliseconds: 3000),
                                                content: Text(
                                                    'Carico configurato per ${loadPaxController.text} persone. Ricorda di salvare;)'),
                                              ));
                                            } else {
                                              _scaffoldKey.currentState.showSnackBar(const SnackBar(
                                                backgroundColor: kPinaColor,
                                                duration: Duration(milliseconds: 600),
                                                content: Text(
                                                    'Immettere un valore numerico corretto per effettuare il carico'),
                                              ));
                                            }
                                            Navigator.of(context).pop();

                                          }
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  );
                }
            },
          ),
        ),
      ),
    ];

    if(workStationProdModelList != null){
      workStationProdModelList.forEach((element) {
        TextEditingController controller;
        if(element.refillStock == 0){
          controller = TextEditingController();
        }else{
          controller = TextEditingController(text: element.refillStock.toStringAsFixed(2).replaceAll('.00', ''));
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        }
        rows.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 1, 8, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    if(dataBundleNotifier.currentBranch.accessPrivilege != Privileges.EMPLOYEE){
                      TextEditingController amountController;
                      if(element.amountHunderd != 0){
                        amountController = TextEditingController(text: element.amountHunderd.toStringAsFixed(2).replaceAll('.00', ''));
                      }else{
                        amountController = TextEditingController();
                      }

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0))),
                            backgroundColor: kCustomWhite,
                            contentPadding: const EdgeInsets.only(top: 10.0),
                            elevation: 30,

                            content: SizedBox(
                              height: getProportionateScreenHeight(250),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Configura Q/100 per ${element.productName}', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints.loose(Size(
                                                getProportionateScreenWidth(250),
                                                getProportionateScreenWidth(60))),
                                            child: CupertinoTextField(
                                              controller: amountController,
                                              textInputAction: TextInputAction.next,
                                              keyboardType: const TextInputType.numberWithOptions(
                                                  decimal: true, signed: false),
                                              clearButtonMode: OverlayVisibilityMode.never,
                                              textAlign: TextAlign.center,
                                              autocorrect: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: getProportionateScreenHeight(25),
                                      ),
                                      InkWell(
                                        child: Container(
                                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                            decoration: const BoxDecoration(
                                              color: Colors.lightBlue,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(25.0),
                                                  bottomRight: Radius.circular(25.0)),
                                            ),
                                            child: SizedBox(
                                              width: getProportionateScreenWidth(500),
                                              child: CupertinoButton(child: const Text('Configura Q/100', style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.lightBlue, onPressed: () async {
                                                if (double.tryParse(amountController.text.replaceAll(",", ".")) != null) {
                                                  try{
                                                    double currentValue = double.parse(amountController.text.replaceAll(",", "."));
                                                    dataBundleNotifier.getclientServiceInstance().updateAmountHundredIntoStorage(currentValue, element.fkStorProdId);
                                                    setState(() {
                                                      element.amountHunderd = currentValue;
                                                    });
                                                  }catch(e){
                                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                      backgroundColor: kPinaColor,
                                                      duration: Duration(milliseconds: 600),
                                                      content: Text(
                                                          'Errore configurazione Q/100. ' + e),
                                                    ));
                                                  }
                                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                    backgroundColor: Colors.green.withOpacity(0.9),
                                                    duration: Duration(milliseconds: 1600),
                                                    content: Text(
                                                        'Configurato Q/100 ${amountController.text} per ${element.productName}'),
                                                  ));
                                                } else {
                                                  _scaffoldKey.currentState.showSnackBar(const SnackBar(
                                                    backgroundColor: kPinaColor,
                                                    duration: Duration(milliseconds: 1600),
                                                    content: Text(
                                                        'Immettere un valore numerico corretto per effettuare il carico'),
                                                  ));
                                                }
                                                Navigator.of(context).pop();
                                              }
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: Text(
                          element.productName,
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(15), color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            element.amountHunderd.toStringAsFixed(2).replaceAll('.00', ''),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenWidth(11), color: Colors.lightBlueAccent),
                          ),
                          Text(
                            ' ' + element.unitMeasure + ' x 100/pax' ,
                            style:
                            TextStyle(fontSize: getProportionateScreenWidth(11), color: Colors.grey.shade50),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Stock Magazzino: ',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenWidth(11), color: Colors.grey),
                          ),
                          Text(
                            ' ' + element.storeStock.toStringAsFixed(2),
                            style:
                            TextStyle(fontSize: getProportionateScreenWidth(11), color: element.storeStock > 0  ? Colors.green : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (element.refillStock <= 1) {
                            dataBundleNotifier.getclientServiceInstance().removeProductFromWorkstation(element);
                            workStationProdModelList.remove(element);

                            dataBundleNotifier.getclientServiceInstance()
                                .moveProductBetweenStorage(listMoveProductBetweenStorageModel: [
                              MoveProductBetweenStorageModel(
                                  pkProductId: element.fkProductId,
                                  storageIdFrom: 0,
                                  storageIdTo: widget.eventModel.fkStorageId,
                                  amount: element.backupRefillStock)
                            ],
                                actionModel: ActionModel(
                                )
                            );
                            dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent.withOpacity(0.9),
                              duration: Duration(milliseconds: 1000),
                              content: Text(
                                  'Prodotto ${element.productName} eliminato'),
                            ));
                          } else {
                            element.refillStock--;
                          }
                        });

                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.minus,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(Size(
                          getProportionateScreenWidth(70),
                          getProportionateScreenWidth(60))),
                      child: CupertinoTextField(
                        controller: controller,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        onChanged: (value){
                          if(double.tryParse(value.replaceAll(',', '.')) != null){
                            element.refillStock = double.parse(double.parse(value.replaceAll(',', '.')).toStringAsFixed(2));
                          }
                        },
                        clearButtonMode: OverlayVisibilityMode.never,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          element.refillStock = element.refillStock + 1;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.plus,
                            color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        rows.add(Divider(color: Colors.grey.withOpacity(0.3), height: 12, indent: 7,));
      });
    }


    rows.add(Divider(color: Colors.black.withOpacity(0.3), height: 132, indent: 7,));
    return Container(
      color: kPrimaryColor,
      child: Stack(
        children: [
          SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: rows,
            ),
          ),
        ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 0,),
              Padding(
                padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 15.0),
                child: DefaultButton(

                  text: 'Effettua Carico',
                  press: () async {
                    if(widget.eventModel.closed == 'Y'){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: kPinaColor,
                        duration: Duration(milliseconds: 3000),
                        content: Text(
                            'L\'evento ${widget.eventModel.eventName} è chiuso. Non puoi effettuare il carico.'),
                      ));
                    }else{
                      try{
                        bool isEverthingOk = true;
                        String productWrong = '';

                        dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId].forEach((prodModel) {
                          if(double.tryParse(prodModel.refillStock.toString()) != null){
                            print(prodModel.productName + ' ok as refillStock value');
                          }else{
                            isEverthingOk = false;
                            productWrong = prodModel.productName;
                          }
                        });

                        if(isEverthingOk){
                          List<MoveProductBetweenStorageModel> unloadProdList = [];


                          dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId].forEach((element) {


                              if(element.refillStock != element.backupRefillStock){
                                unloadProdList.add(
                                    MoveProductBetweenStorageModel(
                                        storageIdTo: widget.eventModel.fkStorageId,
                                        storageIdFrom: 0,
                                        pkProductId: element.fkProductId,
                                        amount: element.backupRefillStock - element.refillStock
                                    )
                                );
                              }
                          });

                          await dataBundleNotifier.getclientServiceInstance()
                              .moveProductBetweenStorage(listMoveProductBetweenStorageModel: unloadProdList,
                              actionModel: ActionModel(
                              )
                          );

                          dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);

                          await dataBundleNotifier.getclientServiceInstance().updateWorkstationProductModel(
                              dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId],
                              ActionModel(
                                  date: DateTime.now().millisecondsSinceEpoch,
                                  description: 'Ha effettuato carico per postazione ${widget.workstationModel.name} (${widget.workstationModel.type}) in evento ${widget.eventModel.eventName}',
                                  fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                  user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                  type: ActionType.EVENT_STORAGE_LOAD, pkActionId: null
                              )
                          );

                          dataBundleNotifier.workstationsProductsMapCalculate();

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.green.withOpacity(0.8),
                            duration: Duration(milliseconds: 600),
                            content: Text(
                                'Carico per ${widget.workstationModel.name} effettuato'),
                          ));
                        }else{
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: kPinaColor,
                            content: Text(
                                'Immettere un valore numerico corretto per $productWrong'),
                          ));
                        }


                      }catch(e){
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Errore durante operazione di scarico bar ' +
                                  e),
                        ));
                      }
                    }

                  },
                  color: kCustomGreenAccent,
                ),
              ),
            ],
          ),
      ],
        ),
    );
  }

  getPriviledgeWarningContainer() {
    return Container(
      color: kPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SvgPicture.asset('assets/icons/warning.svg', color: kCustomOrange, height: 100,),
              Text('WARNING', textAlign: TextAlign.center, style: TextStyle(color: kCustomOrange)),                        ],
          ),
          Center(child: SizedBox(
              width: getProportionateScreenWidth(350),
              height: getProportionateScreenHeight(150),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('Utente non abilitato alla visualizzazione ed all\'utilizzo di questa sezione', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15),)),
              )),),
        ],
      ),
    );
  }

  buildConfigurationWorkstationPage(WorkstationModel workstationModel, DataBundleNotifier dataBundleNotifier) {

    TextEditingController controllerWorkStationName = TextEditingController(text: workstationModel.name);
    TextEditingController controllerResponsible = TextEditingController(text: workstationModel.responsable);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Row(
                children: const [
                  Text('Nome Postazione*',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              CupertinoTextField(
                textInputAction: TextInputAction.next,
                restorationId: 'Nome Postazione',
                keyboardType: TextInputType.text,
                controller: controllerWorkStationName,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                placeholder: 'Nome Postazione',
              ),
              Row(
                children: const [
                  Text('Responsabile',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              CupertinoTextField(
                textInputAction: TextInputAction.next,
                restorationId: 'Responsabile',
                keyboardType: TextInputType.text,
                controller: controllerResponsible,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                placeholder: 'Responsabile',
              ),
              const Text('*campo obbligatorio'),
              SizedBox(height: getProportionateScreenHeight(10),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: CupertinoButton(
                        color: kCustomGreenAccent,
                        child: const Text('Salva Impostazioni'),
                        onPressed: () async {
                          if(controllerWorkStationName.text == null || controllerWorkStationName.text == ''){
                            print('Il nome della postazione è obbligatorio');
                            _scaffoldKey.currentState.showSnackBar(const SnackBar(
                              backgroundColor: kPinaColor,
                              duration: Duration(milliseconds: 600),
                              content: Text(
                                  'Il nome della postazione è obbligatorio'),
                            ));
                          }else{
                            KeyboardUtil.hideKeyboard(context);
                            try{
                              workstationModel.name = controllerWorkStationName.text;
                              workstationModel.responsable = controllerResponsible.text;

                              await dataBundleNotifier.getclientServiceInstance().updateWorkstationDetails(workstationModel);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 5000),
                                  backgroundColor: Colors.green.withOpacity(0.9),
                                  content: const Text('Impostazioni aggiornate', style: TextStyle(color: Colors.white),)));
                            }catch(e){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 5000),
                                  backgroundColor: Colors.red,
                                  content: Text('Impossibile creare fornitore. Riprova più tardi. Errore: $e', style: TextStyle(color: Colors.white),)));
                            }
                          }

                        }),
                  ),
                ],
              ),
              Divider(
                height: getProportionateScreenHeight(50),
                color: kPrimaryColor,
                endIndent: 50,
                indent: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: CupertinoButton(
                        color: Colors.red.shade700.withOpacity(0.9),
                        child: Text('Elimina ${widget.workstationModel.name}'),
                        onPressed: () async {
                          if(widget.eventModel.closed == 'Y'){
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: kPinaColor,
                              duration: Duration(milliseconds: 3000),
                              content: Text(
                                  'L\'evento ${widget.eventModel.eventName} è chiuso. Non puoi eliminare la postazione.'),
                            ));
                          }else{
                            try{
                              await dataBundleNotifier.getclientServiceInstance().removeWorkstation(workstationModel);

                              List<WorkstationModel> workstationModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(widget.eventModel);
                              List<ExpenceEventModel> listExpenceEvent = await dataBundleNotifier.getclientServiceInstance().retrieveEventExpencesByEventId(widget.eventModel);

                              dataBundleNotifier.setCurrentExpenceEventList(listExpenceEvent);
                              dataBundleNotifier.setCurrentWorkstationModelList(workstationModelList);
                              dataBundleNotifier.setCurrentEventModel(widget.eventModel);

                              sleep(const Duration(milliseconds: 200));
                              Navigator.pushNamed(context, EventManagerScreen.routeName);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.green.withOpacity(0.9),
                                  content: Text('Eliminata la postazione ${widget.workstationModel.name}', style: const TextStyle(color: Colors.white),)));

                            }catch(e){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 5000),
                                  backgroundColor: Colors.red,
                                  content: Text('Impossibile eliminare postazione ${widget.workstationModel.name}. Riprova più tardi. Errore: $e', style: TextStyle(color: Colors.white),)));
                            }
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<StorageProductModel>> retrieveProductListFromChoicedStorage(StorageModel currentStorageModel) async {
    ClientVatService clientVatService = ClientVatService();
    List<StorageProductModel> storageProductModelList = await clientVatService.retrieveRelationalModelProductsStorage(currentStorageModel.pkStorageId);
    return storageProductModelList;
  }

  List<int> getIdsProductListAlreadyPresent(List<WorkstationProductModel> workStationProdModelList) {
    List<int> idsList = [];
    workStationProdModelList.forEach((element) {
      idsList.add(element.fkProductId);
    });

    return idsList;
  }

  List<int> getIdsListFromCurrentStorageProductList(List<StorageProductModel> currentStorageProductModelList) {

    List<int> ids = [];
    currentStorageProductModelList.forEach((currentStorageProdutct) {
      if(currentStorageProdutct.selected){
        ids.add(currentStorageProdutct.pkStorageProductId);
      }
    });
    return ids;
  }
}
