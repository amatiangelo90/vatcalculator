import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/light_colors.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.swagger.dart';
import '../../home/main_page.dart';

class LandingBody extends StatefulWidget {
  final String email;
  const LandingBody({Key? key, required this.email}) : super(key: key);

  @override
  State<LandingBody> createState() => _LandingBodyState();
}

class _LandingBodyState extends State<LandingBody> {


  int _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Scaffold(
          backgroundColor: kCustomGrey,

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: Image.asset(
                    "assets/logo/logo_home_white.png",
                    height: SizeConfig.screenHeight * 0.2,
                    width: 130,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Benvenuto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(110),),
              Text(kVersionApp, style: TextStyle(fontSize: getProportionateScreenHeight(12))),

              dataBundleNotifier.isLandingButtonPressed ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: FAProgressBar(
                  size: 20,
                  progressColor: kCustomGreen,
                  backgroundColor: kCustomBlack,
                  currentValue: _currentValue,
                  displayText: '%',
                ),
              ) : Padding(
                padding: EdgeInsets.all(Platform.isAndroid ? 10.0 : 30.0),
                child: SizedBox(
                  width: getProportionateScreenWidth(500),
                  child: CupertinoButton(
                    child: const Text('AVANTI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                    color: kCustomGreen,
                    onPressed: () async {
                      setState((){
                        _currentValue=100;
                      });
                      dataBundleNotifier.switchLandingButton();
                      Swagger swaggerClient = dataBundleNotifier.getSwaggerClient();
                      Response response = await swaggerClient.apiV1AppUsersFindbyemailGet(email: widget.email);
                      if(response.isSuccessful){
                        dataBundleNotifier.setUser(response.body);
                        Navigator.pushNamed(context, HomeScreenMain.routeName);

                      }else{
                        print(response.error);
                        print(response.base.headers.toString());
                      }
                      dataBundleNotifier.switchLandingButton();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
