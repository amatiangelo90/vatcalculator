import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import '../constants.dart';
import 'databundle.dart';

class DataBundleNotifier extends ChangeNotifier {

  List<DataBundle> dataBundleList = [

  ];

  List<RecessedModel> currentListRecessed = [

  ];

  List<ResponseAnagraficaFornitori> currentListSuppliers = [

  ];

  List<StorageModel> currentStorageList = [

  ];

  List<ProductModel> currentProductModelListForSupplier = [

  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorage = [

  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorageUnload = [

  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorageLoad = [

  ];


  List<ProductModel> productToAddToStorage = [

  ];

  List<OrderModel> currentOrdersForCurrentBranch = [

  ];

  List<OrderModel> currentUnderWorkingOrdersList = [];
  //List<ProductOrderAmountModel> currentProductOrderModelAmountListForUnderWorkingtOrder = [];

  List<OrderModel> currentDraftOrdersList = [];
  //List<ProductOrderAmountModel> currentProductOrderModelAmountListForDraftOrder = [];

  List<OrderModel> currentArchiviedWorkingOrdersList = [];
  //List<ProductOrderAmountModel> currentProductOrderModelAmountListForArchiviedOrder = [];

  String currentPrivilegeType;

  ClientVatService clientService = ClientVatService();

  bool isSpecialUser = false;

  BranchModel currentBranch;
  StorageModel currentStorage;

  DateTime currentDateTime = DateTime.now();
  DateTimeRange currentDateTimeRange;

  bool cupertinoSwitch = false;

  void setCurrentPrivilegeType(String privilege){
    currentPrivilegeType = privilege;
    notifyListeners();
  }

  void switchCupertino(){
    if(cupertinoSwitch){
      cupertinoSwitch = false;
    }else{
      cupertinoSwitch = true;
    }

    notifyListeners();
  }
  ClientVatService getclientServiceInstance(){
    if(clientService == null){
      return ClientVatService();
    }else{
      return clientService;
    }
  }

  void enableSpecialUser(){
    isSpecialUser = true;
    notifyListeners();
  }

  void addAllCurrentProductSupplierList(List<ProductModel> listProduct){
    currentProductModelListForSupplier.clear();
    currentProductModelListForSupplier.addAll(listProduct);
    notifyListeners();
  }

  void addAllCurrentListProductToProductListToAddToStorage(List<ProductModel> listProduct){
    productToAddToStorage.clear();
    productToAddToStorage.addAll(listProduct);
    notifyListeners();
  }


  void initializeCurrentDateTimeRangeWeekly() {
    currentDateTimeRange = DateTimeRange(
      start: currentDateTime
          .subtract(Duration(days: currentDateTime.weekday - 1)),
      end: currentDateTime.add(Duration(
          days: DateTime.daysPerWeek - currentDateTime.weekday)),
    );
    notifyListeners();
  }

  void addWeekToDateTimeRange(){
    currentDateTimeRange = DateTimeRange(
      start: currentDateTimeRange.start
          .add(const Duration(days: 7)),
      end: currentDateTimeRange.end.add(const Duration(
          days: 7)),
    );
    notifyListeners();
  }

  void subtractWeekToDateTimeRange(){
    currentDateTimeRange = DateTimeRange(
      start: currentDateTimeRange.start
          .subtract(const Duration(days: 7)),
      end: currentDateTimeRange.end.subtract(const Duration(
          days: 7)),
    );
    notifyListeners();
  }
  bool showIvaButtonPressed = false;
  int indexIvaList = 0;
  List<int> ivaList = [22, 10, 4, 0];


  void setShowIvaButtonToFalse(){
    showIvaButtonPressed = false;
    notifyListeners();
  }

  void setShowIvaButtonToTrue(){
    showIvaButtonPressed = true;
    notifyListeners();
  }

  List<RecessedModel> getRecessedListByRangeDate(DateTime start, DateTime end){
    List<RecessedModel> listToReturn = [];
    if(currentListRecessed.isEmpty){
      return listToReturn;
    }else{
      currentListRecessed.forEach((recessedElement) {
        if(DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isBefore(end) && DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isAfter(start)){
          listToReturn.add(recessedElement);
        }
      });
      return listToReturn;
    }
  }
  List<int> getIvaList(){
    return ivaList;
  }

  void addDataBundle(DataBundle bundle){
    print('Adding bundle to Notifier' + bundle.email.toString());
    dataBundleList.add(bundle);
    notifyListeners();
  }

  Future<void> addBranches(List<BranchModel> branchList) async {
    dataBundleList[0].companyList.clear();
    dataBundleList[0].companyList = branchList;
    if(dataBundleList[0].companyList.isNotEmpty){
      currentBranch = dataBundleList[0].companyList[0];
      List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);
      currentOrdersForCurrentBranch.clear();
      currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);

      currentDraftOrdersList.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();

      //currentProductOrderModelAmountListForDraftOrder.clear();
      //currentProductOrderModelAmountListForUnderWorkingtOrder.clear();
      //currentProductOrderModelAmountListForArchiviedOrder.clear();

      currentOrdersForCurrentBranch.forEach((orderItem) async {
        if(orderItem.status == OrderState.DRAFT){

          currentDraftOrdersList.add(orderItem);
          //currentProductOrderModelAmountListForDraftOrder = await getclientServiceInstance().retrieveProductByOrderId(
          //  OrderModel(pk_order_id: orderItem.pk_order_id,),
          //);

        }else if (orderItem.status == OrderState.ARCHIVED){
          currentArchiviedWorkingOrdersList.add(orderItem);
          //currentProductOrderModelAmountListForArchiviedOrder = await getclientServiceInstance().retrieveProductByOrderId(
        //  OrderModel(pk_order_id: orderItem.pk_order_id,),
          //);
        }else{
          currentUnderWorkingOrdersList.add(orderItem);
          //currentProductOrderModelAmountListForUnderWorkingtOrder = await getclientServiceInstance().retrieveProductByOrderId(
        //  OrderModel(pk_order_id: orderItem.pk_order_id,),
          //);
        }
      });
    }
    notifyListeners();
  }

  setOrdersList(){

  }

  Future<void> setCurrentBranch(BranchModel branchModel) async {
    currentBranch = branchModel;
    List<RecessedModel> _recessedModelList = await clientService.retrieveRecessedListByBranch(currentBranch);
    currentListRecessed.clear();
    currentListRecessed.addAll(_recessedModelList);

    List<ResponseAnagraficaFornitori> _supplierModelList = await clientService.retrieveSuppliersListByBranch(currentBranch);
    currentListSuppliers.clear();
    sleep(const Duration(seconds: 1));
    currentListSuppliers.addAll(_supplierModelList);

    List<StorageModel> _storageModel = await clientService.retrieveStorageListByBranch(currentBranch);
    currentStorageList.clear();
    currentStorageList.addAll(_storageModel);
    if(currentStorageList.isNotEmpty){
      currentStorage = currentStorageList[0];
    }
    if(currentStorageList.isNotEmpty){
      List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);

      currentStorageProductListForCurrentStorage.clear();
      currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

      currentStorageProductListForCurrentStorageUnload.clear();
      currentStorageProductListForCurrentStorageUnload = [];
      currentStorageProductListForCurrentStorage.forEach((element) {
        currentStorageProductListForCurrentStorageUnload.add(StorageProductModel(
            pkStorageProductId: element.pkStorageProductId,
            fkStorageId: element.fkStorageId,
            fkProductId: element.fkProductId,
            supplierId: element.supplierId,
            productName: element.productName,
            stock: 0.0,
            available: element.available,
            supplierName: element.supplierName,
            price: element.price,
            vatApplied: element.vatApplied,
            unitMeasure: element.unitMeasure));
      });

      currentStorageProductListForCurrentStorageLoad.clear();
      currentStorageProductListForCurrentStorageLoad = [];
      currentStorageProductListForCurrentStorage.forEach((element) {
        currentStorageProductListForCurrentStorageLoad.add(StorageProductModel(
            pkStorageProductId: element.pkStorageProductId,
            fkStorageId: element.fkStorageId,
            fkProductId: element.fkProductId,
            supplierId: element.supplierId,
            productName: element.productName,
            stock: 0.0,
            available: element.available,
            supplierName: element.supplierName,
            price: element.price,
            vatApplied: element.vatApplied,
            unitMeasure: element.unitMeasure));
      });
    }

    List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);

    currentOrdersForCurrentBranch.clear();
    currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);

    currentDraftOrdersList.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();

    //currentProductOrderModelAmountListForDraftOrder.clear();
    //currentProductOrderModelAmountListForUnderWorkingtOrder.clear();
    //currentProductOrderModelAmountListForArchiviedOrder.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);
        //currentProductOrderModelAmountListForDraftOrder = await getclientServiceInstance().retrieveProductByOrderId(
      //  OrderModel(pk_order_id: orderItem.pk_order_id,),
        //);

      }else if (orderItem.status == OrderState.ARCHIVED){
        currentArchiviedWorkingOrdersList.add(orderItem);
        //currentProductOrderModelAmountListForArchiviedOrder = await getclientServiceInstance().retrieveProductByOrderId(
      //  OrderModel(pk_order_id: orderItem.pk_order_id,),
        //);
      }else{
        currentUnderWorkingOrdersList.add(orderItem);
        //currentProductOrderModelAmountListForUnderWorkingtOrder = await getclientServiceInstance().retrieveProductByOrderId(
      //  OrderModel(pk_order_id: orderItem.pk_order_id,),
        //);
      }
    });
    notifyListeners();
  }

  String getCurrentDate(){
      if(currentDateTime.day == DateTime.now().day && currentDateTime.month == DateTime.now().month && currentDateTime.year == DateTime.now().year){
        return 'OGGI';
      } else {
        return currentDateTime.day.toString() + '.' + currentDateTime.month.toString() + ' - ' + getNameDayFromWeekDay(currentDateTime.weekday);
      }
  }

  List<RecessedModel> getCurrentListRecessed(){
    return currentListRecessed;
  }

  void setCurrentDateTime(DateTime newDateTime){
    currentDateTime = newDateTime;
    notifyListeners();
  }

  void clearAll(){
    if(dataBundleList.isNotEmpty){
      dataBundleList.clear();
    }
    if(currentBranch != null){
      currentBranch = null;
    }
    if(currentListRecessed.isNotEmpty){
      currentListRecessed.clear();
    }
    if(currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
      currentDraftOrdersList.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();
    }

    if(currentListSuppliers.isNotEmpty){
      currentListSuppliers.clear();
    }
    setShowIvaButtonToFalse();
    indexIvaList = 0;

    notifyListeners();
  }

  void removeOneDayToDate() {
    currentDateTime = currentDateTime.subtract(const Duration(days: 1));
    notifyListeners();
  }

  void addOneDayToDate() {
    currentDateTime = currentDateTime.add(const Duration(days: 1));
    notifyListeners();
  }

  void addCurrentRecessedList(List<RecessedModel> recessedModelList) {
    currentListRecessed.clear();
    currentListRecessed = recessedModelList;

    notifyListeners();
  }

  void previousIva() {
    if(indexIvaList == 0){
      indexIvaList = 3;
    }else{
      indexIvaList --;
    }
    notifyListeners();
  }

  void nextIva() {
    if(indexIvaList == 3){
      indexIvaList = 0;
    }else{
      indexIvaList ++;
    }
    notifyListeners();
  }

  void addCurrentSuppliersList(List<ResponseAnagraficaFornitori> suppliersModelList) {

    currentListSuppliers.clear();
    currentListSuppliers.addAll(suppliersModelList);
    notifyListeners();
  }

  Future<void> setCurrentStorage(StorageModel storageModel) async {
    currentStorage = storageModel;
    List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);
    currentStorageProductListForCurrentStorage.clear();
    currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

    currentStorageProductListForCurrentStorageUnload.clear();
    currentStorageProductListForCurrentStorageUnload = [];
    currentStorageProductListForCurrentStorage.forEach((element) {
      currentStorageProductListForCurrentStorageUnload.add(StorageProductModel(
          pkStorageProductId: element.pkStorageProductId,
          fkStorageId: element.fkStorageId,
          fkProductId: element.fkProductId,
          supplierId: element.supplierId,
          productName: element.productName,
          stock: 0.0,
          available: element.available,
          supplierName: element.supplierName,
          price: element.price,
          vatApplied: element.vatApplied,
          unitMeasure: element.unitMeasure));
    });

    currentStorageProductListForCurrentStorageLoad.clear();
    currentStorageProductListForCurrentStorageLoad = [];
    currentStorageProductListForCurrentStorage.forEach((element) {
      currentStorageProductListForCurrentStorageLoad.add(StorageProductModel(
          pkStorageProductId: element.pkStorageProductId,
          fkStorageId: element.fkStorageId,
          fkProductId: element.fkProductId,
          supplierId: element.supplierId,
          productName: element.productName,
          stock: 0.0,
          available: element.available,
          supplierName: element.supplierName,
          price: element.price,
          vatApplied: element.vatApplied,
          unitMeasure: element.unitMeasure));
    });

    notifyListeners();
  }

  Future<void> refreshProductListAfterInsertProductIntoStorage() async {

    List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);

    currentStorageProductListForCurrentStorage.clear();
    currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

    currentStorageProductListForCurrentStorageUnload.clear();
    currentStorageProductListForCurrentStorageUnload = [];

    currentStorageProductListForCurrentStorage.forEach((element) {
      currentStorageProductListForCurrentStorageUnload.add(StorageProductModel(
          pkStorageProductId: element.pkStorageProductId,
          fkStorageId: element.fkStorageId,
          fkProductId: element.fkProductId,
          supplierId: element.supplierId,
          productName: element.productName,
          stock: 0.0,
          available: element.available,
          supplierName: element.supplierName,
          price: element.price,
          vatApplied: element.vatApplied,
          unitMeasure: element.unitMeasure));
    });

    currentStorageProductListForCurrentStorageLoad.clear();
    currentStorageProductListForCurrentStorageLoad = [];
    currentStorageProductListForCurrentStorage.forEach((element) {
      currentStorageProductListForCurrentStorageLoad.add(StorageProductModel(
          pkStorageProductId: element.pkStorageProductId,
          fkStorageId: element.fkStorageId,
          fkProductId: element.fkProductId,
          supplierId: element.supplierId,
          productName: element.productName,
          stock: 0.0,
          available: element.available,
          supplierName: element.supplierName,
          price: element.price,
          vatApplied: element.vatApplied,
          unitMeasure: element.unitMeasure));
    });

    notifyListeners();
  }

  Future<void> addCurrentOrdersList(List<OrderModel> orderModelList) async {
    currentOrdersForCurrentBranch.clear();
    currentOrdersForCurrentBranch.addAll(orderModelList);
    currentDraftOrdersList.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();





    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);
        //currentProductOrderModelAmountListForDraftOrder.clear();
        //currentProductOrderModelAmountListForDraftOrder = await getclientServiceInstance().retrieveProductByOrderId(
        //  OrderModel(pk_order_id: orderItem.pk_order_id,),
        //);
        //print('currentProductOrderModelAmountListForDraftOrder : ' + currentProductOrderModelAmountListForDraftOrder.length.toString());
      }else if (orderItem.status == OrderState.ARCHIVED){
        currentArchiviedWorkingOrdersList.add(orderItem);
        //currentProductOrderModelAmountListForArchiviedOrder.clear();
        //currentProductOrderModelAmountListForArchiviedOrder = await getclientServiceInstance().retrieveProductByOrderId(
      //  OrderModel(pk_order_id: orderItem.pk_order_id,),
        //);
        //print('currentProductOrderModelAmountListForArchiviedOrder : ' + currentProductOrderModelAmountListForArchiviedOrder.length.toString());
      }else{
        currentUnderWorkingOrdersList.add(orderItem);
        //currentProductOrderModelAmountListForUnderWorkingtOrder.clear();
        //currentProductOrderModelAmountListForUnderWorkingtOrder = await getclientServiceInstance().retrieveProductByOrderId(
      // OrderModel(pk_order_id: orderItem.pk_order_id,),
        //);
        //print('currentProductOrderModelAmountListForUnderWorkingtOrder : ' + currentProductOrderModelAmountListForUnderWorkingtOrder.length.toString());
      }
    });




    notifyListeners();
  }

  Future<void> addCurrentStorageList(List<StorageModel> storageModelList) async {

    currentStorageList.clear();
    currentStorageList.addAll(storageModelList);
    if(currentStorageList.isNotEmpty){
      currentStorage = currentStorageList[0];
    }

    if(currentStorageList.isNotEmpty){
      List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorageList[0].pkStorageId);
      currentStorageProductListForCurrentStorage.clear();
      currentStorageProductListForCurrentStorage.addAll(storageProductModelList);
      currentStorageProductListForCurrentStorageUnload.clear();
      currentStorageProductListForCurrentStorageUnload = [];
      currentStorageProductListForCurrentStorage.forEach((element) {
        currentStorageProductListForCurrentStorageUnload.add(StorageProductModel(
            pkStorageProductId: element.pkStorageProductId,
            fkStorageId: element.fkStorageId,
            fkProductId: element.fkProductId,
            supplierId: element.supplierId,
            productName: element.productName,
            stock: 0.0,
            available: element.available,
            supplierName: element.supplierName,
            price: element.price,
            vatApplied: element.vatApplied,
            unitMeasure: element.unitMeasure));
      });

      currentStorageProductListForCurrentStorageLoad.clear();
      currentStorageProductListForCurrentStorageLoad = [];
      currentStorageProductListForCurrentStorage.forEach((element) {
        currentStorageProductListForCurrentStorageLoad.add(StorageProductModel(
            pkStorageProductId: element.pkStorageProductId,
            fkStorageId: element.fkStorageId,
            fkProductId: element.fkProductId,
            supplierId: element.supplierId,
            productName: element.productName,
            stock: 0.0,
            available: element.available,
            supplierName: element.supplierName,
            price: element.price,
            vatApplied: element.vatApplied,
            unitMeasure: element.unitMeasure));
      });
    }
    notifyListeners();
  }

  List<String> retrieveListStoragesName(){
    List<String> listNames = [];

    currentStorageList.forEach((element) {
      listNames.add(element.name);
    });

    return listNames;
  }

  String retrieveSupplierById(int supplierId) {
    currentListSuppliers.forEach((element) {
      if(element.pkSupplierId == supplierId){
        return element.nome;
      }
    });
    return "";
  }

  void clearUnloadProductList() {
    currentStorageProductListForCurrentStorageUnload.forEach((element) {
      element.stock = 0.0;
    });
    notifyListeners();
  }

  void clearLoadProductList() {
    currentStorageProductListForCurrentStorageLoad.forEach((element) {
      element.stock = 0.0;
    });
    notifyListeners();
  }
}