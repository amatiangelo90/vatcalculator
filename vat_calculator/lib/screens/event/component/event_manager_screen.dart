import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_type.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/expence_event_reg_card.dart';
import 'package:vat_calculator/screens/event/component/recap_workstations_expences_widget.dart';
import 'package:vat_calculator/screens/event/component/workstation_card.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../client/vatservice/model/action_model.dart';
import '../../../client/vatservice/model/move_product_between_storage_model.dart';
import '../../../client/vatservice/model/utils/privileges.dart';
import '../../../constants.dart';
import '../../main_page.dart';
import '../event_home.dart';
import 'expence_event_edit_card.dart';

class EventManagerScreen extends StatefulWidget {

  static String routeName = 'eventmanagerscreen';

  @override
  State<EventManagerScreen> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(

              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                tabs: [
                  Tab(icon: SvgPicture.asset('assets/icons/party.svg', width: getProportionateScreenHeight(34),color: Colors.white,)),
                  Tab(icon: SvgPicture.asset('assets/icons/soldiout_white.svg', width: getProportionateScreenHeight(27),)),
                  Tab(icon: SvgPicture.asset('assets/icons/soldiout_white_orange.svg', width: getProportionateScreenHeight(27),)),
                  Tab(icon: SvgPicture.asset('assets/icons/Settings.svg', color: Colors.white,)),
                ],
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                  dataBundleNotifier.onItemTapped(0);
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(dataBundleNotifier.currentEventModel.eventName,
                    style: TextStyle(fontSize: getProportionateScreenHeight(20), color: Colors.white, fontWeight: FontWeight.bold),),
                  Text(
                    'Creato da: ' + dataBundleNotifier.currentEventModel.owner,
                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
              elevation: 5,
            ),
            backgroundColor: Colors.white,
            body: TabBarView(
              children: [
                buildWorkstationsManagmentScreen(dataBundleNotifier.currentWorkstationModelList, dataBundleNotifier, dataBundleNotifier.currentEventModel),
                dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? getPriviledgeWarningContainer() : RecapWorkstationsWidget(),
                dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? getPriviledgeWarningContainer() : buildResocontoScreenExtraExpences(dataBundleNotifier.currentWorkstationModelList, dataBundleNotifier, dataBundleNotifier.currentEventModel, context),
                dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? getPriviledgeWarningContainer() : buildEventSettingsScreen(dataBundleNotifier.currentEventModel, dataBundleNotifier, dataBundleNotifier.currentWorkstationModelList),
              ],
            ),
          ),
        );
      },
    );
  }

  buildWorkstationsManagmentScreen(List<WorkstationModel> workstationModelList, DataBundleNotifier dataBundleNotifier, EventModel event) {
    List<Widget> listWgBar = [];

    if(dataBundleNotifier.currentPrivilegeType != Privileges.EMPLOYEE){
      listWgBar.add(dataBundleNotifier.currentEventModel.closed == 'Y' ? SizedBox(width: 0,) : Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(180),
              child: Card(
                shadowColor: kCustomOrange,
                elevation: 5,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [ SvgPicture.asset(
                          'assets/icons/bartender.svg',
                          color: kCustomOrange,
                          width: 25,
                        ),
                          Positioned(
                            top: 26.0,
                            right: 9.0,
                            child: Stack(
                              children: <Widget>[
                                const Icon(
                                  Icons.brightness_1,
                                  size: 18,
                                  color: kPrimaryColor,
                                ),
                                Positioned(
                                  right: 2.5,
                                  top: 2.5,
                                  child: Center(
                                    child: Icon(Icons.add_circle_outline, size: 13, color: kCustomOrange,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text('CREA BAR', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(10)),)
                    ],
                  ),
                  onPressed: () async {
                    await dataBundleNotifier.getclientServiceInstance().createWorkstations([
                      WorkstationModel(
                          closed: 'N',
                          extra: '',
                          fkEventId: dataBundleNotifier.currentEventModel.pkEventId,
                          pkWorkstationId: 0,
                          name: 'Nuovo Bar',
                          responsable: '',
                          type: WORKSTATION_TYPE_BAR
                      )
                    ]);

                    List<WorkstationModel> workstationModelListNew = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(dataBundleNotifier.currentEventModel);

                    dataBundleNotifier.setCurrentWorkstationModelList(workstationModelListNew);
                    dataBundleNotifier.workstationsProductsMapCalculate();
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.green.withOpacity(0.8),
                        duration: const Duration(milliseconds: 800),
                        content: const Text('Nuova postazione Bar creata')));
                  },
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(190),
              child: Card(
                shadowColor: kCustomEvidenziatoreGreen,
                elevation: 5,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/bouvette.svg',
                            color: kCustomEvidenziatoreGreen,
                            width: 25,
                          ),
                          Positioned(
                            top: 26.0,
                            right: 9.0,
                            child: Stack(
                              children: const <Widget>[
                                Icon(
                                  Icons.brightness_1,
                                  size: 18,
                                  color: kPrimaryColor,
                                ),
                                Positioned(
                                  right: 2.5,
                                  top: 2.5,
                                  child: Center(
                                    child: Icon(Icons.add_circle_outline, size: 13, color: kCustomEvidenziatoreGreen,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text('CREA CHAMPAGNERIE', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(10)),)
                    ],
                  ),
                  onPressed: () async {
                    await dataBundleNotifier.getclientServiceInstance().createWorkstations([
                      WorkstationModel(
                          closed: 'N',
                          extra: '',
                          fkEventId: dataBundleNotifier.currentEventModel.pkEventId,
                          pkWorkstationId: 0,
                          name: 'Nuova Champagnerie',
                          responsable: '',
                          type: WORKSTATION_TYPE_CHAMP
                      )
                    ]);

                    List<WorkstationModel> workstationModelListNew = await dataBundleNotifier.getclientServiceInstance().retrieveWorkstationListByEventId(dataBundleNotifier.currentEventModel);

                    dataBundleNotifier.setCurrentWorkstationModelList(workstationModelListNew);
                    dataBundleNotifier.workstationsProductsMapCalculate();
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.green.withOpacity(0.8),
                        duration: Duration(milliseconds: 800),
                        content: Text('Nuova postazione Champagnerie creata')));
                  },
                ),
              ),
            ),
          ],
        ),
      ),);
    }



    if(event.closed == 'Y'){
      listWgBar.add(
        SizedBox(
          width: getProportionateScreenWidth(500),
          child: Container(color: kCustomBordeaux, child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(child: Text('EVENTO CHIUSO', style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white),)),
          )),
        ),
      );
    }
    workstationModelList.where((element) => element.type == WORKSTATION_TYPE_BAR).forEach((wkStation) {
      listWgBar.add(WorkstationCard(
        eventModel: dataBundleNotifier.currentEventModel,
        workstationModel: wkStation,
        isBarType : true,
      ),);
    });
    List<Widget> listWgChamp = [];
    workstationModelList.where((element) => element.type == WORKSTATION_TYPE_CHAMP).forEach((wkStation) {
      listWgChamp.add(WorkstationCard(
        eventModel: dataBundleNotifier.currentEventModel,
        workstationModel: wkStation,
        isBarType : false,
      ),);
    });

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Column(
            children: listWgBar.isNotEmpty ? listWgBar : [
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: Column(
                  children: listWgChamp.isNotEmpty ? listWgChamp : [
                    Center(
                      child: Text('Nessuna postazione Bar presente',textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenHeight(16))),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: listWgChamp.isNotEmpty ? listWgChamp : [
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: Column(
                  children: listWgChamp.isNotEmpty ? listWgChamp : [
                    Center(
                      child: Text('Nessuna postazione Champagnerie presente',textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenHeight(16))),
                    )
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 50),
        ])
    );
  }

  buildEventSettingsScreen(EventModel event, DataBundleNotifier dataBundleNotifier, workstationModelList) {

    TextEditingController controllerEventName = TextEditingController(text: event.eventName);
    TextEditingController controllerLocation = TextEditingController(text: event.location);
    List<Widget> widgetList = [];
    if(event.closed == 'Y'){
      widgetList.add(SizedBox(
        width: getProportionateScreenWidth(500),
        child: Container(color: kCustomBordeaux, child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(child: Text('EVENTO CHIUSO', style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white),)),
        )),
      ),);
    }

    widgetList.addAll([
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: Row(
          children: const [
            Text('Nome Evento*',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: CupertinoTextField(
          textInputAction: TextInputAction.next,
          restorationId: 'Nome Evento',
          keyboardType: TextInputType.text,
          controller: controllerEventName,
          clearButtonMode: OverlayVisibilityMode.editing,
          autocorrect: false,
          enabled: dataBundleNotifier.currentEventModel.closed != 'Y' ? true : false,
          placeholder: 'Nome Evento',
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: Row(
          children: const [
            Text('Location',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: CupertinoTextField(
          textInputAction: TextInputAction.next,
          restorationId: 'Location',
          keyboardType: TextInputType.text,
          controller: controllerLocation,
          clearButtonMode: OverlayVisibilityMode.editing,
          autocorrect: false,
          enabled: dataBundleNotifier.currentEventModel.closed != 'Y' ? true : false,
          placeholder: 'Location',
        ),
      ),
      const Text('*campo obbligatorio'),
    ]);
    widgetList.add(
      SizedBox(height: 20),
    );
    if(dataBundleNotifier.currentEventModel.closed != 'Y'){
      widgetList.add(
        SizedBox(
          width: getProportionateScreenWidth(300),
          child: CupertinoButton(
              color: kCustomGreenAccent,
              child: const Text('Salva impostazioni'),
              onPressed: () async {
                if(controllerEventName.text == null || controllerEventName.text == ''){
                  _scaffoldKey.currentState.showSnackBar(const SnackBar(
                    backgroundColor: kPinaColor,
                    duration: Duration(milliseconds: 600),
                    content: Text(
                        'Il nome dell\'evento è obbligatorio'),
                  ));
                }else if(controllerLocation.text == null || controllerLocation.text == ''){
                  _scaffoldKey.currentState.showSnackBar(const SnackBar(
                    backgroundColor: kPinaColor,
                    duration: Duration(milliseconds: 600),
                    content: Text(
                        'La location è obbligatoria'),
                  ));
                }else{

                  event.location = controllerLocation.text;
                  event.eventName = controllerEventName.text;

                  dataBundleNotifier.getclientServiceInstance().updateEventModel(event);

                }
              }),
        ),
      );
    }
    widgetList.add(
      const SizedBox(height: 20),
    );
    widgetList.add(
      Divider(height: getProportionateScreenHeight(220), color: Colors.grey, indent: 30, endIndent: 30,)
    );


    List<Widget> widgetListButtons = [
      event.closed == 'N' ? SizedBox(
        width: getProportionateScreenWidth(300),
        child: CupertinoButton(
            color: Colors.redAccent,
            child: const Text('Chiudi evento'),
            onPressed: () async {
              showDialog(
                context: context,
                  builder: (_) => AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    backgroundColor: kCustomWhite,
                    contentPadding: EdgeInsets.only(top: 10.0),
                    elevation: 30,

                    content: SizedBox(
                      height: getProportionateScreenHeight(370),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Chiudi Evento?', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Chiudendo l\'evento ${event.eventName} i tuoi dipendenti non potranno più accedervi. '
                                    'Puoi, in seguito, consultare gli eventi chiusi andando nella sezione \'ARCHIVIO EVENTI\'. La merce residua verrà caricata nel magazzino ${dataBundleNotifier.getStorageModelById(event.fkStorageId).name}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
                              ),
                              SizedBox(height: 40),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25.0),
                                          bottomRight: Radius.circular(25.0)),
                                    ),
                                    child: SizedBox(
                                      width: getProportionateScreenWidth(300),
                                      child: CupertinoButton(child: const Text('CHIUDI EVENTO', style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.redAccent, onPressed: () async {
                                        try{
                                          await dataBundleNotifier.getclientServiceInstance().performSetNullAllProductsWithNegativeValueForStockStorage(dataBundleNotifier.getStorageModelById(dataBundleNotifier.currentEventModel.fkStorageId));

                                          Map<int, SupportTableObj> supportTableObjList = {};

                                          supportTableObjList.clear();
                                          supportTableObjList = {};

                                          Set<int> idsProductsPresent = Set();

                                          if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
                                            dataBundleNotifier.workstationsProductsMap.forEach((workstationId, listProducts) {
                                              listProducts.forEach((product) {
                                                idsProductsPresent.add(product.fkProductId);
                                              });
                                            });
                                          }

                                          if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
                                            idsProductsPresent.forEach((productId) {

                                              dataBundleNotifier.workstationsProductsMap.forEach((workstationId, listProducts) {
                                                listProducts.forEach((product) {

                                                  if(product.fkProductId == productId){

                                                    if(supportTableObjList.containsKey(productId)){
                                                      supportTableObjList[productId].amountout = supportTableObjList[productId].amountout + product.consumed;
                                                      supportTableObjList[productId].amountin = supportTableObjList[productId].amountin + product.refillStock;

                                                    }else{
                                                      supportTableObjList[productId] = SupportTableObj(
                                                          id: productId,
                                                          amountin: product.refillStock,
                                                          amountout: product.consumed,
                                                          productName: product.productName,
                                                          price: product.productPrice,
                                                          unitMeasure: product.unitMeasure
                                                      );
                                                    }
                                                  }
                                                });
                                              });
                                            });
                                          }
                                          
                                          
                                          if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
                                            List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel = [];

                                            supportTableObjList.forEach((prodId, value) {
                                              listMoveProductBetweenStorageModel.add(
                                                  MoveProductBetweenStorageModel(
                                                      amount: value.amountout,
                                                      pkProductId: prodId,
                                                      storageIdFrom: 0,
                                                      storageIdTo: dataBundleNotifier.currentEventModel.fkStorageId
                                                  )
                                              );
                                            });
                                            await dataBundleNotifier.getclientServiceInstance()
                                                .moveProductBetweenStorage(listMoveProductBetweenStorageModel: listMoveProductBetweenStorageModel,
                                                actionModel: ActionModel(

                                                )
                                            );
                                          }

                                          event.closed = 'Y';
                                          await dataBundleNotifier.getclientServiceInstance().updateEventModel(event);
                                          dataBundleNotifier.cleanExtraArgsListProduct();
                                          dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);

                                          dataBundleNotifier.onItemTapped(0);
                                          Navigator.pushNamed(context, HomeScreenMain.routeName);
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Evento ' +
                                                    event.eventName + ' chiuso. Residuo merce caricata in magazzino ${dataBundleNotifier.getStorageModelById(event.fkStorageId).name}'),
                                          ));
                                        }catch(e){
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Impossibile chiudere evento ' +
                                                    event.eventName + '. ' + e),
                                          ));
                                        }
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
            }),
      ) : SizedBox(height: 0),
      SizedBox(height: 20),
      SizedBox(
        width: getProportionateScreenWidth(300),
        child: CupertinoButton(
            color: kCustomBordeaux,
            child: const Text('Elimina evento'),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    backgroundColor: kCustomWhite,
                    contentPadding: EdgeInsets.only(top: 10.0),
                    elevation: 30,

                    content: SizedBox(
                      height: getProportionateScreenHeight(370),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Elimina Evento?', textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Eliminando l\'evento ${event.eventName} tutta la merce caricata nelle postazioni lavorative verrà reinserita nel magazzino di riferimento  '
                                    '${dataBundleNotifier.getStorageModelById(event.fkStorageId).name}.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
                              ),
                              SizedBox(height: 60),
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      color: kCustomBordeaux,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25.0),
                                          bottomRight: Radius.circular(25.0)),
                                    ),
                                    child: SizedBox(
                                      width: getProportionateScreenWidth(300),
                                      child: CupertinoButton(child: const Text('ELIMINA EVENTO', style: TextStyle(fontWeight: FontWeight.bold)), color: kCustomBordeaux, onPressed: () async {
                                        try{

                                          Map<int, SupportTableObj> supportTableObjList = {};

                                          supportTableObjList.clear();
                                          supportTableObjList = {};

                                          Set<int> idsProductsPresent = Set();

                                          if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
                                            dataBundleNotifier.workstationsProductsMap.forEach((workstationId, listProducts) {
                                              listProducts.forEach((product) {
                                                idsProductsPresent.add(product.fkProductId);
                                              });
                                            });
                                          }

                                          if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
                                            idsProductsPresent.forEach((productId) {

                                              dataBundleNotifier.workstationsProductsMap.forEach((workstationId, listProducts) {
                                                listProducts.forEach((product) {

                                                  if(product.fkProductId == productId){

                                                    if(supportTableObjList.containsKey(productId)){
                                                      supportTableObjList[productId].amountout = supportTableObjList[productId].amountout + product.consumed;
                                                      supportTableObjList[productId].amountin = supportTableObjList[productId].amountin + product.refillStock;

                                                    }else{
                                                      supportTableObjList[productId] = SupportTableObj(
                                                          id: productId,
                                                          amountin: product.refillStock,
                                                          amountout: product.consumed,
                                                          productName: product.productName,
                                                          price: product.productPrice,
                                                          unitMeasure: product.unitMeasure
                                                      );
                                                    }
                                                  }
                                                });
                                              });
                                            });
                                          }

                                          if(dataBundleNotifier.workstationsProductsMap != null || dataBundleNotifier.workstationsProductsMap.isNotEmpty){
                                            List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel = [];

                                            supportTableObjList.forEach((prodId, value) {
                                              listMoveProductBetweenStorageModel.add(
                                                  MoveProductBetweenStorageModel(
                                                      amount: value.amountin,
                                                      pkProductId: prodId,
                                                      storageIdFrom: 0,
                                                      storageIdTo: dataBundleNotifier.currentStorage.pkStorageId
                                                  )
                                              );
                                            });
                                            await dataBundleNotifier.getclientServiceInstance()
                                                .moveProductBetweenStorage(listMoveProductBetweenStorageModel: listMoveProductBetweenStorageModel,
                                                actionModel: ActionModel(

                                                )
                                            );
                                          }



                                          await dataBundleNotifier.getclientServiceInstance().deleteEventModel(event);
                                          dataBundleNotifier.setCurrentStorage(dataBundleNotifier.currentStorage);
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Evento ' +
                                                    event.eventName + ' Eliminato. Merce caricata in magazzino ${dataBundleNotifier.getStorageModelById(event.fkStorageId).name}'),
                                          ));

                                          dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);
                                          dataBundleNotifier.onItemTapped(0);
                                          Navigator.pushNamed(context, HomeScreenMain.routeName);

                                        }catch(e){
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Impossibile eliminare evento ' +
                                                    event.eventName + '. ' + e.toString()),
                                          ));
                                        }
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


            }),
      ),
    ];
    return Container(
      color: kPrimaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: widgetList,
              ),
              Column(
                children: widgetListButtons,
              ),
            ]),
      ),
    );
  }

  buildResocontoScreenExtraExpences(List<WorkstationModel> workstationModelList,
      DataBundleNotifier dataBundleNotifier, EventModel event, context) {
    return FutureBuilder(
      initialData: const Center(
          child: CircularProgressIndicator(
            color: kPinaColor,
          )),
      builder: (context, snapshot){
        return snapshot.data;
      },
      future: retrieveDataToBuildRecapWidgetExtraExpences(workstationModelList, dataBundleNotifier, event, context),
    );
  }

  Future<Widget> retrieveDataToBuildRecapWidgetExtraExpences(List<WorkstationModel> workstationModelList,
      DataBundleNotifier dataBundleNotifier,
      EventModel event, context) async {

    double totalExpenceEvent = 0.0;

    List<TableRow> rowsExpenceEvent = [
      TableRow( children: [
        GestureDetector(
          child: Row(
            children: [
              Text('   TIPO SPESA', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(14)),),
            ],
          ),
        ),
        Text('Q', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
        Text('', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
        Text('€', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
        Text('TOT. (€)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
      ]),
    ];

    dataBundleNotifier.listExpenceEvent.forEach((expence) {
      totalExpenceEvent = totalExpenceEvent + (expence.amount * expence.cost);
      rowsExpenceEvent.add(TableRow( children: [
        GestureDetector(
          onTap: (){

            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: EditingExpenceEventCard(
                    expenceEventModel: expence,
                  ),
                ));

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(expence.description, textAlign: TextAlign.start, style: TextStyle( color: Colors.white, fontSize: getProportionateScreenHeight(13)),),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: EditingExpenceEventCard(
                    expenceEventModel: expence,
                  ),
                ));

          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: Text(expence.amount.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle( color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
          ),
        ),
        GestureDetector(
          onTap: (){
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: EditingExpenceEventCard(
                    expenceEventModel: expence,
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
            child: Text('x', textAlign: TextAlign.center, style: TextStyle( color: Colors.blue, fontSize: getProportionateScreenHeight(20)),),
          ),
        ),
        GestureDetector(
          onTap: (){
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: EditingExpenceEventCard(
                    expenceEventModel: expence,
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text(expence.cost.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle( color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
          ),
        ),
        GestureDetector(
          onTap: (){
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: EditingExpenceEventCard(
                    expenceEventModel: expence,
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text((expence.amount * expence.cost).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle( color: Colors.white, fontSize: getProportionateScreenHeight(16)),),
          ),
        ),
      ]),);
    });

    return Container(
      color: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              event.closed == 'Y' ? SizedBox(
                width: getProportionateScreenWidth(500),
                child: Container(color: kCustomBordeaux, child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(child: Text('EVENTO CHIUSO', style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white),)),
                )),
              ) : SizedBox(height: 10),
              SizedBox(
                width: getProportionateScreenWidth(500),
                child: Container(color: Color(0XFFcc8400), child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child:  Text('TOTALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(24)),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('€ ' + totalExpenceEvent.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: getProportionateScreenHeight(30)),),
                    ),
                  ],
                ),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Riepilogo Costi Evento', style: TextStyle(fontSize: getProportionateScreenHeight(18), color: Colors.white), ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 8),
                      child: IconButton(
                          icon: Icon(Icons.add_circle, size: getProportionateScreenHeight(40), color: Colors.green),
                          onPressed: () {

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  scrollable: true,
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  content: ExpenceEventCard(
                                    eventModel: dataBundleNotifier.currentEventModel,
                                  ),
                                ));


                          }
                      ),
                    ),
                  ],
                ),
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(3),
                },
                border: TableBorder.all(
                    color: Colors.grey,
                    width: 0.1
                ),
                children: rowsExpenceEvent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child:  Text('TOTALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: getProportionateScreenHeight(18)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('€ ' + totalExpenceEvent.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite, fontSize: getProportionateScreenHeight(20)),),
                  ),
                ],
              ),
              Divider(
                height: 44,
                color: kPrimaryColor,
              ),
              SizedBox(height: 50),
            ],

          ),
        ),
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
}

class SupportTableObj{

  int id;
  String productName;
  double amountin;
  double amountout;
  double price;
  String unitMeasure;

  SupportTableObj({this.id, this.productName, this.amountin, this.amountout, this.price, this.unitMeasure});

  toMap(){
    return {
      'id' : id,
      'productName' : productName,
      'amountin' : amountin,
      'amountout' : amountout,
      'unitMeasure' : unitMeasure
    };
  }
}