///Api
/// url test http://217.160.242.158:8080/

const String host = '217.160.242.158';

const String VAT_SERVICE_URL_SAVE_USER = 'http://$host:8080/vatservices/api/v1/create/user';
const String VAT_SERVICE_URL_SAVE_BRANCH = 'http://$host:8080/vatservices/api/v1/create/branch';
const String VAT_SERVICE_URL_SAVE_PRODUCT = 'http://$host:8080/vatservices/api/v1/create/product';
const String VAT_SERVICE_URL_SAVE_STORAGE_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/storage';
const String VAT_SERVICE_URL_SAVE_RECESSED_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/recessed';
const String VAT_SERVICE_URL_SAVE_SUPPLIER_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/supplier';
const String VAT_SERVICE_URL_SAVE_PRODUCT_INTO_STORAGE = 'http://$host:8080/vatservices/api/v1/save/productinstorage';
const String VAT_SERVICE_URL_SAVE_PRODUCT_INTO_ORDER = 'http://$host:8080/vatservices/api/v1/save/productinorder';
const String VAT_SERVICE_URL_SAVE_ORDER = 'http://$host:8080/vatservices/api/v1/create/order';

const String VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL = 'http://$host:8080/vatservices/api/v1/retrieve/user';
const String VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USEREMAIL = 'http://$host:8080/vatservices/api/v1/retrieve/branches';
const String VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/branchesbybranchid';
const String VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/recessed';
const String VAT_SERVICE_URL_RETRIEVE_ORDERS_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/orders';
const String VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/suppliers';
const String VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_CODE_ALIAS_EXTRA = 'http://$host:8080/vatservices/api/v1/retrieve/suppliersbycode';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_SUPPLIER = 'http://$host:8080/vatservices/api/v1/retrieve/products';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/productsbybranch';
const String VAT_SERVICE_URL_RETRIEVE_STORAGE_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/storages';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID = 'http://$host:8080/vatservices/api/v1/retrieve/productsbyorderid';

const String VAT_SERVICE_URL_CHECK_SPECIAL_USER = 'http://$host:8080/vatservices/api/v1/check/specialuser';

const String VAT_SERVICE_ADD_SUPPLIER_TO_CURRENT_BRANCH = 'http://$host:8080/vatservices/api/v1/create/relationbranchsupplier';

//Update url
const String VAT_SERVICE_URL_UPDATE_PRODUCT = 'http://$host:8080/vatservices/api/v1/update/product';
const String VAT_SERVICE_URL_UPDATE_ORDER_STATUS_BY_ID = 'http://$host:8080/vatservices/api/v1/update/orderstatus';
const String VAT_SERVICE_URL_UPDATE_BRANCH_ADD_PROVIDER_FATTURE = 'http://$host:8080/vatservices/api/v1/update/branch/addproviderconfiguration';

//Delete
const String VAT_SERVICE_URL_DELETE_PRODUCT = 'http://$host:8080/vatservices/api/v1/delete/product';
const String VAT_SERVICE_URL_DELETE_STORAGE = 'http://$host:8080/vatservices/api/v1/delete/storage';
const String VAT_SERVICE_URL_DELETE_ORDER = 'http://$host:8080/vatservices/api/v1/delete/order';
const String VAT_SERVICE_URL_REMOVE_SUPPLIER_FROM_BRANCH = 'http://$host:8080/vatservices/api/v1/remove/relationbranchsupplier';

//Retrieve Aggregated Tables
const String VAT_SERVICE_URL_RETRIEVE_RELATIONAL_PRODUCTS_STORAGE
= 'http://$host:8080/vatservices/api/v1/retrieve/relation/productstorage';

//Remove product from storage
const String VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE = 'http://217.160.242.158:8080/vatservices/api/v1/delete/removeproductfromstorage';

//Update Stock
const String VAT_SERVICE_URL_UPDATE_STOCK = 'http://217.160.242.158:8080/vatservices/api/v1/update/stock';

//Create relation between user and branch
const String VAT_SERVICE_URL_CREATE_RELATION_BETWEEN_USER_AND_BRANCH = 'http://$host:8080/vatservices/api/v1/create/userbranchrelation';
//Retrieve related users list on branch by branch id
const String VAT_SERVICE_URL_RETRIEVE_USERS_LIST_RELATIONED_ON_BRANCH_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/userslistbybranchid';
//update table users_branches with new privilege access for current user
const String VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_WITH_NEW_ACCESS_PRIVILEGE = 'http://$host:8080/vatservices/api/v1/update/userbranch/privilege';
// remove user branch relation
const String VAT_SERVICE_URL_REMOVE_USER_BRANCH_RELATION = 'http://$host:8080/vatservices/api/v1/remove/userbranchrelation';
