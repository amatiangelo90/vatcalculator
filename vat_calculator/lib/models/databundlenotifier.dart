
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:vat_calculator/client/vatservice/model/cash_register_model.dart';
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
import 'package:vat_calculator/components/vat_data.dart';
import '../client/fattureICloud/model/response_info_company.dart';
import '../client/firebase_service/firebase_messaging_service_impl.dart';
import '../client/vatservice/model/expence_event_model.dart';
import '../constants.dart';
import 'bundle_users_storage_supplier_forbranch.dart';
import 'databundle.dart';

class DataBundleNotifier extends ChangeNotifier {


  List<UserDetailsModel> userDetailsList = [
  ];

  List<CashRegisterModel> currentListCashRegister = [
  ];

  List<RecessedModel> currentListRecessed = [
  ];

  List<ExpenceModel> currentListExpences = [
  ];

  List<SupplierModel> currentListSuppliers = [
  ];

  List<SupplierModel> currentListSuppliersDuplicated = [
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

  List<String> currentBossTokenList = [];

  List<ProductModel> productListForChoicedSupplierToPerformOrder = [];
  List<CharData> charDataCreditIva = [];
  List<CharData> charDataDebitIva = [];

  List<EventModel> eventModelList = [];
  List<EventModel> eventModelListOlderThanToday = [];

  String currentPrivilegeType;

  ClientVatService clientService = ClientVatService();
  FirebaseMessagingService clientMessagingFirebase = FirebaseMessagingService();
  FattureInCloudClient iCloudClient = FattureInCloudClient();
  EmailSenderService emailService = EmailSenderService();

  bool isSpecialUser = false;

  BranchModel currentBranch;
  StorageModel currentStorage;
  CashRegisterModel currentCashRegisterModel;

  DateTime currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0);
  DateTimeRange currentDateTimeRangeVatService;

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
  List<ResponseAcquistiApi> extractedAcquistiFattureBis = [];

  List<ResponseAcquistiApi> extractedNdc = [];
  List<ResponseAcquistiApi> extractedNdcBis = [];

  List<ResponseAcquistiApi> retrieveListaAcquisti = [];

  List<ResponseFattureApi> retrieveListaFatture = [];
  List<ResponseFattureApi> retrieveListaFattureBis = [];

  List<ResponseNDCApi> retrieveListaNDC = [];
  ResponseCompanyFattureInCloud fattureInCloudCompanyInfo;

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

  FirebaseMessagingService getclientMessagingFirebase(){
    if(clientMessagingFirebase == null){
      return FirebaseMessagingService();
    }else{
      return clientMessagingFirebase;
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
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRangeVatService);
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

  void initializeCurrentDateTimeRange3Months() {
    DateTime date = DateTime.now();

    if(date.month == 1 || date.month == 2 || date.month == 3){
      currentDateTimeRangeVatService = DateTimeRange(
        start: DateTime(date.year, 1, 1, 0, 0, 0, 0,0),
        end: DateTime(date.year, 3, DateTime(date.year, 4, 0).day, 0, 0, 0, 0,0),
      );
    }else if(date.month == 4 || date.month == 5 || date.month == 6){
      currentDateTimeRangeVatService = DateTimeRange(
        start: DateTime(date.year, 4, 1, 0, 0, 0, 0,0),
        end: DateTime(date.year, 6, DateTime(date.year, 7, 0).day, 0, 0, 0, 0,0),
      );
    }else if(date.month == 7 || date.month == 8 || date.month == 9){
      currentDateTimeRangeVatService = DateTimeRange(
        start: DateTime(date.year, 7, 1, 0, 0, 0, 0,0),
        end: DateTime(date.year, 10, DateTime(date.year, 7, 0).day, 0, 0, 0, 0,0),
      );
    }else if(date.month == 10 || date.month == 11 || date.month == 12){
      currentDateTimeRangeVatService = DateTimeRange(
        start: DateTime(date.year, 10, 1, 0, 0, 0, 0,0),
        end: DateTime(date.year, 12, DateTime(date.year + 1, 0, 0).day, 0, 0, 0, 0,0),
      );
    }


    currentWeek = DateTimeRange(start: findFirstDateOfTheWeek(date), end: findLastDateOfTheWeek(date));
    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRangeVatService);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
    }
    clearAndUpdateMapBundle();
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
        if(DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isBefore(end.add(Duration(days: 1))) && DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isAfter(start.subtract(Duration(days: 1)))){
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
      initializeCurrentDateTimeRange3Months();
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
    initializeCurrentDateTimeRange3Months();
    setCurrentPrivilegeType(currentBranch.accessPrivilege);

    currentListCashRegister.clear();
    currentListRecessed.clear();

    List<RecessedModel> _recessedModelList = [];
    currentListCashRegister = await clientService.retrieveCashRegistersByBranchId(currentBranch);

    if(currentListCashRegister.isNotEmpty){
      await Future.forEach(currentListCashRegister,
              (CashRegisterModel cashRegisterModel) async {
        List<RecessedModel> list = await clientService.retrieveRecessedListByCashRegister(cashRegisterModel);
        _recessedModelList.addAll(list);
      });
      currentCashRegisterModel = currentListCashRegister.first;
      currentListRecessed.addAll(_recessedModelList);
    }

    List<ExpenceModel> _expenceModelList = await clientService.retrieveExpencesListByBranch(currentBranch);
    currentListExpences.clear();
    currentListExpences.addAll(_expenceModelList);


    List<EventModel> _eventModelList = await clientService.retrieveEventsListByBranchId(currentBranch);

    addCurrentEventsList(_eventModelList);


    totalFiscalExpences = 0.0;
    totalNotFiscalExpences = 0.0;

    calculateFiscalNotFiscalAmount();

    List<SupplierModel> _supplierModelList = await clientService.retrieveSuppliersListByBranch(currentBranch);
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

    List<String> tokenList = await clientService.retrieveTokenList(currentBranch);
    setCurrentBossTokenList(tokenList);

    //retrieveDataToDrawChartFattureInCloud(currentDateTimeRangeVatService);
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

    if(currentListCashRegister.isNotEmpty){
      currentListCashRegister.clear();
    }

    currentCashRegisterModel = null;

    if(currentListExpences.isNotEmpty){
      currentListExpences.clear();
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

  void addCurrentSuppliersList(List<SupplierModel> suppliersModelList) {
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

      List<SupplierModel> listTemp = [];
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

      List<SupplierModel> listSuppliers = await getclientServiceInstance().retrieveSuppliersListByBranch(BranchModel(
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
    extractedAcquistiFattureBis.clear();
    extractedNdc.clear();
    extractedNdcBis.clear();
    retrieveListaAcquisti.clear();
    retrieveListaFatture.clear();
    retrieveListaFattureBis.clear();

    retrieveListaNDC.clear();

    if(currentBranch.providerFatture != null && currentBranch.providerFatture != ''){
      retrieveListaAcquisti = await iCloudClient.retrieveListaAcquisti(currentBranch.apiUidOrPassword, currentBranch.apiKeyOrUser, currentDateTimeRange.start, currentDateTimeRange.end, '', '', currentDateTimeRange.start.year);
      retrieveListaFatture = await iCloudClient.retrieveListaFatture(currentBranch.apiUidOrPassword, currentBranch.apiKeyOrUser, currentDateTimeRange.start, currentDateTimeRange.end, '', '', currentDateTimeRange.start.year);
      retrieveListaNDC = await iCloudClient.retrieveListaNdc( currentBranch.apiUidOrPassword, currentBranch.apiKeyOrUser, currentDateTimeRange.start, currentDateTimeRange.end, '', '', currentDateTimeRange.start.year);

      fattureInCloudCompanyInfo = await iCloudClient.performRichiestaGetCompanyInfo(currentBranch.apiUidOrPassword, currentBranch.apiKeyOrUser,);

      retrieveListaFattureBis.addAll(retrieveListaFatture);

      totalIvaAcquisti = 0.0;
      totalIvaNdcReceived = 0.0;

      retrieveListaAcquisti.forEach((acquisto) {
        if (acquisto.tipo == 'spesa') {
          extractedAcquistiFatture.add(acquisto);
          extractedAcquistiFattureBis.add(acquisto);
          totalIvaAcquisti = totalIvaAcquisti + double.parse(acquisto.importo_iva);
        } else if (acquisto.tipo == 'ndc') {
          extractedNdc.add(acquisto);
          extractedNdcBis.add(acquisto);
          totalIvaNdcReceived = totalIvaNdcReceived + double.parse(acquisto.importo_iva);
        }
      });


      print(retrieveListaFatture.length.toString());
      totalIvaFatture = 0.0;
      retrieveListaFatture.forEach((fattura) {
        print(fattura.importo_totale.toString());
        print(fattura.importo_netto.toString());
        totalIvaFatture = totalIvaFatture + (double.parse(fattura.importo_totale) - double.parse(fattura.importo_netto));
        print(totalIvaFatture.toString());
      });

      totalIvaNdcSent = 0.0;
      retrieveListaNDC.forEach((ndc) {
        totalIvaNdcSent = totalIvaNdcSent + (double.parse(ndc.importo_totale) - double.parse(ndc.importo_netto));
      });
    }
    notifyListeners();
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
    return normalizeDayValue(currentDateTimeRangeVatService.end.subtract(Duration(days: i)).day) + '/' + normalizeMonth(currentDateTimeRangeVatService.end.subtract(Duration(days: i)).month) + '/' + currentDateTimeRangeVatService.end.subtract(Duration(days: i)).year.toString();
  }


  StorageModel retrieveStorageFromStorageListByIdName(String storageIdName) {
    StorageModel storageModelToReturn;

    currentStorageList.forEach((storage) {
      if(storageIdName.contains(storage.name) &&
          storageIdName.contains(storage.pkStorageId.toString())){
        storageModelToReturn = storage;
      }
    });
    return storageModelToReturn;
  }

  void setIndexIvaListValue(int index) {
    indexIvaList = index;
    notifyListeners();
  }

  void removeProductToAddToStorage(ProductModel element) {
    productToAddToStorage.remove(element);
    notifyListeners();
  }

  SupplierModel retrieveSupplierFromSupplierListByIdName(String selectedSupplier) {
    SupplierModel supplierToReturn;
    currentListSuppliers.forEach((supplier) {
      if(selectedSupplier.contains(supplier.nome) &&
          selectedSupplier.contains(supplier.pkSupplierId.toString())){
        supplierToReturn = supplier;
      }
    });
    return supplierToReturn;
  }

  SupplierModel retrieveSupplierFromSupplierListById(int fk_supplier_id) {
    SupplierModel supplierToReturn;
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

  int retrieveOrdersNumberForCurrentDate(DateTime date) {

    int counter = 0;
    if(currentUnderWorkingOrdersList.isEmpty){
      return counter;
    }else{
      currentUnderWorkingOrdersList.forEach((orderItem) {
        if(DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).day == date.day &&
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).month == date.month &&
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).year == date.year){
          counter = counter + 1;
        }
      });
      return counter;
    }
  }

  List<OrderModel> retrieveOrdersUnderWorkingForCurrentDate(DateTime date) {

    List<OrderModel> orders = [];

    if(currentUnderWorkingOrdersList.isEmpty){
      return orders;
    }else{
      currentUnderWorkingOrdersList.forEach((order) {
        if(DateTime.fromMillisecondsSinceEpoch(order.delivery_date).day == date.day &&
            DateTime.fromMillisecondsSinceEpoch(order.delivery_date).month == date.month &&
            DateTime.fromMillisecondsSinceEpoch(order.delivery_date).year == date.year){
          orders.add(order);
        }
      });
      return orders;
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
      if(element.pkStorageId == fkStorageId){
        storage = element;
      }
    });
    if(storage != null && storage.name != null && storage.name != ''){
      return storage.name;
    }else{
     return 'Nessun magazzino trovato';
    }
  }

  BranchModel retrieveBranchById(int key) {
    BranchModel branchToReturn;

    userDetailsList[0].companyList.forEach((branch) {
      if(branch.pkBranchId == key){
        branchToReturn = branch;
      }
    });
    return branchToReturn;
  }

  buildDateKey(int dateTimeRecessed) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTimeRecessed);
    return normalizeDayValue(date.day).toString()+'/'+normalizeMonth(date.month).toString()+'/'+date.year.toString();
  }

  void setCurrentDateTimeRange(DateTimeRange dateTimeRange) {
    currentDateTimeRangeVatService = dateTimeRange;
    if(currentBranch != null){
      if(currentBranch.providerFatture == 'fatture_in_cloud'){
        retrieveDataToDrawChartFattureInCloud(currentDateTimeRangeVatService);
      }else if(currentBranch.providerFatture == 'aruba'){
        // retrieveDataToDrawChartAruba(currentDateTimeRange);
      }
    }
    notifyListeners();
  }

  filterextractedAcquistiFattureByText(String filterText){
    if(filterText.isEmpty){
      extractedAcquistiFatture.clear();
      extractedAcquistiFatture.addAll(extractedAcquistiFattureBis);
    }else{
      extractedAcquistiFatture.clear();
      extractedAcquistiFattureBis.forEach((element) {
        if(element.nome.toLowerCase().contains(filterText.toLowerCase())){
          extractedAcquistiFatture.add(element);
        }
      });
    }
    notifyListeners();
  }

  void filterextractedextractedNdcByText(String filterText) {
    if(filterText.isEmpty){
      extractedNdc.clear();
      extractedNdc.addAll(extractedNdcBis);
    }else{
      extractedNdc.clear();
      extractedNdcBis.forEach((element) {
        if(element.nome.toLowerCase().contains(filterText.toLowerCase())){
          extractedNdc.add(element);
        }
      });
    }
    notifyListeners();
  }

  void filterListaFattureByText(String filterText) {
    if(filterText.isEmpty){
      retrieveListaFatture.clear();
      retrieveListaFatture.addAll(retrieveListaFattureBis);
    }else{
      retrieveListaFatture.clear();
      retrieveListaFattureBis.forEach((element) {
        if(element.nome.toLowerCase().contains(filterText.toLowerCase())){
          retrieveListaFatture.add(element);
        }
      });
    }
    notifyListeners();

  }

  void setCashRegisterList(List<CashRegisterModel> cashRegisterModelList) {
    if(cashRegisterModelList.isNotEmpty){
      currentListCashRegister.clear();
      currentListCashRegister.addAll(cashRegisterModelList);
      currentCashRegisterModel = currentListCashRegister.first;
      notifyListeners();
    }
  }

  void switchCurrentCashRegisterBack() {
    int currentIndex = 0;
    if(currentListCashRegister.length != 1){
      for(int i = 0; i < currentListCashRegister.length; i++){
        if(currentCashRegisterModel.pkCashRegisterId == currentListCashRegister.elementAt(i).pkCashRegisterId){
          currentIndex = i;
        }
      }
      if(currentIndex == 0){
        currentCashRegisterModel = currentListCashRegister.last;
      }else{
        currentCashRegisterModel = currentListCashRegister.elementAt(currentIndex - 1);
      }
    }
    notifyListeners();
  }

  void switchCurrentCashRegisterForward() {

    int currentIndex = 0;
    if(currentListCashRegister.length != 1){
      for(int i = 0; i < currentListCashRegister.length; i++){
        if(currentCashRegisterModel.pkCashRegisterId == currentListCashRegister.elementAt(i).pkCashRegisterId){
          currentIndex = i;
        }
      }
      if(currentIndex != currentListCashRegister.length - 1){
        currentCashRegisterModel = currentListCashRegister.elementAt(currentIndex + 1);
      }else{
        currentCashRegisterModel = currentListCashRegister.first;
      }
    }
    notifyListeners();
  }

  bool isCurrentCashAlreadyUsed(String text) {
    bool result = false;
    currentListCashRegister.forEach((element) {
      if(element.name.toLowerCase() == text.toLowerCase()){
        result = true;
      }
    });
    return result;
  }

  StorageModel getStorageModelById(int fkStorageId) {
    StorageModel storageModel;

    currentStorageList.forEach((element) {
      if(element.pkStorageId == fkStorageId){
        storageModel = element;
      }
    });
    return storageModel;
  }

  SupplierModel getSupplierFromList(int fk_supplier_id) {
    print('Retrieve supplier for id ' + fk_supplier_id.toString());
    SupplierModel currentSupplierName;

    currentListSuppliers.forEach((currentSupplier) {

      if(currentSupplier.pkSupplierId == fk_supplier_id){
        currentSupplierName = currentSupplier;
      }
    });

    return currentSupplierName;
  }

  Color getProviderColor() {
    if(currentBranch == null || currentBranch.providerFatture == '' &&  currentBranch.providerFatture == null){
      return Colors.white;
    }else{
      switch(currentBranch.providerFatture){
        case 'fatture_in_cloud':
          return Colors.lightBlueAccent;
        case 'aruba':
          return Colors.orange;
        default:
          return Colors.white;
      }
    }
  }

  int selectedIndex = 0;
  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  int areEventsOrOrderOlderThanTodayPresent() {

    int result = 0;
    if(currentUnderWorkingOrdersList.isNotEmpty){
      currentUnderWorkingOrdersList.forEach((orderItem) {
        if(DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).day < DateTime.now().day ||
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).month < DateTime.now().month ||
            DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).year < DateTime.now().year){
          result = result + 1;
        }
      });
    }
    if(eventModelList.isNotEmpty){
      eventModelList.forEach((eventItem) {

        if((DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day < DateTime.now().day ||
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month < DateTime.now().month ||
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year < DateTime.now().year)
                && eventItem.closed == 'N'){

          result = result + 1;
        }
      });
    }
    return result;
  }

  List<OrderModel> getOrdersOlderThanTodayUnderWorking() {

    List<OrderModel> list = [];
    if(currentUnderWorkingOrdersList.isNotEmpty){
      currentUnderWorkingOrdersList.forEach((orderItem) {
        if(DateTime.fromMillisecondsSinceEpoch(orderItem.delivery_date).isBefore(DateTime.now())){
          list.add(orderItem);
        }
      });
    }
    return list;
  }

  List<EventModel> getEventsOlderThanTodayNotClosed() {

    List<EventModel> list = [];
    if(eventModelList.isNotEmpty){
      eventModelList.forEach((eventItem) {
        if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).isBefore(DateTime.now()) && eventItem.closed == 'N'){
          list.add(eventItem);
        }
      });
    }

    return list;
  }

  void setCurrentBossTokenList(List<String> tokenList) {
    currentBossTokenList.clear();
    currentBossTokenList.addAll(tokenList);
    notifyListeners();
  }

  List<ExpenceEventModel> listExpenceEvent = [];

  void setCurrentExpenceEventList(List<ExpenceEventModel> list){
    listExpenceEvent.clear();
    listExpenceEvent.addAll(list);
    notifyListeners();
  }

  void addExpenceEventItem(ExpenceEventModel expenceEventModel) {
    listExpenceEvent.add(expenceEventModel);
    notifyListeners();
  }

  void updateExpenceEventItem(ExpenceEventModel expenceEventModel) {
    listExpenceEvent.forEach((expenceEvent) {
      if(expenceEventModel.pkEventExpenceId == expenceEvent.pkEventExpenceId){
        expenceEvent.amount = expenceEventModel.amount;
        expenceEvent.description = expenceEventModel.description;
        expenceEvent.cost = expenceEventModel.cost;
      }
    });
    notifyListeners();
  }

  void removeExpenceEventItem(ExpenceEventModel expenceEventModel) {
    listExpenceEvent.removeWhere((expt) =>
      expt.pkEventExpenceId == expenceEventModel.pkEventExpenceId
    );
    notifyListeners();
  }

  void cleanExtraArgsListProduct() {
    currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      element.extra = 0.0;
    });
    notifyListeners();
  }
}