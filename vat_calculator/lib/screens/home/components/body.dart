import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/registration_company_screen.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: dataBundleNotifier.dataBundleList[0].companyList.isEmpty ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Sembra che tu non abbia configurato ancora nessuna attività. "
                          "Ma andiamo con ordine. Spero che l'app risulti facile da usare e per qualsiasi problema "
                          "ti invito a contattare l\'amministratore! Troverai i suoi contatti nella sezione profilo (alla voce \'Hai bisogno di aiuto?\'). \n\n"
                          " Ho bisFino a quel momento buon divertimento!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(13),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.6,
                    child: DefaultButton(
                      text: "Crea Attività",
                      press: () async {
                        Navigator.pushNamed(context, RegistrationCompanyScreen.routeName);
                      },
                    ),
                  ),
                ],
              ),
            ) :
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: getProportionateScreenHeight(56),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dataBundleNotifier.dataBundleList[0].companyList[0].companyName.toString(), style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

