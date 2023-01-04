import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/home/components/body.dart';
import '../../models/databundlenotifier.dart';
import '../../size_config.dart';
import '../../swagger/swagger.models.swagger.dart';

class HomeScreenMain extends StatelessWidget {

  static String routeName = "/homemain";

  @override
  Widget build(BuildContext context) {
        return MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> implements TickerProvider{

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return Scaffold(

          appBar: AppBar(
            iconTheme: const IconThemeData(color: kCustomWhite),
            leading: IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.login_outlined, size: getProportionateScreenHeight(30)),
              color: kRed,
            ),
            backgroundColor: kCustomBlack,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/User.svg', color: Colors.white, height: getProportionateScreenHeight(35),),
                  onPressed: (){
                  },
                )
              ),
            ],
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "Ciao ${dataBundleNotifier.getUserEntity().name!}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    color: kCustomWhite,
                  ),
                ),
                Text(
                  dataBundleNotifier.getUserEntity().email!,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(7),
                    color: kCustomWhite,
                  ),
                ),
                Text(
                  dataBundleNotifier.getCurrentBranch().branchId == 0 ? '' : branchUserPriviledgeToJson(dataBundleNotifier.getCurrentBranch()!.userPriviledge).toString() + ' per ' + dataBundleNotifier.getCurrentBranch()!.name!.toString(),
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(5),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            elevation: 0,
          ),
          body: const Center(
            child: HomePageBody(),
          ),
        );
      },
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
