import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vat_calculator/size_config.dart';

const String kVersionApp = '1.0.82';
const Color kPrimaryColor = Color(0XFF0A2227);

const Color kCustomGreyBlue = Color(0XFF41414A);
const Color kPrimaryColorLight = Color(0XFF1c7701);
const Color kPinaColor = Color(0xFFFF2442);
const Color kCustomBordeaux = Color(0xFF7c1228);
const Color kBeigeColor = Color(0XFF80602F);
const Color kCustomWhite = Color(0xFFF5F6F9);
const Color kCustomBlue = Color(0xFF235789);
const Color kCustomGreenAccent = Color(0xFF187436);
const Color kCustomPinkAccent = Color(0xFFe8175d);
Color kCustomOrange = Colors.yellow.shade700.withOpacity(0.8);
const Color kCustomPurple = Color(0xFF9924ff);
const Color kCustomEvidenziatoreGreen = Color(0xFF0ABB9C);

const kPrimaryLightColor = Color(0xFFFFECDF);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

DateFormat dateFormat = DateFormat("dd-MM-yyyy");


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

String getStringDateFromDateTime(DateTime dateTime) {
  return getDayFromWeekDay(dateTime.weekday) + ' ' + dateTime.day.toString() + ' ' + getMonthFromMonthNumber(dateTime.month) + ' ' + dateTime.year.toString();
}

String refactorNumber(String number) {
  if(number.startsWith('+39')){
    return number;
  }else{
    return '+39' + number;
  }
}

String getDayFromWeekDay(int weekDay){
  switch(weekDay){
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
    default:
      return 'Error retrieve week day';
  }
}

String getDayFromWeekDayTrim(int weekDay){
  switch(weekDay){
    case 1:
      return 'Lun';
    case 2:
      return 'Mar';
    case 3:
      return 'Mer';
    case 4:
      return 'Gio';
    case 5:
      return 'Ven';
    case 6:
      return 'Sab';
    case 7:
      return 'Dom';
    default:
      return 'Error retrieve week day';
  }
}

bool isToday(DateTime currentDate) {
  DateTime now = DateTime.now();
  bool result = false;

  if (currentDate.day == now.day &&
      currentDate.month == now.month &&
      currentDate.year == now.year) {
    result = true;
  }
  return result;
}

String getMonthFromMonthNumber(int month){
  switch(month){
    case 1:
      return 'Gennaio';
    case 2:
      return 'Febbraio';
    case 3:
      return 'Marzo';
    case 4:
      return 'Aprile';
    case 5:
      return 'Maggio';
    case 6:
      return 'Giugno';
    case 7:
      return 'Luglio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Settembre';
    case 10:
      return 'Ottobre';
    case 11:
      return 'Novembre';
    case 12:
      return 'Dicembre';
    default:
      return 'Error retrieve week day';
  }
}


String getItalianMonthFromMonthName(String month){
  switch(month){
    case 'january':
      return 'Gennaio';
    case 'february':
      return 'Febbraio';
    case 'march':
      return 'Marzo';
    case 'april':
      return 'Aprile';
    case 'may':
      return 'Maggio';
    case 'june':
      return 'Giugno';
    case 'july':
      return 'Luglio';
    case 'august':
      return 'Agosto';
    case 'september':
      return 'Settembre';
    case 'october':
      return 'Ottobre';
    case 'november':
      return 'Novembre';
    case 'december':
      return 'Dicembre';
    default:
      return month;
  }

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
    default:
      return 'ERRORE';

  }
}


