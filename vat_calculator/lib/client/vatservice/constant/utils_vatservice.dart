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
const String VAT_SERVICE_URL_SAVE_ORDER = 'http://$host:8080/vatservices/api/v1/create/order';

const String VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL = 'http://$host:8080/vatservices/api/v1/retrieve/user';
const String VAT_SERVICE_URL_RETRIEVE_BRANCHES_BY_USEREMAIL = 'http://$host:8080/vatservices/api/v1/retrieve/branches';
const String VAT_SERVICE_URL_RETRIEVE_RECESSED_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/recessed';
const String VAT_SERVICE_URL_RETRIEVE_SUPPLIER_BY_BRANCHES = 'http://$host:8080/vatservices/api/v1/retrieve/suppliers';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_SUPPLIER = 'http://$host:8080/vatservices/api/v1/retrieve/products';
const String VAT_SERVICE_URL_RETRIEVE_PRODUCTS_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/productsbybranch';
const String VAT_SERVICE_URL_RETRIEVE_STORAGE_BY_BRANCH = 'http://$host:8080/vatservices/api/v1/retrieve/storages';

const String VAT_SERVICE_URL_CHECK_SPECIAL_USER = 'http://$host:8080/vatservices/api/v1/check/specialuser';

//Update url
const String VAT_SERVICE_URL_UPDATE_PRODUCT = 'http://$host:8080/vatservices/api/v1/update/product';

//Delete
const String VAT_SERVICE_URL_DELETE_PRODUCT = 'http://$host:8080/vatservices/api/v1/delete/product';

//Retrieve Aggregated Tables
const String VAT_SERVICE_URL_RETRIEVE_RELATIONAL_PRODUCTS_STORAGE = 'http://$host:8080/vatservices/api/v1/retrieve/relation/productstorage';

//Remove product from storage
const String VAT_SERVICE_URL_REMOVE_PRODUCT_FROM_STORAGE = 'http://217.160.242.158:8080/vatservices/api/v1/delete/removeproductfromstorage';

//Update Stock
const String VAT_SERVICE_URL_UPDATE_STOCK = 'http://217.160.242.158:8080/vatservices/api/v1/update/stock';


