import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/workstation_manager_screen.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../constants.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import '../../home/main_page.dart';
import '../event_home.dart';

class EventManagerScreen extends StatefulWidget {

  static String routeName = 'eventmanagerscreen';
  const EventManagerScreen({super.key});

  @override
  State<EventManagerScreen> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        Iterable<Workstation> barList = dataBundleNotifier.getCurrentEvent()
            .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.bar);

        Iterable<Workstation> champList = dataBundleNotifier.getCurrentEvent()
            .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.champagnerie);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: Text(
                    'Location: ' + dataBundleNotifier.getCurrentEvent().location!,
                    style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kCustomGrey, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            key: _scaffoldKey,
            appBar: AppBar(
              bottom: const TabBar(
                indicatorColor: kCustomGrey,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Workstations', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Spese', style: TextStyle(color:  kCustomGrey, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
              actions: [
                dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const Text('') : IconButton(
                  onPressed: (){
                  },
                  icon: SvgPicture.asset('assets/icons/excel.svg', height: getProportionateScreenWidth(30)),
                ),
                dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const Text('') : IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Builder(
                            builder: (context) {
                              return SizedBox(
                                width: getProportionateScreenWidth(900),
                                height: getProportionateScreenHeight(600),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0)),
                                          color: kCustomGrey,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '  Gestione evento',
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
                                      Column(
                                        children: [
                                          Text('Eliminando l\'evento tutta la merce caricata verrà inserita nuvoamente nel magazzino associato all\'evento. L\'operazione non è reversibile.', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey),),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: getProportionateScreenHeight(100),
                                              width: getProportionateScreenWidth(600),
                                              child: OutlinedButton(
                                                style: ButtonStyle(
                                                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                                                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.white),),
                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                                ),
                                                onPressed: () async {
                                                  Response responseDeleteEvent = await dataBundleNotifier.getSwaggerClient().apiV1AppEventDeleteDelete(eventId: dataBundleNotifier.getCurrentEvent().eventId!.toInt());
                                                  if(responseDeleteEvent.isSuccessful){

                                                    dataBundleNotifier.refreshCurrentBranchData();
                                                    Navigator.pushNamed(context, EventHomeScreen.routeName);
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      backgroundColor: kCustomGreen,
                                                      duration: Duration(seconds: 1),
                                                      content: Text('Evento ' + dataBundleNotifier.getCurrentEvent().name! + ' eliminato con success.'),
                                                    ));
                                                  }else{
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      backgroundColor: kCustomGreen,
                                                      duration: Duration(seconds: 1),
                                                      content: Text('Ho riscontrato un errore durante la cancellazione dell\'evento ' + dataBundleNotifier.getCurrentEvent().name! + '. Err:' + responseDeleteEvent!.error.toString()),
                                                    ));
                                                  }
                                                },
                                                child: Text('ELIMINA EVENTO', style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          Text('Chiudendo l\'evento i tuoi dipendenti non potranno piu fare operazioni di scarico e carico. '
                                              'Inoltre tutta la merce in giacenza verrà ricaricata nel magazzino associato all\'evento.', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey),),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: getProportionateScreenHeight(100),
                                              width: getProportionateScreenWidth(600),
                                              child: OutlinedButton(
                                                style: ButtonStyle(
                                                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                                                  backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomBordeaux),
                                                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.white),),
                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                                ),
                                                onPressed: () async {
                                                  Response responseDeleteEvent = await dataBundleNotifier.getSwaggerClient().apiV1AppEventClosePut(eventId: dataBundleNotifier.getCurrentEvent().eventId!.toInt());
                                                  if(responseDeleteEvent.isSuccessful){

                                                    dataBundleNotifier.refreshCurrentBranchData();
                                                    Navigator.pushNamed(context, EventHomeScreen.routeName);
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      backgroundColor: kCustomGreen,
                                                      duration: Duration(seconds: 1),
                                                      content: Text('Evento ' + dataBundleNotifier.getCurrentEvent().name! + ' chiuso con success.'),
                                                    ));
                                                  }else{
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      backgroundColor: kCustomGreen,
                                                      duration: Duration(seconds: 1),
                                                      content: Text('Ho riscontrato un errore durante la chiusura dell\'evento ' + dataBundleNotifier.getCurrentEvent().name! + '. Err:' + responseDeleteEvent!.error.toString()),
                                                    ));
                                                  }
                                                },
                                                child: Text('CHIUDI EVENTO', style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  },
                  icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomGrey, height: getProportionateScreenWidth(30)),
                ),
              ],
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreenMain.routeName);
                  }),
              iconTheme: const IconThemeData(color: kCustomGrey),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(dataBundleNotifier.getCurrentEvent().name!,
                    style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kCustomGrey, fontWeight: FontWeight.bold),),
                  Text(
                    'Creato da: ' + dataBundleNotifier.getCurrentEvent().createdBy!,
                    style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomGrey, fontWeight: FontWeight.bold),),

                ],
              ),
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SvgPicture.asset('assets/icons/storage.svg', color: Colors.black, height: getProportionateScreenHeight(40),),
                                  ),
                                  Column(
                                    children: [
                                      Text('Magazzino di riferimento: ', style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGrey, fontWeight: FontWeight.w200),),
                                      Text(dataBundleNotifier.getStorageById(dataBundleNotifier.getCurrentEvent().storageId!).name!, style: TextStyle(fontSize: getProportionateScreenHeight(25), color: kCustomGrey, fontWeight: FontWeight.bold),),
                                    ],
                                  ),Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SvgPicture.asset('assets/icons/storage.svg', color: Colors.black, height: getProportionateScreenHeight(40),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: kCustomGreen),
                              borderRadius: BorderRadius.all(Radius.circular(9))
                          ),
                          width: getProportionateScreenWidth(600),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('BAR', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGreen)),
                                OutlinedButton(
                                    onPressed: () async {
                                      Response createWorkstationResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppEventWorkstationCreatePost(workstation: Workstation(
                                        workstationType: WorkstationWorkstationType.bar,
                                        eventId: dataBundleNotifier.getCurrentEvent().eventId!,
                                        responsable: '',
                                        name: 'NUOVO BAR',
                                        products: [],
                                        extra: '',
                                      ));
                                      if(createWorkstationResponse.isSuccessful){
                                        dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: kCustomGreen,
                                            duration: Duration(milliseconds: 1000),
                                            content: Text('Postazione bar creata correttamente'
                                            )));
                                      }else{
                                        Navigator.of(context).pop();
                                        dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: kRed,
                                            duration: Duration(milliseconds: 3000),
                                            content: Text('Errore durante la creazione della postazione bar. Riprova fra 2 minuti.'
                                            )));
                                      }
                                    },
                                    child: const Text("Crea nuovo", style: TextStyle(color: kCustomGreen),)
                                )
                              ],
                            ),
                          ),
                        ),
                        buildWorkstationListWidget(barList.toList(), dataBundleNotifier, true),
                        Container(
                          width: getProportionateScreenWidth(600),
                          decoration: BoxDecoration(
                              border: Border.all(color: kCustomBordeaux),
                              borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('CHAMPAGNERIE',textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomBordeaux)),
                                OutlinedButton(
                                    onPressed: () async {
                                      Response createWorkstationResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppEventWorkstationCreatePost(
                                          workstation: Workstation(
                                        workstationType: WorkstationWorkstationType.champagnerie,
                                        eventId: dataBundleNotifier.getCurrentEvent().eventId!,
                                        responsable: '',
                                        name: 'CHAMPAGNERIE',
                                        products: [],
                                        extra: '',
                                      ));
                                      if(createWorkstationResponse.isSuccessful){
                                        dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: kCustomGreen,
                                            duration: Duration(milliseconds: 1000),
                                            content: Text('Postazione champagnerie creata correttamente'
                                            )));
                                      }else{
                                        Navigator.of(context).pop();
                                        dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: kRed,
                                            duration: Duration(milliseconds: 3000),
                                            content: Text('Errore durante la creazione della postazione champagnerie. Riprova fra 2 minuti.'
                                            )));
                                      }
                                    },
                                    child: const Text("Crea nuovo", style: TextStyle(color: kCustomBordeaux),)
                                )
                              ],
                            ),
                          ),
                        ),
                        buildWorkstationListWidget(champList.toList(), dataBundleNotifier, false),
                        SizedBox(height: 100,)
                      ],
                    ),
                  ),
                ),
                dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? Center(child: Text('Non hai i permessi per visualizzare questa pagina'))
                    : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: kCustomGrey),
                                    borderRadius: BorderRadius.all(Radius.circular(9))
                                ),
                                width: getProportionateScreenWidth(600),

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Spese serata', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(16), color: kCustomGrey)),
                                      OutlinedButton(
                                          onPressed: () async {

                                            TextEditingController amountController = TextEditingController();
                                            TextEditingController descriptionController = TextEditingController();
                                            TextEditingController priceController = TextEditingController();

                                            Widget saveButton = TextButton(
                                              child: const Text("Salva", style: TextStyle(color: kCustomGreen),),
                                              onPressed:  () async {
                                                Response apiV1AppEventExpenceCreatePost = await dataBundleNotifier.getSwaggerClient().apiV1AppEventExpenceCreatePost(expenceEvent: ExpenceEvent(
                                                  amount: double.parse(amountController.text),
                                                  description: descriptionController.text,
                                                  price: double.parse(priceController.text),
                                                  eventId: dataBundleNotifier.getCurrentEvent().eventId!.toInt()
                                                ));

                                                if(apiV1AppEventExpenceCreatePost.isSuccessful){
                                                  dataBundleNotifier.setExpenceToCurrentEvent(apiV1AppEventExpenceCreatePost.body);
                                                  Navigator.of(context).pop();
                                                }else{
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                            );

                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  actions: [
                                                    saveButton
                                                  ],
                                                  contentPadding: EdgeInsets.zero,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  content: Builder(
                                                    builder: (context) {
                                                      var width = MediaQuery.of(context).size.width;
                                                      return SizedBox(
                                                        width: width - 90,
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.vertical,
                                                          child: Column(
                                                            children: [
                                                              Center(
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(18.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      const Padding(
                                                                        padding: EdgeInsets.all(8.0),
                                                                        child: Text('Crea spesa evento',
                                                                          style: TextStyle(fontSize: 14),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
                                                                      IconButton(icon: Icon(Icons.clear), onPressed: (){
                                                                        Navigator.of(context).pop();
                                                                      },)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text('Descrizione', style: TextStyle(fontSize: getProportionateScreenHeight(7))),
                                                                    CupertinoTextField(
                                                                      enabled: true,
                                                                      textInputAction: TextInputAction.next,
                                                                      restorationId: 'Descrizion',
                                                                      keyboardType: TextInputType.text,
                                                                      controller: descriptionController,
                                                                      clearButtonMode: OverlayVisibilityMode.never,
                                                                      autocorrect: false,
                                                                      placeholder: 'Descrizione',
                                                                    ),
                                                                    Text('Quantità', style: TextStyle(fontSize: getProportionateScreenHeight(7))),
                                                                    CupertinoTextField(
                                                                      enabled: true,
                                                                      textInputAction: TextInputAction.next,
                                                                      restorationId: 'Quantità',
                                                                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                                                      controller: amountController,
                                                                      clearButtonMode: OverlayVisibilityMode.never,
                                                                      autocorrect: false,
                                                                      placeholder: 'Quantità',
                                                                    ),
                                                                    Text('Prezzo', style: TextStyle(fontSize: getProportionateScreenHeight(7))),
                                                                    CupertinoTextField(
                                                                      enabled: true,
                                                                      textInputAction: TextInputAction.next,
                                                                      restorationId: 'Prezzo',
                                                                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                                                      controller: priceController,
                                                                      clearButtonMode: OverlayVisibilityMode.never,
                                                                      autocorrect: false,
                                                                      placeholder: 'Prezzo',
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                            );
                                          },
                                          child: const Text("Crea nuova", style: TextStyle(color: kCustomGrey),)
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              buildExpenceWidget(dataBundleNotifier),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Totale spese serata: ',  style: TextStyle(color: kCustomGrey)),
                                    Text('€ ' + dataBundleNotifier.getTotalFromCurrentExpenceList(),  style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(20))),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              buildRecapWorkstationExpences(
                                  dataBundleNotifier.getCurrentEvent(),
                                  WorkstationWorkstationType.bar
                              ),
                              buildRecapWorkstationExpences(
                                  dataBundleNotifier.getCurrentEvent(),
                                  WorkstationWorkstationType.champagnerie
                              ),
                            ],
                          )
                      ),
                    )
                )
              ],
            ),
          ),
        );
      },
    );
  }

  buildWorkstationsManagmentScreen(List<Workstation> workstationModelList, DataBundleNotifier dataBundleNotifier, Event event) {
    List<Widget> listWgBar = [];

    if(dataBundleNotifier.getCurrentBranch().userPriviledge != BranchUserPriviledge.employee){
      listWgBar.add(dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.chiuso ? SizedBox(width: 0,) : Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(180),
              child: Card(
                shadowColor: kPinaColor,
                elevation: 5,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kCustomGrey,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [ SvgPicture.asset(
                          'assets/icons/bartender.svg',
                          color: kPinaColor,
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
                                  color: kCustomGrey,
                                ),
                                Positioned(
                                  right: 2.5,
                                  top: 2.5,
                                  child: Center(
                                    child: Icon(Icons.add_circle_outline, size: 13, color: kPinaColor,),
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

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: kCustomGreen,
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
                    backgroundColor: kCustomGrey,
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
                                  color: kCustomGrey,
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

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: kCustomGreen,
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



    if(event.eventStatus == EventEventStatus.chiuso){
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
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [

          SizedBox(height: 50),
        ])
    );
  }




  buildWorkstationListWidget(List<Workstation> barList, DataBundleNotifier dataBundleNotifier, bool isBar) {

    return SizedBox(
      height: barList.length * getProportionateScreenHeight(120),
      child: ListView.builder(
        itemCount: barList.length,
        itemBuilder: (context, index) {
          Workstation workstation = barList[index];
          return dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? buildWorkstationWidget(isBar, dataBundleNotifier, workstation) : Dismissible(
            background: Container(
              decoration: BoxDecoration(
                  color: kCustomBordeaux,
                  border: Border.all(color: kCustomBordeaux,),
                  borderRadius: BorderRadius.all(Radius.circular(9))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Icon(Icons.delete, color: Colors.white, size: getProportionateScreenHeight(40)),
                  )
                ],
              ),
            ),
            key: Key(workstation.workstationId!.toString()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Conferma operazione"),
                    content: const Text("Eliminando la postazione di lavoro tutta la merce caricata in precedenza verrà riassegnata al magazzino di provenienza. Continuare? "),
                    actions: <Widget>[
                      OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Elimina", style: TextStyle(color: kRed),)
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Indietro"),
                      ),
                    ],
                  );
                },
              );
            },
            resizeDuration: Duration(milliseconds: 600),
            onDismissed: (direction) async {
              Response deleteWorkstationResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationRemoveworkstationDelete(workstationId: workstation.workstationId!.toInt());
              if(deleteWorkstationResponse.isSuccessful){
                dataBundleNotifier.removeWorkstationFromEvent(workstation.workstationId!);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: kCustomGreen,
                    content: Text('Postazione lavorativa eliminata con successo')));
              }else{
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    duration: Duration(seconds: 3),
                    backgroundColor: kCustomBordeaux,
                    content: Text('Ho riscontrato un problema durante l\'eliminazione della postazione. Riprova fra 2 minuti o contatta l\'amministratore del sistema')));
              }
            },
            child: buildWorkstationWidget(isBar, dataBundleNotifier, workstation),
          );
        },
      ),
    );
  }

  buildRecapWorkstationExpences(Event currentEvent, WorkstationWorkstationType type) {
    List<Widget> tableRecapRow = [];
    for (var workstation in currentEvent.workstations!.where((element) => element.workstationType == type)) {
      tableRecapRow.add(
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: type == WorkstationWorkstationType.bar ? kCustomGreen : kCustomBordeaux,),
                      borderRadius: BorderRadius.all(Radius.circular(9))
                  ),
                  child: Center(child: Column(
                    children: [
                      Text(workstation.name!, style: TextStyle(color: type == WorkstationWorkstationType.bar ? kCustomGreen : kCustomBordeaux,),),
                      workstation.responsable! == '' ? Text('') : Text('Responsabile: ' + workstation.responsable!, style: TextStyle(color: kCustomGrey),),
                    ],
                  )),
                ),
              ),
            ],
          )
      );
      tableRecapRow.add(Row(
        children: [
          Expanded(flex: 3, child: Text('Prodotto', style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenWidth(12)),),),
          const Expanded(flex: 1, child: Tooltip(message: 'Carico',child: Icon(Icons.arrow_circle_down_outlined, color: kCustomGreen)),),
          const Expanded(flex: 1, child: Tooltip(message: 'Giacenza',child: Icon(Icons.arrow_circle_up, color: kCustomBordeaux)),),
          const Expanded(flex: 1, child: Tooltip(message: 'Consumato',child: Icon(Icons.storage, color: kCustomBlue)),),
          const Expanded(flex: 2, child: Text('Spesa', textAlign: TextAlign.center)),
        ],
      ));
      for (var product in workstation.products!) {
        tableRecapRow.add(
          Row(
            children: [
              Expanded(flex: 3, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(product.productName!, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12)),),
                  Text(' - ' + product.unitMeasure!, style: TextStyle(color: kCustomGreyBlue, fontSize: getProportionateScreenWidth(8)),),
                  Text(' - € ' + product.price!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(color: kCustomGreyBlue, fontSize: getProportionateScreenWidth(8)),),
                ],
              ),),
              Expanded(flex: 1, child: Text(product.stockFromStorage!.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center),),
              Expanded(flex: 1, child: Text(product.leftOvers!.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center),),
              Expanded(flex: 1, child: Text((product.stockFromStorage! - product.leftOvers!).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center),),
              Expanded(flex: 2, child: Text('€ ' + ((product.stockFromStorage! - product.leftOvers!) * product.price!).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center),),
            ],
          ),
        );
        tableRecapRow.add(Divider(height: 1,));
      }

      tableRecapRow.add(
        Row(
          children: [
            Expanded(flex: 3, child: Text('Totale: ', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(12)),),),
            const Expanded(flex: 1, child: Text('', textAlign: TextAlign.center),),
            const Expanded(flex: 1, child: Text('', textAlign: TextAlign.center),),
            const Expanded(flex: 1, child: Text('', textAlign: TextAlign.center),),
            Expanded(flex: 2, child: Text('€ ' + calculateTotal(workstation.products!), textAlign: TextAlign.center),),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(80)),
      child: Column(
        children: tableRecapRow,
      ),
    );
  }

  String calculateTotal(List<RWorkstationProduct> products) {
    double total = 0.0;

    products.forEach((element) {
      total = total + (element.price! * (element.stockFromStorage! - element.leftOvers!));
    });

    return total.toStringAsFixed(2).replaceAll('.00','');
  }

  buildWorkstationWidget(bool isBar, DataBundleNotifier dataBundleNotifier, Workstation workstation) {
    return ListTile(
      onTap: (){

        dataBundleNotifier.setCurrentWorkstation(workstation);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkstationManagerScreen(),
          ),
        );
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Center(
                child: SvgPicture.asset(
                  isBar ? 'assets/icons/bartender.svg' : 'assets/icons/bouvette.svg',
                  height: getProportionateScreenHeight(40),
                  color: isBar ? kCustomGreen : kCustomBordeaux,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workstation.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17), color: kCustomGrey)),
                    Text(workstation.responsable!.isEmpty! ? 'Responsabile: -' : 'Responsabile: '+workstation.responsable!.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                    Text('Prodotti: ' + workstation.products!.length!.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(14), color: kCustomGrey)),
                  ],
                ),
              ),
            ],
          ),

          IconButton(
            onPressed: (){

              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(10.0))),
                    content: Builder(
                      builder: (context) {
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;
                        return SizedBox(
                          height: getProportionateScreenHeight(300),
                          width: width - 90,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0) ),
                                    color: kCustomGrey,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('  Aggiorna postazione ',style: TextStyle(
                                            fontSize: getProportionateScreenWidth(14),
                                            fontWeight: FontWeight.bold,
                                            color: kCustomWhite,
                                          ),),
                                          IconButton(icon: const Icon(
                                            Icons.clear,
                                            color: kCustomWhite,
                                          ), onPressed: () { Navigator.pop(context); },),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                buildSettingWorkstationWidget(dataBundleNotifier, workstation)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
              );
            },
            icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomGrey, height: getProportionateScreenWidth(30)),
          ),
        ],
      ),
    );
  }

  buildSettingWorkstationWidget(DataBundleNotifier dataBundleNotifier, Workstation workstaion) {

    TextEditingController controllerName = TextEditingController(text: workstaion.name);
    TextEditingController controllerResponsable = TextEditingController(text: workstaion.responsable);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Text('Nome postazione: ', style: TextStyle(color: kCustomGrey),),
          ),
          SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoTextField(
              controller: controllerName,
              textInputAction: TextInputAction.next,
              clearButtonMode: OverlayVisibilityMode.never,
              textAlign: TextAlign.center,
              autocorrect: false,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Text('Responsabile: ', style: TextStyle(color: kCustomGrey),),
          ),
          SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoTextField(
              controller: controllerResponsable,
              textInputAction: TextInputAction.next,
              clearButtonMode: OverlayVisibilityMode.never,
              textAlign: TextAlign.center,
              autocorrect: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: getProportionateScreenWidth(400),
              height: getProportionateScreenHeight(55),
              child: OutlinedButton(
                onPressed: () async {
                  if(controllerName.text == ''){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kCustomBordeaux,
                      duration: Duration(milliseconds: 2600),
                      content: Text(
                          'Immettere il nome della workstation'),
                    ));
                  }else{
                    Response responseupdate = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationUpdatePut(workstation: Workstation(
                        name: controllerName.text,
                        responsable: controllerResponsable.text,
                        workstationId: workstaion.workstationId
                    ));

                    if(responseupdate.isSuccessful){

                      dataBundleNotifier.updateCurrentWorkstation(controllerName.text, controllerResponsable.text, workstaion.workstationId!);

                      Navigator.of(context).pop(false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kCustomGreen,
                        duration: Duration(milliseconds: 2600),
                        content: Text(
                            'Impostazioni salvate correttamente'),
                      ));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: kCustomBordeaux,
                        duration: Duration(milliseconds: 2600),
                        content: Text(
                            'Errore durante il salvataggio. Err: ' + responseupdate.error.toString() ),
                      ));
                    }
                  }
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                  backgroundColor: MaterialStateProperty.resolveWith((states) => dataBundleNotifier.getCurrentWorkstation().workstationType == WorkstationWorkstationType.bar ? kCustomGreen : kCustomPinkAccent),
                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                ),
                child: Text('Salva impostazioni', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
              ),
            ),
          )
        ],
      ),
    );


  }

  buildExpenceWidget(DataBundleNotifier dataBundleNotifier) {
    return SizedBox(
      height: dataBundleNotifier.getCurrentEvent().expenceEvents!.length! * 50,
      child: ListView.builder(
        itemCount: dataBundleNotifier.getCurrentEvent().expenceEvents!.length,
        itemBuilder: (context, index) {
          ExpenceEvent currentEventExpence = dataBundleNotifier.getCurrentEvent().expenceEvents![index];
          return Dismissible(key: Key(currentEventExpence.expenceId.toString()),
              child: ListTile(
                title: GestureDetector(
                  onTap: (){
                    TextEditingController amountController = TextEditingController(text: currentEventExpence.amount!.toStringAsFixed(2).replaceAll('.00', ''));
                    TextEditingController descriptionController = TextEditingController(text: currentEventExpence.description);
                    TextEditingController priceController = TextEditingController(text: currentEventExpence.price!.toStringAsFixed(2).replaceAll('.00', ''));

                    Widget saveButton = TextButton(
                      child: const Text("Aggiorna", style: TextStyle(color: kCustomGreen),),
                      onPressed:  () async {

                        Response apiV1AppEventExpenceCreatePost = await dataBundleNotifier.getSwaggerClient().apiV1AppEventExpenceUpdatePut(expenceEvent: ExpenceEvent(
                            amount: double.parse(amountController.text),
                            expenceId: currentEventExpence.expenceId,
                            description: descriptionController.text,
                            price: double.parse(priceController.text),
                            eventId: dataBundleNotifier.getCurrentEvent().eventId!.toInt()
                        ));

                        if(apiV1AppEventExpenceCreatePost.isSuccessful){

                          dataBundleNotifier.updateExpenceToCurrentEvent(amount: double.parse(amountController.text),
                              expenceId: currentEventExpence.expenceId!,
                              description: descriptionController.text,
                              price: double.parse(priceController.text),
                              eventId: dataBundleNotifier.getCurrentEvent().eventId!.toInt());
                          Navigator.of(context).pop();
                        }else{
                          Navigator.of(context).pop();
                        }
                      },
                    );

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          actions: [
                            saveButton
                          ],
                          contentPadding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          content: Builder(
                            builder: (context) {
                              var width = MediaQuery.of(context).size.width;
                              return SizedBox(
                                width: width - 90,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Crea spesa evento',
                                                  style: TextStyle(fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              IconButton(icon: Icon(Icons.clear), onPressed: (){
                                                Navigator.of(context).pop();
                                              },)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Descrizione', style: TextStyle(fontSize: getProportionateScreenHeight(7))),
                                            CupertinoTextField(
                                              enabled: true,
                                              textInputAction: TextInputAction.next,
                                              restorationId: 'Descrizion',
                                              keyboardType: TextInputType.text,
                                              controller: descriptionController,
                                              clearButtonMode: OverlayVisibilityMode.never,
                                              autocorrect: false,
                                              placeholder: 'Descrizione',
                                            ),
                                            Text('Quantità', style: TextStyle(fontSize: getProportionateScreenHeight(7))),
                                            CupertinoTextField(
                                              enabled: true,
                                              textInputAction: TextInputAction.next,
                                              restorationId: 'Quantità',
                                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                              controller: amountController,
                                              clearButtonMode: OverlayVisibilityMode.never,
                                              autocorrect: false,
                                              placeholder: 'Quantità',
                                            ),
                                            Text('Prezzo', style: TextStyle(fontSize: getProportionateScreenHeight(7))),
                                            CupertinoTextField(
                                              enabled: true,
                                              textInputAction: TextInputAction.next,
                                              restorationId: 'Prezzo',
                                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                              controller: priceController,
                                              clearButtonMode: OverlayVisibilityMode.never,
                                              autocorrect: false,
                                              placeholder: 'Prezzo',
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(flex: 4,child: Text(currentEventExpence.description!.toString())),
                      Expanded(flex: 2,child: Text(currentEventExpence.amount!.toStringAsFixed(2).replaceAll('.00', ''))),
                      const Expanded(flex: 1,child: Text('x')),
                      Expanded(flex: 2,child: Text(currentEventExpence.price!.toStringAsFixed(2).replaceAll('.00', ''))),
                      Expanded(flex: 3,child: Text((currentEventExpence.amount! * currentEventExpence.price!).toStringAsFixed(2).replaceAll('.00', '') + ' €')),
                    ],
                  ),
                ),
              ),
            resizeDuration: Duration(milliseconds: 400),
            onDismissed: (direction) async {
              Response responseDeleteExpence = await dataBundleNotifier.getSwaggerClient().apiV1AppEventExpenceDeleteDelete(expenceEvent: currentEventExpence);

              if(responseDeleteExpence.isSuccessful){
                dataBundleNotifier.removeExpence(currentEventExpence);
              }
            },
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: kCustomBordeaux,
                  border: Border.all(color: kCustomGreen),
                  borderRadius: BorderRadius.all(Radius.circular(9))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.delete, color: Colors.white,),
                  )
                ],
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Conferma operazione"),
                    content: const Text("Sei sicuro di voler eliminare la spesa?"),
                    actions: <Widget>[
                      OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Elimina", style: TextStyle(color: kRed),)
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Indietro"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
