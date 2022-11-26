import 'package:flutter/widgets.dart';
import 'package:vat_calculator/screens/branch_registration/branch_creation.dart';
import 'package:vat_calculator/screens/branch_registration/branch_join.dart';
import 'package:vat_calculator/screens/branch_registration/branch_update.dart';
import 'package:vat_calculator/screens/event/component/archivied_events_screen.dart';
import 'package:vat_calculator/screens/event/component/event_create_screen.dart';
import 'package:vat_calculator/screens/event/component/event_manager_screen.dart';
import 'package:vat_calculator/screens/event/event_home.dart';
import 'package:vat_calculator/screens/main_page.dart';
import 'package:vat_calculator/screens/marketing/marketing_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import 'package:vat_calculator/screens/forgot_password/forgot_password_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/archivied_order_page.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/sign_in/sign_in_screen.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/load_screen.dart';
import 'package:vat_calculator/screens/storage/orders/order_from_storage_screen.dart';
import 'package:vat_calculator/screens/storage/qhundred/amount_hundred_screen.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/unload_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/join_supplier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/screens/warnings/warning_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashAnim.routeName: (context) => SplashAnim(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CreateOrderScreen.routeName: (context) => CreateOrderScreen(),
  BranchChoiceCreationEnjoy.routeName: (context) => BranchChoiceCreationEnjoy(),
  SuppliersScreen.routeName: (context) => SuppliersScreen(),
  AddSupplierScreen.routeName: (context) => AddSupplierScreen(),
  LoadStorageScreen.routeName: (context) => LoadStorageScreen(),
  UnloadStorageScreen.routeName: (context) => UnloadStorageScreen(),
  CreationBranchScreen.routeName: (context) => CreationBranchScreen(),
  BranchJoinScreen.routeName: (context) => BranchJoinScreen(),
  ArchiviedOrderPage.routeName: (context) => ArchiviedOrderPage(),
  SupplierChoiceCreationEnjoy.routeName: (context) => SupplierChoiceCreationEnjoy(),
  JoinSupplierScreen.routeName: (context) => JoinSupplierScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
  EventHomeScreen.routeName: (context) => EventHomeScreen(),
  EventCreateScreen.routeName: (context) => EventCreateScreen(),
  AmountHundredScreen.routeName: (context) => AmountHundredScreen(),
  UpdateBranchScreen.routeName: (context) => UpdateBranchScreen(),
  HomeScreenMain.routeName: (context) => HomeScreenMain(),
  WarningScreen.routeName: (context) => WarningScreen(),
  ArchiviedEventPage.routeName: (context) => ArchiviedEventPage(),
  OrderFromStorageScreen.routeName: (context) => OrderFromStorageScreen(),
  EventManagerScreen.routeName: (context) => EventManagerScreen(),
  MarketingScreen.routeName: (context) => const MarketingScreen(),
};
