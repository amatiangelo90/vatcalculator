import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/enums.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class RecapData extends StatefulWidget {

  var mapInfo = HashMap<String,String>();

  RecapData(this.mapInfo);

  @override
  State<StatefulWidget> createState() {
    return RecapDataState();
  }
}

class RecapDataState extends State<RecapData> {
  @override
  Widget build(BuildContext context) {

    var company_name = widget.mapInfo["company_name"];
    var email = widget.mapInfo["email"];
    var piva = widget.mapInfo["piva"];
    var address = widget.mapInfo["address"];
    var mobile = widget.mapInfo["mobile_no"];

    var provider = widget.mapInfo["provider_name"];
    var apikey_user = widget.mapInfo["apikey_or_user"];
    var apiuid_pass = widget.mapInfo["apiuid_or_password"];

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                const Text("R.Sociale: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Flexible(child: Text(company_name, style: const TextStyle(fontSize: 16))),
              ],
            ),const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Text("Email: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Flexible(child: Text(dataBundleNotifier.dataBundleList.isNotEmpty ? dataBundleNotifier.dataBundleList[0].email : '', style: const TextStyle(fontSize: 16))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Text("P.Iva: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Flexible(child: Text(piva, style: const TextStyle(fontSize: 16))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Text("Indirizzo: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Flexible(child: Text(address, style: const TextStyle(fontSize: 16))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Text("Cell: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Flexible(child: Text(mobile, style: const TextStyle(fontSize: 16))),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 4,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Card(
                    color: provider == 'fatture_in_cloud' ? Colors.blueAccent : Colors.orange,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      provider == 'fatture_in_cloud' ? 'assets/images/fattureincloud.png' : 'assets/images/aruba.png',
                      fit: BoxFit.contain,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                provider == 'fatture_in_cloud' ?
                Flexible(child: Text("ApiKey : " + apikey_user, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)) :
                Flexible(child: Text("User : " + apikey_user, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
                //Text(provider, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                provider == 'fatture_in_cloud' ?
                Flexible(child: Text("ApiUid :" + apiuid_pass, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)) :
                Flexible(child: Text("Password : " + apiuid_pass, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
                //Text(provider, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        );
      },
    );
  }
}