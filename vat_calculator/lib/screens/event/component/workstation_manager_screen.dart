import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'event_manager_screen.dart';

class WorkstationManagerScreen extends StatefulWidget {
  const WorkstationManagerScreen({Key key, this.eventModel, this.workstationModel, this.workStationProdModelList, this.callbackFuntion}) : super(key: key);

  final EventModel eventModel;
  final WorkstationModel workstationModel;
  final List<WorkstationProductModel> workStationProdModelList;
  final Function callbackFuntion;

  @override
  State<WorkstationManagerScreen> createState() => _WorkstationManagerScreenState();
}

class _WorkstationManagerScreenState extends State<WorkstationManagerScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loadPaxController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {

    TextEditingController paxController = TextEditingController();

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              bottom: TabBar(
                indicatorColor: kCustomYellow800,
                indicatorWeight: 4,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('CONSUMI', style: TextStyle(color: kCustomYellow800, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('CARICO', style: TextStyle(color: kCustomYellow800, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icons/Settings.svg', color:kCustomYellow800, height: getProportionateScreenHeight(25),)
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.workstationModel.name,
                    style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomYellow800, fontWeight: FontWeight.bold),),
                  Text(
                    'Tipo workstation: ' + widget.workstationModel.type,
                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                buildUnloadWorkstationProductsPage(widget.workStationProdModelList, dataBundleNotifier),
                buildRefillWorkstationProductsPage(widget.workStationProdModelList, dataBundleNotifier),
                buildConfigurationWorkstationPage(widget.workstationModel, dataBundleNotifier),
              ],
            ),
          ),
        );
      },
    );
  }

  buildUnloadWorkstationProductsPage(List<WorkstationProductModel> workStationProdModelList, DataBundleNotifier dataBundleNotifier) {
    List<Widget> rows = [];
    workStationProdModelList.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.consumed.toString());
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
                    element.productName,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(16)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      element.unitMeasure,
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
                        element.consumed = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          duration: const Duration(milliseconds: 1600),
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  element.productName),
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
                      element.consumed = element.consumed + 1;
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
                  color: Colors.white,
                  child: DefaultButton(
                    text: 'Salva Consumo',
                    press: () async {
                      try{
                        await dataBundleNotifier.getclientServiceInstance().updateWorkstationProductModel(
                            widget.workStationProdModelList,
                            ActionModel(
                                date: DateTime.now().millisecondsSinceEpoch,
                                description: 'Ha effettuato scarico per postazione ${widget.workstationModel.name} (${widget.workstationModel.type}) in evento ${widget.eventModel.eventName}',
                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                type: ActionType.EVENT_STORAGE_UNLOAD, pkActionId: null
                            )
                        );
                        widget.callbackFuntion();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.green.withOpacity(0.8),
                          duration: Duration(milliseconds: 600),
                          content: Text(
                              'Consumo per ${widget.workstationModel.name} registrato'),
                        ));

                      }catch(e){
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Errore durante operazione di scarico bar ' +
                                  e),
                        ));
                      }
                    },
                    color: Colors.green.shade900.withOpacity(0.8),
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
      Divider(color: kCustomYellow800,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultButton(



          text: loadPaxController.text == '' || loadPaxController.text == 0 ?
          'Premi per configurare il numero di ospiti attesi':
          'Carico per ${loadPaxController.text} persone',
          press: () async {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: SizedBox(
                    height: getProportionateScreenHeight(200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Persone attese all\'evento'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints.loose(Size(
                                    getProportionateScreenWidth(180),
                                    getProportionateScreenWidth(60))),
                                child: CupertinoTextField(
                                  controller: loadPaxController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                                  clearButtonMode: OverlayVisibilityMode.never,
                                  textAlign: TextAlign.center,
                                  autocorrect: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(child: const Text('Configura'), color: Colors.green, onPressed: (){

                                  if (double.tryParse(loadPaxController.text.replaceAll(",", ".")) != null) {
                                    double currentValue = double.parse(loadPaxController.text.replaceAll(",", "."));
                                    setState(() {
                                      workStationProdModelList.forEach((workstationProd) {
                                        workstationProd.refillStock = workstationProd.amountHunderd * currentValue;
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
                                }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
          color: kCustomYellow800,
        ),
      ),
    ];

    workStationProdModelList.forEach((element) {
      TextEditingController controller = TextEditingController(text: element.refillStock.toStringAsFixed(2));
      rows.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 1, 8, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  TextEditingController amountController = TextEditingController(text: element.amountHunderd.toStringAsFixed(2));
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: SizedBox(
                          height: getProportionateScreenHeight(200),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Q/100 per ${element.productName}'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints.loose(Size(
                                          getProportionateScreenWidth(150),
                                          getProportionateScreenWidth(60))),
                                      child: CupertinoTextField(
                                        controller: amountController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                        clearButtonMode: OverlayVisibilityMode.never,
                                        textAlign: TextAlign.center,
                                        autocorrect: false,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CupertinoButton(child: const Text('Configura'), color: Colors.green, onPressed: (){

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
                                            duration: Duration(milliseconds: 600),
                                            content: Text(
                                                'Immettere un valore numerico corretto per effettuare il carico'),
                                          ));
                                        }
                                        Navigator.of(context).pop();
                                      }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  );
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(16), color: kCustomYellow800),
                      ),
                    ),
                    Row(
                      children: [

                        Text(
                          element.amountHunderd.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenWidth(10), color: customGreenAccent),
                        ),
                        Text(
                          ' ' + element.unitMeasure + ' x 100/pax' ,
                          style:
                          TextStyle(fontSize: getProportionateScreenWidth(10), color: Colors.white),
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
                        if (element.refillStock <= 0) {
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
                          decimal: true, signed: true),
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
    });
    return Container(
      color: kPrimaryColor,
      child: Stack(
        children: [ SingleChildScrollView(
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
                padding: const EdgeInsets.all(8.0),
                child: DefaultButton(

                  text: 'Effettua Carico',
                  press: () async {
                    try{

                      await dataBundleNotifier.getclientServiceInstance().updateWorkstationProductModel(
                          widget.workStationProdModelList,
                          ActionModel(
                              date: DateTime.now().millisecondsSinceEpoch,
                              description: 'Ha effettuato carico per postazione ${widget.workstationModel.name} (${widget.workstationModel.type}) in evento ${widget.eventModel.eventName}',
                              fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                              user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                              type: ActionType.EVENT_STORAGE_LOAD, pkActionId: null
                          )
                      );
                      widget.callbackFuntion();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.green.withOpacity(0.8),
                        duration: Duration(milliseconds: 600),
                        content: Text(
                            'Carico per ${widget.workstationModel.name} effettuato'),
                      ));

                    }catch(e){
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: kPinaColor,
                        content: Text(
                            'Errore durante operazione di scarico bar ' +
                                e),
                      ));
                    }
                  },
                  color: Colors.blueAccent.withOpacity(0.8),
                ),
              ),
            ],
          ),
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
                  Text('Nome Postazione*'),
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
                  Text('Responsabile'),
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
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: CupertinoButton(
                          color: Colors.green.shade700.withOpacity(0.8),
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
                                widget.callbackFuntion();
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
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: CupertinoButton(
                          color: Colors.red.shade700.withOpacity(0.9),
                          child: Text('Elimina ${widget.workstationModel.name}'),
                          onPressed: () async {
                            try{
                              await dataBundleNotifier.getclientServiceInstance().removeWorkstation(widget.workstationModel);
                              List<WorkstationModel> workstationModelList = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(widget.eventModel);

                              Navigator.push(context, MaterialPageRoute(builder: (context) => EventManagerScreen(
                                event: widget.eventModel,
                                workstationModelList: workstationModelList,
                              ),),);

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

                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
