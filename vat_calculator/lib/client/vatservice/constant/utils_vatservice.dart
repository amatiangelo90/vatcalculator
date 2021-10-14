///Api
/// url test http://217.160.242.158:8080/
///
// POST
//
// Salva utente:
const String VAT_SERVICE_URL_SAVE_USER = 'http://217.160.242.158:8080/vatservices/api/saveuser';
const String VAT_SERVICE_URL_SAVE_BRANCH = 'http://217.160.242.158:8080/vatservices/api/createbranch';
const String VAT_SERVICE_URL_RETRIEVE_USER_BY_EMAIL = 'http://217.160.242.158:8080/vatservices/api/retrieveuserbyemail';

// http://217.160.242.158:8080/vatservices/api/saveuser
// {
//    "name": "asd",
//    "lastName": "asd",
//    "phone": "asd",
//    "mail": "df"
// }
//
// POST
// http://217.160.242.158:8080/vatservices/api/retrievemodelmser
//
// POST
// http://217.160.242.158:8080/vatservices/api/retrievemodelbranch
//
//
// http://217.160.242.158:8080/vatservices/api/saveuser
//
// {
//    "pkBranchId": 1,
//    "name": "branch",
//    "vatNumber": "123123123",
//    "address": "via del tormento 32",
//    "phone": "4343234234",
//    "provider": "aruba",
//    "idKeyUser": "XXXXXXXXXXXXXXXXX",
//    "idUidPassword": "XXXXXXXXXXXXXXX",
//    "fkUserId": 1
// }