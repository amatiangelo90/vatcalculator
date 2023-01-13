import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/swagger.models.swagger.dart';
import '../../../components/loader_overlay_widget.dart';
import '../../../components/socal_card.dart';
import '../../../helper/keyboard.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../landing/landing_page.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;

  bool isSignInPage = true;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('Email logged in : ' + user.email!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandingScreen(email: user.email!),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 700),
            backgroundColor: Colors.green,
            content: Text(
              'Accesso con utenza ${user.email}...',
              style: const TextStyle(color: Colors.white),
            )));
      } else {
        print('No user authenticated');
      }
    } catch (e) {
      print('Exception : ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordConfirmationController =
        TextEditingController();

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(
        message: 'Sto caricando i tuoi dati..',
      ),
      child: Scaffold(
        appBar:
            AppBar(title: Text('Sign In'), automaticallyImplyLeading: false),
        body: Consumer<DataBundleNotifier>(
          builder: (child, dataBundleNotifier, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
                        child: Image.asset(
                          'assets/logo/logo_home_nero.png',
                          width: getProportionateScreenWidth(100),
                        ),
                      ),
                      Text(
                        "Benvenuto",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Text(
                          "Ciao! Esegui la login con la tua mail e password, \n oppure continua tramite social network",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AutofillGroup(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 10),
                          child: SizedBox(
                            height: getProportionateScreenHeight(50),
                            child: CupertinoTextField(
                              textInputAction: TextInputAction.next,
                              autofillHints: [AutofillHints.email],
                              restorationId: 'email',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              placeholder: 'email',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: SizedBox(
                          height: getProportionateScreenHeight(50),
                          child: CupertinoTextField(
                            textInputAction: TextInputAction.done,
                            restorationId: 'password',
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            placeholder: 'password',
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      isSignInPage
                          ? Text('')
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: SizedBox(
                                height: getProportionateScreenHeight(50),
                                child: CupertinoTextField(
                                  textInputAction: TextInputAction.done,
                                  restorationId: 'conferma password',
                                  keyboardType: TextInputType.text,
                                  controller: passwordConfirmationController,
                                  clearButtonMode: OverlayVisibilityMode.editing,
                                  placeholder: 'conferma password',
                                ),
                              ),
                            ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: SizedBox(
                      width: getProportionateScreenWidth(400),
                      height: getProportionateScreenHeight(50),
                      child: OutlinedButton(
                        style: ButtonStyle(
                          elevation:
                              MaterialStateProperty.resolveWith((states) => 5),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => kCustomGreen),
                          side: MaterialStateProperty.resolveWith(
                            (states) =>
                                BorderSide(width: 0.5, color: Colors.white),
                          ),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                        ),
                        child: Text(isSignInPage ? 'ACCEDI' : 'REGISTRATI',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: getProportionateScreenHeight(20))),
                        onPressed: () async {
                          if (isSignInPage) {
                            try {
                              context.loaderOverlay.show();
                              KeyboardUtil.hideKeyboard(context);
                              UserCredential user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);

                              if (user.user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingScreen(
                                      email: emailController.text,
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration:
                                            const Duration(milliseconds: 1700),
                                        backgroundColor: kCustomGreen,
                                        content: Text(
                                          'Accesso con utenza ${emailController.text}',
                                          style: const TextStyle(
                                              fontFamily: 'LoraFont',
                                              color: Colors.white),
                                        )));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        duration: Duration(milliseconds: 1700),
                                        backgroundColor: kCustomBordeaux,
                                        content: Text(
                                          'Impossibile eseguire l\'accesso. Nessun utente trovato',
                                          style: TextStyle(
                                              fontFamily: 'LoraFont',
                                              color: Colors.white),
                                        )));
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration:
                                          const Duration(milliseconds: 3000),
                                      backgroundColor: kCustomBordeaux,
                                      content: Text(
                                        e.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'LoraFont',
                                            color: Colors.white),
                                      )));
                            } finally {
                              context.loaderOverlay.hide();
                            }
                          } else {
                            try {
                              context.loaderOverlay.show();
                              KeyboardUtil.hideKeyboard(context);

                              if (passwordController.text == passwordConfirmationController.text) {
                                UserCredential user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);

                                if (user.user != null) {
                                  Response apiV1AppUsersSavePost =
                                  await dataBundleNotifier
                                      .getSwaggerClient()
                                      .apiV1AppUsersSavePost(
                                      userEntity: UserEntity(
                                        name: '',
                                           lastname: '',
                                          profileCompleted: false,
                                          userType: UserEntityUserType.entrepreneur,
                                          photo: '',
                                          email: emailController.text));
                                  if (apiV1AppUsersSavePost.isSuccessful) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LandingScreen(
                                          email: emailController.text,
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration: const Duration(
                                                milliseconds: 1700),
                                            backgroundColor: kCustomGreen,
                                            content: Text(
                                              'Utenza ${emailController.text} creata',
                                              style: const TextStyle(
                                                  fontFamily: 'LoraFont',
                                                  color: Colors.white),
                                            )));
                                  } else {
                                    user.user!.delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            duration:
                                            Duration(milliseconds: 1700),
                                            backgroundColor: kCustomBordeaux,
                                            content: Text(
                                              'Impossibile eseguire l\'accesso. Riprova fra 2 minuti.',
                                              style: TextStyle(
                                                  fontFamily: 'LoraFont',
                                                  color: Colors.white),
                                            )));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      duration: Duration(milliseconds: 1700),
                                      backgroundColor: kCustomBordeaux,
                                      content: Text(
                                        'Impossibile eseguire l\'accesso. Nessun utente trovato',
                                        style: TextStyle(
                                            fontFamily: 'LoraFont',
                                            color: Colors.white),
                                      )));
                                }
                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    duration: Duration(milliseconds: 1700),
                                    backgroundColor: kCustomBordeaux,
                                    content: Text(
                                      'La due password non corrispondono',
                                      style: TextStyle(
                                          fontFamily: 'LoraFont',
                                          color: Colors.white),
                                    )));
                              }


                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration:
                                          const Duration(milliseconds: 3000),
                                      backgroundColor: kCustomBordeaux,
                                      content: Text(
                                        e.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'LoraFont',
                                            color: Colors.white),
                                      )));
                            } finally {
                              context.loaderOverlay.hide();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GestureDetector(
                        onTap: () {
                          TextEditingController emailControllerPassReset = TextEditingController();

                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog (
                                contentPadding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(10.0))),
                                content: Builder(
                                  builder: (context) {
                                    var height = MediaQuery.of(context).size.height;
                                    var width = MediaQuery.of(context).size.width;
                                    return SizedBox(
                                      width: width - 90,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(10.0),
                                                    topLeft: Radius.circular(10.0) ),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('  Reimposta password',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: getProportionateScreenWidth(15),
                                                        fontWeight: FontWeight.bold,
                                                        color: kCustomGrey,
                                                      )),
                                                  IconButton(icon: const Icon(
                                                    Icons.clear,
                                                    color: kCustomGrey,
                                                  ), onPressed: () { Navigator.pop(context); },),

                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                                  child: SizedBox(
                                                    height: getProportionateScreenHeight(50),
                                                    child: CupertinoTextField(
                                                      textInputAction: TextInputAction.done,
                                                      restorationId: 'Inserisci email',
                                                      keyboardType: TextInputType.text,
                                                      controller: emailControllerPassReset,
                                                      clearButtonMode: OverlayVisibilityMode.editing,
                                                      placeholder: 'Inserisci email',
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: getProportionateScreenHeight(50),),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: getProportionateScreenWidth(300),
                                                    height: getProportionateScreenHeight(60),
                                                    child: OutlinedButton(
                                                      style: ButtonStyle(
                                                        elevation:
                                                        MaterialStateProperty.resolveWith((states) => 5),
                                                        backgroundColor: MaterialStateProperty.resolveWith(
                                                                (states) => kCustomGreen),
                                                        side: MaterialStateProperty.resolveWith(
                                                              (states) =>
                                                              const BorderSide(width: 0.5, color: Colors.white),
                                                        ),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(15.0))),
                                                      ),
                                                      child: Text('Reimposta password',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: getProportionateScreenHeight(20))),
                                                      onPressed: () async {
                                                        await _auth.sendPasswordResetEmail(email: emailControllerPassReset.text);
                                                        Navigator.of(context).pop();
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(SnackBar(
                                                            duration: const Duration(milliseconds: 2000),
                                                            backgroundColor: kCustomGreen,
                                                            content: Text('Reset password inviato alla mail ' + emailControllerPassReset.text , style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));

                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const Text(''),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                          );
                        },
                        child: const Text('Password dimenticata?')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialCard(
                                icon: "assets/icons/google-icon.svg",
                                press: () {},
                              ),
                              SocialCard(
                                icon: "assets/icons/facebook-2.svg",
                                press: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        isSignInPage
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignInPage = false;
                                  });
                                },
                                child: const Text('Non hai ancora un account?'))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignInPage = true;
                                  });
                                },
                                child: Text('Login Page'))
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
