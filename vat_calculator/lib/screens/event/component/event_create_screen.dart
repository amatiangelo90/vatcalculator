import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';

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

  Future<void> setCurrentStorage(String storageName,
      DataBundleNotifier dataBundleNotifier) async {
    setState(() {
      _selectedStorage = storageName;
      currentStorageModel = dataBundleNotifier.getCurrentBranch()!.storages!.where((element) => element.name == storageName).first;
      _barPositionCounter = 0;
      _champagneriePositionCounter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

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
                      icon: const Icon(Icons.arrow_back_ios, color: kCustomWhite),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  iconTheme: const IconThemeData(color: kCustomWhite),
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
                              color: kCustomWhite,
                            ),
                          ),
                          Text(
                            'Pagina creazione eventi',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(11),
                              color: kCustomWhite,
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
                            Text('  Nome Evento', style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(16))),
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
                            style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(20)),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 11,),
                            Text('  Location', style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(16))),
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
                            style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(20)),
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
                            Text('  Seleziona il magazzino di riferimento', style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12))),
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
                        _selectedStorage == 'Seleziona Magazzino' ? SizedBox(width: 0,) : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Configura Workstations', textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.w800, fontSize: getProportionateScreenWidth(15))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4, left: 8, top: 5),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                      image: AssetImage("assets/png/bar.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: getProportionateScreenWidth(250),
                                  width: getProportionateScreenWidth(600),
                                  child: OutlinedButton(
                                    onPressed: (){

                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white.withOpacity(0.1)),
                                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 3.5, color: kCustomGreen),),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('BAR',style: TextStyle(
                                              color: kCustomWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  17)),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2, style: BorderStyle.solid)),
                                                child: FloatingActionButton(
                                                  heroTag: "btn11112",
                                                  onPressed: (){
                                                    setState(() {
                                                      if (_barPositionCounter <= 0) {
                                                      } else {
                                                        _barPositionCounter--;
                                                      }
                                                    });
                                                  },
                                                  child: Icon(Icons.remove, color: Colors.white, size: getProportionateScreenWidth(30)),
                                                  backgroundColor: Colors.white.withOpacity(0.1),
                                                ),
                                              ),
                                              Text(_barPositionCounter.toString(), style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: getProportionateScreenWidth(60),
                                                  color: kCustomWhite),),
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2, style: BorderStyle.solid)),
                                                child: FloatingActionButton(
                                                  heroTag: "btnbar121",
                                                  onPressed: (){
                                                    setState(() {
                                                      _barPositionCounter++;
                                                    });
                                                  },
                                                  child: Icon(Icons.add, color: Colors.white, size: getProportionateScreenWidth(30)),
                                                  backgroundColor: Colors.white.withOpacity(0.1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text('')
                                      ],
                                    ),
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4, left: 8, top: 5),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                      image: AssetImage("assets/png/champagnerie.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: getProportionateScreenWidth(250),
                                  width: getProportionateScreenWidth(600),
                                  child: OutlinedButton(
                                    onPressed: (){

                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white.withOpacity(0.1)),
                                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 3.5, color: kCustomPinkAccent),),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('CHAMPAGNERIE',style: TextStyle(
                                              color: kCustomWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  17)),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2, style: BorderStyle.solid)),
                                                child: FloatingActionButton(
                                                  heroTag: "btn98786543",
                                                  onPressed: (){
                                                    setState(() {
                                                      if (_champagneriePositionCounter <= 0) {
                                                      } else {
                                                        _champagneriePositionCounter--;
                                                      }
                                                    });
                                                  },
                                                  child: Icon(Icons.remove, color: Colors.white, size: getProportionateScreenWidth(30)),
                                                  backgroundColor: Colors.white.withOpacity(0.1),
                                                ),
                                              ),
                                              Text(_champagneriePositionCounter.toString(), style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: getProportionateScreenWidth(60),
                                                  color: kCustomWhite),),
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white, width: 2, style: BorderStyle.solid)),
                                                child: FloatingActionButton(
                                                  heroTag: "btn14323481z123",
                                                  onPressed: (){
                                                    setState(() {
                                                      _champagneriePositionCounter++;
                                                    });
                                                  },
                                                  child: Icon(Icons.add, color: Colors.white, size: getProportionateScreenWidth(30)),
                                                  backgroundColor: Colors.white.withOpacity(0.1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text('')
                                      ],
                                    ),
                                  )
                              ),
                            ),

                            const Divider(height: 25, endIndent: 50, indent: 50,),
                            const SizedBox(height: 100,),
                          ],
                        ),

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

                            print(Event(
                                storageId: currentStorageModel.storageId,
                                branchId: dataBundleNotifier.getCurrentBranch().branchId,
                                name: controllerEventName.text,
                                dateEvent: dateFormat.format(currentDate),
                                dateCreation: dateFormat.format(DateTime.now()),
                                eventId: 0,
                                createdBy: dataBundleNotifier.getUserEntity().name! + ' ' + dataBundleNotifier.getUserEntity().lastname!,
                                cardColor: '0xff398564',
                                eventStatus: EventEventStatus.aperto,
                                expenceEvents: [],
                                location: controllerLocation.text,
                                workstations: buildWorkstationsList()
                            ).toJson().toString());
                            Response apiV1AppEventSavePost = await dataBundleNotifier.getSwaggerClient().apiV1AppEventSavePost(
                              event: Event(
                                  storageId: currentStorageModel.storageId,
                                  branchId: dataBundleNotifier.getCurrentBranch().branchId,
                                  name: controllerEventName.text,
                                  dateEvent: dateFormat.format(currentDate),
                                  dateCreation: dateFormat.format(DateTime.now()),
                                  eventId: 0,
                                  createdBy: dataBundleNotifier.getUserEntity().name! + ' ' + dataBundleNotifier.getUserEntity().lastname!,
                                  cardColor: '0xff398564',
                                  eventStatus: EventEventStatus.aperto,
                                  expenceEvents: [],
                                  location: controllerLocation.text,
                                  workstations: buildWorkstationsList()
                              ),
                            );

                            if(apiV1AppEventSavePost.isSuccessful){
                              dataBundleNotifier.refreshCurrentBranchData();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 800),
                                  content: Text('Evento ${controllerEventName.value.text} creato correttamente')));
                              Navigator.of(context).pop();
                            }else{

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 800),
                                  content: Text('Errore durante il salvataggio dell\'evento ${controllerEventName.value.text}. Err: ' + apiV1AppEventSavePost.error!.toString())));
                            }

                          }catch(e){
                            print('Exception: ' + e.toString());
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent.withOpacity(0.8),
                                duration: Duration(milliseconds: 2800),
                                content: Text(e.toString())));
                          }finally{
                            context.loaderOverlay.hide();
                          }
                        }
                      },
                      color: kCustomGreen, textColor: kCustomWhite,
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

  buildListProduct(DataBundleNotifier dataBundleNotifier) {
    List<Widget> listWidget = [
    ];
    for (var product in dataBundleNotifier.getListBarProduct()) {
      listWidget.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomBlack, fontSize: getProportionateScreenHeight(17)),),
                  Text(product.unitMeasure.toString(), style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGrey, fontWeight: FontWeight.bold,),),
                ],
              ),
              IconButton(onPressed: () async {
                dataBundleNotifier.removeProdFromBarListProduct(product);
              }, icon: Icon(Icons.delete, color: kRed, size: getProportionateScreenHeight(25)),

              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: getProportionateScreenWidth(900),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(children: listWidget,),
        ),
      ),
    );
  }

  List<num> getIds(DataBundleNotifier dataBundleNotifier) {
    List<num> ids = [];

    dataBundleNotifier.getListBarProduct().forEach((element) {
      ids.add(element.productId!);
    });

    return ids;
  }
}


