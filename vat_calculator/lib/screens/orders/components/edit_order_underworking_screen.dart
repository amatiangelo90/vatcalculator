import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vat_calculator/client/pdf/helper/save_file_mobile.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/action_type.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/models/bundle_users_storage_supplier_forbranch.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

import '../orders_screen.dart';

class OrderCompletionScreen extends StatefulWidget {
  const OrderCompletionScreen({Key key, this.orderModel, this.productList, }) : super(key: key);

  final OrderModel orderModel;
  final List<ProductOrderAmountModel> productList;

  @override
  State<OrderCompletionScreen> createState() => _OrderCompletionScreenState();
}

class _OrderCompletionScreenState extends State<OrderCompletionScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati...',),
      child: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, child){
          return Scaffold(
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: CupertinoButton(
                          color: Colors.green,
                          child: Text('Ricevuto', style: const TextStyle(color: kCustomWhite),),
                          onPressed: (){
                            dataBundleNotifier.setEditOrderToFalse();
                            Widget cancelButton = TextButton(
                              child: const Text("Indietro", style: TextStyle(color: kPrimaryColor),),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            );

                            Widget continueButton = TextButton(
                              child: const Text("Ricevuto", style: TextStyle(color: Colors.green)),
                              onPressed:  () async {
                                Navigator.of(context).pop();

                                context.loaderOverlay.show();
                                StorageModel storageModel = dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id);
                                await dataBundleNotifier.setCurrentStorage(storageModel);

                                print('Start adding order to current storage stock');

                                dataBundleNotifier.currentStorageProductListForCurrentStorage.forEach((element) {
                                  widget.productList.forEach((standardElement) {
                                    if (standardElement.pkProductId == element.fkProductId) {
                                      element.stock = element.stock + standardElement.amount;
                                    }
                                  });
                                });

                                print('Finish uploading storage stock');

                                ClientVatService getclientServiceInstance = dataBundleNotifier.getclientServiceInstance();

                                //TODO aggiungere lista merce aggiunta a fronte del carico
                                getclientServiceInstance.updateStock(
                                    currentStorageProductListForCurrentStorageUnload: dataBundleNotifier.currentStorageProductListForCurrentStorage,
                                    actionModel: ActionModel(
                                        date: DateTime.now().millisecondsSinceEpoch,
                                        description: 'Ha eseguito il carico nel magazzino ${storageModel.name} a fronte della ricezione dell\'ordine #${widget.orderModel.code} '
                                            'da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}. ',
                                        fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                        user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                        type: ActionType.STORAGE_LOAD
                                    )
                                );
                                dataBundleNotifier.clearUnloadProductList();
                                dataBundleNotifier.refreshProductListAfterInsertProductIntoStorage();

                                await dataBundleNotifier.getclientServiceInstance().updateOrderStatus(
                                  orderModel: OrderModel(
                                      pk_order_id: widget.orderModel.pk_order_id,
                                      status: OrderState.RECEIVED_ARCHIVED,
                                      delivery_date: DateTime.now().millisecondsSinceEpoch,
                                      closedby: dataBundleNotifier.dataBundleList[0].firstName + ' ' + dataBundleNotifier.dataBundleList[0].lastName
                                  ),
                                  actionModel: ActionModel(
                                      date: DateTime.now().millisecondsSinceEpoch,
                                      description: 'Ha modificato in ${OrderState.RECEIVED_ARCHIVED} l\'ordine #${widget.orderModel.code} da parte del fornitore ${dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id)}.',
                                      fkBranchId: dataBundleNotifier.currentBranch.pkBranchId,
                                      user: dataBundleNotifier.retrieveNameLastNameCurrentUser(),
                                      type: ActionType.RECEIVED_ORDER
                                  )
                                );
                                dataBundleNotifier.updateOrderStatusById(widget.orderModel.pk_order_id, OrderState.RECEIVED_ARCHIVED, DateTime.now().millisecondsSinceEpoch, dataBundleNotifier.dataBundleList[0].firstName + ' ' + dataBundleNotifier.dataBundleList[0].lastName);
                                dataBundleNotifier.setCurrentBranch(dataBundleNotifier.currentBranch);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(),
                                  ),
                                );
                                context.loaderOverlay.hide();
                              },
                            );

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog (
                                  actions: [
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        cancelButton,
                                        continueButton,
                                      ],
                                    ),
                                  ],
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
                                        height: getProportionateScreenHeight(300),
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
                                                  color: kPrimaryColor,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('  Completa Ordine ed Archivia',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: getProportionateScreenWidth(15),
                                                          fontWeight: FontWeight.bold,
                                                          color: kCustomWhite,
                                                        )),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ), onPressed: () { Navigator.pop(context); },),

                                                  ],
                                                ),
                                              ),
                                              Text(''),
                                              Center(
                                                child: Text('Contrassegna ordine #${widget.orderModel.code.toString()} come ricevuto ed eseguire il carico per magazzino ${dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id).name}? ', textAlign: TextAlign.center,),
                                              ),
                                              Text(''),
                                              Text('Nota: Nel caso tu non abbia ricevuto l\'intero ordine puoi modificare le quantità cliccando sull\'icona ' , style: TextStyle(fontSize: getProportionateScreenHeight(12)), textAlign: TextAlign.center,),
                                              IconButton(
                                                icon: SvgPicture.asset('assets/icons/edit-cust.svg',
                                                  width: 20,
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: (){
                                                  dataBundleNotifier.switchEditOrder();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/textmessage.svg',
                      height: getProportionateScreenHeight(30),
                    ),
                    onPressed: () => {
                      //launch('sms:${refactorNumber(number)}?body=$message');
                    }
                ),
                IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/ws.svg',
                      height: getProportionateScreenHeight(30),
                    ),
                    onPressed: () => {
                      //launch('https://api.whatsapp.com/send/?phone=${refactorNumber(number)}&text=$message');
                    }
                ),
              ],
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: kCustomYellow800),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              automaticallyImplyLeading: true,
              title: Text(
                'Dettaglio Ordine', style: TextStyle(color: kCustomYellow800),
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Card(
                          child: Column(
                            children: [
                              Text(dataBundleNotifier.getSupplierName(widget.orderModel.fk_supplier_id), style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(25)),),
                              Text('#' + widget.orderModel.code, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(17)),),
                              Divider(endIndent: 40, indent: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Creato da: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(getUserDetailsById(widget.orderModel.fk_user_id, widget.orderModel.fk_branch_id, dataBundleNotifier.currentMapBranchIdBundleSupplierStorageUsers), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(buildDateFromMilliseconds(widget.orderModel.creation_date), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Magazzino: ', style: TextStyle(fontWeight: FontWeight.bold),),

                                  dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id) == null ? SizedBox(width: 0,) : Text(dataBundleNotifier.getStorageFromCurrentStorageListByStorageId(widget.orderModel.fk_storage_id).name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Stato: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(widget.orderModel.status, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Divider(endIndent: 40, indent: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Da consegnare a: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.companyName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('In via: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.address, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Città: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.city, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('CAP : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  dataBundleNotifier.currentBranch == null ? Text('') : Text(dataBundleNotifier.currentBranch.cap.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Da consegnare il: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(buildDateFromMilliseconds(widget.orderModel.delivery_date), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),),
                                ],
                              ),
                              const Divider(endIndent: 40, indent: 40,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text('Dettagli'),
                              ),
                              Text(widget.orderModel.details,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Carrello', style: TextStyle(color: kPinaColor, fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: IconButton(
                                icon: SvgPicture.asset('assets/icons/pdf.svg', width: getProportionateScreenWidth(23),),
                                  onPressed: _generatePDF,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: IconButton(
                                icon: SvgPicture.asset('assets/icons/edit-cust.svg',
                                  width: getProportionateScreenWidth(dataBundleNotifier.editOrder ? 23 : 21),
                                  color: dataBundleNotifier.editOrder ? Colors.blueAccent : kPrimaryColor,
                                ),

                                onPressed: (){
                                  dataBundleNotifier.switchEditOrder();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildProductListWidget(context, dataBundleNotifier),
                  SizedBox(height: getProportionateScreenHeight(90),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildProductListWidget(context, DataBundleNotifier dataBundleNotifier) {

    List<Widget> tableRowList = [
    ];

    widget.productList.forEach((currentProduct) {
      TextEditingController controller = TextEditingController(text: currentProduct.amount.toString());
      tableRowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.view_stream, color: kPrimaryColor,size: 5,),
                Text( ' ' + currentProduct.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(16), color: kPrimaryColor),),
                Text(' (' + currentProduct.unita_misura + ')', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomYellow800),),
              ],
            ),
            Row(
              children: [
                dataBundleNotifier.editOrder ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if(currentProduct.amount <= 0){
                      }else{
                        currentProduct.amount --;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.minus, color: kPinaColor,),
                  ),
                ) : SizedBox(height: 0,),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                      getProportionateScreenWidth(70),
                      getProportionateScreenWidth(60))),
                  child: CupertinoTextField(
                    controller: controller,
                    enabled: dataBundleNotifier.editOrder,
                    onChanged: (text) {
                      if (double.tryParse(text) != null) {
                        currentProduct.amount = double.parse(text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: kPinaColor,
                          content: Text(
                              'Immettere un valore numerico corretto per ' +
                                  currentProduct.nome),
                        ));
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    clearButtonMode: OverlayVisibilityMode.never,
                    textAlign: TextAlign.center,
                    autocorrect: false,
                  ),
                ),
                dataBundleNotifier.editOrder ? GestureDetector(
                  onTap: () {
                    setState(() {
                      currentProduct.amount  =  currentProduct.amount + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.plus, color: Colors.green.shade900),
                  ),
                ) : SizedBox(height: 0,),
              ],
            ),
          ],
        ),
      );
      tableRowList.add(Divider(endIndent: 20, indent: 30,),);
    });

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: tableRowList,
      ),
    );
  }

  String getNiceNumber(String string) {
    if(string.contains('.00')){
      return string.replaceAll('.00', '');
    }else if(string.contains('.0')){
      return string.replaceAll('.0', '');
    }else {
      return string;
    }
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

  String buildDateFromMilliseconds(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString();
  }



  Future<void> _generatePDF() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = _getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(page, pageSize, grid);
    //Draw grid
    _drawGrid(page, grid, result);
    //Add invoice footer
    _drawFooter(page, pageSize);
    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();
    //Launch file.

    await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');
  }

  //Draws the invoice header
  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));
    page.graphics.drawString(r'$' + _getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = 'Invoice Number: 2058557939\r\n\r\nDate: ' +
        format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(invoiceNumber);
    const String address =
        'Bill To: \r\n\r\nAbraham Swearegin, \r\n\r\nUnited States, California, San Mateo, \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136';
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));
    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120));
  }


  //Draws the grid
  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));
    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds.left,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height));
    page.graphics.drawString(_getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width,
            totalPriceCellBounds.height));
  }

  //Get the total amount.
  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
      grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }


  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void _addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }
}
