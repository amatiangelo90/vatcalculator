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
                  icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomGrey, height: getProportionateScreenWidth(30)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog (
                              backgroundColor:  kCustomGrey,
                              contentPadding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  return SingleChildScrollView(
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('  Crea postazione',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: getProportionateScreenWidth(15),
                                                    fontWeight: FontWeight.bold,
                                                    color: kCustomWhite,
                                                  )),
                                              IconButton(icon: const Icon(
                                                Icons.clear,
                                                color: kCustomWhite,
                                              ), onPressed: () { Navigator.pop(context); },),

                                            ],
                                          ),
                                        ),

                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4, left: 8, top: 5),
                                              child: Container(
                                                  width: getProportionateScreenWidth(500),
                                                  height: getProportionateScreenHeight(120),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    image: DecorationImage(
                                                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                                      image: const AssetImage("assets/png/bar.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: OutlinedButton(
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
                                                        Navigator.of(context).pop();
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
                                                          padding: const EdgeInsets.all(10),
                                                          child: Text('CREA POSTAZIONE BAR',style: TextStyle(
                                                              color: kCustomWhite,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize:
                                                              getProportionateScreenWidth(
                                                                  15)),),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4, left: 8, top: 5, bottom: 20),
                                              child: Container(
                                                  width: getProportionateScreenWidth(500),
                                                  height: getProportionateScreenHeight(120),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    image: DecorationImage(
                                                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                                      image: AssetImage("assets/png/champagnerie.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: OutlinedButton(
                                                    onPressed: () async {
                                                      Response createWorkstationResponse = await dataBundleNotifier.getSwaggerClient().apiV1AppEventWorkstationCreatePost(workstation: Workstation(
                                                        workstationType: WorkstationWorkstationType.champagnerie,
                                                        eventId: dataBundleNotifier.getCurrentEvent().eventId!,
                                                        responsable: '',
                                                        name: 'NUOVA CHAMPAGNERIE',
                                                        products: [],
                                                        extra: '',
                                                      ));

                                                      if(createWorkstationResponse.isSuccessful){
                                                        Navigator.of(context).pop();
                                                        dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            backgroundColor: kCustomBordeaux,
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
                                                          padding: const EdgeInsets.all(10),
                                                          child: Text('CREA CHAMPAGNERIE',style: TextStyle(
                                                              color: kCustomWhite,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize:
                                                              getProportionateScreenWidth(
                                                                  15)),),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                        );
                      },
                      icon: Icon(Icons.add, color: kCustomGrey, size: getProportionateScreenWidth(30))
                  ),
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
                          width: getProportionateScreenWidth(600),
                          color: kCustomGreen,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Postazioni bar', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white)),
                          ),
                        ),
                        buildWorkstationListWidget(barList.toList(), dataBundleNotifier, true),
                        Container(
                          width: getProportionateScreenWidth(600),
                          color: kCustomBordeaux,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Postazioni champagnerie',textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(25), color: Colors.white)),
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
              color: kCustomBordeaux,
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
            resizeDuration: Duration(seconds: 1),
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
                  color: type == WorkstationWorkstationType.bar ? kCustomGreen : kCustomBordeaux,
                  height: getProportionateScreenHeight(50),
                  child: Center(child: Column(
                    children: [
                      Text(workstation.name!, style: TextStyle(color: Colors.white),),
                      workstation.responsable! == '' ? Text('') : Text('Responsabile: ' + workstation.responsable!, style: TextStyle(color: Colors.white),),
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
          Expanded(flex: 1, child: Icon(Icons.arrow_circle_down_outlined, color: kCustomGreen),),
          Expanded(flex: 1, child: Icon(Icons.arrow_circle_up, color: kCustomBordeaux),),
          Expanded(flex: 2, child: Text('Spesa', textAlign: TextAlign.center)),
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
              Expanded(flex: 1, child: Text(product.consumed!.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center),),
              Expanded(flex: 2, child: Text('€ ' + (product.consumed! * product.price!).toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center),),
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
      total = total + (element.price! * (element.stockFromStorage! - element.consumed!));
    });

    return total.toStringAsFixed(2).replaceAll('.00','');
  }

  buildWorkstationWidget(bool isBar, DataBundleNotifier dataBundleNotifier, Workstation workstation) {
    return ListTile(
      title: Column(
        children: [
          ListTile(
            leading: ClipRect(
              child: SvgPicture.asset(
                isBar ? 'assets/icons/bartender.svg' : 'assets/icons/bouvette.svg',
                height: getProportionateScreenHeight(40),
                color: isBar ? kCustomGreen : kCustomBordeaux,
              ),
            ),
            onTap: (){

              dataBundleNotifier.setCurrentWorkstation(workstation);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkstationManagerScreen(),
                ),
              );
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workstation.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20), color: kCustomGrey)),
                  Text(workstation.responsable!.isEmpty ? '' : 'Responsabile: ' + workstation.responsable!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kCustomGrey)),
                  Divider()
                ],
              ),
            ),
          ),
          const Divider(color: kCustomWhite, height: 4, endIndent: 80,),
        ],
      ),
    );
  }
}
