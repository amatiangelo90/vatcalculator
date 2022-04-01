import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'branch_creation.dart';
import 'branch_join.dart';

class BranchChoiceCreationEnjoy extends StatefulWidget {

  static String routeName = 'branch_choice';
  @override
  _BranchChoiceCreationEnjoyState createState() => _BranchChoiceCreationEnjoyState();
}

class _BranchChoiceCreationEnjoyState extends State<BranchChoiceCreationEnjoy> {
  var currentStep = 0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text('Registra la tua attività',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(19),
            color: Colors.white,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Stack(
        children: [
          Container(
            color: kPrimaryColor,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20,),
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('Gestisci la tua attività dal tuo smartphone.', textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite),),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenWidth(450),
                          child: CupertinoButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.home_work, color: kCustomGreenAccent,),
                                const SizedBox(width: 5,),
                                Text('Crea una nuova attività', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: getProportionateScreenWidth(16),
                                      fontWeight: FontWeight.bold, color: kPrimaryColor),),
                              ],
                            ),
                            color: kCustomWhite,
                            onPressed: (){
                              Navigator.pushNamed(context, CreationBranchScreen.routeName);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('Sei un socio oppure un dipendente?'
                          ' Associa il tuo account con una attività già esistente. Scopri come..', textAlign: TextAlign.center, style: TextStyle(color: kCustomWhite),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenWidth(450),
                          child: CupertinoButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.people, color: kCustomGreenAccent),
                                const SizedBox(width: 5,),
                                Text('Unisciti ad una esistente', overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold, color: kPrimaryColor),),
                              ],
                            ),
                            color: kCustomWhite,
                            onPressed: (){
                              Navigator.pushNamed(context, BranchJoinScreen.routeName);
                            },
                          ),
                        ),
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
  }

}