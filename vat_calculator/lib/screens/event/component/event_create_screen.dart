import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/product_datasource.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';

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
  int _rowsPerPage = 5;

  List<StorageProductModel> currentStorageProductModelList = [];

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
    currentStorageModel = dataBundleNotifier.retrieveStorageFromStorageListByIdName(storage);
    currentStorageProductModelList = await retrieveProductListFromChoicedStorage(currentStorageModel);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kCustomWhite,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.black.withOpacity(0.9),
              centerTitle: true,
              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Crea Evento',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          color: kCustomYellow800,
                        ),
                      ),
                      Text(
                        'Pagina creazione eventi',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(10),
                          color: kCustomWhite,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              elevation: 2,
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
                        Text('  Nome Evento', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                        Text('  Location', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                                  color: Colors.black.withOpacity(0.8),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                            ) : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: getProportionateScreenHeight(400),
                                child: CupertinoButton(
                                  child:
                                  Text(buildDateFromMilliseconds(currentDate.millisecondsSinceEpoch), style: TextStyle(color: kCustomYellow800),),
                                  color: Colors.black.withOpacity(0.8),
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
                        Text('  Seleziona il magazzino di riferimento', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                    const Divider(height: 25, endIndent: 50, indent: 50,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('  Postazioni Bar', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                    _barPositionCounter == 0 ? SizedBox() : PaginatedDataTable(

                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: const <int>[5, 10, 20, 25],
                      onRowsPerPageChanged: (int value) {
                        setState(() {
                          _rowsPerPage = value;
                        });
                      },
                      columns: kTableColumns,
                      source: ProductDataSource(currentStorageProductModelList),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('  Postazioni Champagnerie', style: TextStyle(color: kPrimaryColor, fontSize: getProportionateScreenWidth(12))),
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
                                  enabled: false,
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
                    _champagneriePositionCounter == 0 ? SizedBox() : PaginatedDataTable(

                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: const <int>[5, 10, 20, 25],
                      onRowsPerPageChanged: (int value) {
                        setState(() {
                          _rowsPerPage = value;
                        });
                      },
                      columns: kTableColumns,
                      source: ProductDataSource(currentStorageProductModelList),
                    ),
                    const Divider(height: 25, endIndent: 50, indent: 50,),
                    SizedBox(height: 100,),
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
                  print('Performing send order ...');
                  //if(_selectedStorage == 'Seleziona Magazzino'){
                  // context.loaderOverlay.hide();
                //    AwesomeDialog(
                //      context: context,
                //      animType: AnimType.SCALE,
                //      dialogType: DialogType.WARNING,
                //      body: const Center(child: Text(
                //        'Selezionare il magazzino',
                //      ),),
                //      title: 'This is Ignored',
                //      desc:   'This is also Ignored',
                //      btnOkColor: Colors.green.shade800,
                //      btnOkOnPress: () {},
                //    ).show();
                //  }else if(currentStorageModel == null){
              //  context.loaderOverlay.hide();
             ////  AwesomeDialog(
             //        context: context,
             //        animType: AnimType.SCALE,
             //        dialogType: DialogType.WARNING,
             //        body: const Center(child: Text(
             //          'Selezionare il magazzino',
             //        ),),
             //        title: 'This is Ignored',
             //        desc:   'This is also Ignored',
             //        btnOkOnPress: () {},
             //        btnOkColor: Colors.green.shade800,
             //      ).show();
              // }else if(currentDate == null) {
            //   context.loaderOverlay.hide();
            //   AwesomeDialog(
                 //     context: context,
                 //     animType: AnimType.RIGHSLIDE,
                 //     dialogType: DialogType.WARNING,
                 //     body: const Center(child: Text(
                 //       'Selezionare la data di consegna',
                 //     ),),
                 //     title: 'This is Ignored',
                 //     desc:   'This is also Ignored',
                 //     btnOkOnPress: () {},
                 //     btnOkColor: Colors.green.shade800,
                 //   ).show();
                 // }else{
                 //   Response performSaveOrderId = await dataBundleNotifier.getclientServiceInstance().performCreateEvent(
                 //       eventModel: EventModel(
//
                 //       ),
                 //       actionModel: ActionModel(
                 //           date: DateTime.now().millisecondsSinceEpoch,
                 //           description: 'Ha creato l\'evento  ' + dataBundleNotifier.currentBranch.companyName,
                 //           fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                 //           user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                 //           type: ActionType.EVENT_CREATION, pkActionId: 0
                 //       )
                 ////   );
                  //}
                  },
                color: Colors.green.shade900.withOpacity(0.8),
              ),
            ),
          );
        });
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
      label: Text('Misura'),
      numeric: true,
    ),
    const DataColumn(
      label: Text('Prezzo'),
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
}


