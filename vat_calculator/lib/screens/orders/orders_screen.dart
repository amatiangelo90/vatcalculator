import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../size_config.dart';
import 'components/screens/underworking_order_page.dart';

class OrdersScreen extends StatefulWidget {

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
        return Container(
          child: dataBundleNotifier.currentBranch == null ? Column(
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
        );
      },
    );
  }
}
