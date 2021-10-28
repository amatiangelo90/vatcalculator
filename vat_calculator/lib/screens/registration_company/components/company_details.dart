import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class Contact extends StatefulWidget {
  const Contact({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactState();
  }
}

class ContactState extends State<Contact> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static TextEditingController controllerPIva = TextEditingController();
  static TextEditingController controllerCompanyName = TextEditingController();
  static TextEditingController controllerEmail = TextEditingController();
  static TextEditingController controllerAddress = TextEditingController();
  static TextEditingController controllerCity = TextEditingController();
  static TextEditingController controllerCap = TextEditingController();
  static TextEditingController controllerMobileNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Form(
          key: formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              TextFormField(
                enabled: false,
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  hintText: dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].email : '',
                  hintStyle: const TextStyle(color: Colors.black),
                  disabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                ),
                controller: controllerEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.add_business,
                    color: Colors.grey,
                  ),
                  hintText: 'Ragione Sociale',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerCompanyName,
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.all_inbox,
                    color: Colors.grey,
                  ),
                  hintText: 'Partita Iva',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerPIva,
              ),
              const SizedBox(height: 20),
              TextFormField(
                minLines: 1,
                maxLines: 2,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  hintText: 'Indirizzo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerAddress,
              ),
              const SizedBox(height: 20),TextFormField(
                minLines: 1,
                maxLines: 2,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  hintText: 'Città',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerCity,
              ),
              const SizedBox(height: 20),TextFormField(
                minLines: 1,
                maxLines: 2,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  hintText: 'Cap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerCap,
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  hintText: 'Cellulare',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerMobileNo,
              ),
            ],
          ),
        );
      },
    );
  }

}