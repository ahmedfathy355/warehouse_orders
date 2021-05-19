import 'package:flutter/material.dart';
import 'package:warehouse_orders/Models/storeOrder.dart';
import 'package:warehouse_orders/Models/storeOrderItems.dart';


class CartItemWidget extends StatefulWidget {
  String heroTag;
  StoreOrders orders;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget({Key key, this.orders, this.heroTag, this.increment, this.decrement, this.onDismissed}) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.orders.SOC),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          //Navigator.of(context).pushNamed('/Food', arguments: RouteArgument(id: widget.cart.food.id, heroTag: widget.heroTag));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.orders.CreatedDate.toString() ,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subhead,
                          ),

                          //Helper.getPrice(widget.cart.food.price, context, style: Theme.of(context).textTheme.display1)
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon:  widget.orders.IsSend == null ? Icon(Icons.arrow_upward) : Container(),
                          color: Theme.of(context).hintColor,
                        ),
                        //Text(widget.orders.SenderID.toString(), style: Theme.of(context).textTheme.subhead),
//                        IconButton(
//                          onPressed: () {
//                            setState(() {
//                              widget.decrement();
//                            });
//                          },
//                          iconSize: 30,
//                          padding: EdgeInsets.symmetric(horizontal: 5),
//                          icon: Icon(Icons.remove_circle_outline),
//                          color: Theme.of(context).hintColor,
//                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
