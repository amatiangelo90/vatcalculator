import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class EditBranchScreen extends StatefulWidget {
  const EditBranchScreen({Key key, this.currentBranch, this.listStorageModel, this.listUserModel, this.listSuppliersModel}) : super(key: key);

  final BranchModel currentBranch;
  final List<UserModel> listUserModel;
  final List<ResponseAnagraficaFornitori> listSuppliersModel;
  final List<StorageModel> listStorageModel;

  @override
  _EditBranchScreenState createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {

  int currentUserPage = 0;
  int currentStoragePage = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child){
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
            title: Text(widget.currentBranch.companyName,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
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
                  children: [
                    SizedBox(height: 5,),
                    Center(child: Text(
                      'Personale', style: TextStyle(fontSize: getProportionateScreenWidth(15)),
                    )),
                    buildListUsersForCurrentBranch(widget.listUserModel, widget.currentBranch, dataBundleNotifier),
                    Center(child: Text(
                      'Magazzini', style: TextStyle(fontSize: getProportionateScreenWidth(15)),
                    )),
                    buildListStoragesForCurrentBranch(widget.listStorageModel, widget.currentBranch, dataBundleNotifier),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: getProportionateScreenHeight(70),
                        width: getProportionateScreenWidth(400),
                        child: CupertinoButton(
                          child: Text('Elimina Attività'),
                          onPressed: (){

                          },
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildListUsersForCurrentBranch(List<UserModel> listUserModel,
      BranchModel currentBranch,
      DataBundleNotifier dataBundleNotifier) {
    return SizedBox(
      width: getProportionateScreenWidth(500),
      height: getProportionateScreenHeight(400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentUserPage = value;
                  });
                },
                itemCount: listUserModel.length,
                itemBuilder: (context, index) => Container(
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 16,
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(60)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kCustomWhite,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)),
                              color: kCustomGreyBlue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(listUserModel[index].privilege, style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20)),),

                              listUserModel[index].id == dataBundleNotifier.dataBundleList[0].id ? SizedBox(height: 0,) :
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: getProportionateScreenHeight(50),
                                        width: getProportionateScreenWidth(300),
                                        child: CupertinoButton(
                                          child: Text('Rendi Amministratore'),
                                          color: Colors.green,
                                          onPressed: (){},
                                        ),
                                      ),
                                    ],
                                  ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(listUserModel[index].name, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(23)),),
                                  SizedBox(width: 3,),
                                  Text(listUserModel[index].lastName, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(23)),),
                                ],
                              ),
                              ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        listUserModel.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(flex: 3),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  buildListStoragesForCurrentBranch(List<StorageModel> listStorageModel, BranchModel currentBranch, DataBundleNotifier dataBundleNotifier) {
    return SizedBox(
      width: getProportionateScreenWidth(500),
      height: getProportionateScreenHeight(400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentStoragePage = value;
                  });
                },
                itemCount: listStorageModel.length,
                itemBuilder: (context, index) => Container(
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 16,
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(60)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kPinaColor,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)),
                              color: kCustomGreyBlue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                ],
                              ),
                              Text(listStorageModel[index].name, style: TextStyle(color: kCustomWhite, fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(20)),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        listStorageModel.length,
                            (index) => buildDotStoragePages(index: index),
                      ),
                    ),
                    const Spacer(flex: 3),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentUserPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentUserPage == index ? kCustomGreyBlue : kBeigeColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  AnimatedContainer buildDotStoragePages({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentStoragePage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentStoragePage == index ? kCustomGreyBlue : kBeigeColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

}
