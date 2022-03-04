import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/screens/sign_in/sign_in_screen.dart';
import 'package:vat_calculator/size_config.dart';

class SplashAnim extends StatefulWidget {
  static String routeName = 'splash_anim';
  @override
  _SplashAnimState createState() => _SplashAnimState();
}

class _SplashAnimState extends State<SplashAnim> {
  @override
  Widget build(BuildContext context) {
    return SecondClass();
  }
}

class SecondClass extends StatefulWidget {
  @override
  _SecondClassState createState() => _SecondClassState();
}

class _SecondClassState extends State<SecondClass>
    with TickerProviderStateMixin {
  AnimationController scaleController;
  Animation<double> scaleAnimation;

  double _opacity = 0;
  bool _value = true;

  @override
  void initState() {
    super.initState();

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addStatusListener(
          (status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacement(
            ThisIsFadeRoute(
              route: SignInScreen(),
            ),
          );
          Timer(
            const Duration(milliseconds: 300),
                () {
              scaleController.reset();
            },
          );
        }
      },
    );

    scaleAnimation =
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);

    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        _opacity = 1.0;
        _value = false;
      });
    });
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        scaleController.forward();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scaleController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 6),
              opacity: _opacity,
              child: AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 6),
                height: _value ? 50 : 200,
                width: _value ? 50 : 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(.2),
                      blurRadius: 100,
                      spreadRadius: 10,
                    ),
                  ],
                  color: kCustomYellow800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children :[ Center(
                    child: Container(
                      width: 450,
                      height: 450,
                      decoration: BoxDecoration(
                          color: kCustomYellow800, shape: BoxShape.circle),
                      child: AnimatedBuilder(
                        animation: scaleAnimation,
                        builder: (c, child) => Transform.scale(
                          scale: scaleAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kCustomYellow800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset('assets/logo/logo_home_nero.png',width: getProportionateScreenWidth(2000),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  ThisIsFadeRoute({this.page, this.route})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: route,
        ),
  );
}