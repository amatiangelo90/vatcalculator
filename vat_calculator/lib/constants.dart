import 'package:flutter/material.dart';
import 'package:vat_calculator/size_config.dart';

const Color kPrimaryColor = Color(0XFF66855F);
const Color kPinaColor = Colors.brown;

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
