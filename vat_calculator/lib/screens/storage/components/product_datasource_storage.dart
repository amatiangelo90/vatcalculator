import 'package:flutter/material.dart';
import 'package:vat_calculator/client/vatservice/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/constants.dart';
import 'package:vat_calculator/size_config.dart';

class ProductDataSourceStorage extends DataTableSource {

  int _selectedCount = 0;
  final List<StorageProductModel> _products;
  ProductDataSourceStorage(this._products, this._listSuppliers, this.isEmployee);
  final List<SupplierModel> _listSuppliers;
  final bool isEmployee;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _products.length) return DataRow(cells: []);
    final StorageProductModel product = _products[index];
    return DataRow.byIndex(
        index: index,
        selected: product.selected,
        onSelectChanged: (bool? value) {
          if (product.selected != value) {
            _selectedCount += value! ? 1 : -1;
            assert(_selectedCount >= 0);
            product.selected = value!;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(product.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getProportionateScreenHeight(15), color: kPrimaryColor)),
                  Text(product.unitMeasure, style: TextStyle(fontSize: getProportionateScreenHeight(11), fontWeight: FontWeight.bold, color: kCustomGreenAccent)),
                ],
            )),
          DataCell(Text(product.stock.toStringAsFixed(2).replaceAll('.00',''), style: TextStyle( fontSize: getProportionateScreenHeight(15), color: product.stock <= 0 ? Colors.red : kPrimaryColor, fontWeight: FontWeight.bold),)),
          DataCell(Text(isEmployee ? '---' :  product.price.toStringAsFixed(2).replaceAll('.00','') + ' €' )),
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

  String getSupplierFromListById(List<SupplierModel> listSuppliers, int supplierId) {

     String currentSupplierName = 'Fornitore Sconosciuto';

      listSuppliers.forEach((currentSupplier) {

        if(currentSupplier.pkSupplierId == supplierId){
          currentSupplierName = currentSupplier.nome;
        }
      });
      return currentSupplierName;
  }
}