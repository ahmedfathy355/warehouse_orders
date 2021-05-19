import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_orders/Pages/storeItems.dart';
import 'package:warehouse_orders/Widgets/DrawerWidget.dart';
import 'package:warehouse_orders/Widgets/LocalNotificationScreen.dart';



class Home extends StatefulWidget {
  GlobalKey<ScaffoldState> parentScaffoldKey;

  Home({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    //widget.parentScaffoldKey = new GlobalKey<ScaffoldState>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: ()  {
              widget.parentScaffoldKey.currentState.openDrawer();
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
          "Masrawy Fast Food",
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
//          actions: <Widget>[
//            Padding(
//              padding: EdgeInsets.only(right: 10,left: 10),
//              child:  Icon(
//                Icons.shopping_basket,
//                color: Theme.of(context).hintColor,
//              ),
//            )
//          ],
        ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20,bottom: 10),
            child: FlatButton(
              onPressed: () {
                String _SOC = DateTime.now().millisecondsSinceEpoch.toString();
                Navigator.push(context, new MaterialPageRoute(builder: (context) => StoreItems(parentScaffoldkey: widget.parentScaffoldKey,SOC: _SOC,OrderType: "2")));
              },
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              color: Theme.of(context).accentColor.withOpacity(0.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "طلب النواقص من المعمل",
                style: Theme.of(context).textTheme.title.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20,bottom: 20),
            child: FlatButton(
              onPressed: () {
                String _SOC = DateTime.now().millisecondsSinceEpoch.toString();
                Navigator.push(context, new MaterialPageRoute(builder: (context) => StoreItems(parentScaffoldkey: widget.parentScaffoldKey,SOC: _SOC ,OrderType: "1",)));
              },
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              color: Theme.of(context).accentColor.withOpacity(0.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "طلب النواقص من المخزن",
                style: Theme.of(context).textTheme.title.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              ),
            ),
          ),
//          FlatButton(child: Text("notifi"),
//          onPressed: () {
//;
//            Navigator.push(context, new MaterialPageRoute(builder: (context) => LocalNotificationScreen()));
//          },),
          //المعمل
//          ListTile(
//            onTap: () {
//              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Orders(parentScaffoldkey: widget.parentScaffoldKey,OrderCode: "1",OrderType: "StoreOrder",)));
//            },
//            leading: Icon(
//              Icons.border_style,
//              color: Theme.of(context).focusColor.withOpacity(1),
//            ),
//            title: Text(
//              "طلب النواقص من المعمل",
//              style: Theme.of(context).textTheme.title.merge(TextStyle(color: Theme.of(context).accentColor)),
//            ),
//          ),
        ],
      )
    );
  }
}
