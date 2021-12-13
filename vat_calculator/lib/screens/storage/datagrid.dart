import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';

class PageScc extends StatefulWidget {
  PageScc({Key key}) : super(key: key);

  static String routeName = 'datapagae';
  @override
  _PageSccState createState() => _PageSccState();
}

class _PageSccState extends State<PageScc> {
  StorageProductModelDataSource employeeDataSource;

  final int _rowsPerPage = 15;
  final double _dataPagerHeight = 60.0;

  List<DataGridRow> addedRowsGeneral = [];

  List<DataGridRow> removedRowsGeneral = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter DataGrid'),
      ),
      body: Consumer<DataBundleNotifier>(
        builder: (context, dataBundleNotifier, _){
          employeeDataSource = StorageProductModelDataSource(storageProd: dataBundleNotifier.currentStorageProductListForCurrentStorage);
          return Column(
            children: [
              addedRowsGeneral.length == 0 ? Text('vuoto') : Text('Delete'),
              SizedBox(
                height: 500,
                child: SfDataGrid(
                  selectionMode: SelectionMode.multiple,
                  navigationMode: GridNavigationMode.row,
                  onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows){

                    print(addedRows.length.toString());
                    print(removedRows.length.toString());
                    addedRowsGeneral.addAll(addedRows);
                    print(addedRows[0].getCells()[3].value);
                    print(addedRowsGeneral.length.toString());

                  },
                  allowSorting: true,
                  source: employeeDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'name',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Nome'))),
                    GridColumn(
                        columnName: 'price',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Giacenza'))),
                    GridColumn(
                        columnName: 'supplier',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Fornitore',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'id',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Codice'))),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class StorageProductModelDataSource extends DataGridSource {

  StorageProductModelDataSource({@required List<StorageProductModel> storageProd}) {
    _employeeData = storageProd
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'name', value: e.productName),

      DataGridCell<double>(columnName: 'amount', value: e.stock),
      DataGridCell<String>(
          columnName: 'supplier', value: e.supplierName),
      DataGridCell<int>(columnName: 'code', value: e.pkStorageProductId),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}