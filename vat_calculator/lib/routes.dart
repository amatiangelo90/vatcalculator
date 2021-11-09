import 'package:flutter/widgets.dart';
import 'package:vat_calculator/screens/complete_profile/complete_profile_screen.dart';
import 'package:vat_calculator/screens/details_screen/details_recessed.dart';
import 'package:vat_calculator/screens/forgot_password/forgot_password_screen.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/landing/landing_page.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/profile_edit/profile_edit_home.dart';
import 'package:vat_calculator/screens/registration_company/components/company_registration.dart';
import 'package:vat_calculator/screens/registration_company/components/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/sign_in/sign_in_screen.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/storage/components/add_storage_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_product.dart';
import 'package:vat_calculator/screens/suppliers/components/edit_product.dart';
import 'package:vat_calculator/screens/suppliers/components/edit_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';


import 'screens/sign_up/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LandingScreen.routeName: (context) => LandingScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  FattureInCloudCalculatorScreen.routeName: (context) => FattureInCloudCalculatorScreen(),
  DetailsRecessed.routeName: (context) => DetailsRecessed(),
  ArubaCalculatorScreen.routeName: (context) => ArubaCalculatorScreen(),
  CompanyRegistration.routeName: (context) => CompanyRegistration(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  StorageScreen.routeName: (context) => StorageScreen(),
  SuppliersScreen.routeName: (context) => SuppliersScreen(),
  AddSupplierScreen.routeName: (context) => AddSupplierScreen(),
  EditSuppliersScreen.routeName: (context) => EditSuppliersScreen(),
  AddProductScreen.routeName: (context) => AddProductScreen(),
  EditProductScreen.routeName: (context) => EditProductScreen(),
  AddStorageScreen.routeName: (context) => AddStorageScreen(),
  ProfileEditiScreen.routeName: (context) => ProfileEditiScreen(),
  RegisterFattureProviderScreen.routeName: (context) => RegisterFattureProviderScreen(),
};
