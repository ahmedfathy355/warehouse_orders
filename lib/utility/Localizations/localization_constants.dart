import '../Localizations/DemoLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslated(BuildContext context , String key){
  return DemoLocalizations.of(context).getTranslatedValue(key);
}

const String English = 'en';
const String Arabic = 'ar';
const String Chinese = 'zh';

const String LANGUAGE_CODE = 'languageCode';
const String Language_Index = 'languageIndex';

Future<Locale> setLocale(String languageCode , int languageIndex) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LANGUAGE_CODE, languageCode);
  await prefs.setInt(Language_Index, languageIndex);
  return _locale(languageCode , languageIndex);

}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = await prefs.getString(LANGUAGE_CODE) ?? 'en';
  int languageIndex = await prefs.getInt(Language_Index) ?? 1;
  return _locale(languageCode , languageIndex);
}

Locale _locale(String languageCode , languageIndex)
{
  Locale _temp;
  switch(languageIndex){
    case 0:
      languageCode = 'en';
      _temp = Locale(languageCode, 'US');
      break;
    case 1:
      languageCode = 'ar';
      _temp = Locale(languageCode, 'EG');
      break;
    case 2:
      languageCode = 'zh';
      _temp = Locale(languageCode, 'HK');
      break;
    default:
      _temp = Locale(English, 'US');
  }
  return _temp;
}