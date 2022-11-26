import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/expence_event_model.dart';
import 'package:vat_calculator/helper/keyboard.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class EditingExpenceEventCard extends StatefulWidget {
  const EditingExpenceEventCard({Key? key,required this.expenceEventModel}) : super(key: key);

  final ExpenceEventModel expenceEventModel;

  @override
  _EditingExpenceEventCardState createState() => _EditingExpenceEventCardState();
}

class _EditingExpenceEventCardState extends State<EditingExpenceEventCard> {


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {

        TextEditingController expenceController = TextEditingController(text: widget.expenceEventModel.cost.toStringAsFixed(2));
        TextEditingController casualeExpenceController = TextEditingController(text: widget.expenceEventModel.description);
        TextEditingController amountController = TextEditingController(text: widget.expenceEventModel.amount.toStringAsFixed(2));

        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: kPrimaryColor,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Gestione spesa', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(15))
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.white,
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.white,
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Text('Quantità', style: TextStyle(color: Colors.white),),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(100),
                                child: CupertinoTextField(
                                  controller: amountController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: const TextInputType.numberWithOptions(signed: false,decimal:  true),
                                  clearButtonMode: OverlayVisibilityMode.never,
                                  textAlign: TextAlign.center,
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                            child: Text('X', style: TextStyle(color: Colors.white)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Text('Importo (€)', style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(120),
                                child: CupertinoTextField(
                                  controller: expenceController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: false,
                                      decimal: true
                                  ),
                                  clearButtonMode: OverlayVisibilityMode.never,
                                  textAlign: TextAlign.center,
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 4,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: Text('Casuale', style: TextStyle(color: Colors.white)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SizedBox(
                              width: getProportionateScreenWidth(300),
                              child: CupertinoTextField(
                                controller: casualeExpenceController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                clearButtonMode: OverlayVisibilityMode.never,
                                textAlign: TextAlign.center,
                                autocorrect: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        endIndent: 10,
                        indent: 10,
                        height: 50,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(400),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SizedBox(
                            width: getProportionateScreenWidth(320),
                            child: CupertinoButton(
                              pressedOpacity: 0.5,
                              child: const Text('Aggiorna'),
                              color: Colors.blueAccent,
                              onPressed: () async {
                                try {
                                  KeyboardUtil.hideKeyboard(context);
                                  if (expenceController.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire importo',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else if (double.tryParse(
                                      expenceController.text.replaceAll(",", ".")) ==
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire un importo corretto',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  }else if (double.tryParse(
                                      amountController.text.replaceAll(",", ".")) ==
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire una quantità corretta',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else if (casualeExpenceController.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                            const Duration(milliseconds: 2000),
                                            backgroundColor:
                                            Colors.redAccent.withOpacity(0.8),
                                            content: const Text(
                                              'Inserire casuale',
                                              style: TextStyle(color: Colors.white),
                                            )));
                                  } else {
                                    try {

                                      dataBundleNotifier.getclientServiceInstance().updateEventExpenceModel(
                                          ExpenceEventModel(
                                              pkEventExpenceId: widget.expenceEventModel.pkEventExpenceId,
                                              description: casualeExpenceController.text,
                                              amount: double.parse(amountController.text.replaceAll(",", ".")),
                                              cost: double.parse(expenceController.text.replaceAll(",", ".")),
                                              dateTimeInsert: DateTime.now().millisecondsSinceEpoch,
                                              fkEventId: widget.expenceEventModel.fkEventId));

                                      dataBundleNotifier.updateExpenceEventItem(ExpenceEventModel(
                                          pkEventExpenceId: widget.expenceEventModel.pkEventExpenceId,
                                          description: casualeExpenceController.text,
                                          amount: double.parse(amountController.text.replaceAll(",", ".")),
                                          cost: double.parse(expenceController.text.replaceAll(",", ".")),
                                          dateTimeInsert: DateTime.now().millisecondsSinceEpoch,
                                          fkEventId: widget.expenceEventModel.fkEventId));

                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 6000),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                                style: const TextStyle(
                                                    fontFamily: 'LoraFont',
                                                    color: Colors.white),
                                              )));
                                    }

                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: const Duration(milliseconds: 6000),
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                      style: const TextStyle(
                                          fontFamily: 'LoraFont',
                                          color: Colors.white),
                                    ),
                                  ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 10,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(400),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SizedBox(
                            width: getProportionateScreenWidth(320),
                            child: CupertinoButton(
                              pressedOpacity: 0.5,
                              child: const Text('Elimina Spesa'),
                              color: Colors.red,
                              onPressed: () async {
                                try {
                                  KeyboardUtil.hideKeyboard(context);
                                    try {
                                      dataBundleNotifier.getclientServiceInstance().deleteEventExpenceModel(
                                          ExpenceEventModel(
                                              pkEventExpenceId: widget.expenceEventModel.pkEventExpenceId,
                                              description: casualeExpenceController.text,
                                              amount: double.parse(amountController.text.replaceAll(",", ".")),
                                              cost: double.parse(expenceController.text.replaceAll(",", ".")),
                                              dateTimeInsert: DateTime.now().millisecondsSinceEpoch,
                                              fkEventId: widget.expenceEventModel.fkEventId));

                                      dataBundleNotifier.removeExpenceEventItem(ExpenceEventModel(
                                          pkEventExpenceId: widget.expenceEventModel.pkEventExpenceId,
                                          description: casualeExpenceController.text,
                                          amount: double.parse(amountController.text.replaceAll(",", ".")),
                                          cost: double.parse(expenceController.text.replaceAll(",", ".")),
                                          dateTimeInsert: DateTime.now().millisecondsSinceEpoch,
                                          fkEventId: widget.expenceEventModel.fkEventId));

                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 6000),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                                style: const TextStyle(
                                                    fontFamily: 'LoraFont',
                                                    color: Colors.white),
                                              )));
                                    }
                                    Navigator.of(context).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: const Duration(milliseconds: 6000),
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Abbiamo riscontrato un errore durante l\'operazione. Riprova più tardi. Errore: $e',
                                      style: const TextStyle(
                                          fontFamily: 'LoraFont',
                                          color: Colors.white),
                                    ),
                                  ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
