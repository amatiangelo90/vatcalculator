import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';

import 'helper/save_file_mobile.dart';

class PdfService{

  Future<void> generatePdfOrderAndOpenOnDevide(
      OrderModel order,
      List<ProductOrderAmountModel> productList, BranchModel currentBranch) async {


    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    final PdfGrid grid = _getGrid(productList);
    final PdfLayoutResult result = _drawHeader(page, pageSize, grid, order, productList, currentBranch);
    _drawGrid(page, grid, result);
    _drawFooter(page, pageSize, order);
    final List<int> bytes = document.save();
    document.dispose();

    await FileSaveHelper.saveAndLaunchFile(bytes, 'Ordine-${order.code}.pdf');
  }


  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid, OrderModel order, List<ProductOrderAmountModel> productList, BranchModel currentBranch) {
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(0, 34, 34)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));

    page.graphics.drawString(
        'Ordine #' + order.code.toString() , PdfStandardFont(PdfFontFamily.helvetica, 22),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(0, 34, 34)));
    page.graphics.drawString('€' + _getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    page.graphics.drawString('Tot.', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = 'Codice Ordine: ${order.code}\r\n\r\nEffettuato in data: ' +
        order.creation_date + '\r\n\r\nDa consegnare in data: ' +
        order.delivery_date;

    final Size contentSize = contentFont.measureString(invoiceNumber);
    String address =
        'Ordine per: \r\n\r\n${currentBranch.companyName}, \r\n\r\n${currentBranch.address}, ${currentBranch.cap}, \r\n\r\n${currentBranch.city}, '
        '\r\n\r\n\nemail: ${currentBranch.eMail} \r\n\r\ncell: ${currentBranch.phoneNumber}';
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));
    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120));
  }


  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));
    page.graphics.drawString('Totale: ',
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


  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
      grid.rows[i].cells[grid.columns.count - 1].value as String;
      if(value != null){
        total += double.parse(value);
      }

    }
    return total;
  }
  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize, OrderModel order) {
    final PdfPen linePen =
    PdfPen(PdfColor(0, 170, 0, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    String footerContent =
        order.details;

    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  PdfGrid _getGrid(List<ProductOrderAmountModel> productList) {

    final PdfGrid grid = PdfGrid();
    int lenght = 0;
    productList.forEach((element) {
      lenght ++;
    });

    print('Length : ' + lenght.toString());

    if(lenght < 5){
      lenght = 5;
    }


    grid.columns.add(count: lenght);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(21, 11, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Prodotto ';
    headerRow.cells[2].value = 'Prezzo';
    headerRow.cells[3].value = 'Quantità';
    headerRow.cells[4].value = 'Totale';

    productList.forEach((product) {
      double total = product.prezzo_lordo * product.amount;
      _addProducts(product.pkProductId.toString(), product.nome, product.prezzo_lordo, product.amount, total, grid);
    });

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

  void _addProducts(String productId,
      String productName,
      double price,
      double quantity,
      double total,
      PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }
}