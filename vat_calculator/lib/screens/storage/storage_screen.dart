import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';

class StorageScreen extends StatelessWidget {
  static String routeName = "/storagescreen";
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          drawer: const CommonDrawer(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text('Magazzino',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kCustomWhite,
              ),
            ),
            backgroundColor: kPrimaryColor,
          ),
          body: dataBundleNotifier.currentBranch == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sembra che tu non abbia configurato ancora nessuna attività. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: DefaultButton(
                  text: "Crea Attività",
                  press: () async {
                    Navigator.pushNamed(context, CompanyRegistration.routeName);
                  },
                ),
              ),
            ],
          ) : dataBundleNotifier.currentStorageList.isEmpty ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dataBundleNotifier.dataBundleList.isNotEmpty ? "Ciao ${dataBundleNotifier.dataBundleList[0].firstName}, sembra "
                      "che tu non abbia configurato ancora nessun magazzino per ${dataBundleNotifier.currentBranch.companyName}. "
                      "Ti ricordo che è possibile associare i prodotti al tuo magazzino solo dopo averli creati ed associati ad uno dei tuoi fornitori." : "",
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
                  text: "Crea Magazzino",
                  press: () async {

                  },
                ),
              ),
            ],
          )
              : Text('Lista magazzino'),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.storage),
        );
      },
    );
  }
}
