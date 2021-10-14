import 'package:flutter/material.dart';

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
  static TextEditingController controllerMobileNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: formKey,
      autovalidate: false,
      child: Column(
        children: <Widget>[
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
                Icons.email,
                color: Colors.grey,
              ),
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            controller: controllerEmail,
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
          const SizedBox(height: 20),
          TextFormField(
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
            validator: (value) {
              if (value.trim().isEmpty) {
                return "Il cellulare è obbligatorio";
              }
            },
            controller: controllerMobileNo,
          ),
        ],
      ),
    );
  }

}