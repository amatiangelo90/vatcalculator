import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';
import '../size_config.dart';

class LoaderOverlayWidget extends StatelessWidget {
  const LoaderOverlayWidget({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(130),
            width: getProportionateScreenWidth(250),
            child: Card(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(15),),
                      SpinKitRing(
                        lineWidth: 3,
                        color: kPrimaryColor,
                        size: getProportionateScreenHeight(50),
                      ),
                      SizedBox(height: getProportionateScreenHeight(4),),
                      Text(message),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


