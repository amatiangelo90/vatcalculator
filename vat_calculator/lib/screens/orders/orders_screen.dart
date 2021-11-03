import 'package:flutter/material.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/archivied_order_page.dart';
import 'components/draft_order_page.dart';
import 'components/underworking_order_page.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = "/ordersscreen";

  final int initialIndex;

  const OrdersScreen({Key key, this.initialIndex}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin{

  TabController controller;
  int _currentIndex;

  @override
  Widget build(BuildContext context) {

    final kPages = <Widget>[
      UnderWorkingOrderPage(),
      DraftOrderPage(),
      ArchiviedOrderPage(),
    ];


    final kTab = <Tab>[
      Tab(child: Text('In Lavorazione', style: TextStyle(color: _currentIndex == 0 ? Colors.blue : kCustomWhite),)),
      Tab(child: Text('Bozze Ordini', style: TextStyle(color: _currentIndex == 1 ? Colors.orange : kCustomWhite))),
      Tab(child: Text('Archiviati', style: TextStyle(color: _currentIndex == 2 ? Colors.redAccent : kCustomWhite))),
    ];

    return DefaultTabController(
      length: kTab.length,
      child: Scaffold(
        drawer: const CommonDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text('Ordini',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(17),
              color: kCustomWhite,
            ),
          ),
          backgroundColor: kPrimaryColor,
          bottom: TabBar(
            controller: controller,
            tabs: kTab,
            indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: controller.index == 0 ? Colors.blueAccent : controller.index == 1 ? Colors.orange : Colors.redAccent),
            ),
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: kPages,
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
      ),
    );
  }

  @override
  void initState() {
    if(widget.initialIndex == null){
      _currentIndex = 0;
    }else{
      _currentIndex = widget.initialIndex;
    }

    controller = TabController(length:3, initialIndex: _currentIndex, vsync: this);
    controller.addListener(() {
      setState(() {
        _currentIndex = controller.index;
      });
    });
  }
}
