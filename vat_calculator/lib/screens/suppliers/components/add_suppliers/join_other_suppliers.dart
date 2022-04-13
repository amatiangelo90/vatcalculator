import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/suppliers/suppliers_screen.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

class JoinSupplierAlreadyRegisteredScreen extends StatefulWidget {
  JoinSupplierAlreadyRegisteredScreen({Key key, this.mapListSupplierForBranch}) : super(key: key);

  static String routeName = 'joinfromsupplierlist';

  final Map<int, List<SupplierModel>> mapListSupplierForBranch;

  @override
  State<JoinSupplierAlreadyRegisteredScreen> createState() => _JoinSupplierAlreadyRegisteredScreenState();
}

class _JoinSupplierAlreadyRegisteredScreenState extends State<JoinSupplierAlreadyRegisteredScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child) {
          return Scaffold(
            backgroundColor: kCustomWhite,
            bottomSheet: Padding(
              padding: EdgeInsets.all(Platform.isAndroid ? 8.0 : 18.0),
            ),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => {
                    Navigator.pushNamed(context, SuppliersScreen.routeName),
                  }
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Associa Fornitore',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(19),
                      color: kCustomWhite,
                    ),
                  ),
                ],
              ),
              elevation: 5,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Column(
                    children: buildCurrentSupplierListForSelectedBranch(dataBundleNotifier),
                  ),

                  Column(
                    children: _buildSuppliersWidget(widget.mapListSupplierForBranch, dataBundleNotifier),
                  )
                ],
              ),
            ),
          );
        });
  }

  _buildSuppliersWidget(Map<int, List<SupplierModel>> mapListSupplierForBranch, DataBundleNotifier dataBundleNotifier) {

    List<Widget> list = [];
    mapListSupplierForBranch.forEach((key, listSuppliers) {


      List<Widget> listBranch = [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('  Fornitori associati a ' + dataBundleNotifier.retrieveBranchById(key).companyName, style: TextStyle(color: kPrimaryColor),),
            ),
          ],
        )
      ];
      listSuppliers.forEach((supplier) {
        listBranch.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
            child: Container(
              padding: const EdgeInsets.only(left: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kPrimaryColor,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: kCustomWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: getProportionateScreenWidth(5)),
                          SvgPicture.asset(
                            'assets/icons/supplier.svg',
                            color: kPrimaryColor,
                            width: getProportionateScreenWidth(30),
                          ),
                          SizedBox(width: getProportionateScreenWidth(20)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supplier.nome,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontSize: getProportionateScreenWidth(15)),
                              ),Text(
                                key.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontSize: getProportionateScreenWidth(15)),
                              ),
                              Text('#' + supplier.extra,
                                  style: TextStyle(
                                    color: kBeigeColor,
                                    fontSize: getProportionateScreenWidth(12),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.add),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      list.addAll(listBranch);
    });

    return list;
  }

  buildCurrentSupplierListForSelectedBranch(DataBundleNotifier dataBundleNotifier) {
    List<Widget> list = [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('  Fornitori già associati', style: TextStyle(color: kPrimaryColor),),
          ),
        ],
      )
    ];

    dataBundleNotifier.currentListSuppliers.forEach((supplier) {
      list.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(15)),
                      ),
                      Text('#' + supplier.extra,
                          style: TextStyle(
                            color: kBeigeColor,
                            fontSize: getProportionateScreenWidth(12),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
    return list;
  }
}



