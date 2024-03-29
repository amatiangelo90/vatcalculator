import 'package:flutter/widgets.dart';
import 'package:vat_calculator/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_creation.dart';
import 'package:vat_calculator/screens/branch_registration/branch_join.dart';
import 'package:vat_calculator/screens/authentication/edit_profile.dart';
import 'package:vat_calculator/screens/event/component/event_manager_screen_closed.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_details_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/recap_order_screen.dart';
import 'package:vat_calculator/screens/storage/components/load_unload_screen.dart';
import 'package:vat_calculator/screens/storage/components/order_from_storage_widget.dart';
import 'package:vat_calculator/screens/storage/move_prod_to_other_storage.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_update.dart';
import 'package:vat_calculator/screens/event/component/event_create_screen.dart';
import 'package:vat_calculator/screens/event/component/event_manager_screen.dart';
import 'package:vat_calculator/screens/event/event_home.dart';
import 'package:vat_calculator/screens/home/main_page.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/screens/splash/animated_splash.dart';
import 'package:vat_calculator/screens/storage/qhundred/amount_hundred_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_choice.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_from_contact_list.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/join_supplier.dart';
import 'package:vat_calculator/screens/suppliers/components/add_suppliers/add_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/components/edit_product.dart';
import 'package:vat_calculator/screens/suppliers/components/edit_supplier_screen.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashAnim.routeName: (context) => SplashAnim(),
  CreateOrderScreen.routeName: (context) => CreateOrderScreen(),
  BranchChoiceCreationEnjoy.routeName: (context) => BranchChoiceCreationEnjoy(),
  SuppliersScreen.routeName: (context) => SuppliersScreen(),
  AddSupplierScreen.routeName: (context) => AddSupplierScreen(),
  CreationBranchScreen.routeName: (context) => CreationBranchScreen(),
  BranchJoinScreen.routeName: (context) => BranchJoinScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SupplierChoiceCreationEnjoy.routeName: (context) => SupplierChoiceCreationEnjoy(),
  JoinSupplierScreen.routeName: (context) => JoinSupplierScreen(),
  RecapOrderScreen.routeName: (context) => RecapOrderScreen(),
  EventHomeScreen.routeName: (context) => EventHomeScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
  EditSuppliersScreen.routeName: (context) => EditSuppliersScreen(),
  AddSupplierFromContactList.routeName: (context) => AddSupplierFromContactList(),
  EventCreateScreen.routeName: (context) => EventCreateScreen(),
  AmountHundredScreen.routeName: (context) => AmountHundredScreen(),
  UpdateBranchScreen.routeName: (context) => UpdateBranchScreen(),
  HomeScreenMain.routeName: (context) => HomeScreenMain(),
  OrderFromStorageWidget.routeName: (context) => OrderFromStorageWidget(),
  LoadUnloadScreen.routeName: (context) => LoadUnloadScreen(isLoad: false, isUnLoad: true),
  StorageScreen.routeName: (context) => StorageScreen(),
  EventManagerScreen.routeName: (context) => EventManagerScreen(),
  MoveProductToOtherStorageScreen.routeName: (context) => MoveProductToOtherStorageScreen(),
  EventManagerScreenClosed.routeName: (context) => EventManagerScreenClosed(),
  OrderDetailsScreen.routeName: (context) => OrderDetailsScreen(),
};
