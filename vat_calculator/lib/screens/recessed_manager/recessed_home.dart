import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/recessed_body.dart';
import 'components/recessed_reg_card.dart';

class RecessedScreen extends StatefulWidget {
  const RecessedScreen({Key key}) : super(key: key);


  static String routeName = "/recessedscreen";

  @override
  _RecessedScreenState createState() => _RecessedScreenState();
}

class _RecessedScreenState extends State<RecessedScreen> {

  DateTimeRange _currentDateTimeRange;


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: kCustomGreen,
              elevation: 5,
              onPressed: (){
                showDialog(context: context, builder: (_) => const AlertDialog(
                  backgroundColor: Colors.transparent,
                  actions: [
                    RecessedCard(showIndex: false, showHeader: false),
                  ],
                ));
              },
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, HomeScreen.routeName),
                  }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Area Gestione Incassi',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(17),
                          color: kCustomGreen,
                        ),
                      ),
                      Text(
                        dataBundleNotifier.currentBranch.companyName,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(11),
                          color: kCustomWhite,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      color: Colors.white,
                      width: getProportionateScreenWidth(25),
                    ),
                    onPressed: () {
                      _selectDateTimeRange(context, dataBundleNotifier);

                    }),
              ],
              elevation: 2,
            ),
            body: const RecessedBodyWidget(),
          );
        });
  }
  Future<void> _selectDateTimeRange(BuildContext context, DataBundleNotifier dataBundleNotifier) async {
    DateTimeRange dateTimeRange = await showDateRangePicker(
      context: context,
      initialDateRange: _currentDateTimeRange,
      firstDate: DateTime(DateTime.now().year -1, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kCustomGreen,
            ),
          ),
          child: child,
        );
      },
    );

    if (dateTimeRange != null && dateTimeRange != _currentDateTimeRange){
      dataBundleNotifier.setCurrentDateTimeRange(dateTimeRange);
    }
  }

}
