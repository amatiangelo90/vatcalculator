import 'package:dio/dio.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/cash_register_model.dart';
import 'package:vat_calculator/client/vatservice/model/expence_event_model.dart';
import 'package:vat_calculator/models/databundle.dart';
import 'model/action_model.dart';
import 'model/branch_model.dart';
import 'model/deposit_order_model.dart';
import 'model/event_model.dart';
import 'model/expence_model.dart';
import 'model/move_product_between_storage_model.dart';
import 'model/order_model.dart';
import 'model/product_model.dart';
import 'model/product_order_amount_model.dart';
import 'model/recessed_model.dart';
import 'model/save_product_into_storage_request.dart';
import 'model/storage_model.dart';
import 'model/storage_product_model.dart';
import 'model/user_model.dart';
import 'model/workstation_model.dart';
import 'model/workstation_product_model.dart';

abstract class VatServiceInterface{

  Future<Response> performSaveUser(String firstName,String lastName, String phoneNumber, String eMail, String privileges, int relatedUserId);
  Future<Response> checkSpecialUser(UserModel usermodel);
  Future<Response> performSaveRecessed(double amountF, double amountNF, double amountCash, double amountPos, String description, int iva, int dateTimeRecessed, int pkBranchId, ActionModel actionModel);
  Future<Response> performSaveExpence(double amount, String description, int iva, int dateTimeExpence, int pkBranchId, String fiscal, ActionModel actionModel);
  Future<Response> performSaveStorage({StorageModel storageModel, ActionModel actionModel});
  Future<Response> performSaveOrder({OrderModel orderModel, ActionModel actionModel});
  Future<List<ProductOrderAmountModel>> retrieveProductByOrderId(OrderModel orderModel);
  Future<Response> performSaveSupplier({SupplierModel anagraficaFornitore, ActionModel actionModel});
  Future<Response> performSaveBranch(BranchModel company, ActionModel actionModel);
  Future<Response> performSaveProduct({ProductModel product, ActionModel actionModel});
  Future<Response> performSaveProductIntoStorage({SaveProductToStorageRequest saveProductToStorageRequest, ActionModel actionModel});
  Future<Response> performSaveProductIntoOrder(double amount, int productId, int orderId);
  Future<Response> performUpdateProduct({ProductModel product});
  Future<Response> performUpdateExpence({ExpenceModel expenceModel, ActionModel actionModel});
  Future<Response> performDeleteProduct({ProductModel product, ActionModel actionModel});
  Future<Response> removeProductFromStorage({StorageProductModel storageProductModel, ActionModel actionModel});
  Future<UserModel> retrieveUserByEmail(String eMail);
  Future<List<BranchModel>> retrieveBranchesByUserId(int id);
  //Future<List<ActionModel>> retrieveActionsByBranchId(int branchId);
  //Future<List<ActionModel>> retrieveLastWeekActionsByBranchId(int branchId);
  Future<List<StorageProductModel>> retrieveRelationalModelProductsStorage(int pkStorageId);
  Future<List<RecessedModel>> retrieveRecessedListByCashRegister(CashRegisterModel currentBranch);
  Future<List<ExpenceModel>> retrieveExpencesListByBranch(BranchModel currentBranch);
  Future<List<OrderModel>> retrieveOrdersByBranch(BranchModel currentBranch);
  Future<List<OrderModel>> retrieveOrderModelBySupplierIdAndBranchIdWhereStatusIsReceivedAndPaidIsFalse(int supplierId, int branchId);
  Future<List<OrderModel>> retrieveArchiviedOrdersByBranch(BranchModel currentBranch);
  Future<List<SupplierModel>> retrieveSuppliersListByBranch(BranchModel currentBranch);
  Future<List<ProductModel>> retrieveProductsBySupplier(SupplierModel currentSupplier);
  Future<List<ProductModel>> retrieveProductsByBranch(BranchModel branchModel);
  Future<List<StorageModel>> retrieveStorageListByBranch(BranchModel currentBranch);
  Future<List<BranchModel>> retrieveBranchByBranchId(String codeBranch);
  Future<List<UserModel>> retrieveUserListRelatedWithBranchByBranchId(BranchModel branchModel);
  Future<void> updateStock({List<StorageProductModel> currentStorageProductListForCurrentStorageUnload, ActionModel actionModel});
  Future<void> deleteOrder({OrderModel orderModel, ActionModel actionModel});
  Future<void> deleteExpence({ExpenceModel expenceModel, ActionModel actionModel});
  Future<void> deleteStorage({StorageModel storageModel, ActionModel actionModel});
  Future<void> updateOrderStatus({OrderModel orderModel, ActionModel actionModel});
  Future<Response> addProviderDetailsToBranch({BranchModel branchModel, ActionModel actionModel});
  Future<List<SupplierModel>> retrieveSuppliersListByCode({String code});
  Future<int> addSupplierToCurrentBranch({SupplierModel supplierRetrievedByCodeToUpdateRelationTableBranchSupplier, ActionModel actionModel});
  Future<void> removeSupplierFromCurrentBranch({SupplierModel requestRemoveSupplierFromBranch, ActionModel actionModel});
  Future<Response> removeProviderFromBranch({BranchModel branchModel, ActionModel actionModel});
  Future<Response> createUserBranchRelation({int fkUserId, int fkBranchId, String accessPrivilege, ActionModel actionModel});
  Future<Response> updatePrivilegeForUserBranchRelation({int branchId, int userId, String privilegeType, ActionModel actionModel});
  Future<Response> updateFirebaseTokenForUserBranchRelation({int branchId, int userId, String token});
  Future<Response> removeUserBranchRelation({int branchId, int userId, ActionModel actionModel});
  Future<Response> performEditSupplier({SupplierModel anagraficaFornitore, ActionModel actionModel});
  Future<Response> removeProductFromOrder(ProductOrderAmountModel element);
  Future<Response> updateProductAmountIntoOrder(int pkOrderProductId, double amount, int pkProductId, int pk_order_id);
  Future<void>  updateUserData(UserDetailsModel userDetail);
  Future<List<WorkstationProductModel>> retrieveWorkstationProductModelByWorkstationId(WorkstationModel workstation);
  Future<List<EventModel>> retrieveEventsListByBranchId(BranchModel currentBranch);
  Future<List<EventModel>> retrieveEventsClosedListByBranchId(BranchModel currentBranch);
  Future updateWorkstationProductModel(List<WorkstationProductModel> workStationProdModelList, ActionModel actionModel);
  Future<Response> createCashRegister(CashRegisterModel cashRegisterModel);
  Future<Response> updateCashRegister(CashRegisterModel cashRegisterModel);
  Future<Response> deleteCashRegister(CashRegisterModel cashRegisterModel);
  Future<List<CashRegisterModel>> retrieveCashRegistersByBranchId(BranchModel branchModel);
  Future<Response> removeProductFromWorkstation(WorkstationProductModel prodModelWorkstation);
  Future<Response> updateEventModel(EventModel event);
  Future<List<String>> retrieveTokenList(BranchModel branchModel);

  Future<List<ExpenceEventModel>> retrieveEventExpencesByEventId(EventModel eventModel);
  Future<Response> updateEventExpenceModel(ExpenceEventModel expenceEventModel);
  Future<Response> createEventExpenceModel(ExpenceEventModel expenceEventModel);
  Future<Response> deleteEventExpenceModel(ExpenceEventModel expenceEventModel);
  Future<Response> moveProductBetweenStorage({List<MoveProductBetweenStorageModel> listMoveProductBetweenStorageModel, ActionModel actionModel});
  Future<Response> performEmptyStockStorage(StorageModel currentStorage);

  //Deposit order
  Future<Response> performInsertDepositOrder(DepositOrder depositOrder);
  Future<Response> performDeleteDepositOrder(DepositOrder depositOrder);
  Future<Response> performUpdateDepositOrder(DepositOrder depositOrder);
  Future<List<DepositOrder>> performRetrieveDepositOrderByOrderId(OrderModel orderModel);
}