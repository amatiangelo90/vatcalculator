import 'package:flutter/material.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/size_config.dart';

class ProductDataSourceStorage extends DataTableSource {
  int _selectedCount = 0;

  final List<StorageProductModel> _products;
  ProductDataSourceStorage(this._products, this._listSuppliers );
  final List<ResponseAnagraficaFornitori> _listSuppliers;


  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _products.length) return null;
    final StorageProductModel product = _products[index];
    return DataRow.byIndex(
        index: index,
        selected: product.selected,
        onSelectChanged: (bool value) {
          if (product.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            product.selected = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(product.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(product.unitMeasure, style: TextStyle(fontSize: getProportionateScreenHeight(10))),
            ],
          )),
          DataCell(Text(product.stock.toStringAsFixed(2), style: TextStyle(color: product.stock <= 0 ? Colors.red : Colors.green.shade900, fontWeight: FontWeight.bold),)),
          DataCell(Text(product.price.toStringAsFixed(2))),
          DataCell(Text(getSupplierFromListById(_listSuppliers, product.supplierId))),
        ]
    );
  }

  @override
  int get rowCount => _products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  String getSupplierFromListById(List<ResponseAnagraficaFornitori> listSuppliers, int supplierId) {

     String currentSupplierName = 'Fornitore Sconosciuto';

      listSuppliers.forEach((currentSupplier) {

        if(currentSupplier.pkSupplierId == supplierId){
          currentSupplierName = currentSupplier.nome;
        }
      });
      return currentSupplierName;
  }
}