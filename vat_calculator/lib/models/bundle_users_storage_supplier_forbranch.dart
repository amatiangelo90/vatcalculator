import 'dart:core';

import 'package:vat_calculator/client/fattureICloud/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';

class BundleUserStorageSupplier{

  int _pkBranchId;
  List<StorageModel> _storageModelList;
  List<UserModel> _userModelList;
  List<ResponseAnagraficaFornitori> _supplierModelList;

  BundleUserStorageSupplier(this._pkBranchId, this._storageModelList,
      this._userModelList, this._supplierModelList);

  List<ResponseAnagraficaFornitori> get supplierModelList => _supplierModelList;

  set supplierModelList(List<ResponseAnagraficaFornitori> value) {
    _supplierModelList = value;
  }

  List<UserModel> get userModelList => _userModelList;

  set userModelList(List<UserModel> value) {
    _userModelList = value;
  }

  List<StorageModel> get storageModelList => _storageModelList;

  set storageModelList(List<StorageModel> value) {
    _storageModelList = value;
  }

  int get pkBranchId => _pkBranchId;

  set pkBranchId(int value) {
    _pkBranchId = value;
  }
}