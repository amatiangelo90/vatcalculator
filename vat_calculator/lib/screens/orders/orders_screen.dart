import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/screens/draft_order_page.dart';
import 'components/screens/underworking_order_page.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "orders_screen";

  const OrdersScreen({Key key}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          drawer: const CommonDrawer(),
          appBar: AppBar(
            actions: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/draft.svg",
                          width: 25,
                        ),
                        onPressed: () {
                          dataBundleNotifier.setShowIvaButtonToFalse();
                          Navigator.pushNamed(
                              context, DraftOrderPage.routeName);
                        }
                    ),
                  ),
                  Positioned(
                    top: 13.0,
                    right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 5.0 : 8.0,
                    child: Stack(
                      children: <Widget>[
                        const Icon(
                          Icons.brightness_1,
                          size: 16,
                          color: Colors.orange,
                        ),
                        Positioned(
                          right: dataBundleNotifier.currentDraftOrdersList.length > 9 ? 3.0 : 5.0,
                          top: 2,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/archive.svg",
                      width: 25,
                    ),
                    onPressed: () {
                      dataBundleNotifier.setShowIvaButtonToFalse();
                      Navigator.pushNamed(
                          context, DraftOrderPage.routeName);
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, getProportionateScreenWidth(10), 0),
                child: Icon(
                  Icons.add,
                  size: getProportionateScreenWidth(30),
                ),
              ),

            ],
            iconTheme: const IconThemeData(color: kPrimaryColor),
            centerTitle: true,
            title: Text('Gestione Ordini',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kPrimaryColor,
              ),
            ),
            backgroundColor: kCustomWhite,
          ),
          body: UnderWorkingOrderPage(),
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
        );
      },
    );
  }
}