import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_orders/Models/store.dart';
import 'package:warehouse_orders/Pages/home.dart';
import 'package:warehouse_orders/Pages/login.dart';
import 'Models/ReceivedNotification.dart';
import 'Pages/PagesWidget.dart';
import 'utility/Localizations/DemoLocalizations.dart';
import 'utility/Localizations/localization_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:warehouse_orders/Models/user.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}


class PaddedRaisedButton extends StatelessWidget {
  const PaddedRaisedButton({
    @required this.buttonText,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: RaisedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    ),
  );
}

class MyApp extends StatefulWidget {
  //final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  MyApp();

  // This widget is the root of your application.
  static void setLocale(BuildContext context , Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocal(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  Locale _locale;
  void setLocal(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }
  @override
  void initState() {
    getCurrentUser().then((user) {
      setState(() {
        currentUser.value = user;
      });
    });
    getCurrentStore().then((store) {
      setState(() {
        currentStore.value = store;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        DemoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: [
        const Locale('en', 'US'), // English, no country code
        const Locale('ar', 'EG'), // Hebrew, no country code
// ... other locales the app supports
      ],
      localeResolutionCallback: (deviceLocal , supportedLocals){
        for(var local in supportedLocals)
        {
          if(local.languageCode == deviceLocal.languageCode && local.countryCode  == deviceLocal.countryCode)
          {
            return deviceLocal;
          }
        }
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: !IsLogin  ? Login() : WalletHome(EmpName: prefs.getString("Name"),) ,
      home: currentUser.value.UserID == null  ? Login() : PagesWidget(currentTab: 0,) ,
      debugShowCheckedModeBanner: false,
    );
  }
}


