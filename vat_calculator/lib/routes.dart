import 'package:flutter/widgets.dart';
import 'package:vat_calculator/screens/actions_manager/action_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_creation.dart';
import 'package:vat_calculator/screens/branch_registration/branch_join.dart';
import 'package:vat_calculator/screens/complete_profile/complete_profile_screen.dart';
import 'package:vat_calculator/screens/expence_manager/expence_home.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_confirm_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/product_order_choice_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import 'package:vat_calculator/screens/forgot_password/forgot_password_screen.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import 'package:vat_calculator/screens/landing/landing_page.dart';
import 'package:vat_calculator/screens/orders/components/screens/archivied_order_page.dart';
import 'package:vat_calculator/screens/orders/components/screens/draft_order_page.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/profile_edit/profile_edit_home.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/sign_in/sign_in_screen.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/screens/splash/splash_screen.dart';
import 'package:vat_calculator/screens/storage/components/add_storage_screen.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/load_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/storage/load_unload_screens/unload_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_product.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/join_supplier.dart';
import 'package:vat_calculator/screens/suppliers/components/edit_product.dart';
import 'package:vat_calculator/screens/suppliers/components/edit_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/recessed_manager/recessed_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashAnim.routeName: (context) => SplashAnim(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LandingScreen.routeName: (context) => LandingScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  FattureInCloudCalculatorScreen.routeName: (context) => FattureInCloudCalculatorScreen(),
  CreateOrderScreen.routeName: (context) => CreateOrderScreen(),
  ArubaCalculatorScreen.routeName: (context) => ArubaCalculatorScreen(),
  BranchChoiceCreationEnjoy.routeName: (context) => BranchChoiceCreationEnjoy(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  StorageScreen.routeName: (context) => StorageScreen(),
  SuppliersScreen.routeName: (context) => SuppliersScreen(),
  AddSupplierScreen.routeName: (context) => AddSupplierScreen(),
  EditSuppliersScreen.routeName: (context) => EditSuppliersScreen(),
  AddProductScreen.routeName: (context) => const AddProductScreen(),
  EditProductScreen.routeName: (context) => const EditProductScreen(),
  AddStorageScreen.routeName: (context) => const AddStorageScreen(),
  ProfileEditiScreen.routeName: (context) => ProfileEditiScreen(),
  RegisterFattureProviderScreen.routeName: (context) => RegisterFattureProviderScreen(),
  LoadStorageScreen.routeName: (context) => LoadStorageScreen(),
  UnloadStorageScreen.routeName: (context) => UnloadStorageScreen(),
  CreationBranchScreen.routeName: (context) => CreationBranchScreen(),
  BranchJoinScreen.routeName: (context) => BranchJoinScreen(),
  DraftOrderPage.routeName: (context) => DraftOrderPage(),
  ArchiviedOrderPage.routeName: (context) => ArchiviedOrderPage(),
  ActionsDetailsScreen.routeName: (context) => ActionsDetailsScreen(),
  SupplierChoiceCreationEnjoy.routeName: (context) => SupplierChoiceCreationEnjoy(),
  JoinSupplierScreen.routeName: (context) => JoinSupplierScreen(),
  ChoiceOrderProductScreen.routeName: (context) => ChoiceOrderProductScreen(),
  OrderConfirmationScreen.routeName: (context) => OrderConfirmationScreen(),
  RecessedManagerScreen.routeName: (context) => RecessedManagerScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
  ExpenceScreen.routeName: (context) => ExpenceScreen(),
};
