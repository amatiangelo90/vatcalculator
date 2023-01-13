import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../../size_config.dart';

class AddSupplierFromContactList extends StatefulWidget {
  @override
  _AddSupplierFromContactListState createState() => _AddSupplierFromContactListState();

  static String routeName = 'add_supplier_from_contact';
}

class _AddSupplierFromContactListState extends State<AddSupplierFromContactList> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: getProportionateScreenHeight(599),
    child: _body(),
  );

  Widget _body() {
    if (_permissionDenied) return const Center(child: Text('Permission denied'));
    if (_contacts == null) return const Center(child: CircularProgressIndicator());
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundle, _){
        return  Padding(
          padding: const EdgeInsets.only(bottom: 300),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _contacts!.length,
              itemBuilder: (context, i) => ListTile(
                  title: Text(_contacts![i].displayName!, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(19))),
                  onTap: () async {
                    Contact? contact = await FlutterContacts.getContact(_contacts![i].id!);
                    dataBundle.setCurrentSupplierToCreateNew(contact);
                    Navigator.of(context).pop(true);
                  })),
        );
      },
    );
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName!)),
      body: Column(children: [
        Text('First name: ${contact.name!.first}'),
        Text('Last name: ${contact.name!.last}'),

        Text(
            'Email address: ${contact.emails!.isNotEmpty ? contact.emails!.first!.address : '(none)'}'),
      ]));
}