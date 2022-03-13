import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/screens/archivied_order_page.dart';
import 'components/screens/draft_order_page.dart';
import 'components/screens/underworking_order_page.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "orders_screen";

  const OrdersScreen({Key key}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(
          drawer: const CommonDrawer(),
          appBar: AppBar(
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
            ],
            iconTheme: IconThemeData(color: kCustomWhite),
            centerTitle: true,
            title: Text(
              'Ordini',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                color: kCustomGreen,
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
                child: const CreateBranchButton(),
              ),
            ],
          ) : const UnderWorkingOrderPage(),
          bottomNavigationBar: const BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 3,
            color: kPrimaryColor,
            child: CustomBottomNavBar(selectedMenu: MenuState.orders),
          ),

        );
      },
    );
  }
}
