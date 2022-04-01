///Api
/// url test http://217.160.242.158:8080/
///
const String host = '217.160.242.158';
const String VAT_SERVICE_URL_SAVE_USER = 'http://$host:8080/vatservices/api/v1/create/user';
const String VAT_SERVICE_URL_SAVE_BRANCH = 'http://$host:8080/vatservices/api/v1/create/branch';
const String VAT_SERVICE_URL_SAVE_PRODUCT = 'http://$host:8080/vatservices/api/v1/create/product';
const String VAT_SERVICE_URL_SAVE_STORAGE_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/storage';
const String VAT_SERVICE_URL_SAVE_RECESSED_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/recessed';
const String VAT_SERVICE_URL_SAVE_EXPENCE_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/expence';
const String VAT_SERVICE_URL_SAVE_SUPPLIER_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/create/supplier';
const String VAT_SERVICE_URL_SAVE_PRODUCT_INTO_STORAGE = 'http://$host:8080/vatservices/api/v1/save/productinstorage';
const String VAT_SERVICE_URL_SAVE_PRODUCT_INTO_ORDER = 'http://$host:8080/vatservices/api/v1/save/productinorder';
const String VAT_SERVICE_URL_CREATE_WORKSTATIONS = 'http://$host:8080/vatservices/api/v1/create/workstations';
const String VAT_SERVICE_URL_SAVE_ORDER = 'http://$host:8080/vatservices/api/v1/create/order';
const String VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL = 'http://$host:8080/vatservices/api/v1/retrieve/user';
const String VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USER_ID = 'http://$host:8080/vatservices/api/v1/retrieve/branches';
const String VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/branchesbybranchid';
const String VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/recessed';
const String VAT_SERVICE_URL_RETRIEVE_EXPENCE_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/expences';
const String VAT_SERVICE_URL_RETRIEVE_ORDERS_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/orders';
const String VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/suppliers';
const String VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_CODE_ALIAS_EXTRA = 'http://$host:8080/vatservices/api/v1/retrieve/suppliersbycode';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_SUPPLIER = 'http://$host:8080/vatservices/api/v1/retrieve/products';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/productsbybranch';
const String VAT_SERVICE_URL_RETRIEVE_STORAGE_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/storages';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_ORDER_ID = 'http://$host:8080/vatservices/api/v1/retrieve/productsbyorderid';
const String VAT_SERVICE_URL_RETRIEVE_EVENTS_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/eventsbybranchid';
const String VAT_SERVICE_URL_RETRIEVE_CLOSED_EVENTS_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/closedeventsbybranchid';
const String VAT_SERVICE_URL_CHECK_SPECIAL_USER = 'http://$host:8080/vatservices/api/v1/check/specialuser';
const String VAT_SERVICE_ADD_SUPPLIER_TO_CURRENT_BRANCH = 'http://$host:8080/vatservices/api/v1/create/relationbranchsupplier';
//Update url
const String VAT_SERVICE_URL_UPDATE_PRODUCT = 'http://$host:8080/vatservices/api/v1/update/product';
const String VAT_SERVICE_URL_UPDATE_ORDER_STATUS_BY_ID = 'http://$host:8080/vatservices/api/v1/update/orderstatus';
const String VAT_SERVICE_URL_UPDATE_BRANCH_ADD_PROVIDER_FATTURE = 'http://$host:8080/vatservices/api/v1/update/branch/addproviderconfiguration';
const String VAT_SERVICE_URL_UPDATE_PRODUCT_AMOUNT_INTO_ORDER = 'http://$host:8080/vatservices/api/v1/update/amountproductinorder';
const String VAT_SERVICE_URL_UPDATE_SUPPLIER = 'http://$host:8080/vatservices/api/v1/update/supplier';
const String VAT_SERVICE_URL_UPDATE_EXPENCE = 'http://$host:8080/vatservices/api/v1/update/expence';
const String VAT_SERVICE_URL_UPDATE_RECESSED = 'http://$host:8080/vatservices/api/v1/update/recessed';
const String VAT_SERVICE_URL_UPDATE_USER_DATA = 'http://$host:8080/vatservices/api/v1/update/user';
const String VAT_SERVICE_URL_UPDATE_WORKSTATIONS_DETAILS = 'http://$host:8080/vatservices/api/v1/update/workstationdetails';
const String VAT_SERVICE_URL_UPDATE_AMOUNT_HUNDRED = 'http://$host:8080/vatservices/api/v1/update/amounthundredonstorage';
const String VAT_SERVICE_URL_UPDATE_BRANCH = 'http://$host:8080/vatservices/api/v1/update/branch';
const String VAT_SERVICE_URL_UPDATE_EVENT = 'http://$host:8080/vatservices/api/v1/update/event';

//Delete
const String VAT_SERVICE_URL_DELETE_PRODUCT = 'http://$host:8080/vatservices/api/v1/delete/product';
const String VAT_SERVICE_URL_DELETE_PRODUCT_FROM_ORDER = 'http://$host:8080/vatservices/api/v1/delete/productfromorder';
const String VAT_SERVICE_URL_DELETE_STORAGE = 'http://$host:8080/vatservices/api/v1/delete/storage';
const String VAT_SERVICE_URL_DELETE_ORDER = 'http://$host:8080/vatservices/api/v1/delete/order';
const String VAT_SERVICE_URL_REMOVE_SUPPLIER_FROM_BRANCH = 'http://$host:8080/vatservices/api/v1/remove/relationbranchsupplier';
const String VAT_SERVICE_URL_DELETE_EXPENCE = 'http://$host:8080/vatservices/api/v1/delete/expence';
const String VAT_SERVICE_URL_DELETE_WORKSTATION = 'http://$host:8080/vatservices/api/v1/delete/workstation';
const String VAT_SERVICE_URL_DELETE_RECESSED = 'http://$host:8080/vatservices/api/v1/delete/recessedbyid';
const String VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_WORKSTATION = 'http://$host:8080/vatservices/api/v1/delete/workstationproduct';

//Retrieve Aggregated Tables
const String VAT_SERVICE_URL_RETRIEVE_RELATIONAL_PRODUCTS_STORAGE = 'http://$host:8080/vatservices/api/v1/retrieve/relation/productstorage';
//Remove product from storage
const String VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE = 'http://$host:8080/vatservices/api/v1/delete/removeproductfromstorage';
//Update Stock
const String VAT_SERVICE_URL_UPDATE_STOCK = 'http://$host:8080/vatservices/api/v1/update/stock';
//Create relation between user and branch
const String VAT_SERVICE_URL_CREATE_RELATION_BETWEEN_USER_AND_BRANCH = 'http://$host:8080/vatservices/api/v1/create/userbranchrelation';
//Retrieve related users list on branch by branch id
const String VAT_SERVICE_URL_RETRIEVE_USERS_LIST_RELATIONED_ON_BRANCH_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/userslistbybranchid';
//update table users_branches with new privilege access for current user
const String VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_WITH_NEW_ACCESS_PRIVILEGE = 'http://$host:8080/vatservices/api/v1/update/userbranch/privilege';

//update table users_branches with new privilege access for current user
const String VAT_SERVICE_URL_UPDATE_USER_BRANCH_RELATION_TABLE_REFRESH_FIREBASE_TOKEN = 'http://$host:8080/vatservices/api/v1/update/userbranch/token';
const String VAT_SERVICE_URL_RETRIEVE_TOKEN_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/tokenslist';

// remove user branch relation
const String VAT_SERVICE_URL_REMOVE_USER_BRANCH_RELATION = 'http://$host:8080/vatservices/api/v1/remove/userbranchrelation';
// remove user branch relation
const String VAT_SERVICE_URL_REMOVE_PROVIDER_FROM_BRANCH = 'http://$host:8080/vatservices/api/v1/removeprovider';
// save action each time user perform operation on db
const String VAT_SERVICE_URL_ADD_ACTION_FOR_BRANCH = 'http://$host:8080/vatservices/api/v1/save/action';
// retrieve actions by branch id
const String VAT_SERVICE_URL_RETRIEVE_ACTIONS_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/actionsbybranchid';
const String VAT_SERVICE_URL_RETRIEVE_LASTWEEK_ACTIONS_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/lastactionsbybranchid';

const String VAT_SERVICE_URL_CREATE_EVENT = 'http://$host:8080/vatservices/api/v1/create/event';

const String VAT_SERVICE_URL_CREATE_WORKSTATIONS_PRODUCTSTORAGE_RELATION = 'http://$host:8080/vatservices/api/v1/createrelation/workstationsproductstorage';

const String VAT_SERVICE_URL_RETRIEVE_WORKSTATIONS_BY_EVENT_ID = 'http://$host:8080/vatservices/api/v1/retrieve/workstationlistbyeventid';
const String VAT_SERVICE_URL_RETRIEVE_WORKSTATION_PRODUCT_LIST_BY_WORKSTATION_ID = 'http://$host:8080/vatservices/api/v1/retrieve/productsbyworkstationid';
const String VAT_SERVICE_URL_UPDATE_WORKSTATIONS_PRODUCTS = 'http://$host:8080/vatservices/api/v1/update/workstationproducts';

// Cash registers api

const String VAT_SERVICE_URL_RETRIEVE_CASH_REGISTERS_BY_BRANCH_ID = 'http://$host:8080/vatservices/api/v1/retrieve/cashregisterbybranchid';
const String VAT_SERVICE_URL_UPDATE_CASH_REGISTER = 'http://$host:8080/vatservices/api/v1/update/cashregister';
const String VAT_SERVICE_URL_CREATAE_CASH_REGISTER = 'http://$host:8080/vatservices/api/v1/create/cashregister';
const String VAT_SERVICE_URL_DELETE_CASH_REGISTER = 'http://$host:8080/vatservices/api/v1/delete/cashregister';

