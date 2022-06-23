import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/client/vatservice/model/deposit_order_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/size_config.dart';

import '../../../../client/vatservice/model/order_model.dart';
import '../../../../models/bundle_users_storage_supplier_forbranch.dart';
import '../../../../components/light_colors.dart';

class OrderUnpaidCard extends StatelessWidget {
  final Color cardColor;
  final double paidPercent;
  final String total;
  final String code;
  final Function function;
  final String supplierName;
  final String orderStatus;
  final List<DepositOrder> depositList;
  final OrderModel order;
  final Map<int, BundleUserStorageSupplier> mapBundleUserStorageSupplier;

  OrderUnpaidCard({
    this.cardColor,
    this.paidPercent,
    this.code,
    this.function,
    this.total,
    this.supplierName,
    this.orderStatus,
    this.depositList,
    this.order,
    this.mapBundleUserStorageSupplier
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(supplierName, style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.white, fontSize: 15),),
            Text(
              code,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              orderStatus,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(12),
                color: Colors.lightGreenAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Creato da:',
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Chiuso da:',
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Data Ordine:',
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Ricevuto:             ',
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getUserDetailsById(order.fk_user_id, order.fk_branch_id, mapBundleUserStorageSupplier),
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: LightColors.kLightYellow2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      order.closedby,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: LightColors.kLightYellow2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      order.creation_date,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: LightColors.kLightYellow2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      order.delivery_date,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        color: LightColors.kLightYellow2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('', style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                Text(depositList.isNotEmpty ? 'Acconti' : '', style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white, fontSize: getProportionateScreenHeight(10)),),
                const Text('', style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Stato Saldo Fattura ', style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white, fontSize: 10),),
                    SizedBox(height: 10),
                    CircularPercentIndicator(
                      animation: true,
                      radius: 100.0,
                      percent: paidPercent,
                      lineWidth: 5.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.white10,
                      progressColor: Colors.lightGreenAccent,
                      center: Text(
                        '${(paidPercent*100).round()}%',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 11, 10, 11),
                      child: Text(
                        ' € ' + total.replaceAll('.00', ''),
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                    buildListDeposit(depositList),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  buildListDepositDates(depositList),
                ),
              ],
            ),
            Divider(
              height: 14,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,

                  decoration: BoxDecoration(
                    color: LightColors.kGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlatButton(
                    onPressed: function,
                    child: Center(
                      child: Text(
                        'GESTICI',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 50.0,

                  decoration: BoxDecoration(
                    color: LightColors.kRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlatButton(

                    onPressed: () {

                    },
                    child: Center(
                      child: Text(
                        'SEGNA COME PAGATA',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String calculateIva(List<ResponseAcquistiApi> listFatture) {
    double totaleIva = 0.0;

    listFatture.forEach((fattura) {
      totaleIva = totaleIva + double.parse(fattura.importo_iva);
    });

    return totaleIva.toStringAsFixed(2);
  }

  String calculateTot(List<ResponseAcquistiApi> listFatture) {
    double totale = 0.0;

    listFatture.forEach((fattura) {
      totale = totale + double.parse(fattura.importo_netto);
    });

    return totale.toStringAsFixed(2);

  }

  buildListDeposit(List<DepositOrder> depositList) {
    List<Widget> listOut = [];

    depositList.forEach((element) {
      listOut.add(
        Text(' - € ' + element.amount.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: getProportionateScreenHeight(12)),),
      );
    });

    return listOut;
  }

  buildListDepositDates(List<DepositOrder> depositList) {
    List<Widget> listOut = [];

    depositList.forEach((element) {
      listOut.add(
        Text(buildDateFromMilliseconds(element.creationDate), style: TextStyle(fontWeight: FontWeight.w100, color: Colors.grey, fontSize: getProportionateScreenHeight(12)),),
      );
    });

    return listOut;
  }

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return getDayFromWeekDayTrim(dateTime.weekday) + ' ' + dateTime.day.toString() + ' ' + getMonthFromMonthNumber(dateTime.month) + ' ' + dateTime.year.toString();
  }

  String getUserDetailsById(
      int fkUserId,
      int fkBranchId,
      Map<int, BundleUserStorageSupplier> currentMapBranchIdBundleSupplierStorageUsers) {

    String currentUserName = '';
    currentMapBranchIdBundleSupplierStorageUsers.forEach((key, value) {
      if(key == fkBranchId){
        value.userModelList.forEach((user) {
          if(user.id == fkUserId){
            currentUserName = user.name + ' ' + user.lastName;
          }
        });
      }
    });
    return currentUserName;
  }

}