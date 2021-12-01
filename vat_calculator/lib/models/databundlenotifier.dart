import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/email_sender/emailservice.dart';
import 'package:vat_calculator/client/fattureICloud/client_icloud.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_acquisti_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fatture_api.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_ndc_api.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/action_model.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/components/vat_data.dart';
import '../constants.dart';
import '../size_config.dart';
import 'bundle_users_storage_supplier_forbranch.dart';
import 'databundle.dart';

class DataBundleNotifier extends ChangeNotifier {

  List<DataBundle> dataBundleList = [
  ];

  List<RecessedModel> currentListRecessed = [
  ];

  List<ResponseAnagraficaFornitori> currentListSuppliers = [
  ];

  List<ResponseAnagraficaFornitori> currentListSuppliersDuplicated = [
  ];

  List<StorageModel> currentStorageList = [
  ];
  Map<int, BundleUserStorageSupplier> currentMapBranchIdBundleSupplierStorageUsers = {

  };

  List<ProductModel> currentProductModelListForSupplier = [
  ];

  List<ProductModel> currentProductModelListForSupplierDuplicated = [
  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorage = [
  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorageDuplicated = [];

  List<StorageProductModel> currentStorageProductListForCurrentStorageUnload = [
  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorageLoad = [
  ];

  List<ProductModel> productToAddToStorage = [
  ];

  List<OrderModel> currentOrdersForCurrentBranch = [];

  List<OrderModel> currentTodayOrdersForCurrentBranch = [];

  List<OrderModel> currentUnderWorkingOrdersList = [];

  List<OrderModel> currentDraftOrdersList = [];

  List<OrderModel> currentArchiviedWorkingOrdersList = [];

  List<ActionModel> currentBranchActionsList = [

  ];

  List<VatData> charDataCreditIva = [];
  List<VatData> charDataDebitIva = [];

  String currentPrivilegeType;

  ClientVatService clientService = ClientVatService();
  FattureInCloudClient iCloudClient = FattureInCloudClient();
  EmailSenderService emailService = EmailSenderService();

  bool isSpecialUser = false;

  BranchModel currentBranch;
  StorageModel currentStorage;

  DateTime currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0);
  DateTimeRange currentDateTimeRange;

  bool cupertinoSwitch = false;
  bool editProfile = false;
  bool searchStorageButton = false;
  bool isZtoAOrderded = false;
  bool editOrder = false;

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

  EmailSenderService getEmailServiceInstance(){
    if(emailService == null){
      return EmailSenderService();
    }else{
      return emailService;
    }
  }

  void enableSpecialUser(){
    isSpecialUser = true;
    notifyListeners();
  }

  void addAllCurrentProductSupplierList(List<ProductModel> listProduct){
    currentProductModelListForSupplier.clear();
    currentProductModelListForSupplier.addAll(listProduct);
    currentProductModelListForSupplierDuplicated.clear();
    currentProductModelListForSupplierDuplicated.addAll(listProduct);
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  void addAllCurrentListProductToProductListToAddToStorage(List<ProductModel> listProduct){
    productToAddToStorage.clear();
    productToAddToStorage.addAll(listProduct);
    clearAndUpdateMapBundle();
    notifyListeners();
  }


  void initializeCurrentDateTimeRangeWeekly() {

    currentDateTimeRange = DateTimeRange(
      start: currentDateTime
          .subtract(Duration(days: currentDateTime.weekday - 1)),
      end: currentDateTime.add(Duration(
          days: DateTime.daysPerWeek - currentDateTime.weekday)),
    );

    currentDateTimeRange = DateTimeRange(
      start: currentDateTimeRange.start
          .subtract(const Duration(days: 100)),
      end: currentDateTimeRange.end.subtract(const Duration(
          days: 100)),
    );

    if(currentBranch.providerFatture == 'fatture_in_cloud'){
      retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
    }else{
      // retrieveDataToDrawChartAruba(currentDateTimeRange);
    }


    clearAndUpdateMapBundle();
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
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  Future<void> addBranches(List<BranchModel> branchList) async {
    dataBundleList[0].companyList.clear();
    dataBundleList[0].companyList = branchList;

    if(dataBundleList[0].companyList.isNotEmpty){
      currentBranch = dataBundleList[0].companyList[0];
      initializeCurrentDateTimeRangeWeekly();
      setCurrentPrivilegeType(currentBranch.accessPrivilege);
      List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);
      currentOrdersForCurrentBranch.clear();
      currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);

      currentTodayOrdersForCurrentBranch.clear();

      currentDraftOrdersList.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();

      currentOrdersForCurrentBranch.forEach((orderItem) async {

        if(orderItem.status == OrderState.DRAFT){
          currentDraftOrdersList.add(orderItem);
        }else if (orderItem.status == OrderState.ARCHIVED
            || orderItem.status == OrderState.NOT_RECEIVED_ARCHIVED
            || orderItem.status == OrderState.RECEIVED_ARCHIVED
            || orderItem.status == OrderState.REFUSED_ARCHIVED){
          currentArchiviedWorkingOrdersList.add(orderItem);
        }else{
          currentUnderWorkingOrdersList.add(orderItem);
          if(
          DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).day == DateTime.now().day &&
          DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).month == DateTime.now().month &&
          DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).year == DateTime.now().year){

            currentTodayOrdersForCurrentBranch.add(orderItem);

          }
        }
      });

    }

    currentBranchActionsList.clear();
    currentBranchActionsList = await getclientServiceInstance().retrieveLastWeekActionsByBranchId(currentBranch.pkBranchId);


    clearAndUpdateMapBundle();
    notifyListeners();
  }

  Future<void> setCurrentBranch(BranchModel branchModel) async {

    currentBranch = branchModel;
    initializeCurrentDateTimeRangeWeekly();
    setCurrentPrivilegeType(currentBranch.accessPrivilege);

    List<RecessedModel> _recessedModelList = await clientService.retrieveRecessedListByBranch(currentBranch);
    currentListRecessed.clear();
    currentListRecessed.addAll(_recessedModelList);

    List<ResponseAnagraficaFornitori> _supplierModelList = await clientService.retrieveSuppliersListByBranch(currentBranch);
    currentListSuppliers.clear();
    currentListSuppliersDuplicated.clear();

    currentListSuppliers.addAll(_supplierModelList);
    currentListSuppliersDuplicated.addAll(_supplierModelList);

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

      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);

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
    currentTodayOrdersForCurrentBranch.clear();

    currentDraftOrdersList.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);

      }else if (orderItem.status == OrderState.ARCHIVED
          || orderItem.status == OrderState.NOT_RECEIVED_ARCHIVED
          || orderItem.status == OrderState.RECEIVED_ARCHIVED
          || orderItem.status == OrderState.REFUSED_ARCHIVED){

        currentArchiviedWorkingOrdersList.add(orderItem);
      }else {
        currentUnderWorkingOrdersList.add(orderItem);
        if(
        DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).day == DateTime.now().day &&
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).month == DateTime.now().month &&
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).year == DateTime.now().year){

          currentTodayOrdersForCurrentBranch.add(orderItem);

        }
      }
    });

    currentBranchActionsList.clear();
    currentBranchActionsList = await getclientServiceInstance().retrieveLastWeekActionsByBranchId(currentBranch.pkBranchId);

    clearAndUpdateMapBundle();
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
      currentPrivilegeType = null;
    }
    if(currentListRecessed.isNotEmpty){
      currentListRecessed.clear();
    }
    if(currentOrdersForCurrentBranch != null && currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
      currentDraftOrdersList.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();
      currentTodayOrdersForCurrentBranch.clear();
    }

    if(currentListSuppliers != null && currentListSuppliers.isNotEmpty){
      currentListSuppliers.clear();
    }
    if(currentListSuppliersDuplicated != null && currentListSuppliersDuplicated.isNotEmpty){
      currentListSuppliers.clear();
    }

    if(currentStorageList != null && currentStorageList.isNotEmpty){
      currentStorageList.clear();
    }

    if(currentBranchActionsList != null && currentBranchActionsList.isNotEmpty){
      currentBranchActionsList.clear();
    }
    if(currentArchiviedWorkingOrdersList != null && currentArchiviedWorkingOrdersList.isNotEmpty){
      currentArchiviedWorkingOrdersList.clear();
    }

    if(currentDraftOrdersList != null && currentDraftOrdersList.isNotEmpty){
      currentDraftOrdersList.clear();
    }
    if(currentOrdersForCurrentBranch != null && currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
    }
    if(currentTodayOrdersForCurrentBranch != null && currentTodayOrdersForCurrentBranch.isNotEmpty){
      currentTodayOrdersForCurrentBranch.clear();
    }
    if(currentBranchActionsList != null && currentBranchActionsList.isNotEmpty){
      currentBranchActionsList.clear();
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
    currentListSuppliersDuplicated.clear();
    currentListSuppliers.addAll(suppliersModelList);
    currentListSuppliersDuplicated.addAll(suppliersModelList);
    notifyListeners();
  }

  Future<void> setCurrentStorage(StorageModel storageModel) async {
    currentStorage = storageModel;
    List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);
    currentStorageProductListForCurrentStorage.clear();
    currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

    currentStorageProductListForCurrentStorageDuplicated.clear();
    currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);

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

    currentStorageProductListForCurrentStorageDuplicated.clear();
    currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);

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
    currentTodayOrdersForCurrentBranch.clear();
    currentOrdersForCurrentBranch.addAll(orderModelList);
    currentDraftOrdersList.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);
      }else if (orderItem.status == OrderState.ARCHIVED
              || orderItem.status == OrderState.REFUSED_ARCHIVED
              || orderItem.status == OrderState.RECEIVED_ARCHIVED
              || orderItem.status == OrderState.NOT_RECEIVED_ARCHIVED){
        currentArchiviedWorkingOrdersList.add(orderItem);
      }else{
        currentUnderWorkingOrdersList.add(orderItem);
        if(
        DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).day == DateTime.now().day &&
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).month == DateTime.now().month &&
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).year == DateTime.now().year){

          currentTodayOrdersForCurrentBranch.add(orderItem);

        }
      }
    });
    notifyListeners();
  }

  String getSupplierName(int fk_supplier_id) {

    print('Retrieve supplier name for id ' + fk_supplier_id.toString());
    String currentSupplierName = 'Fornitore Sconosciuto';

    currentListSuppliers.forEach((currentSupplier) {

      if(currentSupplier.pkSupplierId == fk_supplier_id){
        currentSupplierName = currentSupplier.nome;
      }
    });
    print('Name retrieved: ' + currentSupplierName);
    return currentSupplierName;
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

      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);

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
    clearAndUpdateMapBundle();
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

  void addProviderFattureDetailsToCurrentBranch({String providerFatture, String apiKeyOrUser, String apiUidOrPassword}) {
    currentBranch.providerFatture = providerFatture;
    currentBranch.apiKeyOrUser = apiKeyOrUser;
    currentBranch.apiUidOrPassword = apiUidOrPassword;
    notifyListeners();

  }

  void filterCurrentListSupplierByName(String currentText) {
    if(currentText == ''){
      currentListSuppliersDuplicated.clear();
      currentListSuppliersDuplicated.addAll(currentListSuppliers);
    }else {

      List<ResponseAnagraficaFornitori> listTemp = [];
      currentListSuppliers.forEach((element) {
        if(element.nome.toLowerCase().contains(currentText.toLowerCase())
            || element.extra.toLowerCase().contains(currentText.toLowerCase())){
          listTemp.add(
              element
          );
        }
      });
      currentListSuppliersDuplicated.clear();
      currentListSuppliersDuplicated.addAll(listTemp);
    }
    notifyListeners();
  }

  void filterCurrentListProductByName(String currentText) {

    if(currentText == ''){
      currentProductModelListForSupplierDuplicated.clear();
      currentProductModelListForSupplierDuplicated.addAll(currentProductModelListForSupplier);
    }else{


      List<ProductModel> listTemp = [];
      currentProductModelListForSupplier.forEach((element) {
        print(currentText + ' on ' + element.nome);


        if(element.nome.toLowerCase().contains(currentText.toLowerCase())){
          listTemp.add(element);
        }
      });
      currentProductModelListForSupplierDuplicated.clear();
      currentProductModelListForSupplierDuplicated.addAll(listTemp);
    }
    notifyListeners();
  }

  void changeEditProfileBoolValue() {
    if(editProfile){
      editProfile = false;
    }else{
      editProfile = true;
    }
    notifyListeners();
  }

  void filterStorageProductList(String currentText) {

    if(currentText == '' || currentText == 'Tutti i fornitori'){
      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(currentStorageProductListForCurrentStorage);
    }else{


      List<StorageProductModel> listTemp = [];
      currentStorageProductListForCurrentStorage.forEach((element) {

        if(element.productName.toLowerCase().contains(currentText.toLowerCase()) ||
            element.supplierName.toLowerCase().contains(currentText.toLowerCase())){
          listTemp.add(element);
        }
      });
      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(listTemp);
    }
    notifyListeners();
  }

  refreshSearchButtonStoreConfiguration(){
    searchStorageButton = false;
    isZtoAOrderded = false;
    notifyListeners();
  }
  void switchSearchProductStorageButton() {
    if(searchStorageButton){
      searchStorageButton = false;
    }else{
      searchStorageButton = true;
    }
    notifyListeners();
  }

  void sortCurrentStorageListDuplicatedFromAToZ() {

    if(isZtoAOrderded){
      currentStorageProductListForCurrentStorageDuplicated.sort((a, b) => a.productName.toLowerCase().compareTo(b.productName.toLowerCase()));
      isZtoAOrderded = false;
    }else{
      currentStorageProductListForCurrentStorageDuplicated.sort((a, b) => b.productName.toLowerCase().compareTo(a.productName.toLowerCase()));
      isZtoAOrderded = true;
    }


    notifyListeners();
  }

  void clearAndUpdateMapBundle() {
    currentMapBranchIdBundleSupplierStorageUsers.clear();
    dataBundleList[0].companyList.forEach((currentBranch) async {

      List<StorageModel> listStorages = await getclientServiceInstance().retrieveStorageListByBranch(BranchModel(
          pkBranchId: currentBranch.pkBranchId
      ));

      List<ResponseAnagraficaFornitori> listSuppliers = await getclientServiceInstance().retrieveSuppliersListByBranch(BranchModel(
          pkBranchId: currentBranch.pkBranchId
      ));

      List<UserModel> listUsers = await getclientServiceInstance().retrieveUserListRelatedWithBranchByBranchId(BranchModel(
          pkBranchId: currentBranch.pkBranchId
      ));
      currentMapBranchIdBundleSupplierStorageUsers[currentBranch.pkBranchId] = BundleUserStorageSupplier(currentBranch.pkBranchId, listStorages, listUsers, listSuppliers);
    });
    notifyListeners();
  }

  void switchEditOrder() {
    if(editOrder){
      editOrder = false;
    }else{
      editOrder = true;
    }
    notifyListeners();
  }

  void setEditOrderToFalse(){
    editOrder = false;

    notifyListeners();
  }

  void removeObjectFromStorageProductList(StorageProductModel element) {
    currentStorageProductListForCurrentStorageDuplicated.remove(element);
    notifyListeners();
  }

  StorageModel getStorageFromCurrentStorageListByStorageId(int storageId) {
    StorageModel storageResult;
    currentStorageList.forEach((storage) {
      if(storage.pkStorageId == storageId){
        storageResult = storage;
      }
    });
    return storageResult;
  }

  void updateOrderStatusById(int pk_order_id, String received_archived, int millisecondsSinceEpoch, String closedByUser) {

    List<OrderModel> orderModelToRemove = [];

    currentUnderWorkingOrdersList.forEach((currentUnderWorkingOrderItem) {
      if(currentUnderWorkingOrderItem.pk_order_id == pk_order_id){
        orderModelToRemove.add(currentUnderWorkingOrderItem);
        currentUnderWorkingOrderItem.delivery_date = millisecondsSinceEpoch;
        currentUnderWorkingOrderItem.status = received_archived;
        currentUnderWorkingOrderItem.closedby = closedByUser;
        currentArchiviedWorkingOrdersList.add(
            currentUnderWorkingOrderItem
        );
      }
    });
    currentUnderWorkingOrdersList.removeWhere((element) => element.pk_order_id == pk_order_id);
    notifyListeners();
  }

  void removeProviderFromCurrentBranch() {
    currentBranch.providerFatture = '';
    currentBranch.apiUidOrPassword = '';
    currentBranch.apiKeyOrUser = '';
    notifyListeners();

  }

  String retrieveNameLastNameCurrentUser() {
    if(dataBundleList.isNotEmpty){
      return dataBundleList[0].firstName + ' ' + dataBundleList[0].lastName;
    }else{
      return 'Error retrieving user name';
    }
  }

  void removeProductFromStorage(StorageProductModel productStorageElementToRemove) {
    currentStorageProductListForCurrentStorage.remove(productStorageElementToRemove);
    currentStorageProductListForCurrentStorageDuplicated.remove(productStorageElementToRemove);
    currentStorageProductListForCurrentStorageUnload.remove(productStorageElementToRemove);
    currentStorageProductListForCurrentStorageLoad.remove(productStorageElementToRemove);
    notifyListeners();
  }

  retrieveDataToDrawChartFattureInCloud(DateTimeRange currentDateTimeRange) async {

    List<ResponseAcquistiApi> retrieveListaAcquisti =
    await iCloudClient.retrieveListaAcquisti(
        currentBranch.apiUidOrPassword,
        currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);

    List<ResponseFattureApi> retrieveListaFatture =
    await iCloudClient.retrieveListaFatture(
        currentBranch.apiUidOrPassword,
        currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);

    List<ResponseNDCApi> retrieveListaNDC = await iCloudClient.retrieveListaNdc(
        currentBranch.apiUidOrPassword,
        currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);

    double totalIvaAcquisti = 0.0;
    double totalIvaFatture = 0.0;
    double totalIvaNdcReceived = 0.0;
    double totalIvaNdcSent = 0.0;

    Map<String, double> resultCreditIvaMap =
    initializeMap(currentDateTimeRange);
    Map<String, double> resultDebitIvaMap = initializeMap(currentDateTimeRange);

    List<ResponseAcquistiApi> extractedAcquistiFatture = [];
    List<ResponseAcquistiApi> extractedNdc = [];

    retrieveListaAcquisti.forEach((acquisto) {
      if (acquisto.tipo == 'spesa') {
        if (resultCreditIvaMap.containsKey(acquisto.data)) {
          resultCreditIvaMap[acquisto.data] =
              resultCreditIvaMap[acquisto.data] +
                  double.parse(acquisto.importo_iva);
        } else {
          resultCreditIvaMap[acquisto.data] =
              double.parse(acquisto.importo_iva);
        }

        extractedAcquistiFatture.add(acquisto);
        totalIvaAcquisti =
            totalIvaAcquisti + double.parse(acquisto.importo_iva);
      } else if (acquisto.tipo == 'ndc') {
        extractedNdc.add(acquisto);
        totalIvaNdcReceived =
            totalIvaNdcReceived + double.parse(acquisto.importo_iva);

        if (resultDebitIvaMap.containsKey(acquisto.data)) {
          resultDebitIvaMap[acquisto.data] = resultDebitIvaMap[acquisto.data] +
              double.parse(acquisto.importo_iva);
        } else {
          resultDebitIvaMap[acquisto.data] = double.parse(acquisto.importo_iva);
        }
      }
    });

    retrieveListaFatture.forEach((fattura) {
      totalIvaFatture = totalIvaFatture +
          (double.parse(fattura.importo_totale) -
              double.parse(fattura.importo_netto));
      if (resultDebitIvaMap.containsKey(fattura.data)) {
        resultDebitIvaMap[fattura.data] = resultDebitIvaMap[fattura.data] +
            (double.parse(fattura.importo_totale) -
                double.parse(fattura.importo_netto));
      } else {
        resultDebitIvaMap[fattura.data] =
        (double.parse(fattura.importo_totale) -
            double.parse(fattura.importo_netto));
      }
    });

    retrieveListaNDC.forEach((ndc) {
      totalIvaNdcSent = totalIvaNdcSent +
          (double.parse(ndc.importo_totale) - double.parse(ndc.importo_netto));

      if (resultCreditIvaMap.containsKey(ndc.data)) {
        resultCreditIvaMap[ndc.data] = resultCreditIvaMap[ndc.data] +
            (double.parse(ndc.importo_totale) -
                double.parse(ndc.importo_netto));
      } else {
        resultCreditIvaMap[ndc.data] = (double.parse(ndc.importo_totale) -
            double.parse(ndc.importo_netto));
      }
    });

    print(resultCreditIvaMap.toString());
    print(resultDebitIvaMap.toString());


    charDataCreditIva = [
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 6)), retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 5)),
          retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 4)),
          retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 3)),
          retrieveValueFromMapByDate(3, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 2)),
          retrieveValueFromMapByDate(2, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(3, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 1)),
          retrieveValueFromMapByDate(1, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(2, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(3, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 0)),
          retrieveValueFromMapByDate(0, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(1, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(2, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(3, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
    ];

    charDataDebitIva = [
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 6)), retrieveValueFromMapByDate(6, resultDebitIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 5)),
          retrieveValueFromMapByDate(5, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultDebitIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 4)),
          retrieveValueFromMapByDate(4, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 3)),
          retrieveValueFromMapByDate(3, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 2)),
          retrieveValueFromMapByDate(2, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(3, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 1)),
          retrieveValueFromMapByDate(1, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(2, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(3, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
      VatData(
          currentDateTimeRange.end.subtract(const Duration(days: 0)),
          retrieveValueFromMapByDate(0, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(1, resultDebitIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(2, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(3, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(4, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(5, resultCreditIvaMap, currentDateTimeRange) + retrieveValueFromMapByDate(6, resultCreditIvaMap, currentDateTimeRange)),
    ];

    charDataCreditIva.forEach((element) {
      print(element.date.toString() + ' - ' + element.vatValue.toString());
    });

    charDataDebitIva.forEach((element) {
      print(element.date.toString() + ' - ' + element.vatValue.toString());
    });
    print('finish');

    notifyListeners();
  }

  Map<String, double> initializeMap(DateTimeRange currentDateTimeRange) {
    Map<String, double> mapToReturn = {};

    mapToReturn[buildKeyFromTimeRange(6)] = 0;
    mapToReturn[buildKeyFromTimeRange(5)] = 0;
    mapToReturn[buildKeyFromTimeRange(4)] = 0;
    mapToReturn[buildKeyFromTimeRange(3)] = 0;
    mapToReturn[buildKeyFromTimeRange(2)] = 0;
    mapToReturn[buildKeyFromTimeRange(1)] = 0;
    mapToReturn[buildKeyFromTimeRange(0)] = 0;

    return mapToReturn;
  }

  double retrieveValueFromMapByDate(int dayToSubtract, Map<String, double> resultCreditIvaMap, DateTimeRange timeRange){

    return resultCreditIvaMap[

      normalizeDayValue(timeRange.end.subtract(Duration(days: dayToSubtract)).day)
        + '/' + normalizeMonth(timeRange.end.subtract(Duration(days: dayToSubtract)).month) +
        '/' + timeRange.end.subtract(Duration(days: dayToSubtract))
        .year
        .toString()];
  }

  String normalizeDayValue(int day) {
    if(day < 10){
      return '0' + day.toString();
    }else{
      return day.toString();
    }
  }

  String normalizeMonth(int month) {
    if(month < 10){
      return '0' + month.toString();
    }else{
      return month.toString();
    }
  }

  String buildKeyFromTimeRange(int i) {
    return normalizeDayValue(currentDateTimeRange.end.subtract(Duration(days: i)).day) + '/' + normalizeMonth(currentDateTimeRange.end.subtract(Duration(days: i)).month) + '/' + currentDateTimeRange.end.subtract(Duration(days: i)).year.toString();
  }
}