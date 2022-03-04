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
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/expence_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/client/vatservice/model/utils/order_state.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_product_model.dart';
import 'package:vat_calculator/components/vat_data.dart';
import '../constants.dart';
import 'bundle_users_storage_supplier_forbranch.dart';
import 'databundle.dart';

class DataBundleNotifier extends ChangeNotifier {

  List<UserDetailsModel> userDetailsList = [
  ];

  List<RecessedModel> currentListRecessed = [
  ];

  List<ExpenceModel> currentListExpences = [
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

  List<StorageProductModel> currentStorageProductListForCurrentStorageLoad = [];

  List<ProductModel> productToAddToStorage = [];
  List<ProductModel> productToAddToStorageDuplicated = [];

  List<OrderModel> currentOrdersForCurrentBranch = [];

  List<OrderModel> currentTodayOrdersForCurrentBranch = [];

  List<OrderModel> currentUnderWorkingOrdersList = [];

  List<OrderModel> currentDraftOrdersList = [];

  List<OrderModel> currentArchiviedWorkingOrdersList = [];

  List<ActionModel> currentBranchActionsList = [

  ];

  List<ProductModel> productListForChoicedSupplierToPerformOrder = [];
  List<CharData> charDataCreditIva = [];
  List<CharData> charDataDebitIva = [];
  List<CharData> recessedListCharData = [];

  List<EventModel> eventModelList = [];

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
  bool isZtoAOrderded = false;
  bool editOrder = true;

  int daysRangeDate = DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month);
  int currentYear = DateTime.now().year;
  DateTime currentDate = DateTime.now();
  DateTimeRange currentWeek;

  double totalIvaAcquisti = 0.0;
  double totalIvaFatture = 0.0;
  double totalIvaNdcReceived = 0.0;
  double totalIvaNdcSent = 0.0;
  List<ResponseAcquistiApi> extractedAcquistiFatture = [];
  List<ResponseAcquistiApi> extractedNdc = [];
  Map<String, double> resultCreditIvaMap = {};
  Map<String, double> resultDebitIvaMap = {};
  List<ResponseAcquistiApi> retrieveListaAcquisti = [];
  List<ResponseFattureApi> retrieveListaFatture = [];
  List<ResponseNDCApi> retrieveListaNDC = [];

  List<ProductModel> storageTempListProduct = [];
  List<ProductOrderAmountModel> currentProdOrderModelList = [];

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  double totalNotFiscalExpences = 0.0;
  double totalFiscalExpences = 0.0;

  void setCurrentPrivilegeType(String privilege){
    currentPrivilegeType = privilege;
    notifyListeners();
  }

  void setProductListForChoicedSupplierToPerformOrder(List<ProductModel> list){
    productListForChoicedSupplierToPerformOrder.clear();
    productListForChoicedSupplierToPerformOrder = list;
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

    productToAddToStorageDuplicated.clear();
    productToAddToStorageDuplicated.addAll(listProduct);

    clearAndUpdateMapBundle();
    notifyListeners();
  }

  void recalculateGraph() {

    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
    }
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  void initializeCurrentDateTimeRangeWeekly() {
    DateTime date = DateTime.now();
    currentDateTimeRange = DateTimeRange(
      start: DateTime(date.year, date.month, 1, 0, 0, 0, 0,0),
      end: DateTime(date.year, date.month, DateTime(date.year, date.month + 1, 0).day, 0, 0, 0, 0,0),
    );

    currentWeek = DateTimeRange(start: findFirstDateOfTheWeek(date), end: findLastDateOfTheWeek(date));
    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
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

  void addWeekToDateTimeRangeWeekly(){
    currentWeek = DateTimeRange(
      start: currentWeek.start
          .add(const Duration(days: 7)),
      end: currentWeek.end.add(const Duration(
          days: 7)),
    );

    totalFiscalExpences = 0.0;
    totalNotFiscalExpences = 0.0;

    currentListExpences.forEach((expence) {
      if(currentWeek.start.isBefore(DateTime.fromMillisecondsSinceEpoch(expence.dateTimeExpence).add(const Duration(days: 1))) &&
          currentWeek.end.isAfter(DateTime.fromMillisecondsSinceEpoch(expence.dateTimeExpence).subtract(const Duration(days: 1)))) {

        if(expence.fiscal == 'Y'){
          totalFiscalExpences = totalFiscalExpences + expence.amount;
        }else if(expence.fiscal == 'N'){
          totalNotFiscalExpences = totalNotFiscalExpences + expence.amount;
        }
      }
    });
    notifyListeners();
  }

  void subtractWeekToDateTimeRangeWeekly(){
    currentWeek = DateTimeRange(
      start: currentWeek.start
          .subtract(const Duration(days: 7)),
      end: currentWeek.end.subtract(const Duration(
          days: 7)),
    );


    calculateFiscalNotFiscalAmount();

    notifyListeners();
  }


  bool showIvaButtonPressed = false;
  int indexIvaList = 0;
  List<int> ivaList = [22, 10, 4, 0];

  int trimCounter;
  Map<int, Widget> ivaListCupertino = {
    0 : const Text('22'),
    1 : const Text('10'),
    2 : const Text('4'),
    3 : const Text('0'),
  };

  int trimCounterPeriod;
  Map<int, Widget> ivaListPeriodCupertino = {
    0 : const Text('Gen-Mar'),
    1 : const Text('Apr-Giu'),
    2 : const Text('Lug-Set'),
    3 : const Text('Ott-Dic'),
  };

  int ivaListTrimMonthChoiceCupertinoIndex = 0;
  Map<int, Widget> ivaListTrimMonthChoiceCupertino = {
    0 : const Text('Mensile'),
    1 : const Text('Trimestrale'),
  };


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

  List<ExpenceModel> getExpenceListByRangeDate(DateTime start, DateTime end){
    List<ExpenceModel> listToReturn = [];
    if(currentListExpences.isEmpty){
      return listToReturn;
    }else{
      currentListExpences.forEach((expenceElement) {
        if(DateTime.fromMillisecondsSinceEpoch(expenceElement.dateTimeExpence).isBefore(end) && DateTime.fromMillisecondsSinceEpoch(expenceElement.dateTimeExpence).isAfter(start)){
          listToReturn.add(expenceElement);
        }
      });
      return listToReturn;
    }
  }

  List<int> getIvaList(){
    return ivaList;
  }

  void addDataBundle(UserDetailsModel bundle){
    print('Adding bundle to Notifier' + bundle.email.toString());
    userDetailsList.add(bundle);
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  Future<void> addBranches(List<BranchModel> branchList) async {
    userDetailsList[0].companyList.clear();
    userDetailsList[0].companyList = branchList;

    if(userDetailsList[0].companyList.isNotEmpty){
      currentBranch = userDetailsList[0].companyList[0];
      initializeCurrentDateTimeRangeWeekly();
      setCurrentPrivilegeType(currentBranch.accessPrivilege);
      List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);
      currentOrdersForCurrentBranch.clear();
      currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);

      currentTodayOrdersForCurrentBranch.clear();

      currentDraftOrdersList.clear();
      orderIdProductListMap.clear();
      currentArchiviedWorkingOrdersList.clear();
      currentUnderWorkingOrdersList.clear();

      currentOrdersForCurrentBranch.forEach((orderItem) async {

        if(orderItem.status == OrderState.DRAFT){
          currentDraftOrdersList.add(orderItem);
          currentDraftOrdersList.forEach((element) async {
            List<ProductOrderAmountModel> list = await getclientServiceInstance()
                .retrieveProductByOrderId(
              OrderModel(
                pk_order_id: element.pk_order_id,
              ),
            );
            orderIdProductListMap[element.pk_order_id] = list;
          });
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
    if(currentBranch != null){
      currentBranchActionsList = await getclientServiceInstance().retrieveLastWeekActionsByBranchId(currentBranch.pkBranchId);
    }

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

    List<ExpenceModel> _expenceModelList = await clientService.retrieveExpencesListByBranch(currentBranch);
    currentListExpences.clear();
    currentListExpences.addAll(_expenceModelList);


    List<EventModel> _eventModelList = await clientService.retrieveEventsListByBranchId(currentBranch);

    addCurrentEventsList(_eventModelList);


    totalFiscalExpences = 0.0;
    totalNotFiscalExpences = 0.0;

    calculateFiscalNotFiscalAmount();

    recessedListCharData.clear();
    _recessedModelList.forEach((recessedElement) {
      recessedListCharData.add(CharData(
        DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed),
        recessedElement.amount
      ));
    });


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
    orderIdProductListMap.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);
        currentDraftOrdersList.forEach((element) async {
          List<ProductOrderAmountModel> list = await getclientServiceInstance()
              .retrieveProductByOrderId(
            OrderModel(
              pk_order_id: element.pk_order_id,
            ),
          );
          orderIdProductListMap[element.pk_order_id] = list;
        });

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

    retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
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

  List<ExpenceModel> getCurrentListExpences(){
    return currentListExpences;
  }

  void setCurrentDateTime(DateTime newDateTime){
    currentDateTime = newDateTime;
    notifyListeners();
  }

  void clearAll(){
    if(userDetailsList.isNotEmpty){
      userDetailsList.clear();
    }
    if(currentBranch != null){
      currentBranch = null;
      currentPrivilegeType = null;
    }
    if(currentListRecessed.isNotEmpty){
      currentListRecessed.clear();
    }

    if(currentListExpences.isNotEmpty){
      currentListExpences.clear();
    }
    if(recessedListCharData.isNotEmpty){
      recessedListCharData.clear();
    }
    if(currentOrdersForCurrentBranch != null && currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
      currentDraftOrdersList.clear();
      orderIdProductListMap.clear();
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
      orderIdProductListMap.clear();
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

  void addCurrentExpencesList(List<ExpenceModel> expenceList) {
    currentListExpences.clear();
    currentListExpences = expenceList;

    totalFiscalExpences = 0.0;
    totalNotFiscalExpences = 0.0;

    calculateFiscalNotFiscalAmount();

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


    List<ProductModel> retrieveProductsByBranch = await getclientServiceInstance().retrieveProductsByBranch(currentBranch);

    storageTempListProduct.addAll(retrieveProductsByBranch);

    List<int> listProductIdsToRemove = [];
    print('coming list size ' + retrieveProductsByBranch.length.toString());
    currentStorageProductListForCurrentStorage.forEach((currentProductAlreadyPresent) {
      listProductIdsToRemove.add(currentProductAlreadyPresent.fkProductId);
    });

    retrieveProductsByBranch.removeWhere((element) =>
        listProductIdsToRemove.contains(element.pkProductId),
    );
    print('coming list size ' + retrieveProductsByBranch.length.toString());
    addAllCurrentListProductToProductListToAddToStorage(retrieveProductsByBranch);
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
    orderIdProductListMap.clear();
    currentArchiviedWorkingOrdersList.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.status == OrderState.DRAFT){

        currentDraftOrdersList.add(orderItem);
        currentDraftOrdersList.forEach((element) async {
          List<ProductOrderAmountModel> list = await getclientServiceInstance()
              .retrieveProductByOrderId(
            OrderModel(
              pk_order_id: element.pk_order_id,
            ),
          );
          orderIdProductListMap[element.pk_order_id] = list;
        });
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
      List<ProductModel> retrieveProductsByBranch = await getclientServiceInstance().retrieveProductsByBranch(currentBranch);
      List<int> listProductIdsToRemove = [];
      print('coming list size ' + retrieveProductsByBranch.length.toString());
      currentStorageProductListForCurrentStorage.forEach((currentProductAlreadyPresent) {
        listProductIdsToRemove.add(currentProductAlreadyPresent.fkProductId);
      });

      retrieveProductsByBranch.removeWhere((element) =>
          listProductIdsToRemove.contains(element.pkProductId),
      );

      print('coming list size ' + retrieveProductsByBranch.length.toString());
      addAllCurrentListProductToProductListToAddToStorage(retrieveProductsByBranch);
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
    String currentSupplier = '';
    currentListSuppliers.forEach((element) {
      if(element.pkSupplierId == supplierId){
        currentSupplier = element.nome;
      }
    });
    return currentSupplier;
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
    isZtoAOrderded = false;
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
    userDetailsList[0].companyList.forEach((currentBranch) async {

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
    if(userDetailsList.isNotEmpty){
      return userDetailsList[0].firstName + ' ' + userDetailsList[0].lastName;
    }else{
      return 'Error retrieving user name';
    }
  }

  retrieveDataToDrawChartFattureInCloud(DateTimeRange currentDateTimeRange) async {

    totalIvaAcquisti = 0.0;
    totalIvaFatture = 0.0;
    totalIvaNdcReceived = 0.0;
    totalIvaNdcSent = 0.0;
    extractedAcquistiFatture.clear();
    extractedNdc.clear();
    resultDebitIvaMap.clear();
    resultCreditIvaMap.clear();
    retrieveListaAcquisti.clear();
    retrieveListaFatture.clear();
    retrieveListaNDC.clear();

    print('Inizia a calcolare iva con ' + currentDateTimeRange.start.toString());
    print('Inizia a calcolare iva con ' + currentDateTimeRange.end.toString());
    retrieveListaAcquisti =
    await iCloudClient.retrieveListaAcquisti(
        currentBranch.apiUidOrPassword,
        currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);

    retrieveListaFatture =
    await iCloudClient.retrieveListaFatture(
        currentBranch.apiUidOrPassword,
        currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);

    retrieveListaNDC = await iCloudClient.retrieveListaNdc(
        currentBranch.apiUidOrPassword,
        currentBranch.apiKeyOrUser,
        currentDateTimeRange.start,
        currentDateTimeRange.end,
        '',
        '',
        currentDateTimeRange.start.year);


    resultCreditIvaMap = initializeMap(currentDateTimeRange);
    resultDebitIvaMap = initializeMap(currentDateTimeRange);


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

    int j = 0;

    charDataCreditIva.clear();
    do{
      charDataCreditIva.add(CharData(
          currentDateTimeRange.end.subtract(Duration(days: daysRangeDate-j)),
          calculateValue(resultCreditIvaMap, currentDateTimeRange, daysRangeDate-j, daysRangeDate, false)));
      j++;
    }while(j <= daysRangeDate);

    int i = 0;
    charDataDebitIva.clear();
    do{
      charDataDebitIva.add(CharData(
          currentDateTimeRange.end.subtract(Duration(days: daysRangeDate-i)),
          calculateValue(resultDebitIvaMap, currentDateTimeRange, daysRangeDate-i, daysRangeDate, true)));
      i++;
    }while(i <= daysRangeDate);

    print('Char data credit iva');
    charDataCreditIva.forEach((element) {
      print(element.date.toString() + ' - ' + element.value.toString());
    });
    print('Char data debit iva');
    charDataDebitIva.forEach((element) {
      print(element.date.toString() + ' - ' + element.value.toString());
    });
    print('finish');

    notifyListeners();
  }

  Map<String, double> initializeMap(DateTimeRange currentDateTimeRange) {
    Map<String, double> mapToReturn = {};
    int i = 0;
    do{
      mapToReturn[buildKeyFromTimeRange(daysRangeDate-i)] = 0;
      i++;
    }while(i <= daysRangeDate);

    return mapToReturn;
  }

  double retrieveValueFromMapByDate(int dayToSubtract, Map<String, double> resultCreditIvaMap, DateTimeRange timeRange, bool debit){

    double valueToReturn = 0.0;
    if(debit){
      currentListRecessed.forEach((recessed) {
        if(timeRange.end.subtract(Duration(days: dayToSubtract)).day == DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).day &&
            timeRange.end.subtract(Duration(days: dayToSubtract)).month == DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).month &&
            timeRange.end.subtract(Duration(days: dayToSubtract)).year == DateTime.fromMillisecondsSinceEpoch(recessed.dateTimeRecessed).year){
          valueToReturn = valueToReturn + ((recessed.amount/100) * recessed.vat);
        }
      });
    }

    return valueToReturn + resultCreditIvaMap[
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

  StorageModel retrieveStorageFromStorageListByIdName(String storageIdName) {
    print('Retrieve Storage');
    StorageModel storageModelToReturn;

    currentStorageList.forEach((storage) {
      if(storageIdName.contains(storage.name) &&
          storageIdName.contains(storage.pkStorageId.toString())){
        storageModelToReturn = storage;
      }
    });
    return storageModelToReturn;
  }

  double calculateValue(Map<String, double> resultDebitIvaMap,
      DateTimeRange currentDateTimeRange, int daysToSubtract, int j, bool isDebit) {

    double valueToReturn = 0.0;

    if(DateTime.now().isAfter(currentDateTimeRange.end.subtract(Duration(days: daysToSubtract)))){
      while(daysToSubtract <= j){
        valueToReturn = valueToReturn + retrieveValueFromMapByDate(daysToSubtract, resultDebitIvaMap, currentDateTimeRange, isDebit);
        daysToSubtract++;
      }
      return valueToReturn;
    }
    return null;
  }

  void setIndexIvaListValue(int index) {
    indexIvaList = index;
    notifyListeners();
  }



  void subtractMonth() {
    currentDate = DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    currentDateTimeRange = DateTimeRange(
      start: DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0, 0, 0),
      end: DateTime(currentDate.year, currentDate.month, DateTime(currentDate.year, currentDate.month + 1, 0).day, 0, 0, 0, 0,0),
    );
    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
    }
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  void addMonth() {

    currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    currentDateTimeRange = DateTimeRange(
      start: DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0, 0,0),
      end: DateTime(currentDate.year, currentDate.month, DateTime(currentDate.year, currentDate.month + 1, 0).day, 0, 0, 0, 0,0),
    );
    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
    }
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  void switchTrimAndCalculateIvaGraph(int index) {

    currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    switch(index){
      case 0:
        currentDateTimeRange = DateTimeRange(
          start: DateTime(currentYear, 1, 1, 0, 0, 0, 0,0),
          end: DateTime(currentYear, 3, DateTime(currentDate.year, 3 + 1, 0).day, 0, 0, 0, 0,0),
        );
        daysRangeDate = currentDateTimeRange.end.difference(currentDateTimeRange.start).inDays;

        break;
      case 1:
        currentDateTimeRange = DateTimeRange(
          start: DateTime(currentYear, 4, 1, 0, 0, 0, 0,0),
          end: DateTime(currentYear, 6, DateTime(currentDate.year, 6 + 1, 0).day, 0, 0, 0, 0,0),
        );
        daysRangeDate = currentDateTimeRange.end.difference(currentDateTimeRange.start).inDays;
        break;
      case 2:
        currentDateTimeRange = DateTimeRange(
          start: DateTime(currentYear, 7, 1, 0, 0, 0, 0,0),
          end: DateTime(currentYear, 9, DateTime(currentDate.year, 9 + 1, 0).day, 0, 0, 0, 0,0),
        );
        daysRangeDate = currentDateTimeRange.end.difference(currentDateTimeRange.start).inDays;
        break;
      case 3:
        currentDateTimeRange = DateTimeRange(
          start: DateTime(currentYear, 10, 1, 0, 0, 0, 0,0),
          end: DateTime(currentYear, 12, DateTime(currentDate.year + 1, 1, 0).day, 0, 0, 0, 0,0),
        );
        daysRangeDate = currentDateTimeRange.end.difference(currentDateTimeRange.start).inDays;
        break;

    }

    print(currentDateTimeRange.start.toString());
    print(currentDateTimeRange.end.toString());

    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
    }
    clearAndUpdateMapBundle();
    notifyListeners();

  }

  void setIvaListTrimMonthChoiceCupertinoIndex(int index) {

    if(index == 0){
      daysRangeDate = DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month);
      currentDate = DateTime.now();
      currentDateTimeRange = DateTimeRange(
        start: DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0, 0,0),
        end: DateTime(currentDate.year, currentDate.month, DateTime(currentDate.year, currentDate.month + 1, 0).day, 0, 0, 0, 0,0),
      );
      if(currentBranch != null){
        if(currentBranch.providerFatture == 'fatture_in_cloud'){
          retrieveDataToDrawChartFattureInCloud(currentDateTimeRange);
        }else if(currentBranch.providerFatture == 'aruba'){
          // retrieveDataToDrawChartAruba(currentDateTimeRange);
        }
      }
    }else if(index == 1){
      DateTime now = DateTime.now();
      if(now.month == 1 || now.month == 2 || now.month == 3){
        switchTrimAndCalculateIvaGraph(0);
      }else if(now.month == 4 || now.month == 5 || now.month == 6){
        switchTrimAndCalculateIvaGraph(1);
      }else if(now.month == 7 || now.month == 8 || now.month ==9){
        switchTrimAndCalculateIvaGraph(2);
      }else if(now.month == 10 || now.month == 11 || now.month == 12){
        switchTrimAndCalculateIvaGraph(3);
      }
    }

    ivaListTrimMonthChoiceCupertinoIndex = index;
    notifyListeners();
  }

  void removeProductToAddToStorage(ProductModel element) {
    productToAddToStorage.remove(element);
    notifyListeners();
  }

  ResponseAnagraficaFornitori retrieveSupplierFromSupplierListByIdName(String selectedSupplier) {
    ResponseAnagraficaFornitori supplierToReturn;
    currentListSuppliers.forEach((supplier) {
      if(selectedSupplier.contains(supplier.nome) &&
          selectedSupplier.contains(supplier.pkSupplierId.toString())){
        supplierToReturn = supplier;
      }
    });
    return supplierToReturn;
  }

  ResponseAnagraficaFornitori retrieveSupplierFromSupplierListById(int fk_supplier_id) {
    ResponseAnagraficaFornitori supplierToReturn;
    currentListSuppliers.forEach((supplier) {
      if(supplier.pkSupplierId == fk_supplier_id){
        supplierToReturn = supplier;
      }
    });
    return supplierToReturn;
  }

  OrderModel getDraftOrderFromListBySupplierId(int pkSupplierId) {
    OrderModel orderToReturn;

    currentDraftOrdersList.forEach((draftOrder) {
      if(draftOrder.fk_supplier_id == pkSupplierId){
        orderToReturn = draftOrder;
      }
    });
    return orderToReturn;
  }

  void setCurrentProductListToSendDraftOrder(List<ProductOrderAmountModel> prodOrderModelList) {
    currentProdOrderModelList.clear();
    currentProdOrderModelList.addAll(prodOrderModelList);
    notifyListeners();
  }

  void calculateFiscalNotFiscalAmount() {
    totalFiscalExpences = 0.0;
    totalNotFiscalExpences = 0.0;
    currentListExpences.forEach((expence) {
      if(currentWeek.start.isBefore(DateTime.fromMillisecondsSinceEpoch(expence.dateTimeExpence).add(const Duration(days: 1))) &&
          currentWeek.end.isAfter(DateTime.fromMillisecondsSinceEpoch(expence.dateTimeExpence))) {

        if(expence.fiscal == 'Y'){
          totalFiscalExpences = totalFiscalExpences + expence.amount;
        }else if(expence.fiscal == 'N'){
          totalNotFiscalExpences = totalNotFiscalExpences + expence.amount;
        }
      }
    });
    notifyListeners();
  }

  int retrieveEventsNumberForCurrentDate(DateTime date) {

    int counter = 0;
    if(eventModelList.isEmpty){
      return counter;
    }else{
      eventModelList.forEach((eventItem) {
        if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day == date.day &&
        DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month == date.month &&
        DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year == date.year){
          counter = counter + 1;
        }
      });
      return counter;
    }
  }

  List<EventModel> retrieveEventsForCurrentDate(DateTime date) {

    List<EventModel> events = [];

    if(eventModelList.isEmpty){
      return events;
    }else{
      eventModelList.forEach((eventItem) {
        if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day == date.day &&
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month == date.month &&
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year == date.year){
          events.add(eventItem);
        }
      });
      return events;
    }
  }

  void addCurrentEventsList(List<EventModel> eventList) {
    eventModelList.clear();
    eventModelList.addAll(eventList);
    notifyListeners();
  }

  String retrieveEventsNumberOpenStatus() {
    int counter = 0;
    if(eventModelList.isEmpty){
      return counter.toString();
    }else{
      eventModelList.forEach((eventItem) {
        print(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).toString());
        if(eventItem.closed == 'N'){
          counter = counter + 1;
        }
      });
      return counter.toString();
    }
  }

  String retrieveStorageById(int fkStorageId) {
    StorageModel storage;
    currentStorageList.forEach((element) {
      storage = element;
    });
    if(storage != null && storage.name != null && storage.name != ''){
      return storage.name;
    }else{
     return 'Nessun magazzino trovato';
    }
  }

  void setToSelectedFalseAllItemOnCurrentStorageProductListForCurrentStorageDuplicated() {
    currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      element.selected = false;
    });
    notifyListeners();
  }

}