import 'dart:async';
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

class LandingBody extends StatelessWidget {
  final String email;
  const LandingBody({Key? key, required this.email}) : super(key: key);

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
                  padding: const EdgeInsets.all(105.0),
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
                      email,
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
                  padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    height: getProportionateScreenHeight(50),
                    child: OutlinedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith((states) => 5),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                          side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                        ),
                        onPressed: () async {
                      try{
                        context.loaderOverlay.show();
                        Swagger swaggerClient = dataBundleNotifier.getSwaggerClient();
                        Response response = await swaggerClient.apiV1AppUsersFindbyemailGet(email: email);

                        if(response.isSuccessful){
                          dataBundleNotifier.setUser(response.body);

                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreenMain()));

                        } else{
                          print(response.error);
                          print(response.base.headers.toString());
                        }
                      }catch(e){
                        print(e.toString());
                      }finally{
                        context.loaderOverlay.hide();
                      }
                    }, child: Text('Accedi', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(20)),)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
