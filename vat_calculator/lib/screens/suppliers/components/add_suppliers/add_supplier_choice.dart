import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import '../../../../models/databundlenotifier.dart';
import '../../../../size_config.dart';
import 'add_supplier_from_other_branch.dart';
import 'add_supplier_screen.dart';
import 'join_supplier.dart';

class SupplierChoiceCreationEnjoy extends StatefulWidget {

  static String routeName = 'supplier_choice';
  @override
  _SupplierChoiceCreationEnjoyState createState() => _SupplierChoiceCreationEnjoyState();
}

class _SupplierChoiceCreationEnjoyState extends State<SupplierChoiceCreationEnjoy> {
  var currentStep = 0;


  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kCustomGrey,
              ),
            ),
            centerTitle: true,
            title: Text('Registra Fornitore',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(19),
                color: kCustomGrey,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              Container(
                color: Colors.white,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('Crea un nuovo fornitore', textAlign: TextAlign.center,),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: getProportionateScreenWidth(100),
                              width: getProportionateScreenWidth(600),
                              child: OutlinedButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, AddSupplierScreen.routeName);
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/supplier.svg', width: getProportionateScreenWidth(30)) ,
                                    SizedBox(width: 5,),
                                    Text('Crea Fornitore', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.bold, color: kCustomGrey),),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text('Puoi aggiungine uno esistente alla tua lista. '
                              'Se il tuo fornitore utilizza l\'app puoi collegarti al '
                              'suo account ed utilizzare il suo catalogo prodotti per eseguire i tuoi ordini.', textAlign: TextAlign.center,),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: getProportionateScreenWidth(100),
                              width: getProportionateScreenWidth(600),
                              child: OutlinedButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, JoinSupplierScreen.routeName);
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/deal.svg', width: getProportionateScreenWidth(30)) ,
                                    SizedBox(width: 5,),
                                    Text('Associa Fornitore', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.bold, color: kCustomGrey),),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text('oppure sceglilo fra quelli già associati alle tue altre attività', textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: getProportionateScreenWidth(100),
                              width: getProportionateScreenWidth(600),
                              child: OutlinedButton(
                                onPressed: (){
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Builder(
                                          builder: (context) {
                                            return SizedBox(
                                              width: getProportionateScreenWidth(900),
                                              height: getProportionateScreenHeight(600),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(10.0),
                                                            topLeft: Radius.circular(10.0)),
                                                        color: kCustomGrey,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            '  Lista Fornitori',
                                                            style: TextStyle(
                                                              fontSize:
                                                              getProportionateScreenWidth(17),
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.clear,
                                                              color: Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    AddSupplierFromOtherBranchWidget(),
                                                    const SizedBox(height: 40),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      });
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/finger.svg', width: getProportionateScreenWidth(30)) ,
                                    SizedBox(width: 5,),
                                    Text('Scegli Fornitore', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.bold, color: kCustomGrey),),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 0,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}