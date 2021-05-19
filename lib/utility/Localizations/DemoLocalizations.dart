import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalizations{
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, String> _localizedValues;

  Future load() async {
    String jsonstriingvalue = await rootBundle.loadString('lib/utility/Localizations/lang/${locale.languageCode}.json');
 
    
    Map<String,dynamic> mappedJson = json.decode(jsonstriingvalue);
    
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));

  }

  String getTranslatedValue (String key){
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<DemoLocalizations> delegate = _DemolocalizationDelegate();
}

class _DemolocalizationDelegate extends LocalizationsDelegate<DemoLocalizations>{
  const _DemolocalizationDelegate();
  @override
  bool isSupported(Locale locale){
    return{'en','ar','zh'}.contains(locale.languageCode);
  }

  @override
  Future<DemoLocalizations> load(Locale locale) async{
    DemoLocalizations localizations = new DemoLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_DemolocalizationDelegate old) => false ;
}