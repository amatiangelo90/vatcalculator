import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
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

  List<ExpenceEvent> selectedExpences = [];

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        Iterable<Workstation> barList = dataBundleNotifier.getCurrentEvent()
            .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.bar);

        Iterable<Workstation> champList = dataBundleNotifier.getCurrentEvent()
            .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.champagnerie);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              bottom: TabBar(
                indicatorColor: kCustomGrey,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Workstations', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10)),),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Contabilità', style: TextStyle(color:  kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10)),),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Spese', style: TextStyle(color:  kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(10)),),
                    ),
                  ),
                ],
              ),
              actions: [
                dataBundleNotifier.getCurrentBranch().userPriviledge != BranchUserPriviledge.employee ? IconButton(
                  onPressed: (){
                    _createExcel();
                  },
                  icon: SvgPicture.asset('assets/icons/excel.svg', height: getProportionateScreenWidth(30)),
                ) :  const Text(''),
                dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.aperto ? dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const Text('') : IconButton(
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
                                                  Navigator.of(context).pop();

                                                  return await showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Conferma operazione"),
                                                        content: const Text("Una volta eliminato l\'evento tutti i prodotti registrati nelle workstation verranno ricaricati nei magazzini di provenienza. L\'operazione non è reversibile e verranno persi tutti i dati. Continuare?"),
                                                        actions: <Widget>[
                                                          OutlinedButton(
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

                                                  Navigator.of(context).pop();

                                                  return await showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Conferma operazione"),
                                                        content: const Text("Una volta chiuso l\'evento la giacenza registrata per ogni singolo prodotto verrà ricaricata nel magazzino di provenienza. L\'evento non sarà piu visibile nel calendario e ai tuoi collaboratori. Potrai comunque consultare gli eventi chiusi nella sezione \'Archivio Eventi\'. Continuare?"),
                                                        actions: <Widget>[
                                                          OutlinedButton(
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
                                                              child: const Text("Chiudi Evento", style: TextStyle(color: kRed),)
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
                ) : SizedBox(height: 1),
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
                        SizedBox(
                          height: getProportionateScreenHeight(70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: SvgPicture.asset('assets/icons/storage.svg', color: Colors.black, height: getProportionateScreenHeight(40),),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Magazzino di riferimento: ', style: TextStyle(fontSize: getProportionateScreenHeight(7), color: kCustomGrey, fontWeight: FontWeight.bold),),
                                  Text(dataBundleNotifier.getStorageById(dataBundleNotifier.getCurrentEvent().storageId!).name!, style: TextStyle(fontSize: getProportionateScreenHeight(16), color: Colors.grey.shade700, fontWeight: FontWeight.bold),),
                                  Text('Location: ', style: TextStyle(fontSize: getProportionateScreenHeight(7), color: kCustomGrey, fontWeight: FontWeight.bold),),
                                  Text(dataBundleNotifier.getCurrentEvent().location!, style: TextStyle(fontSize: getProportionateScreenHeight(18), color: Colors.grey.shade700, fontWeight: FontWeight.bold),),
                                ],
                              ),Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: SvgPicture.asset('assets/icons/Location point.svg', color: Colors.black, height: getProportionateScreenHeight(40),),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: kCustomGreen,
                              border: Border.all(color: kCustomGreen),
                              borderRadius: BorderRadius.all(Radius.circular(9))
                          ),
                          width: getProportionateScreenWidth(600),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('BAR', textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(16), color: Colors.white)),
                                dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.aperto ? OutlinedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                    ),
                                    onPressed: () async {
                                      if(dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: Duration(milliseconds: 3000),
                                            content: Text('Non hai i permessi per creare una nuova postazione'
                                            )));
                                      }else{
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
                                      }

                                    },
                                    child: const Text("Crea nuovo", style: TextStyle(color: Colors.white),)
                                ) : Text(''),
                              ],
                            ),
                          ),
                        ),
                        buildWorkstationListWidget(barList.toList(), dataBundleNotifier, true),
                        Container(
                          width: getProportionateScreenWidth(600),
                          decoration: BoxDecoration(
                            color: kCustomBordeaux,
                            border: Border.all(color: kCustomBordeaux),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('CHAMPAGNERIE',textAlign: TextAlign.center, style: TextStyle(fontSize: getProportionateScreenHeight(16), color: Colors.white)),
                                dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.aperto ? OutlinedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomBordeaux),
                                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                    ),
                                    onPressed: () async {

                                      if(dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: Duration(milliseconds: 3000),
                                            content: Text('Non hai i permessi per creare una nuova postazione'
                                            )));
                                      }else{
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
                                      }

                                    },
                                    child: const Text("Crea nuovo", style: TextStyle(color: Colors.white),)
                                ) : Text('')
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
                    child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                      ),
                                      child: Center(child: Column(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Resoconto', style: TextStyle(color: Colors.white, fontSize: 16),),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            buildRecapAllWorkstationExpences(
                                dataBundleNotifier.getCurrentEvent()
                            ),
                            buildTotalTableRecap(dataBundleNotifier, false, true, true),
                            buildRecapWorkstationExpences(
                                dataBundleNotifier.getCurrentEvent(),
                                WorkstationWorkstationType.bar
                            ),
                            buildRecapWorkstationExpences(
                                dataBundleNotifier.getCurrentEvent(),
                                WorkstationWorkstationType.champagnerie
                            ),
                            const SizedBox(height: 50),
                          ],
                        )
                    )
                ),
                if (dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee) const Center(child: Text('Non hai i permessi per visualizzare questa pagina')) else Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  buildExpenceWidget(dataBundleNotifier),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20,
                                    color: Colors.blue,
                                  ),
                                  buildTotalTableRecap(dataBundleNotifier, true, true, true),
                                  SizedBox(height: 150),
                                ],
                              )
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(alignment: Alignment.bottomRight, child: FloatingActionButton(
                          child: Icon(Icons.add, size: getProportionateScreenHeight(30),),

                          onPressed: (){

                            TextEditingController amountController = TextEditingController();
                            TextEditingController descriptionController = TextEditingController();
                            TextEditingController priceController = TextEditingController();

                            Widget saveButton = TextButton(
                              child: const Text("Salva", style: TextStyle(color: kCustomGreen),),
                              onPressed:  () async {

                                Response apiV1AppEventExpenceCreatePost = await dataBundleNotifier.getSwaggerClient().apiV1AppEventExpenceCreatePost(expenceEvent: ExpenceEvent(
                                    amount: double.parse(amountController.text.replaceAll(',', '.')),
                                    description: descriptionController.text,
                                    price: double.parse(priceController.text.replaceAll(',', '.')),
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
                                                  padding: EdgeInsets.all(3.0),
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
                                              Wrap(

                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Barman';
                                                        priceController.text = '80';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Barman - 80€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Cameriere';
                                                        priceController.text = '60';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Cameriere - 60€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Assunzione';
                                                        priceController.text = '35';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Assunzione - 35€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Drink base';
                                                        priceController.text = '1.9';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Drink base - 1.9€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Drink premium';
                                                        priceController.text = '3.5';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Drink premium - 3.5€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Kit base';
                                                        priceController.text = '28';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Kit base - 28€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Kit premium';
                                                        priceController.text = '50';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Kit premium - 50€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Champagne';
                                                        priceController.text = '50';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Champagne - 50€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Ca del bosco';
                                                        priceController.text = '30';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Ca del bosco - 30€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        descriptionController.text = 'Prosecco';
                                                        priceController.text = '11';
                                                      }
                                                      );
                                                    },
                                                    child: const Chip(
                                                      label: Text('Prosecco - 11€', style: TextStyle(color: Colors.white)),
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                                alignment: WrapAlignment.center,
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
                          })),
                    ),
                  ],
                ),
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
            direction: dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.aperto ? DismissDirection.endToStart : DismissDirection.none,
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




  buildRecapAllWorkstationExpences(Event currentEvent) {

    List<Widget> tableRecapRow = [];

    List<RWorkstationProduct> normalizedProd = normalizeProducts(currentEvent.workstations!);

    tableRecapRow.add(Row(
      children: [
        Expanded(flex: 3, child: Text('Prodotto', style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(16)),),),
        const Expanded(flex: 1, child: Tooltip(message: 'Carico',child: Icon(Icons.arrow_circle_down_outlined, color: kCustomGreen)),),
        const Expanded(flex: 1, child: Tooltip(message: 'Giacenza',child: Icon(Icons.arrow_circle_up, color: kCustomBordeaux)),),
        const Expanded(flex: 1, child: Tooltip(message: 'Consumato',child: Icon(Icons.storage, color: kCustomBlue)),),
        Expanded(flex: 2, child: Text('Spesa', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(16)),),),
      ],
    ));
    for (var product in normalizedProd) {
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
          Expanded(flex: 2, child: Text('€ ' + calculateTotal(normalizedProd), textAlign: TextAlign.center),),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: tableRecapRow,
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: type == WorkstationWorkstationType.bar ? kCustomGreen : kCustomBordeaux,

                    ),
                    child: Center(child: Column(
                      children: [
                        Text(workstation.name!, style: TextStyle(color: Colors.white),),
                        workstation.responsable! == '' ? Text('') : Text('Responsabile: ' + workstation.responsable!, style: TextStyle(color: Colors.white),),
                      ],
                    )),
                  ),
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
        if(dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.aperto){
          dataBundleNotifier.setCurrentWorkstation(workstation);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkstationManagerScreen(),
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: kCustomBordeaux,
            duration: Duration(seconds: 2),
            content: Text('Evento chiuso. Per visualizzare le informazioni della postazione lavorativa vai nella sezione spese.'),
          ));
        }

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
          dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.aperto ? IconButton(
            onPressed: (){
              if(dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: kCustomBordeaux,
                  duration: Duration(seconds: 2),
                  content: Text('Utente non abilitato alla modifica della postazione bar'),
                ));
              }else{
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
                            height: getProportionateScreenHeight(350),
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
              }

            },
            icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomGrey, height: getProportionateScreenWidth(30)),
          ) : Text(''),
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

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: getProportionateScreenHeight(100),
                child: ListView.builder(
                  itemCount: dataBundleNotifier.userBranchList!.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            controllerResponsable.text = dataBundleNotifier.userBranchList[index].userEntity!.name! + ' ' + dataBundleNotifier.userBranchList[index].userEntity!.lastname!;
                          });
                        },
                        child: Column(
                          children: [
                            dataBundleNotifier.userBranchList[index].userEntity!.photo != null ?
                            CircleAvatar(
                              backgroundImage: NetworkImage(dataBundleNotifier.userBranchList[index].userEntity!.photo!),
                            ) : const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/monkey.png'),
                            ),

                            Text(dataBundleNotifier.userBranchList[index].userEntity!.name!, style: TextStyle(
                                fontSize: getProportionateScreenWidth(10),
                                color: kCustomGrey),),
                            Text(dataBundleNotifier.userBranchList[index].userEntity!.lastname!, style: TextStyle(
                                fontSize: getProportionateScreenWidth(7),
                                color: kCustomGrey),),
                          ],
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),

          SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoTextField(
              enabled: false,
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
                  backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
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

    final columns = ['Desc', 'Q', 'C (€)', 'Tot (€)'];

    return DataTable(
      columnSpacing: getProportionateScreenWidth(40),
      columns: getColumns(columns),
      rows: buildRows(dataBundleNotifier),
    );
  }

  List<Widget> buildListAvatars(List<UserBranch> listUserBranch) {
    List<Widget> widget = [];
    listUserBranch.forEach((userBranch) {
      widget.add(Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: (){

          },
          child: Column(

            children: [
              userBranch.userEntity!.photo != null ?
              CircleAvatar(
                backgroundImage: NetworkImage(userBranch.userEntity!.photo!),
              ) : const CircleAvatar(
                backgroundImage: AssetImage('assets/images/monkey.png'),
              ),

              Text(userBranch.userEntity!.name!, style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: kCustomGrey),),
              Text(userBranch.userEntity!.lastname!, style: TextStyle(
                  fontSize: getProportionateScreenWidth(7),
                  color: kCustomGrey),),
            ],
          ),
        ),
      ),);
    });

    return widget;
  }

  List<RWorkstationProduct> normalizeProducts(List<Workstation> workstations) {
    List<RWorkstationProduct> rWorkStationProdList = [];

    for (var workstation in workstations) {
      for (var prod in workstation.products!) {

        if(rWorkStationProdList.where((rWorkProd) => rWorkProd.productId == prod.productId).isNotEmpty){

          RWorkstationProduct rWorkstationProduct = RWorkstationProduct.fromJson(rWorkStationProdList.where((rWorkProd) => rWorkProd.productId == prod.productId).first!.toJson());
          rWorkstationProduct.leftOvers = rWorkstationProduct.leftOvers! + prod.leftOvers!;
          rWorkstationProduct.stockFromStorage = rWorkstationProduct.stockFromStorage! + prod.stockFromStorage!;
          rWorkStationProdList.removeWhere((element) => element.productId == prod.productId);
          rWorkStationProdList.add(rWorkstationProduct);

        }else{
          rWorkStationProdList.add(prod);
        }
      }
    }

    return rWorkStationProdList;

  }

  getColumns(List<String> columns) => columns.map((String columnName) => DataColumn(
    label: Center(child: Text(' ' + columnName, style: TextStyle(fontSize: getProportionateScreenWidth(12)), textAlign: TextAlign.center,)),
  )).toList();

  List<DataRow> buildRows(DataBundleNotifier dataBundle) =>

      dataBundle.getCurrentEvent().expenceEvents!.map((ExpenceEvent exp) => DataRow(
          selected: selectedExpences.contains(exp),
          onLongPress: (){
            TextEditingController amountController = TextEditingController(text: exp.amount!.toStringAsFixed(2).replaceAll('.00', ''));
            TextEditingController descriptionController = TextEditingController(text: exp.description);
            TextEditingController priceController = TextEditingController(text: exp.price!.toStringAsFixed(2).replaceAll('.00', ''));

            Widget saveButton = TextButton(
              child: const Text("Aggiorna", style: TextStyle(color: kCustomGreen),),
              onPressed:  () async {

                Response apiV1AppEventExpenceCreatePost = await dataBundle.getSwaggerClient().apiV1AppEventExpenceUpdatePut(expenceEvent: ExpenceEvent(
                    amount: double.parse(amountController.text),
                    expenceId: exp.expenceId,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    eventId: dataBundle.getCurrentEvent().eventId!.toInt()
                ));

                if(apiV1AppEventExpenceCreatePost.isSuccessful){

                  dataBundle.updateExpenceToCurrentEvent(amount: double.parse(amountController.text),
                      expenceId: exp.expenceId!,
                      description: descriptionController.text,
                      price: double.parse(priceController.text),
                      eventId: dataBundle.getCurrentEvent().eventId!.toInt());
                  Navigator.of(context).pop();
                }else{
                  Navigator.of(context).pop();
                }
              },
            );

            Widget deleteButton = TextButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Conferma operazione"),
                      content: const Text("Sei sicuro di voler eliminare la spesa?"),
                      actions: <Widget>[
                        OutlinedButton(
                            onPressed: () async {
                              Response responseDeleteExpence = await dataBundle.getSwaggerClient().apiV1AppEventExpenceDeleteDelete(expenceEvent: exp);

                              if(responseDeleteExpence.isSuccessful){
                                dataBundle.removeExpence(exp);
                                setState((){
                                  selectedExpences.remove(exp);
                                });
                                Navigator.of(context).pop(false);
                              }else{
                                print(responseDeleteExpence.error);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: kCustomGreen,
                                  duration: Duration(seconds: 1),
                                  content: Text('Errore: ' + responseDeleteExpence.error.toString()),
                                ));
                                Navigator.of(context).pop(false);
                              }
                            },
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


              }, child: const Text("Cancella", style: TextStyle(color: kCustomBordeaux),),
            );

            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  actions: [
                    deleteButton,
                    saveButton,
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
                                        child: Text('Modifica spesa evento',
                                          style: TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      IconButton(icon: const Icon(Icons.clear), onPressed: (){
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
          onSelectChanged: (isSelected){
            setState((){
              final isAdding = isSelected != null && isSelected;
              isAdding ? selectedExpences.add(exp) : selectedExpences.remove(exp);
            });
          },
          cells: [
            DataCell(Text(exp.description.toString())),
            DataCell(Text(exp.amount!.toStringAsFixed(2).replaceAll('.00', ''))),
            DataCell(Text(exp.price!.toStringAsFixed(2).replaceAll('.00', '') + ' €')),
            DataCell(Text((exp.price! * exp.amount!).toStringAsFixed(2).replaceAll('.00', '') + ' €')),
          ]
      )).toList();

  Widget buildTotalTableRecap(DataBundleNotifier dataBundleNotifier, bool totB, bool totSelB, bool totUnselB) {
    double tot = 0.0;
    for (var element in dataBundleNotifier.getCurrentEvent().expenceEvents!) {
      tot = tot + (element.price! * element.amount!);
    }

    double totSelected = 0.0;
    for (var exp in selectedExpences) {
      totSelected = totSelected + (exp.price! * exp.amount!);
    }


    List<DataRow> list = [];


    if(totSelB){
      list.add(DataRow(
      cells: [
      DataCell(Row(
    children: const [
    Icon(Icons.check_box, color: Colors.blue),
    Text(' Totale selezionati'),
    ],
    )),
    DataCell(Text(totSelected.toStringAsFixed(2).replaceAll('.00', '') + ' €')),
    ]
    ));
    }

    if(totUnselB){
      list.add(
          DataRow(
              cells: [
                DataCell(Row(
                  children: const [
                    Icon(Icons.check_box_outline_blank, color: Colors.grey),
                    Text(' Totale non selezionati'),
                  ],
                )),
                DataCell(Text((tot - totSelected).toStringAsFixed(2).replaceAll('.00', '') + ' €')),
              ]
          )
      );
    }
    if(totB){
      list.add(DataRow(
          cells: [
            DataCell(Row(
              children: const [
                Icon(Icons.checklist, color: Colors.green),
                Text(' Totale'),
              ],
            )),
            DataCell(Text(tot.toStringAsFixed(2).replaceAll('.00', '') + ' €')),
          ]
      ));
    }
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            rows: list,
            columns: [
              DataColumn(label: Text('')),
              DataColumn(label: Text('')),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createExceel() async {
    final excel.Workbook workbook = excel.Workbook();
    final List<int> bytes = workbook.saveAsStream();


    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsm';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);

  }


  Future<void> _createExcel() async {

    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    sheet.getRangeByName('B4').setText('Invoice');
    sheet.getRangeByName('B4').cellStyle.fontSize = 32;

    sheet.getRangeByName('B8').setText('BILL TO:');
    sheet.getRangeByName('B8').cellStyle.fontSize = 9;
    sheet.getRangeByName('B8').cellStyle.bold = true;

    sheet.getRangeByName('B9').setText('Abraham Swearegin');
    sheet.getRangeByName('B9').cellStyle.fontSize = 12;

    sheet
        .getRangeByName('B10')
        .setText('United States, California, San Mateo,');
    sheet.getRangeByName('B10').cellStyle.fontSize = 9;

    sheet.getRangeByName('B11').setText('9920 BridgePointe Parkway,');
    sheet.getRangeByName('B11').cellStyle.fontSize = 9;

    sheet.getRangeByName('B12').setNumber(9365550136);
    sheet.getRangeByName('B12').cellStyle.fontSize = 9;
    sheet.getRangeByName('B12').cellStyle.hAlign = excel.HAlignType.left;

    final excel.Range range1 = sheet.getRangeByName('F8:G8');
    final excel.Range range2 = sheet.getRangeByName('F9:G9');
    final excel.Range range3 = sheet.getRangeByName('F10:G10');
    final excel.Range range4 = sheet.getRangeByName('F11:G11');
    final excel.Range range5 = sheet.getRangeByName('F12:G12');

    range1.merge();
    range2.merge();
    range3.merge();
    range4.merge();
    range5.merge();

    sheet.getRangeByName('F8').setText('INVOICE#');
    range1.cellStyle.fontSize = 8;
    range1.cellStyle.bold = true;
    range1.cellStyle.hAlign = excel.HAlignType.right;

    sheet.getRangeByName('F9').setNumber(2058557939);
    range2.cellStyle.fontSize = 9;
    range2.cellStyle.hAlign = excel.HAlignType.right;

    sheet.getRangeByName('F10').setText('DATE');
    range3.cellStyle.fontSize = 8;
    range3.cellStyle.bold = true;
    range3.cellStyle.hAlign = excel.HAlignType.right;

    sheet.getRangeByName('F11').dateTime = DateTime(2020, 08, 31);
    sheet.getRangeByName('F11').numberFormat =
    '[\$-x-sysdate]dddd, mmmm dd, yyyy';
    range4.cellStyle.fontSize = 9;
    range4.cellStyle.hAlign = excel.HAlignType.right;

    range5.cellStyle.fontSize = 8;
    range5.cellStyle.bold = true;
    range5.cellStyle.hAlign = excel.HAlignType.right;

    final excel.Range range6 = sheet.getRangeByName('B15:G15');
    range6.cellStyle.fontSize = 10;
    range6.cellStyle.bold = true;

    sheet.getRangeByIndex(15, 2).setText('Code');
    sheet.getRangeByIndex(16, 2).setText('CA-1098');
    sheet.getRangeByIndex(17, 2).setText('LJ-0192');
    sheet.getRangeByIndex(18, 2).setText('So-B909-M');
    sheet.getRangeByIndex(19, 2).setText('FK-5136');
    sheet.getRangeByIndex(20, 2).setText('HL-U509');

    sheet.getRangeByIndex(15, 3).setText('Description');
    sheet.getRangeByIndex(16, 3).setText('AWC Logo Cap');
    sheet.getRangeByIndex(17, 3).setText('Long-Sleeve Logo Jersey, M');
    sheet.getRangeByIndex(18, 3).setText('Mountain Bike Socks, M');
    sheet.getRangeByIndex(19, 3).setText('ML Fork');
    sheet.getRangeByIndex(20, 3).setText('Sports-100 Helmet, Black');

    sheet.getRangeByIndex(15, 3, 15, 4).merge();
    sheet.getRangeByIndex(16, 3, 16, 4).merge();
    sheet.getRangeByIndex(17, 3, 17, 4).merge();
    sheet.getRangeByIndex(18, 3, 18, 4).merge();
    sheet.getRangeByIndex(19, 3, 19, 4).merge();
    sheet.getRangeByIndex(20, 3, 20, 4).merge();

    sheet.getRangeByIndex(15, 5).setText('Quantity');
    sheet.getRangeByIndex(16, 5).setNumber(2);
    sheet.getRangeByIndex(17, 5).setNumber(3);
    sheet.getRangeByIndex(18, 5).setNumber(2);
    sheet.getRangeByIndex(19, 5).setNumber(6);
    sheet.getRangeByIndex(20, 5).setNumber(1);

    sheet.getRangeByIndex(15, 6).setText('Price');
    sheet.getRangeByIndex(16, 6).setNumber(8.99);
    sheet.getRangeByIndex(17, 6).setNumber(49.99);
    sheet.getRangeByIndex(18, 6).setNumber(9.50);
    sheet.getRangeByIndex(19, 6).setNumber(175.49);
    sheet.getRangeByIndex(20, 6).setNumber(34.99);

    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    //Save and launch file.
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

}












