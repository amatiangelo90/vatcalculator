import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';

import '../../../constants.dart';
import '../../../models/databundlenotifier.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';

class EventSettingScreen extends StatefulWidget {
  const EventSettingScreen({Key? key}) : super(key: key);

  static String routeName = 'eventsetting';

  @override
  State<EventSettingScreen> createState() => _EventSettingScreenState();
}

class _EventSettingScreenState extends State<EventSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: buildWorkstationManagerItems(dataBundleNotifier),
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop(false);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            centerTitle: true,
            title: Text(dataBundleNotifier.getCurrentEvent().name!, style: TextStyle(color: kCustomGrey)),
          ),
        );
      },
    );
  }

  buildWorkstationManagerItems(DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [];

    for (Workstation workstation in dataBundleNotifier.getCurrentEvent()!.workstations!) {
      TextEditingController controllerName = TextEditingController(text: workstation.name);
      TextEditingController controllerResponsable = TextEditingController(text: workstation.responsable);
      list.add(
        Card(
          shadowColor: kCustomGrey,
          child: Padding(
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
                    keyboardType: const TextInputType.numberWithOptions(signed: false,decimal:  true),
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
                              workstationId: workstation.workstationId
                          ));

                          if(responseupdate.isSuccessful){

                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: kCustomGreen,
                              duration: Duration(milliseconds: 2600),
                              content: Text(
                                  'Impostazioni salvate correttamente'),
                            ));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: kCustomGreen,
                              duration: Duration(milliseconds: 2600),
                              content: Text(
                                  'Errore durante il salvataggio. Err: ' + responseupdate.error.toString() ),
                            ));
                          }
                        }
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.resolveWith((states) => 5),
                        backgroundColor: MaterialStateProperty.resolveWith((states) => workstation.workstationType == WorkstationWorkstationType.bar ? kCustomGreen : kCustomPinkAccent),
                        side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                      ),
                      child: Text('Salva impostazioni', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      );
    }
    return list;
  }
}
