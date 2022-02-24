import 'package:flutter/material.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';

class ProductDataSource extends DataTableSource {
  int _selectedCount = 0;

  final List<StorageProductModel> _products;
  ProductDataSource(this._products);

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
          DataCell(Text(product.productName)),
          DataCell(Text(product.stock.toStringAsFixed(2), style: TextStyle(color: product.stock <= 0 ? Colors.red : Colors.green.shade900),)),
          DataCell(Text(product.unitMeasure.toString())),
          DataCell(Text(product.price.toStringAsFixed(2))),
          DataCell(Text(product.amountHundred.toStringAsFixed(2))),
        ]
    );
  }

  @override
  int get rowCount => _products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}