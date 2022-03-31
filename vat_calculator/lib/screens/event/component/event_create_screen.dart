import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/product_datasource_events.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/main_page.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../event_home.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({Key key}) : super(key: key);

  static String routeName = 'create_event_screen';

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {

  DateTime currentDate;
  static TextEditingController controllerEventName;
  static TextEditingController controllerLocation;

  String _selectedStorage = 'Seleziona Magazzino';
  StorageModel currentStorageModel;

  int _barPositionCounter = 0;
  int _champagneriePositionCounter = 0;
  int _rowsPerPage = 10;
  int _rowsPerPageChamp = 10;

  List<StorageProductModel> currentStorageProductModelListBar = [];
  List<StorageProductModel> currentStorageProductModelListChampagnerie = [];

  @override
  void initState() {
    super.initState();
    currentStorageModel = null;
    controllerEventName = TextEditingController();
    controllerLocation = TextEditingController();
    currentDate = null;
  }

  Future<void> setCurrentStorage(String storage, DataBundleNotifier dataBundleNotifier) async {
    setState(() {
      _selectedStorage = storage;
    });
    currentStorageProductModelListChampagnerie.clear();
    currentStorageProductModelListBar.clear();
    currentStorageModel = dataBundleNotifier.retrieveStorageFromStorageListByIdName(storage);
    currentStorageProductModelListBar = await retrieveProductListFromChoicedStorage(currentStorageModel);
    currentStorageProductModelListChampagnerie = await retrieveProductListFromChoicedStorage(currentStorageModel);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Creazione evento in corso...',),
      child: Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
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
                  children: [
                    Column(
                      children: [
                        Text(
                          'Crea Evento',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(19),
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Pagina creazione eventi',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(10),
                            color: kCustomGreenAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                elevation: 5,
              ),
              body: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(15),),
                      Row(
                        children: [
                          const SizedBox(width: 11,),
                          Text('  Nome Evento', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                        child: CupertinoTextField(
                          textInputAction: TextInputAction.next,
                          restorationId: 'Nome Evento',
                          keyboardType: TextInputType.name,
                          controller: controllerEventName,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          autocorrect: false,
                          placeholder: 'Nome Evento',
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 11,),
                          Text('  Location', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                        child: CupertinoTextField(
                          textInputAction: TextInputAction.next,
                          restorationId: 'Location Evento',
                          keyboardType: TextInputType.name,
                          controller: controllerLocation,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          autocorrect: false,
                          placeholder: 'Location Evento',
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              currentDate == null ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: getProportionateScreenHeight(400),
                                  child: CupertinoButton(
                                    child: const Text('Seleziona data evento'),
                                    color: kPrimaryColor,
                                    onPressed: () => _selectDate(context),
                                  ),
                                ),
                              ) : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: getProportionateScreenHeight(400),
                                  child: CupertinoButton(
                                    child:
                                    Text(buildDateFromMilliseconds(currentDate.millisecondsSinceEpoch), style: TextStyle(color: Colors.green),),
                                    color: kPrimaryColor,
                                    onPressed: () => _selectDate(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 25, endIndent: 50, indent: 50,),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const SizedBox(width: 11,),
                          Text('  Seleziona il magazzino di riferimento', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                        child: Center(
                          child: DropdownWithSearch(
                            selectedItemStyle: TextStyle(color: Colors.black, fontSize: getProportionateScreenHeight(16)),
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
                      _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : const Divider(height: 25, endIndent: 50, indent: 50,),
                      _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('  Postazioni Bar', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_barPositionCounter <= 0) {
                                      } else {
                                        _barPositionCounter--;
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
                                    controller: TextEditingController(text: _barPositionCounter.toString()),
                                    onChanged: (text) {
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
                                      _barPositionCounter = _barPositionCounter + 1;
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
                      ),
                      _barPositionCounter == 0 ? SizedBox() : Row(
                        children: const [
                          Text('    Lista prodotti per carico bar', style: TextStyle(color: kPrimaryColor),),
                        ],
                      ),
                      _barPositionCounter == 0 ? const SizedBox() : PaginatedDataTable(
                        rowsPerPage: _rowsPerPage,
                        availableRowsPerPage: const <int>[5, 10, 20, 25],
                        onRowsPerPageChanged: (int value) {
                          setState(() {
                            _rowsPerPage = value;
                          });
                        },
                        columns: kTableColumns,
                        source: ProductDataSourceEvents(currentStorageProductModelListBar),
                      ),
                      _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : const Divider(height: 25, endIndent: 50, indent: 50,),
                      _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('  Postazioni Champagnerie', style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_champagneriePositionCounter <= 0) {
                                      } else {
                                        _champagneriePositionCounter--;
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
                                    controller: TextEditingController(text: _champagneriePositionCounter.toString()),
                                    onChanged: (text) {
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
                                      _champagneriePositionCounter = _champagneriePositionCounter + 1;
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
                      ),
                      _champagneriePositionCounter == 0 ? SizedBox() : Row(
                        children: const [
                          Text('    Lista prodotti per carico champagnerie', style: TextStyle(color: kPrimaryColor),),
                        ],
                      ),
                      _champagneriePositionCounter == 0 ? const SizedBox() : PaginatedDataTable(
                        rowsPerPage: _rowsPerPageChamp,
                        availableRowsPerPage: const <int>[5, 10, 20, 25],
                        onRowsPerPageChanged: (int value) {
                          setState(() {
                            _rowsPerPageChamp = value;
                          });
                        },
                        columns: kTableColumns,
                        source: ProductDataSourceEvents(currentStorageProductModelListChampagnerie),
                      ),
                      const Divider(height: 25, endIndent: 50, indent: 50,),
                      const SizedBox(height: 100,),
                    ],
                  ),
                ),
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultButton(
                  text: 'Crea Evento',
                  press: () async {
                    //context.loaderOverlay.show();
                    print('Performing creation event ...');
                    if(controllerEventName.text == ''){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          duration: Duration(milliseconds: 800),
                          content: Text('Inserire il nome evento')));
                    }else if(controllerLocation.text == ''){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          duration: Duration(milliseconds: 800),
                          content: Text('Inserire la location')));
                    }else if(currentDate == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          duration: Duration(milliseconds: 800),
                          content: Text('Selezionare la data dell\'evento')));
                    }else if(_selectedStorage == 'Seleziona Magazzino'){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          duration: Duration(milliseconds: 800),
                          content: const Text('Associare un magazzino all\'evento')));
                    }else if(_champagneriePositionCounter == 0 && _barPositionCounter == 0){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          duration: const Duration(milliseconds: 1000),
                          content: const Text('Configurare almeno una fra Postazione Bar e Postazione Champagnerie')));
                    }else{

                      try{
                        context.loaderOverlay.show();

                        Response performSaveEventId = await dataBundleNotifier.getclientServiceInstance().performCreateEvent(
                            eventModel: EventModel(
                                owner: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                                fkStorageId: currentStorageModel.pkStorageId,
                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                eventName: controllerEventName.value.text,
                                creationDate: DateTime.now().millisecondsSinceEpoch,
                                eventDate: currentDate.millisecondsSinceEpoch,
                                closed: 'N',
                                location: controllerLocation.value.text,
                                pkEventId: 0
                            ),
                            actionModel: ActionModel(
                                date: DateTime.now().millisecondsSinceEpoch,
                                description: 'Ha creato l\'evento ' + controllerEventName.value.text + 'per attività ' + dataBundleNotifier.currentBranch.companyName,
                                fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                type: ActionType.EVENT_CREATION, pkActionId: 0
                            )
                        );

                        print('Event saved. Id event on db: ' + performSaveEventId.data.toString());

                        List<WorkstationModel> workstationModelList = [];
                        List<WorkstationModel> workstationChampModelList = [];
                        if(performSaveEventId != null && performSaveEventId.data > 0){
                          print('Populate with bar workstation model the workstations list for event with id ${performSaveEventId.data.toString()}');
                          for(int counter = 0; counter < _barPositionCounter; counter ++){
                            workstationModelList.add(WorkstationModel(
                                closed: 'N',
                                extra: '',
                                fkEventId: performSaveEventId.data,
                                pkWorkstationId: 0,
                                name: 'Bar ' + (counter + 1).toString(),
                                responsable: '',
                                type: WORKSTATION_TYPE_BAR
                            ));
                          }
                          print('Populate with champagnerie workstation model the workstations list for event with id ${performSaveEventId.data.toString()}');

                          for(int counter = 0; counter < _champagneriePositionCounter; counter ++){
                            workstationChampModelList.add(WorkstationModel(
                                closed: 'N',
                                extra: '',
                                fkEventId: performSaveEventId.data,
                                pkWorkstationId: 0,
                                name: 'Champagnerie ' + (counter + 1).toString(),
                                responsable: '',
                                type: WORKSTATION_TYPE_CHAMP
                            ));
                          }
                        }
                        Response listpout = await dataBundleNotifier.getclientServiceInstance().createWorkstations(workstationModelList);
                        Response listpoutChamps = await dataBundleNotifier.getclientServiceInstance().createWorkstations(workstationChampModelList);

                        print('Create relation between storageproduct and workstations');
                        if(listpout != null && listpout.data != null && listpout.data.length > 0){
                          await dataBundleNotifier
                              .getclientServiceInstance()
                              .createRelationBetweenWorkstationsAndProductStorage(listpout.data, getIdsListFromCurrentStorageProductList(currentStorageProductModelListBar));
                        }
                        if(listpoutChamps != null && listpoutChamps.data != null && listpoutChamps.data.length > 0){
                          await dataBundleNotifier
                              .getclientServiceInstance()
                              .createRelationBetweenWorkstationsAndProductStorage(listpoutChamps.data, getIdsListFromCurrentStorageProductList(currentStorageProductModelListChampagnerie));
                        }
                        if(dataBundleNotifier.currentBranch != null){
                          List<EventModel> _eventModelList = await dataBundleNotifier.getclientServiceInstance().retrieveEventsListByBranchId(dataBundleNotifier.currentBranch);
                          dataBundleNotifier.addCurrentEventsList(_eventModelList);
                        }

                        String eventDatePretty = '${getDayFromWeekDay(currentDate.weekday)} ${currentDate.day.toString()} ${getMonthFromMonthNumber(currentDate.month)} ${currentDate.year.toString()}';

                        dataBundleNotifier.getclientMessagingFirebase().sendNotificationToTopic('branch-${dataBundleNotifier.currentBranch.pkBranchId.toString()}',
                          'Evento ${controllerEventName.value.text} in programma $eventDatePretty a ${controllerLocation.value.text}', '${dataBundleNotifier.userDetailsList[0].firstName} ha creato un nuovo evento', '');

                        Navigator.pushNamed(context, EventHomeScreen.routeName);
                        context.loaderOverlay.hide();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 800),
                            content: Text('Evento ${controllerEventName.value.text} creato')));
                        }catch(e){
                          print('Exception: ' + e);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              duration: Duration(milliseconds: 2800),
                              content: Text(e.toString())));
                        }
                      }
                    },
                  color: kCustomGreenAccent,
                ),
              ),
            );
          }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              backgroundColor: kPrimaryColor,
              dialogBackgroundColor: kPrimaryColor,
              colorScheme: ColorScheme.dark(
                onSurface: Colors.white,
                primary: kCustomGreenAccent,
                secondary: Colors.white,
                onSecondary: Colors.white,
                background: Colors.white,
                onBackground: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.white, // button// text color
                ),
              ),
            ),
            child: child,
          );
        },

        helpText: "Seleziona data evento",
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

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return getDayFromWeekDay(dateTime.weekday) + ' ' + dateTime.day.toString() + ' ' + getMonthFromMonthNumber(dateTime.month) + ' ' + dateTime.year.toString();
  }

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

  Future<List<StorageProductModel>> retrieveProductListFromChoicedStorage(StorageModel currentStorageModel) async {
    ClientVatService clientVatService = ClientVatService();

    List<StorageProductModel> storageProductModelList = await clientVatService.retrieveRelationalModelProductsStorage(currentStorageModel.pkStorageId);
    return storageProductModelList;
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

  int getNumberElementsFromProductList(List<StorageProductModel> currentStorageProductModelList) {
    int counter = 0;

    currentStorageProductModelList.forEach((currentStorageProdutct) {
      if(currentStorageProdutct.selected){
        counter = counter + 1;
      }
    });
    return counter;
  }
}


