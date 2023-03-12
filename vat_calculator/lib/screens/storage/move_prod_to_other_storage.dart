import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/storage/storage_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/choiced_storage_stock_widget.dart';
import 'components/move_stock_widget.dart';

class MoveProductToOtherStorageScreen extends StatefulWidget {
  const MoveProductToOtherStorageScreen({Key? key}) : super(key: key);

  static String routeName = 'move_prod_to_oth_storage';
  @override
  State<MoveProductToOtherStorageScreen> createState() => _MoveProductToOtherStorageScreenState();
}

class _MoveProductToOtherStorageScreenState extends State<MoveProductToOtherStorageScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _){
        return Scaffold(
          body: Stack(
            children: [
              dataBundleNotifier.selectedStorageNameToMoveProd.storageId == 0 ? Center(
                child: Text('Seleziona magazzino', style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    color: kCustomGrey
                ),),
              ) : Stack(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: const Color(0xFFFFFFFF),
                            child: const SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: MoveStockComponent()),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: ChoicedStorageStockComponent(),
                            ),
                            color: const Color(0xFFFFFFFA),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          color: Colors.blue,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text('  ' + dataBundleNotifier.getCurrentStorage().name!, style: TextStyle(
                                      fontSize: getProportionateScreenWidth(17),
                                      color: Colors.white
                                  ),)
                              ),
                              Expanded(
                                  child: Text('--> ' +  dataBundleNotifier.selectedStorageNameToMoveProd.name!, style: TextStyle(
                                      fontSize: getProportionateScreenWidth(17),
                                      color: Colors.white
                                  ),)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CoolDropdown(
                isAnimation: true,
                dropdownWidth: 400,
                gap: 2,
                resultWidth: 500,
                dropdownList: dataBundleNotifier.getCoolDropDownListFromStorages(),
                onChange: (index) {

                  dataBundleNotifier.calculateStorageProdListByStorageId(index);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 2000),
                      backgroundColor: kCustomGrey ,
                      content: Text('Hai selezionato magazzino ' + dataBundleNotifier.selectedStorageNameToMoveProd.name!, style: const TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
                },
                defaultValue: dataBundleNotifier.getCoolDropDownListFromStorages()[1],
                // placeholder: 'insert...',
              ),
            ]
          ),
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: kCustomGrey),
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
              Navigator.pushNamed(context, StorageScreen.routeName);
            },),
            title: dataBundleNotifier.getCurrentBranch().storages!.isEmpty ? Text('Area Magazzini' , style: TextStyle(
                fontSize: getProportionateScreenWidth(17),
                color: kCustomGrey
            ),) : Column(
              children: [
                Text(
                  'Sposta prodotti',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(20),
                    color: kCustomGrey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
