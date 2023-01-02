import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import 'event_manager_screen.dart';

class WorkstationManagerScreen extends StatefulWidget {
  const WorkstationManagerScreen({Key? key,
    required this.workstationModel}) : super(key: key);

  final Workstation workstationModel;

  @override
  State<WorkstationManagerScreen> createState() => _WorkstationManagerScreenState();
}

class _WorkstationManagerScreenState extends State<WorkstationManagerScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loadPaxController = TextEditingController(text: '');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Consumer<DataBundleNotifier>(
        builder: (child, dataBundleNotifier, _){
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: kCustomGrey,
              key: _scaffoldKey,
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: kCustomGreen,
                  indicatorWeight: 2,
                  tabs: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CARICO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('SCARICO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/Settings.svg', color:Colors.white, height: getProportionateScreenHeight(25),)
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
                backgroundColor: kCustomGrey,
                elevation: 5,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.workstationModel.name!,
                      style: TextStyle(fontSize: getProportionateScreenHeight(19), color: Colors.white, fontWeight: FontWeight.bold),),
                    Text(
                      'Tipo workstation: ' + workstationWorkstationTypeToJson(widget.workstationModel.workstationType!)!,
                      style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGreen, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Text(''),
                  Text(''),
                  //buildRefillWorkstationProductsPage(!, dataBundleNotifier),
                  //buildUnloadWorkstationProductsPage(dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId]!, dataBundleNotifier),
                  dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee
                      ? getPriviledgeWarningContainer() :
                  buildConfigurationWorkstationPage(widget.workstationModel, dataBundleNotifier),
                ],
              ),
            ),
          );
        },
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

  buildConfigurationWorkstationPage(Workstation workstationModel, DataBundleNotifier dataBundleNotifier) {

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
                  Text('Nome Postazione*',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  Text('Responsabile',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: CupertinoButton(
                        color: kCustomGreen,
                        child: const Text('Salva Impostazioni'),
                        onPressed: () async {
                          if(controllerWorkStationName.text == null || controllerWorkStationName.text == ''){
                            print('Il nome della postazione è obbligatorio');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: kPinaColor,
                              duration: Duration(milliseconds: 600),
                              content: Text(
                                  'Il nome della postazione è obbligatorio'),
                            ));
                          }else{
                            KeyboardUtil.hideKeyboard(context);
                            try{
                              controllerWorkStationName.text;
                              controllerResponsible.text;

                              //dataBundleNotifier.getSwaggerClient().upda
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
                ],
              ),
              Divider(
                height: getProportionateScreenHeight(50),
                color: kCustomGrey,
                endIndent: 50,
                indent: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: CupertinoButton(
                        color: Colors.red.shade700.withOpacity(0.9),
                        child: Text('Elimina ${widget.workstationModel.name}'),
                        onPressed: () async {
                          if(dataBundleNotifier.getCurrentEvent().eventStatus == EventEventStatus.chiuso){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: kPinaColor,
                              duration: Duration(milliseconds: 3000),
                              content: Text(
                                  'L\'evento ${dataBundleNotifier.getCurrentEvent().name} è chiuso. Non puoi eliminare la postazione.'),
                            ));
                          }else{
                            try{
                              Navigator.pushNamed(context, EventManagerScreen.routeName);
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
                          }
                        }),
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
