
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/home/components/body.dart';
import 'package:vat_calculator/screens/orders/orders_screen.dart';
import 'package:vat_calculator/screens/profile_edit/profile_edit_home.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/storage/components/add_storage_screen.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';

import '../client/vatservice/model/utils/privileges.dart';
import '../components/common_drawer.dart';
import '../models/databundlenotifier.dart';
import '../size_config.dart';
import 'event/component/event_create_screen.dart';
import 'orders/components/screens/archivied_order_page.dart';
import 'orders/components/screens/draft_order_page.dart';
import 'orders/components/screens/order_creation/order_create_screen.dart';

class HomeScreenMain extends StatelessWidget {

  static String routeName = "/homemain";

  @override
  Widget build(BuildContext context) {
        return MyStatefulWidget();
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _pages = <Widget>[
    const HomePageBody(),
    const StorageScreen(),
    const OrdersScreen(),
    const ProfileEditiScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          drawer: CommonDrawer(),
          appBar: getAppBarByIndex(dataBundleNotifier.selectedIndex, dataBundleNotifier),
          body: Center(
            child: _pages.elementAt(dataBundleNotifier.selectedIndex),
          ),
          bottomNavigationBar:
          Theme(
            data: ThemeData(
            backgroundColor: kPrimaryColor,
            canvasColor: kPrimaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home.svg",
                    color: dataBundleNotifier.selectedIndex == 0
                        ? kCustomBlueAccent
                        : Colors.white,
                    width: 25,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/storage.svg",
                    color: dataBundleNotifier.selectedIndex == 1
                        ? kCustomBlueAccent
                        : Colors.white,
                    width: 27,
                  ),
                  label: 'Magazzino',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                    SvgPicture.asset(
                    "assets/icons/receipt.svg",
                    color: dataBundleNotifier.selectedIndex == 2
                        ? kCustomBlueAccent
                        : Colors.white,
                    width: 27,
                  ),
                      Positioned(
                        top: -2.0,
                        right: dataBundleNotifier.currentUnderWorkingOrdersList.length > 9 ? 0.0 : -2.0,
                        child: Stack(
                          children: <Widget>[
                            const Icon(
                              Icons.brightness_1,
                              size: 16,
                              color: Colors.blueAccent,
                            ),
                            Positioned(
                              right: dataBundleNotifier.currentUnderWorkingOrdersList.length > 9 ? 3.0 : 5.0,
                              top: 3.5,
                              child: Center(
                                child: Text(
                                  dataBundleNotifier.currentUnderWorkingOrdersList.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 0.0 : -2.0,
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.brightness_1,
                              size: 16,
                              color: Colors.orange,
                            ),
                            Positioned(
                              right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 3.0 : 5.0,
                              top: 3.5,
                              child: Center(
                                child: Text(
                                  dataBundleNotifier.currentDraftOrdersList.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  label: 'Ordini',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/Settings.svg",
                    color: dataBundleNotifier.selectedIndex == 3
                        ? kCustomBlueAccent
                        : Colors.white,
                    width: 25,
                  ),
                  label: 'Gestione',
                ),
              ],
              currentIndex: dataBundleNotifier.selectedIndex,
              selectedItemColor: kCustomBlueAccent,
              unselectedItemColor: Colors.white,
              onTap: dataBundleNotifier.onItemTapped,
            ),
              ),
        );
      },
    );
  }

  getAppBarByIndex(int selectedIndex, DataBundleNotifier dataBundleNotifier) {
    switch(selectedIndex){
      case 0:
        return AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: kPrimaryColor,
          actions: [
            dataBundleNotifier.currentBranch == null ? const SizedBox(width: 0,) : dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? const Text('') : Column(
              children: [
                dataBundleNotifier.currentPrivilegeType == Privileges.EMPLOYEE ? const Text('') :
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/iva.svg',
                    color: dataBundleNotifier.getProviderColor(),
                    width: 25,
                  ),
                  onPressed: () {
                    switch(dataBundleNotifier.currentBranch.providerFatture){
                      case 'fatture_in_cloud':
                        Navigator.pushNamed(context, FattureInCloudCalculatorScreen.routeName);
                        break;
                      case 'aruba':
                        Navigator.pushNamed(context, ArubaCalculatorScreen.routeName);
                        break;
                      case '':
                        Navigator.pushNamed(context, RegisterFattureProviderScreen.routeName);
                        break;
                    }
                  },
                ),
              ],
            ),
            Stack(
              children: [ IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/receipt.svg',
                  color: Colors.white,
                  width: 25,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CreateOrderScreen.routeName);
                },
              ),
                Positioned(
                  top: 26.0,
                  right: 9.0,
                  child: Stack(
                    children: const <Widget>[
                      Icon(
                        Icons.brightness_1,
                        size: 18,
                        color: kPrimaryColor,
                      ),
                      Positioned(
                        right: 2.5,
                        top: 2.5,
                        child: Center(
                          child: Icon(Icons.add_circle_outline, size: 13, color: kCustomBlueAccent,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/party.svg',
                    color: Colors.white,
                    width: 50,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context,
                        EventCreateScreen.routeName);
                  },
                ),
                Positioned(
                  top: 26.0,
                  right: 9.0,
                  child: Stack(
                    children:  const <Widget>[
                      Icon(
                        Icons.brightness_1,
                        size: 18,
                        color: kPrimaryColor,
                      ),
                      Positioned(
                        right: 2.5,
                        top: 2.5,
                        child: Center(
                          child: Icon(
                            Icons
                                .add_circle_outline,
                            size: 13,
                            color:
                            kCustomBlueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5,),
          ],
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "Ciao ${dataBundleNotifier.userDetailsList.isNotEmpty ? dataBundleNotifier.userDetailsList[0].firstName : ''}",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  color: Colors.white,
                ),
              ),
              Text(
                dataBundleNotifier.userDetailsList.isNotEmpty ? dataBundleNotifier.userDetailsList[0].email : '',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(7),
                  color: Colors.white,
                ),
              ),
              Text(
                dataBundleNotifier.userDetailsList.isNotEmpty && dataBundleNotifier.userDetailsList[0].companyList.isNotEmpty ?
                dataBundleNotifier.currentBranch.accessPrivilege + ' per ' + dataBundleNotifier.currentBranch.companyName : '',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(5),
                  color: kCustomBlueAccent,
                ),
              ),
            ],
          ),
          elevation: 5,
        );
      case 1:
        return AppBar(
          elevation: 5,
          iconTheme: const IconThemeData(color: kCustomWhite),
          actions: [
            GestureDetector(
              onTap: () {
                buildStorageChooserDialog(context, dataBundleNotifier);
              },
              child: Stack(
                children: [
                  IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/storage.svg',
                    color: kCustomWhite,
                    width: getProportionateScreenHeight(28),
                  ),
                  onPressed: () {
                    buildStorageChooserDialog(context, dataBundleNotifier);
                  },
                ),
                  Positioned(
                    top: 26.0,
                    right: 4.0,
                    child: Stack(
                      children: <Widget>[
                        const Icon(
                          Icons.brightness_1,
                          size: 20,
                          color: Colors.red,
                        ),
                        Positioned(
                          right: 6.5,
                          top: 1.5,
                          child: Center(
                            child: Text(dataBundleNotifier.currentStorageList.length.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: getProportionateScreenWidth(10))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10,),
          ],
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: dataBundleNotifier.currentStorage == null ? Text('Area Magazzini' , style: TextStyle(
            fontSize: getProportionateScreenWidth(17),
            color: kCustomBlueAccent,
          ),) : Column(
            children: [
              Text(
                dataBundleNotifier.currentStorage.name,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  color: Colors.white,
                ),
              ),
              Text(
              'Area gestione magazzini',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(8),
                  color: kCustomBlueAccent,
                ),
              ),
            ],
          ),
        );
      case 2:
        return AppBar(
          elevation: 3,
          actions: [
            dataBundleNotifier.currentBranch == null ? SizedBox(width: 0,) : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/archive.svg",
                        width: 25,
                        color: kCustomWhite,
                      ),
                      onPressed: () {
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        Navigator.pushNamed(
                            context, ArchiviedOrderPage.routeName);
                      }),
                ),
                Positioned(
                  top: 13.0,
                  right: dataBundleNotifier.currentArchiviedWorkingOrdersList.length > 9
                      ? 5.0
                      : 8.0,
                  child: Stack(
                    children: <Widget>[
                      const Icon(
                        Icons.brightness_1,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      Positioned(
                        right:
                        dataBundleNotifier.currentArchiviedWorkingOrdersList.length >
                            9
                            ? 3.0
                            : 5.0,
                        top: 2,
                        child: Center(
                          child: Text(
                            dataBundleNotifier.currentArchiviedWorkingOrdersList.length
                                .toString(),
                            style: const TextStyle(
                                fontSize: 8.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            dataBundleNotifier.currentBranch == null ? SizedBox(width: 0,) : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/draft.svg",
                        width: 25,
                        color: kCustomWhite,
                      ),
                      onPressed: () {
                        dataBundleNotifier.setShowIvaButtonToFalse();
                        Navigator.pushNamed(
                            context, DraftOrderPage.routeName);
                      }),
                ),
                Positioned(
                  top: 13.0,
                  right: dataBundleNotifier.currentDraftOrdersList.length > 9
                      ? 5.0
                      : 8.0,
                  child: Stack(
                    children: <Widget>[
                      const Icon(
                        Icons.brightness_1,
                        size: 16,
                        color: Colors.orange,
                      ),
                      Positioned(
                        right:
                        dataBundleNotifier.currentDraftOrdersList.length >
                            9
                            ? 3.0
                            : 5.0,
                        top: 2,
                        child: Center(
                          child: Text(
                            dataBundleNotifier.currentDraftOrdersList.length
                                .toString(),
                            style: const TextStyle(
                                fontSize: 8.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            dataBundleNotifier.currentBranch == null ? SizedBox(width: 0,) : Stack(
              children: [ Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/receipt.svg',
                    color: Colors.white,
                    width: 25,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CreateOrderScreen.routeName);
                  },
                ),
              ),
                Positioned(
                  top: 30.0,
                  right: 9.0,
                  child: Stack(
                    children: const <Widget>[
                      Icon(
                        Icons.brightness_1,
                        size: 18,
                        color: kPrimaryColor,
                      ),
                      Positioned(
                        right: 2.5,
                        top: 2.5,
                        child: Center(
                          child: Icon(Icons.add_circle_outline, size: 13, color: kCustomBlueAccent,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          iconTheme: const IconThemeData(color: kCustomWhite),
          centerTitle: true,
          title: Text(
            'Ordini',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              color: kCustomBlueAccent,
            ),
          ),
          backgroundColor: kPrimaryColor,
        );
      case 3:
        return AppBar(
          iconTheme: const IconThemeData(color: kCustomWhite),
          centerTitle: true,
          title: Text(
            'Gestione',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(19),
              color: kCustomBlueAccent,
            ),
          ),
          backgroundColor: kPrimaryColor,
        );
    }
  }

  void buildStorageChooserDialog(BuildContext context, DataBundleNotifier dataBundleNotifier) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return SizedBox(

                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                          color: kPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '  Lista Magazzini',
                              style: TextStyle(
                                fontSize:
                                getProportionateScreenWidth(17),
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: buildListStorages(
                            dataBundleNotifier, context),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  buildListStorages(DataBundleNotifier dataBundleNotifier, context) {
    List<Widget> storagesWidgetList = [];

    dataBundleNotifier.currentStorageList.forEach((currentStorageElement) {
      storagesWidgetList.add(
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: dataBundleNotifier.currentStorage.name ==
                  currentStorageElement.name
                  ? kPrimaryColor
                  : Colors.white,
              border: const Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(icon: SvgPicture.asset('assets/icons/storage.svg', color: kCustomBlueAccent, width: getProportionateScreenWidth(25),), ),
                      Text(
                        '   ' + currentStorageElement.name,
                        style: TextStyle(
                            fontSize: dataBundleNotifier.currentStorage.name ==
                                currentStorageElement.name
                                ? getProportionateScreenWidth(16)
                                : getProportionateScreenWidth(13),
                            color: dataBundleNotifier.currentStorage.name ==
                                currentStorageElement.name
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  dataBundleNotifier.currentStorage.name ==
                      currentStorageElement.name ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                    child: SvgPicture.asset(
                      'assets/icons/success-green.svg',
                      width: getProportionateScreenHeight(25),
                    ),
                  ) : const SizedBox(height: 0,),
                ],
              ),
            ),
          ),
          onTap: () {
            //EasyLoading.show();
            dataBundleNotifier.setCurrentStorage(currentStorageElement);
            //EasyLoading.dismiss();
            Navigator.pop(context);
          },
        ),
      );
    });
    storagesWidgetList.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          width: MediaQuery.of(context).size.width,
          child: CupertinoButton(
            child: Text('Crea Magazzino'),
            color: kCustomBlueAccent,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStorageScreen(
                    branch: dataBundleNotifier.currentBranch,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    return storagesWidgetList;
  }

}

