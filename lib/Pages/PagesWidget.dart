import 'package:flutter/material.dart';
import 'package:warehouse_orders/Pages/Cart.dart';
import 'package:warehouse_orders/Widgets/DrawerWidget.dart';
import '../pages/home.dart';


// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  int currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage = Home();
  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 0;
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = Home(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = CartWidget();
          break;
        case 2:
          //widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          //widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          //widget.currentPage = FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 32,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            new BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: new Icon(Icons.home,),
                title: new Text("الرئيسية", style: new TextStyle(
                    color: const Color(0xFF06244e), fontSize: 14.0))),
            new BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: new Icon(Icons.shopping_basket,),
                title: new Text("قائمة الاوردرات", style: new TextStyle(
                    color: const Color(0xFF06244e), fontSize: 14.0))),

//            BottomNavigationBarItem(
//              icon: Icon(Icons.person),
//              title: new Container(height: 0.0),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.notifications),
//              title: new Container(height: 0.0),
//            ),


          ],
        ),
      ),
    );
  }
}
