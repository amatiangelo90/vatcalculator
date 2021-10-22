import 'package:flutter/material.dart';
import 'package:vat_calculator/size_config.dart';

//const Color kPrimaryColor = Color(0XFF66855F);
//const Color kPrimaryColor = Color(0XFF127410);

//Draft https://www.color-hex.com/color-palette/115661
//#081730	(8,23,48)
// #2c3c5c	(44,60,92)
// #171717	(23,23,23)
// #e38f54	(227,143,84)
// #152440	(21,36,64)


//#2f4a36	(47,74,54)
// #405169	(64,81,105)
// #e7e5e1	(231,229,225)
// #a8acab	(168,172,171)
// #d2c5b9	(210,197,185)
const Color kPrimaryColor = Color(0XFF2f4a36);
const Color kPinaColor = Color(0XFF803037);
const Color kBeigeColor = Color(0XFFd2c5b9);
const Color kCustomWhite = Color(0xFFF5F6F9);
const Color kCustomBlue = Color(0xFF405169);

const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Inserisci la mail";
const String kInvalidEmailError = "Inserisci una mail valida";
const String kPassNullError = "Inserisci la password";
const String kDataTreatmentFalseError = "Consenti al trattamento dati";
const String kShortPassError = "Password troppo corta";
const String kMatchPassError = "Le password non corrispondono";
const String kNamelNullError = "Inserisci il tuo nome";
const String kImportNullError = "Inserisci l\'importo";
const String kInvalidImportNullError = "Inserire un importo valido";
const String kCasualeExpenceNullError = "Inserisci la casuale";
const String kPhoneNumberNullError = "Inserisci il tuo numero di cellulare";
const String kAddressNullError = "Inserisci il tuo indirizzo";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

String getNameDayFromWeekDay(int weekday) {
  switch(weekday){
    case 1:
      return 'Lunedi';
    case 2:
      return 'Martedi';
    case 3:
      return 'Mercoledi';
    case 4:
      return 'Giovedi';
    case 5:
      return 'Venerdi';
    case 6:
      return 'Sabato';
    case 7:
      return 'Domenica';

  }
}
