import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/email_sender/emailservice.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
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

  List<OrderModel> currentUnderWorkingOrdersList = [];

  List<OrderModel> currentDraftOrdersList = [];

  List<OrderModel> currentArchiviedWorkingOrdersList = [];

  String currentPrivilegeType;

  ClientVatService clientService = ClientVatService();
  EmailSenderService emailService = EmailSenderService();

  bool isSpecialUser = false;

  BranchModel currentBranch;
  StorageModel currentStorage;

  DateTime currentDateTime = DateTime.now();
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
      setCurrentPrivilegeType(currentBranch.accessPrivilege);
      List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);
      currentOrdersForCurrentBranch.clear();
      currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);

      currentDraftOrdersList.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();

      currentOrdersForCurrentBranch.forEach((orderItem) async {
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        print('Order status POPOPOPO: ' + orderItem.status);
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        if(orderItem.status == OrderState.DRAFT){
          currentDraftOrdersList.add(orderItem);
        }else if (orderItem.status == OrderState.ARCHIVED
            || orderItem.status == OrderState.NOT_RECEIVED_ARCHIVED
            || orderItem.status == OrderState.RECEIVED_ARCHIVED
            || orderItem.status == OrderState.REFUSED_ARCHIVED){
          currentArchiviedWorkingOrdersList.add(orderItem);
        }else{
          currentUnderWorkingOrdersList.add(orderItem);
        }
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        print('currentUnderWorkingOrdersList: ' + currentUnderWorkingOrdersList.length.toString());
        print('currentArchiviedWorkingOrdersList: ' + currentArchiviedWorkingOrdersList.length.toString());
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
        print('@@@@@@@@@@@@@@@@@@@@@@@@@');
      });

    }

    clearAndUpdateMapBundle();
    notifyListeners();
  }

  Future<void> setCurrentBranch(BranchModel branchModel) async {

    currentBranch = branchModel;
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

    currentDraftOrdersList.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      print('@@@@@@@@@@@@@@@@@@@@@@@@@');
      print('@@@@@@@@@@@@@@@@@@@@@@@@@');
      print('Order status : ' + orderItem.status);
      print('@@@@@@@@@@@@@@@@@@@@@@@@@');
      print('@@@@@@@@@@@@@@@@@@@@@@@@@');
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);

      }else if (orderItem.status == OrderState.ARCHIVED
          || orderItem.status == OrderState.NOT_RECEIVED_ARCHIVED
          || orderItem.status == OrderState.RECEIVED_ARCHIVED
          || orderItem.status == OrderState.REFUSED_ARCHIVED){

        currentArchiviedWorkingOrdersList.add(orderItem);
      }else {
        currentUnderWorkingOrdersList.add(orderItem);
      }
    });
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
    if(currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
      currentDraftOrdersList.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();
    }

    if(currentListSuppliers.isNotEmpty){
      currentListSuppliers.clear();
    }
    if(currentListSuppliersDuplicated.isNotEmpty){
      currentListSuppliers.clear();
    }

    if(currentStorageList.isNotEmpty){
      currentStorageList.clear();
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
      }
    });




    notifyListeners();
  }

  String getSupplierName(int fk_supplier_id) {
    String currentSupplierName;
    currentListSuppliers.forEach((currentSupplier) {
      if(currentSupplier.pkSupplierId == fk_supplier_id){
        currentSupplierName = currentSupplier.nome;
      }
    });
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
}