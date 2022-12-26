import 'dart:io';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/light_colors.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/product_datasource_events.dart';
import 'package:vat_calculator/screens/home/main_page.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import '../event_home.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({Key? key}) : super(key: key);

  static String routeName = 'create_event_screen';

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {

  DateTime currentDate = DateTime.now();
  late TextEditingController controllerEventName;
  late TextEditingController controllerLocation;

  String _selectedStorage = 'Seleziona Magazzino';
  Storage currentStorageModel = Storage(storageId: 0);

  int _barPositionCounter = 0;
  int _champagneriePositionCounter = 0;

  int _rowsPerPage = 10;
  int _rowsPerPageChamp = 10;

  List<StorageProductModel> currentStorageProductModelListBar = [];
  List<StorageProductModel> currentStorageProductModelListChampagnerie = [];

  @override
  void initState() {
    super.initState();
    controllerEventName = TextEditingController();
    controllerLocation = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setCurrentStorage(String storage,
      DataBundleNotifier dataBundleNotifier) async {
    setState(() {
      _selectedStorage = storage;
      _barPositionCounter = 0;
      _champagneriePositionCounter = 0;
    });
    //currentStorageProductModelListChampagnerie.clear();
    //currentStorageProductModelListBar.clear();
    //currentStorageModel = dataBundleNotifier.retrieveStorageFromStorageListByIdName(storage)!;
    //currentStorageProductModelListBar = await retrieveProductListFromChoicedStorage(currentStorageModel);
    //currentStorageProductModelListChampagnerie = await retrieveProductListFromChoicedStorage(currentStorageModel);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Creazione evento in corso...',),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Consumer<DataBundleNotifier>(
            builder: (context, dataBundleNotifier, child) {
              return Scaffold(
                backgroundColor: kCustomGrey,
                appBar: AppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                      Navigator.pushNamed(context, HomeScreenMain.routeName);
                      }),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: kCustomGrey,
                  centerTitle: true,
                  title: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Crea Evento',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: getProportionateScreenWidth(19),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Pagina creazione eventi',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(11),
                              color: kCustomGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  elevation: 0,
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
                            Text('  Nome Evento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(16))),
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
                            style: TextStyle(color: kCustomBlack, fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(25)),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 11,),
                            Text('  Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(16))),
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
                            style: TextStyle(color: kCustomBlack, fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(25)),
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
                                      color: kCustomGreen,
                                      onPressed: () => _selectDate(context),
                                    ),
                                  ),
                                ) : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: getProportionateScreenHeight(400),
                                    child: CupertinoButton(
                                      child:
                                      Text(buildDateFromMilliseconds(currentDate.millisecondsSinceEpoch), style: TextStyle(color: Colors.white, ),),
                                      color: kCustomGreen,
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
                            Text('  Seleziona il magazzino di riferimento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                              itemStyle: TextStyle(color: kCustomBlack, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(20)),

                            items: dataBundleNotifier.getCurrentBranch().storages!.map((Storage storageModel) {
                                return storageModel.name;
                              }).toList(),
                              selected: _selectedStorage,
                              onChanged: (storage) {
                                setCurrentStorage(storage, dataBundleNotifier);
                              }, label: '',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Configura Workstations', textAlign: TextAlign.center, style: TextStyle(color: LightColors.kLightYellow, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(15))),
                        ),

                        _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('  Bar', style: TextStyle(color: kCustomGreen, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(15))),
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
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        FontAwesomeIcons.minus,
                                        color: kPinaColor,
                                        size: getProportionateScreenWidth(30),
                                      ),
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints.loose(Size(
                                        getProportionateScreenWidth(60),
                                        getProportionateScreenWidth(60))),
                                    child: CupertinoTextField(
                                      controller: TextEditingController(text: _barPositionCounter.toString()),
                                      textInputAction: TextInputAction.next,
                                      enabled: false,
                                      keyboardType: const TextInputType.numberWithOptions(
                                          decimal: true, signed: true),
                                      clearButtonMode: OverlayVisibilityMode.never,
                                      textAlign: TextAlign.center,
                                      autocorrect: false,
                                      style: TextStyle(color: kCustomBlack, fontSize: getProportionateScreenWidth(30)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _barPositionCounter = _barPositionCounter + 1;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(FontAwesomeIcons.plus,
                                          color: LightColors.kLightGreen,
                                        size: getProportionateScreenWidth(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _barPositionCounter == 0 ? SizedBox() : Row(
                          children: const [
                            Text('    Lista prodotti per carico bar', style: TextStyle(color: LightColors.kLightYellow),),
                          ],
                        ),
                        _barPositionCounter == 0 ? const SizedBox() : PaginatedDataTable(
                          rowsPerPage: _rowsPerPage,
                          availableRowsPerPage: const <int>[5, 10, 20, 25],
                          onRowsPerPageChanged: (int? value) {
                            setState(() {
                              _rowsPerPage = value!;
                            });
                          },
                          columns: kTableColumns,
                          source: ProductDataSourceEvents(currentStorageProductModelListBar),
                        ),
                        _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('  Champagnerie',
                                  style: TextStyle(color: kCustomGreen,fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(15))),
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
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        FontAwesomeIcons.minus,
                                        color: kPinaColor,
                                        size: getProportionateScreenWidth(30),
                                      ),
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints.loose(Size(
                                        getProportionateScreenWidth(60),
                                        getProportionateScreenWidth(60))),
                                    child: CupertinoTextField(
                                      controller: TextEditingController(text: _champagneriePositionCounter.toString()),
                                      enabled: false,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: const TextInputType.numberWithOptions(
                                          decimal: true, signed: true),
                                      clearButtonMode: OverlayVisibilityMode.never,
                                      textAlign: TextAlign.center,
                                      autocorrect: false,
                                      style: TextStyle(color: kCustomBlack, fontSize: getProportionateScreenWidth(30)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _champagneriePositionCounter = _champagneriePositionCounter + 1;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(FontAwesomeIcons.plus,
                                          color: LightColors.kLightGreen,
                                        size: getProportionateScreenWidth(30),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _champagneriePositionCounter == 0 ? SizedBox() : Row(
                          children: const [
                            Text('    Lista prodotti per carico champagnerie', style: TextStyle(color: kCustomBlack),),
                          ],
                        ),
                        _champagneriePositionCounter == 0 ? const SizedBox() : PaginatedDataTable(
                          rowsPerPage: _rowsPerPageChamp,
                          availableRowsPerPage: const <int>[5, 10, 20, 25],
                          onRowsPerPageChanged: (int? value) {
                            setState(() {
                              _rowsPerPageChamp = value!;
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
                bottomSheet: Container(
                  color: kCustomGrey,
                  child: Padding(
                    padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
                    child: DefaultButton(
                      text: 'CREA EVENTO',
                      press: () async {
                        print('Performing creation event ...');
                        if(controllerEventName.text == ''){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              duration: const Duration(milliseconds: 800),
                              content: const Text('Inserire il nome evento')));
                        }else if(controllerLocation.text == ''){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              duration: const Duration(milliseconds: 800),
                              content: const Text('Inserire la location')));
                        }else if(currentStorageModel.storageId == 0){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              duration: Duration(milliseconds: 800),
                              content: const Text('Associare un magazzino all\'evento')));
                        }else{

                          try{
                            context.loaderOverlay.show();

                            Event event = Event(
                              storageId: currentStorageModel.storageId,
                              branchId: dataBundleNotifier.getCurrentBranch().branchId,
                              name: controllerEventName.text,
                              dateEvent: dateFormat.format(currentDate),
                              dateCreation: dateFormat.format(DateTime.now()),
                              eventId: 0,
                              eventStatus: EventEventStatus.aperto,
                              expenceEvents: [],
                              location: controllerLocation.text,
                              workstations: buildWorkstationsList()
                            );
                       //     Response performSaveEventId = await dataBundleNotifier.getclientServiceInstance().performCreateEvent(
                       //         eventModel: EventModel(
                       //             owner: dataBundleNotifier.userDetailsList[0].firstName + ' ' + dataBundleNotifier.userDetailsList[0].lastName,
                       //             fkStorageId: currentStorageModel.pkStorageId,
                       //             fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                       //             eventName: controllerEventName.value.text,
                       //             creationDate: DateTime.now().millisecondsSinceEpoch,
                       //             eventDate: currentDate.millisecondsSinceEpoch,
                       //             closed: 'N',
                       //             location: controllerLocation.value.text,
                       //             pkEventId: 0
                       //         )
                       //     );
//
                       //     print('Event saved. Id event on db: ' + performSaveEventId.data.toString());
//
                       //     List<WorkstationModel> workstationModelList = [];
                       //     List<WorkstationModel> workstationChampModelList = [];
                       //     if(performSaveEventId != null && performSaveEventId.data > 0){
                       //       print('Populate with bar workstation model the workstations list for event with id ${performSaveEventId.data.toString()}');
                       //       for(int counter = 0; counter < _barPositionCounter; counter ++){
                       //         workstationModelList.add(WorkstationModel(
                       //             closed: 'N',
                       //             extra: '',
                       //             fkEventId: performSaveEventId.data,
                       //             pkWorkstationId: 0,
                       //             name: 'Bar ' + (counter + 1).toString(),
                       //             responsable: '',
                       //             type: WORKSTATION_TYPE_BAR
                       //         ));
                       //       }
                       //       print('Populate with champagnerie workstation model the workstations list for event with id ${performSaveEventId.data.toString()}');
//
                       //       for(int counter = 0; counter < _champagneriePositionCounter; counter ++){
                       //         workstationChampModelList.add(WorkstationModel(
                       //             closed: 'N',
                       //             extra: '',
                       //             fkEventId: performSaveEventId.data,
                       //             pkWorkstationId: 0,
                       //             name: 'Champagnerie ' + (counter + 1).toString(),
                       //             responsable: '',
                       //             type: WORKSTATION_TYPE_CHAMP
                       //         ));
                       //       }
                       //     }
                       //     Response listpout = await dataBundleNotifier.getclientServiceInstance().createWorkstations(workstationModelList);
                       //     Response listpoutChamps = await dataBundleNotifier.getclientServiceInstance().createWorkstations(workstationChampModelList);
//
                       //     print('Create relation between storageproduct and workstations');
                       //     if(listpout != null && listpout.data != null && listpout.data.length > 0){
                       //       await dataBundleNotifier
                       //           .getclientServiceInstance()
                       //           .createRelationBetweenWorkstationsAndProductStorage(listpout.data, getIdsListFromCurrentStorageProductList(currentStorageProductModelListBar));
                       //     }
                       //     if(listpoutChamps != null && listpoutChamps.data != null && listpoutChamps.data.length > 0){
                       //       await dataBundleNotifier
                       //           .getclientServiceInstance()
                       //           .createRelationBetweenWorkstationsAndProductStorage(listpoutChamps.data, getIdsListFromCurrentStorageProductList(currentStorageProductModelListChampagnerie));
                       //     }
                       //     if(dataBundleNotifier.currentBranch != null){
                       //       List<EventModel> _eventModelList = await dataBundleNotifier.getclientServiceInstance().retrieveEventsListByBranchId(dataBundleNotifier.currentBranch);
                       //       dataBundleNotifier.addCurrentEventsList(_eventModelList);
                       //     }
//
                       //     String eventDatePretty = '${getDayFromWeekDay(currentDate.weekday)} ${currentDate.day.toString()} ${getMonthFromMonthNumber(currentDate.month)} ${currentDate.year.toString()}';
//
                       //     dataBundleNotifier.getclientMessagingFirebase().sendNotificationToTopic('branch-${dataBundleNotifier.currentBranch.pkBranchId.toString()}',
                       //       'Evento ${controllerEventName.value.text} in programma $eventDatePretty a ${controllerLocation.value.text}', '${dataBundleNotifier.userDetailsList[0].firstName} ha creato un nuovo evento', '');
//
                       //     Navigator.pushNamed(context, EventHomeScreen.routeName);
                       //     context.loaderOverlay.hide();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 800),
                                content: Text('Evento ${controllerEventName.value.text} creato')));
                            }catch(e){
                              print('Exception: ' + e.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  duration: Duration(milliseconds: 2800),
                                  content: Text(e.toString())));
                            }
                          }
                        },
                      color: kCustomGreen, textColor: Colors.white,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              backgroundColor: kCustomBlack,
              dialogBackgroundColor: kCustomBlack,
              canvasColor: Colors.white,
              colorScheme: const ColorScheme.dark(
                onSurface: Colors.white,
                primary: Colors.white,
                secondary: Colors.white,
                onSecondary: Colors.white,
                background: Colors.white,
                onBackground: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: kCustomGreen, // button// text color
                ),
              ),
            ),
            child: child!,
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

  List<Workstation> buildWorkstationsList() {
    List<Workstation> output = [];
    for(int i = 0; i < _barPositionCounter; i++){
      output.add(Workstation(
        name: 'Bar ' + i.toString(),
        products: [],
        extra: '',
        responsable: '',
        workstationType: WorkstationWorkstationType.bar
      ));
    }

    for(int i = 0; i < _champagneriePositionCounter; i++){
      output.add(Workstation(
          name: 'Champagnerie ' + i.toString(),
          products: [],
          extra: '',
          responsable: '',
          workstationType: WorkstationWorkstationType.champagnerie
      ));
    }


    return output;
  }
}


