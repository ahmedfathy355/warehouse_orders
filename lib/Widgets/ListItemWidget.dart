import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_orders/Models/storeOrderItems.dart';
import 'package:warehouse_orders/Models/user.dart' as userRepo;
import 'package:warehouse_orders/utility/utils.dart';
import '../Models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// ignore: must_be_immutable
class ListItemWidget extends StatefulWidget {
//  String heroTag;
  Item item ;
  final String SOC ;
  final GlobalKey<ScaffoldState> parentScaffoldkey ;

  ListItemWidget({Key key, this.item , this.SOC ,this.parentScaffoldkey}) : super(key: key);
  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}


class _ListItemWidgetState extends State<ListItemWidget> {
  double Qty = 0 ;
  var con_Qty ;
  Color _back1 = const Color(0xFFe0eaf5);
  Color _back2 =const Color(0xFFfa5555);

  StreamSubscription connectivityStream;
  ConnectivityResult  connectivityResult;

  @override
  void initState() {
    listenForConnection();
    setState(() {
      //con_Qty = TextEditingController(text: widget.item.temp_qty == null ? '' : widget.item.temp_qty.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    // other dispose methods
    Qty = 0;
    setState(() {
      con_Qty.dispose();
    });
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
      else if (connectivityResult == ConnectivityResult.none){
        setState(() {
          Utils.isConnected = true;
        });
      }
      connectivityResult = new_result;
    });
  }

  @override
  Widget build(BuildContext context) {
    con_Qty = TextEditingController(text: widget.item.temp_qty == null ? '' : widget.item.temp_qty.toString());
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onDoubleTap: () {
        setState(() {
          con_Qty.Text = "";
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: widget.item.selected ? _back2 : _back1,
          boxShadow: [
            BoxShadow(
                color: widget.item.selected ? _back2 : _back1,
                blurRadius: 2,
                offset: Offset(0, 0)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 5),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.item.ItemName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).primaryTextTheme.subhead,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: <Widget>[
                      new Container(
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                        ),
                        child:  TextField(
                          controller: con_Qty,
                          keyboardType: TextInputType.number,
                          style:TextStyle(fontFamily: 'Roboto', fontSize: 17, color: const Color(0xff0d2137), ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).hintColor,
                        onPressed: () {
                          if(Utils.isConnected) {
                            if(!widget.item.selected) {
                              Qty = double.parse(con_Qty.text);
                              setState(() {
                                widget.item.selected = true;
                                widget.item.temp_qty = Qty;
                                AddItemToOrder(Qty);

                              });
                            }
                          }
                          else{
                            widget.parentScaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text('فشل , غير متصل بالانترنت'),
                            ));
                          }
                        },
                      )
                    ],
                  )
                  //Helper.getPrice(food.price, context, style: Theme.of(context).textTheme.display1),
                ],
              ),
            )
          ],
        ),
      ),
    );


  }

  void AddItemToOrder(double _Qty) async {
    var _orderitem = new StoreOrderItems();
    _orderitem.SOC = widget.SOC;
    _orderitem.ItemID = widget.item.ItemID;
    _orderitem.Qty = _Qty.toString();
    _orderitem.CreatedDate = DateTime.now().toString();
    updateOrderItm(_orderitem).then((value) {
//      setState(() {
//        this.loadCart = false;
//      });
      Utils.OrderHaveItems = true;
//      widget.parentScaffoldkey.currentState.showSnackBar(SnackBar(
//        content: Text('Item was added'),
//      ));
    });
  }
}

