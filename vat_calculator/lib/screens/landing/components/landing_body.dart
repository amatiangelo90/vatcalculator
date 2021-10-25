import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/components/default_button.dart';
import 'package:vat_calculator/models/databundle.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/home/home_screen.dart';
import '../../../size_config.dart';

class LandingBody extends StatelessWidget {
  final String email;
  const LandingBody({Key key, this.email}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
        return Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Image.asset(
              "assets/images/success.png",
              height: SizeConfig.screenHeight * 0.4,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            Flexible(
              child: Text(
                "Benvenuto " + email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: "Procediamo",
                press: () async {
                  EasyLoading.show();

                  ClientVatService clientService = ClientVatService();
                  UserModel userModelRetrieved = await clientService.retrieveUserByEmail(email);

                  DataBundle dataBundle = DataBundle(userModelRetrieved.mail, '', userModelRetrieved.name, userModelRetrieved.lastName, userModelRetrieved.phone, []);
                  print("###########");
                  List<BranchModel> _branchList = await clientService.retrieveBranchesByUserEmail(userModelRetrieved.mail);
                  dataBundleNotifier.addDataBundle(dataBundle);
                  dataBundleNotifier.addBranches(_branchList);

                  if(dataBundleNotifier.currentBranch != null){
                    List<RecessedModel> _recessedModelList = await clientService.retrieveRecessedListByBranch(dataBundleNotifier.currentBranch);
                    dataBundleNotifier.addCurrentRecessedList(_recessedModelList);
                  }

                  if(dataBundleNotifier.currentBranch != null){
                    List<ResponseAnagraficaFornitori> _suppliersModelList = await clientService.retrieveSuppliersListByBranch(dataBundleNotifier.currentBranch);
                    dataBundleNotifier.addCurrentSuppliersList(_suppliersModelList);
                  }
                  if(dataBundleNotifier.currentBranch != null){
                    List<StorageModel> _storageModelList = await clientService.retrieveStorageListByBranch(dataBundleNotifier.currentBranch);
                    dataBundleNotifier.addCurrentStorageList(_storageModelList);
                  }


                  dataBundleNotifier.initializeCurrentDateTimeRangeWeekly();
                  EasyLoading.dismiss();
                  Navigator.pushNamed(context, HomeScreen.routeName);
                },
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
