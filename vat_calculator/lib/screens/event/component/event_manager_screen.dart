import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/expence_event_reg_card.dart';
import 'package:vat_calculator/screens/event/component/workstation_manager_screen.dart';
import 'package:vat_calculator/size_config.dart';
import '../../../constants.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import '../../home/main_page.dart';
import 'event_setting_page.dart';

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

    double width = MediaQuery.of(context).size.width;

    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){

        Iterable<Workstation> barList = dataBundleNotifier.getCurrentEvent()
            .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.bar);


        return Scaffold(
          bottomSheet: Container(
            color: kCustomGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(dataBundleNotifier.getCurrentEvent().location!, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kCustomWhite, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          key: _scaffoldKey,
          appBar: AppBar(
            actions: [
              dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const Text('') : IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, EventSettingScreen.routeName);
                },
                icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomWhite, height: getProportionateScreenWidth(30)),
              ),
            ],
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pushNamed(context, HomeScreenMain.routeName);
                }),
            iconTheme: const IconThemeData(color: kCustomWhite),
            backgroundColor: kCustomGrey,
            centerTitle: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(dataBundleNotifier.getCurrentEvent().name!,
                  style: TextStyle(fontSize: getProportionateScreenHeight(26), color: kCustomWhite, fontWeight: FontWeight.bold),),
                Text(
                  'Creato da: ' + dataBundleNotifier.getCurrentEvent().createdBy!,
                  style: TextStyle(fontSize: getProportionateScreenHeight(11), color: kCustomWhite, fontWeight: FontWeight.bold),),
              ],
            ),
            elevation: 0,
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white, width: 1, style: BorderStyle.solid)),
            child: FloatingActionButton(
              heroTag: "btn1",
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
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    backgroundColor: kCustomGreen,
                                                    duration: Duration(milliseconds: 1000),
                                                    content: Text('Postazione bar creata correttamente'
                                                    )));
                                              }else{
                                                Navigator.of(context).pop();
                                                dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                                    backgroundColor: kCustomPinkAccent,
                                                    duration: Duration(milliseconds: 1000),
                                                    content: Text('Postazione champagnerie creata correttamente'
                                                    )));
                                              }else{
                                                Navigator.of(context).pop();
                                                dataBundleNotifier.refreshEventById(createWorkstationResponse.body);
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
              child: Icon(Icons.add, color: Colors.white, size: getProportionateScreenWidth(30)),
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          backgroundColor: kCustomGrey,
          body: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
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
                            height:  width * 3/7,
                            child: OutlinedButton(
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
                                                          '  Lista Bar',
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
                                                    children: buildWorkstationListWidget(barList, dataBundleNotifier),
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
                                    child: Text(dataBundleNotifier.getCurrentEvent()
                                        .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.bar).length.toString(), style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: getProportionateScreenWidth(50),
                                        color: kCustomWhite),),
                                  ),
                                  Text('')
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, left: 4, top: 5),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                image: AssetImage("assets/png/champagnerie.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height:  width * 3/7,
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
                                    child: Text(dataBundleNotifier.getCurrentEvent()
                                        .workstations!.where((element) => element.workstationType == WorkstationWorkstationType.champagnerie).length.toString(), style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: getProportionateScreenWidth(50),
                                        color: kCustomWhite),),
                                  ),
                                  Text(''),
                                ],
                              ),
                            )
                        ),
                      ),
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

  buildEventSettingsScreen(Event event, DataBundleNotifier dataBundleNotifier, workstationModelList) {

    TextEditingController controllerEventName = TextEditingController(text: event.name);
    TextEditingController controllerLocation = TextEditingController(text: event.location);
    List<Widget> widgetList = [];
    if(event.eventStatus == EventEventStatus.chiuso){
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
          enabled: event.eventStatus == EventEventStatus.chiuso ? true : false,
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
          enabled: event.eventStatus == EventEventStatus.chiuso ? true : false,
          placeholder: 'Location',
        ),
      ),
      const Text('*campo obbligatorio'),
    ]);
    widgetList.add(
      SizedBox(height: 20),
    );
    if(event.eventStatus == EventEventStatus.aperto){
      widgetList.add(
        SizedBox(
          width: getProportionateScreenWidth(300),
          child: CupertinoButton(
              color: kCustomGreen,
              child: const Text('Salva impostazioni'),
              onPressed: () async {
                if(controllerEventName.text == null || controllerEventName.text == ''){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: kPinaColor,
                    duration: Duration(milliseconds: 600),
                    content: Text(
                        'Il nome dell\'evento è obbligatorio'),
                  ));
                }else if(controllerLocation.text == null || controllerLocation.text == ''){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: kPinaColor,
                    duration: Duration(milliseconds: 600),
                    content: Text(
                        'La location è obbligatoria'),
                  ));
                }else{

                  //event.location = controllerLocation.text;
                  //event.eventName = controllerEventName.text;

                  //dataBundleNotifier.getclientServiceInstance().updateEventModel(event);

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
      event.eventStatus == EventEventStatus.aperto ? SizedBox(
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
                          const Text('Chiudi Evento?', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Chiudendo l\'evento ${event.name} i tuoi dipendenti non potranno più accedervi. '
                                    'Puoi, in seguito, consultare gli eventi chiusi andando nella sezione \'ARCHIVIO EVENTI\'. La merce residua verrà caricata nel magazzino ${dataBundleNotifier.getCurrentBranch().storages!
                                    .where((element) => dataBundleNotifier.getCurrentEvent().storageId == element.storageId).first.name!}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
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

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Evento ' +
                                                    event.name! + ' chiuso. Residuo merce caricata in magazzino ${dataBundleNotifier.getCurrentBranch().storages!
                                                    .where((element) => dataBundleNotifier.getCurrentEvent().storageId == element.storageId).first.name!}'),
                                          ));
                                        }catch(e){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Impossibile chiudere evento ' +
                                                    event.name! + '. ' + e.toString()),
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
                          const Text('Elimina Evento?', textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontWeight: FontWeight.bold),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Eliminando l\'evento ${event.name!} tutta la merce caricata nelle postazioni lavorative verrà reinserita nel magazzino di riferimento  '
                                    '${dataBundleNotifier.getCurrentBranch().storages!
                                    .where((element) => dataBundleNotifier.getCurrentEvent().storageId == element.storageId).first.name!}.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: getProportionateScreenHeight(15))),
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

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Evento ' +
                                                    event.name! + ' Eliminato. Merce caricata in magazzino ${dataBundleNotifier.getCurrentBranch().storages!
                                                    .where((element) => dataBundleNotifier.getCurrentEvent().storageId == element.storageId).first.name!}'),
                                          ));
                                          Navigator.pushNamed(context, HomeScreenMain.routeName);

                                        }catch(e){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: const Duration(milliseconds: 3000),
                                            content: Text(
                                                'Impossibile eliminare evento ' +
                                                    event.name! + '. ' + e.toString()),
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
      color: kCustomGrey,
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

  buildResocontoScreenExtraExpences(List<Workstation> workstationModelList,
      DataBundleNotifier dataBundleNotifier, Event event, context) {
    return FutureBuilder(
      initialData: const Center(
          child: CircularProgressIndicator(
            color: kPinaColor,
          )),
      builder: (context, snapshot){
        return snapshot.data!;
      },
      future: retrieveDataToBuildRecapWidgetExtraExpences(workstationModelList, dataBundleNotifier, event, context),
    );
  }

  Future<Widget> retrieveDataToBuildRecapWidgetExtraExpences(List<Workstation> workstationModelList,
      DataBundleNotifier dataBundleNotifier,
      Event event, context) async {

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

    return Container(
      color: kCustomGrey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              event.eventStatus == EventEventStatus.chiuso ? SizedBox(
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
                          icon: Icon(Icons.add_circle, size: getProportionateScreenHeight(40), color: kCustomGreen),
                          onPressed: () {

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  scrollable: true,
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  content: ExpenceEventCard(
                                    eventModel: dataBundleNotifier.getCurrentEvent(),
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
                    child:  Text('TOTALE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen, fontSize: getProportionateScreenHeight(18)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('€ ' + totalExpenceEvent.toStringAsFixed(2).replaceAll('.00', ''), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomWhite, fontSize: getProportionateScreenHeight(20)),),
                  ),
                ],
              ),
              Divider(
                height: 44,
                color: kCustomGrey,
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
      color: kCustomGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SvgPicture.asset('assets/icons/warning.svg', color: kPinaColor, height: 100,),
              Text('WARNING', textAlign: TextAlign.center, style: TextStyle(color: kPinaColor)),                        ],
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

  buildWorkstationListWidget(Iterable<Workstation> barList, DataBundleNotifier dataBundleNotifier) {
    List<Widget> listout = [];

    for (Workstation workstation in barList) {
      listout.add(
        ListTile(
          leading: CircleAvatar(
            backgroundColor: kCustomGreen,
            child: Text(workstation.workstationId!.toString()),
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
            child: Text(workstation.name!),
          ),
        ),
      );
    }
    return listout;
  }
}

class SupportTableObj{

  int id;
  String productName;
  double amountin;
  double amountout;
  double price;
  String unitMeasure;

  SupportTableObj({required this.id,required  this.productName, required this.amountin, required this.amountout, required this.price, required this.unitMeasure});

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