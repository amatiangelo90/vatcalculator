import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../client/fattureICloud/model/response_fornitori.dart';
import '../../../../constants.dart';
import '../../../../models/databundlenotifier.dart';
import '../../../../size_config.dart';
import 'add_supplier_screen.dart';
import 'join_other_suppliers.dart';
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
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            title: Text('Registra Fornitore',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kCustomBlueAccent,
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
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('Crea un nuovo fornitore', textAlign: TextAlign.center,),
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
                                    SvgPicture.asset('assets/icons/supplier.svg', width: getProportionateScreenWidth(30),),
                                    SizedBox(width: 5,),
                                    Text('Crea Fornitore', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                color: kCustomWhite,
                                onPressed: (){
                                  Navigator.pushNamed(context, AddSupplierScreen.routeName);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('Puoi aggiungine uno esistente alla tua lista. '
                              'Se il tuo fornitore utilizza l\'app puoi collegarti al '
                              'suo account ed utilizzare il suo catalogo prodotti per eseguire i tuoi ordini.', textAlign: TextAlign.center,),
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
                                    SvgPicture.asset('assets/icons/deal.svg', width: getProportionateScreenWidth(30),),
                                    SizedBox(width: 5,),
                                    Text('Associa Fornitore', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                color: kCustomWhite,
                                onPressed: (){
                                  Navigator.pushNamed(context, JoinSupplierScreen.routeName);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('oppure sceglilo fra quelli già associati alle altre attività che hai registrato', textAlign: TextAlign.center,),
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
                                    SvgPicture.asset('assets/icons/deal.svg', width: getProportionateScreenWidth(30),),
                                    SizedBox(width: 5,),
                                    Text('I tuoi fornitori', overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.bold, color: kPrimaryColor),),
                                  ],
                                ),
                                color: kCustomWhite,
                                onPressed: () async {
                                  Map<int, List<SupplierModel>> mapListSupplierForBranch = {};

                                  await Future.forEach(dataBundleNotifier.userDetailsList[0].companyList, (branch) async {
                                    if(branch.pkBranchId != dataBundleNotifier.currentBranch.pkBranchId){
                                      print('Retrieve list supplier for current branch with id ' + branch.pkBranchId.toString());
                                      List<SupplierModel> _suppliersModelList = await dataBundleNotifier.getclientServiceInstance().retrieveSuppliersListByBranch(branch);
                                      mapListSupplierForBranch[branch.pkBranchId] = _suppliersModelList;
                                    }
                                  });
                                  print('mapListSupplierForBranch: ' + mapListSupplierForBranch.toString());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JoinSupplierAlreadyRegisteredScreen(
                                        mapListSupplierForBranch: mapListSupplierForBranch,
                                      ),
                                    ),
                                  );
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
      },
    );
  }

}