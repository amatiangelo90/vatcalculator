import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/swagger/client_index.dart';
import '../../client/excel/helper/save_file_mobile.dart';
import '../../components/default_button.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.models.swagger.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({Key? key}) : super(key: key);

  static String routeName = 'marketing';

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    return Consumer<DataBundleNotifier>(
      builder: (child, dataBundleNotifier, _) {
        return FutureBuilder(
          future: _retrieveDataCustomer(dataBundleNotifier),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                bottomSheet: Container(
                  color: Color(0xff10793F),
                  child: SizedBox(
                    height: 100,
                    child: DefaultButton(
                      textColor: Colors.white,
                      text: 'Esporta Excel',
                      press: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              contentPadding: EdgeInsets.only(top: 20.0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        buildReservationButton('20M2 - CISTERNINO', dataBundleNotifier.customerListCisternino, Colors.black, height, Colors.white, Color(0xff121212), 'cisternino'),
                                        buildReservationButton('20M2 - LOCOROTONDO', dataBundleNotifier.customerListCisternino, Colors.black, height, Colors.white, Color(0xff121212),'locorotondo'),
                                        buildReservationButton('20M2 - MONOPOLI', dataBundleNotifier.customerListCisternino, Colors.black, height, Colors.white, Color(0xff121212), 'monopoli'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,)
                                ],
                              ),
                            );
                          },
                        );

                      },
                      color: Color(0xff10793F),
                    ),
                  ),
                ),
                appBar: AppBar(
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: () {},
                      ),
                    )
                  ],
                  bottom: const TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(icon: Text('Cisternino')),
                      Tab(icon: Text('Locorotondo')),
                      Tab(icon: Text('Monopoli')),
                    ],
                  ),
                  title: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Area Marketing',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '20m2',
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(13),
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor: Color(0xff10793F),
                  elevation: 1,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: TabBarView(
                  children: [
                    _buildTableByBranch(dataBundleNotifier.customerListCisternino, context),
                    _buildTableByBranch(dataBundleNotifier.customerListLocorotondo, context),
                    _buildTableByBranch(dataBundleNotifier.customerListMonopoli, context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _createExcel(Set<Customer> customers, String fileName) async {
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    sheet.enableSheetCalculations();

    sheet.getRangeByName('D1').cellStyle.fontSize = 9;
    sheet.getRangeByName('A1').columnWidth = 25;
    sheet.getRangeByName('B1').columnWidth = 25;
    sheet.getRangeByName('C1').columnWidth = 35;
    sheet.getRangeByName('D1').columnWidth = 16;

    sheet.getRangeByName('A1').setText('nome');
    sheet.getRangeByName('B1').setText('cognome');
    sheet.getRangeByName('C1').setText('email');
    sheet.getRangeByName('D1').setText('telefono');
    sheet.getRangeByName('E1').setText('indirizzo');
    sheet.getRangeByName('F1').setText('citta');
    sheet.getRangeByName('G1').setText('cap');
    sheet.getRangeByName('H1').setText('provincia');
    sheet.getRangeByName('I1').setText('nazione');
    sheet.getRangeByName('J1').setText('note');

    for(int i = 2; i < customers.length + 2; i++){

      if(isValidPhoneNumber(customers.elementAt(i-2).phone!)){
        String? phone = '+39';
        phone = phone + customers.elementAt(i-2).phone!;
        sheet.getRangeByName('A' + i.toString()).setText(customers.elementAt(i-2).name);
        sheet.getRangeByName('B' + i.toString()).setText(customers.elementAt(i-2).lastname);
        sheet.getRangeByName('C' + i.toString()).setText(customers.elementAt(i-2).email);
        sheet.getRangeByName('D' + i.toString()).setText(phone);
        sheet.getRangeByName('E' + i.toString()).setText('');
        sheet.getRangeByName('F' + i.toString()).setText('');
        sheet.getRangeByName('G' + i.toString()).setText('');
        sheet.getRangeByName('H' + i.toString()).setText('');
        sheet.getRangeByName('I' + i.toString()).setText('');
        sheet.getRangeByName('J' + i.toString()).setText('');
      }else{
        print('phone not valid');
      }

    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveAndLaunchFile(bytes, fileName + '.xlsx');
  }

  Future<dynamic> _retrieveDataCustomer(
      DataBundleNotifier dataBundleNotifier) async {
    print('calling');
    Swagger swagger = Swagger.create(
        baseUrl: 'http://servicedbacorp741w.com:8080/ventimetriquadriservice');
    Response customers =
        await swagger.apiV1WebsiteCustomersFindallGet();
    dataBundleNotifier
        .setCurrentCustomerList(customers.body);
  }

  _buildTableByBranch(Set<Customer> customerList, context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(5),
          4: FlexColumnWidth(6),
        },
        border: TableBorder.all(
            color: Colors.grey.shade700,
            style: BorderStyle.solid,
            width: 0.5),
        children: buildTableRowByCurrentCustomerList(customerList, context),
      ),
    );
  }

  buildTableRowByCurrentCustomerList(Set<Customer> customerList, context) {
    List<TableRow> rows = [
      TableRow( children: [
        Column(children:const [Text('Nome', style: TextStyle(fontSize: 9.0))]),
        Column(children:const [Text('Cognome', style: TextStyle(fontSize: 9.0))]),
        Column(children:const [Text('Accessi', style: TextStyle(fontSize: 9.0))]),
        Column(children:const [Text('Cell', style: TextStyle(fontSize: 9.0))]),
        Column(children:const [Text('email', style: TextStyle(fontSize: 9.0))]),
      ]),
    ];
    
    customerList.forEach((customer) {
      rows.add(
        TableRow( children: [
          Column(children:[Text(customer.name!, style: TextStyle(fontSize: 10.0))]),
          Column(children:[Text(customer.lastname!, style: TextStyle(fontSize: 10.0))]),
          Column(children:[Text(customer.accessesList!.length.toString(), style: TextStyle(fontSize: 10.0))]),
          GestureDetector(
              onTap: (){
                showDialog(
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      contentPadding: EdgeInsets.only(top: 20.0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                Text(customer.name! + customer.lastname!),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: buildAccessDetails(customer.accessesList!)
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 9/7,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xFF7c1228))
                                        ),
                                        onPressed: () async {
                                          Swagger swagger = Swagger.create(
                                              baseUrl: 'http://servicedbacorp741w.com:8080/ventimetriquadriservice');
                                              await swagger.apiV1WebsiteCustomersDeleteDelete(customerId: customer.customerId!.toInt());
                                              Navigator.of(context).pop();
                                        }, child: Text('Elimina Utente')))
                              ],
                            ),
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                    );
                  }, context: context,
                );
              },
              child: Column(children:[Text('+39' + customer.phone!, style: TextStyle(fontSize: 10.0))])),
          Column(children:[Text(customer.email!, style: TextStyle(fontSize: 10.0))]),
        ]),
      );
    });
    return rows;
  }

  buildReservationButton(String name,
      Set<Customer> customers,
      Color color,
      double height,
      Color insideButtonColor, Color borderColor, String fileName) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: 300,
        height: height * 1/16,
        child: ElevatedButton(
          onPressed: (){
            _createExcel(customers, fileName);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => insideButtonColor,),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: borderColor)
                  )
              )
          ), child: Text(name,
            style: TextStyle(fontWeight: FontWeight.bold, color:
            color, fontSize: height * 1/55, fontFamily: 'Dance')),),
      ),
    );
  }

  bool isValidPhoneNumber(String? phone) =>
      RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(phone ?? '');

  buildAccessDetails(List<CustomerAccess> list) {
    List<Row> rows = [];

    list.forEach((element) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(element.accessDate.toString()),
            Text(customerAccessBranchLocationToJson(element.branchLocation)!),
          ],
        )
      );
    });

    return rows;
  }
}
