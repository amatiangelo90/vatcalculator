import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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
              child: Column(
                children: [
                  Center(
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
                  SizedBox(height: 10,),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: 'Conferma ed Invia',
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

}
