import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../components/loader_overlay_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Sto caricando i tuoi dati..',),
      child: Consumer<DataBundleNotifier>(
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
                SizedBox(height: getProportionateScreenHeight(20),),
                Text('v. ' + kVersionApp, style: TextStyle(fontSize: getProportionateScreenHeight(12))),

                Padding(
                  padding: EdgeInsets.all(Platform.isAndroid ? 10.0 : 30.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(500),
                        child: CupertinoButton(
                          child: const Text('AVANTI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                          color: kCustomGreen,
                          onPressed: () async {

                            try{
                              context.loaderOverlay.show();
                              Swagger swaggerClient = dataBundleNotifier.getSwaggerClient();
                              Response response = await swaggerClient.apiV1AppUsersFindbyemailGet(email: widget.email);

                              if(response.isSuccessful){
                                dataBundleNotifier.setUser(response.body);
                                Navigator.pushNamed(context, HomeScreenMain.routeName);

                              } else{

                                print(response.error);
                                print(response.base.headers.toString());

                              }
                            }catch(e){
                              print(e.toString());
                            }finally{
                              context.loaderOverlay.hide();
                            }


                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Developed by Angelo Amati - All right reserved', style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(6))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
