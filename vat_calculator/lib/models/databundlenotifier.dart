import 'package:flutter/foundation.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';

import 'databundle.dart';

class DataBundleNotifier extends ChangeNotifier {

  List<DataBundle> dataBundleList = [
  ];

  void addDataBundle(DataBundle bundle){
    print('Adding bundle to Notifier' + bundle.email.toString());
    dataBundleList.add(bundle);
    notifyListeners();
  }

  void addBranches(List<BranchModel> branchList) {

    dataBundleList[0].companyList.clear();
    dataBundleList[0].companyList = branchList;
    notifyListeners();
  }

  void clearAll(){
    dataBundleList.clear();
    notifyListeners();
  }
}