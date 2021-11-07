import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class Contact extends StatefulWidget {
  const Contact({Key key}) : super(key: key);

  static String routeName = 'companyregistration';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactState();
  }
}

class ContactState extends State<Contact> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){

        TextEditingController controllerPIva = TextEditingController();
        TextEditingController controllerCompanyName = TextEditingController();
        TextEditingController controllerEmail = TextEditingController(text: dataBundleNotifier.dataBundleList[0].email);
        TextEditingController controllerAddress = TextEditingController();
        TextEditingController controllerCity = TextEditingController();
        TextEditingController controllerCap = TextEditingController();
        TextEditingController controllerMobileNo = TextEditingController();

        return Scaffold(
          body: Form(
            autovalidate: false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: controllerEmail,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Email',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Nome Attività',
                    keyboardType: TextInputType.emailAddress,
                    controller: controllerCompanyName,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Nome Attività',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Partita Iva',
                    keyboardType: TextInputType.emailAddress,
                    controller: controllerPIva,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Partita Iva',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Indirizzo',
                    keyboardType: TextInputType.emailAddress,
                    controller: controllerAddress,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Indirizzo',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Città',
                    keyboardType: TextInputType.emailAddress,
                    controller: controllerCity,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Città',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Cap',
                    keyboardType: TextInputType.number,
                    controller: controllerCap,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Cap',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    restorationId: 'Cellulare',
                    keyboardType: TextInputType.number,
                    controller: controllerMobileNo,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    autocorrect: false,
                    placeholder: 'Cellulare',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}