import 'package:flutter/material.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import 'components/company_registration.dart';

class RegistrationCompanyScreen extends StatelessWidget {
  static String routeName = "/registration_company";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Regista la tua attività', style: TextStyle(color: Colors.black, fontFamily: "Muli",)),
      ),
      body: CompanyRegistration(),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.company),
    );
  }
}
