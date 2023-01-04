import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';

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
  void initState() {
    super.initState();
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
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              appBar: AppBar(
                bottom: const TabBar(
                  indicatorColor: kCustomGreen,
                  indicatorWeight: 3,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CARICO', style: TextStyle(color: kCustomGreen, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('SCARICO', style: TextStyle(color: kCustomBordeaux, fontWeight: FontWeight.bold),),
                    ),
                //   Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: SvgPicture.asset('assets/icons/Settings.svg', color:kCustomGrey, height: getProportionateScreenHeight(25),)
                //   ),
                  ],
                ),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      Navigator.of(context).pop(),
                    }),
                iconTheme: const IconThemeData(color: kCustomGrey),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.workstationModel.name!,
                      style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomGrey, fontWeight: FontWeight.bold),),
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

    TextEditingController controllerWorkStationName = TextEditingController(text: widget.workstationModel.name);
    TextEditingController controllerResponsible = TextEditingController(text: widget.workstationModel.responsable);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(400),
                height: getProportionateScreenHeight(55),
                child: OutlinedButton(
                  onPressed: () async {
                    if(controllerWorkStationName.text == ''){
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

                        print('asdasdsadsad '+ controllerWorkStationName.text);
                        print('asdasdsadsad '+ controllerResponsible.text);
                        Response resp = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationUpdatePut(workstation: Workstation(
                            workstationId: workstationModel.workstationId,
                            name: controllerWorkStationName.text,
                            responsable: controllerResponsible.text
                        ));

                        if(resp.isSuccessful){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              duration: Duration(milliseconds: 5000),
                              backgroundColor: kCustomGreen,
                              content: Text('Impostazioni aggiornate', style: TextStyle(color: Colors.white),)));
                        }else{
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 5000),
                              backgroundColor: Colors.red,
                              content: Text('Errore durante l\'aggiornamento dei dati. Errore: ${resp.error!.toString()}', style: TextStyle(color: Colors.white),)));
                        }

                      }catch(e){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 5000),
                            backgroundColor: Colors.red,
                            content: Text('Errore durante l\'aggiornamento dei dati. Errore: $e', style: TextStyle(color: Colors.white),)));
                      }
                    }
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                    backgroundColor: MaterialStateProperty.resolveWith((states) =>kCustomBordeaux),
                    side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  child: Text('Salva impostazioni', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
