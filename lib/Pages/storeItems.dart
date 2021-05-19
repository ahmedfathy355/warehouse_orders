import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_orders/Models/item.dart';
import 'package:warehouse_orders/Models/store.dart' as storeRepo;
import 'package:warehouse_orders/Models/storeOrder.dart';
import 'package:warehouse_orders/Widgets/GridItemWidget.dart';
import 'package:warehouse_orders/Widgets/ItemWidget.dart';
import 'package:warehouse_orders/Widgets/ListItemWidget.dart';
import 'package:warehouse_orders/Widgets/SearchBarWidget.dart';
import 'package:warehouse_orders/utility/utils.dart';


class StoreItems extends StatefulWidget {

  final GlobalKey<ScaffoldState> parentScaffoldkey ;
  final String OrderType  ;
  final String SOC ;
  StoreItems({Key key, this.parentScaffoldkey,this.SOC , this.OrderType}) : super(key: key);
  @override
  _StoreItemsState createState() => _StoreItemsState();
}

class _StoreItemsState extends State<StoreItems> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Item> listItems = <Item>[];
  List<Item> listItems_filterd = <Item>[];
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  var formatter_time = new DateFormat('H:mm');
  TextEditingController _searchController = TextEditingController();

  StreamSubscription connectivityStream;
  ConnectivityResult  connectivityResult;

  @override
  void initState() {
    isPingHost();
    creatOrder();
    listenForItems();
    super.initState();
  }

  @override
  void dispose() {
    connectivityStream.cancel();
    super.dispose();
  }

  void listenForConnection() async{
    connectivityStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult new_result) {
      if(new_result == ConnectivityResult.none){
        setState(() {
          Utils.isConnected = false;
        });
      }
      else if (new_result == ConnectivityResult.wifi || new_result == ConnectivityResult.mobile ){
        setState(() {
          Utils.isConnected = true;
        });
      }
      connectivityResult = new_result;
    });
  }

  void isPingHost() async{
      try{
        final result = await InternetAddress.lookup('google.com');
        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty)
          {
            setState(() {
              Utils.isConnected = true;
            });
          }
        else{
          setState(() {
            Utils.isConnected = false;
          });
        }
      } on SocketException catch(_){
        setState(() {
          Utils.isConnected = false;
        });
      }
  }

  void checkConnectivity() async{
    try{
      final conn_result = await (Connectivity().checkConnectivity()) ;
      if(conn_result == ConnectivityResult.mobile || conn_result == ConnectivityResult.wifi)
      {
        setState(() {
          Utils.isConnected = true;
        });
      }
      else if(conn_result == ConnectivityResult.none){
        Utils.isConnected = false;
      }
    } on SocketException catch(_){
      Utils.isConnected = false;
    }
  }

  void creatOrder() async {
    try {
      var _order = new StoreOrders();
      _order.SOC = widget.SOC;
      _order.ReceiverID = int.parse(widget.OrderType) ;
      _order.CreatedDate = DateTime.now().toString();
      _order.CreatTime = formatter_time.format(now).toString();
      addOrder(_order).then((value) {
//      setState(() {
//        this.loadCart = false;
//      });
//        widget.parentScaffoldkey.currentState.showSnackBar(SnackBar(
//          content: Text('This was added'),
//        ));
      });
    }
    catch (ex)
    {}
  }

  void updateOrder() async {
    try {
      var _order = new StoreOrders();
      _order.SOC = widget.SOC;
      _order.IsSend = true;

      updateSendOrder(_order).then((value) {
//      setState(() {
//        this.loadCart = false;
//      });
        widget.parentScaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text('This was added'),
        ));
      });
    }
    catch (ex)
    {}
  }

  void listenForItems() async {
    final Stream<Item> stream = await getItems(widget.OrderType);
    stream.listen((Item _item) {
      setState(()
          {
            listItems.add(_item);
            listItems_filterd.add(_item);
          }
      );
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(7, 120, 7, 55),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ListItems()
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(7, 90, 7, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).focusColor.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(4)),
            child: SearchBar(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(7, 20, 7, 0),
            child: From(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(7, 60, 7, 0),
            child: To(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                  ),
                  color:  const  Color(0xff3c82ff) ,
                  highlightColor: Colors.blueGrey,
                  elevation: 5,
                  onPressed: (){
                    isPingHost();
                    if(Utils.isConnected && Utils.OrderHaveItems )
                    {
                      updateOrder();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Utils.isConnected ? Text(
                    'ارسال',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      color: const Color(0xffffffff),
                    ),
                  ) : Text(
                    'فشل ، غير متصل بالانترنت',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      color:Colors.yellow,
                    ),
                  ),
                )
            ),
          )
        ],
      ),
    );

  }

  Widget From() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        dense: true,
        //contentPadding: EdgeInsets.symmetric(vertical: 20),
        leading: Icon(
          Icons.home,
          color: Theme.of(context).hintColor,
        ),
        title: Text(
           " من   : " + storeRepo.currentStore.value.StoreName,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget To() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        dense: true,
        //contentPadding: EdgeInsets.symmetric(vertical: 20),
        leading: Icon(
          Icons.send,
          color: Theme.of(context).hintColor,
        ),
        title: Text(
           widget.OrderType == "2" ?  "  الى  : المعمل" : "  الى  : المخزن",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget SearchBar()
  {
     return Padding(
       padding: const EdgeInsets.only(right: 12, left: 12),
       child: TextField(
         decoration: InputDecoration(
             contentPadding: EdgeInsets.all(10),
             icon: Icon(Icons.search),
             hintText: "ابحث عن صنف أو منتج"
         ),
         onChanged: (string){
           _debouncer.run(() {
             setState(() {
               //listItems_filterd = listItems.where((nm) { nm.ItemName.toLowerCase().contains(string.toLowerCase());}).toList();
               listItems_filterd = listItems.where((nm) => nm.ItemName.contains(string)
               ).toList();
             });
           });

         },
       ),
     );
  }

  Widget ListItems()
  {
    return listItems_filterd.isEmpty
        ? Center(child: CircularProgressIndicator(),)
        : ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: listItems_filterd.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 2,);
      },
      itemBuilder: (context, index) {
        return new ListItemWidget(item: listItems_filterd[index],SOC: widget.SOC,parentScaffoldkey: widget.parentScaffoldkey,);
      },
    );
  }

  Widget SearchBar1()
  {
    var _controller = TextEditingController();
    return TextField(
      controller: _controller,
      decoration: InputDecoration(

        icon: Icon(Icons.search),
        hintText: "ابحث عن صنف أو منتج",
        suffixIcon: IconButton(
          onPressed: () => _controller.clear(),
          icon: Icon(Icons.clear),
        ),
      ),
      onChanged: (string){
        setState(() {
          listItems_filterd = listItems.where((nm) {
            nm.ItemName.toLowerCase().contains(string.toLowerCase());
          }).toList();
        });

      },
    );
  }

}

class Debouncer{
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action){
    if(null != _timer){
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds),action);
  }

}