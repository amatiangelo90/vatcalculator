import 'package:flutter/material.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/company_registration.dart';

class RegistrationCompanyScreen extends StatelessWidget {
  static String routeName = "/registration_company";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Regista la tua attività',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: CompanyRegistration(),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.company),
    );
  }
}
