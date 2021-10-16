import 'package:flutter/widgets.dart';

import 'package:vat_calculator/screens/complete_profile/complete_profile_screen.dart';
import 'package:vat_calculator/screens/forgot_password/forgot_password_screen.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/landing/landing_page.dart';
import 'package:vat_calculator/screens/profile/profile_screen.dart';
import 'package:vat_calculator/screens/registration_company/registration_company_screen.dart';
import 'package:vat_calculator/screens/sign_in/sign_in_screen.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/vat_calculator_screen.dart';


import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LandingScreen.routeName: (context) => LandingScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  RegistrationCompanyScreen.routeName: (context) => RegistrationCompanyScreen(),
  VatCalculatorScreen.routeName: (context) => VatCalculatorScreen(),
};
