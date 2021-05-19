import 'package:flutter/material.dart';
import 'package:warehouse_orders/Models/storeOrder.dart';
import 'package:warehouse_orders/Widgets/CartItemWidget.dart';

class CartWidget extends StatefulWidget {
  CartWidget({Key key}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  List<StoreOrders> orders = <StoreOrders>[];
  @override
  void initState() {
    listenForStoreOrders(message: "refreshed successfuly");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshCarts,
          child: orders.isEmpty
              ? Container()
              : Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(bottom: 15),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            "قائمة الاوردرات",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.display1,
                          ),
                          subtitle: Text(
                            "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: orders.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 2);
                        },
                        itemBuilder: (context, index) {
                          return CartItemWidget( orders: orders[index], heroTag: 'order',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> refreshCarts() async {
    listenForStoreOrders(message: "refreshed successfuly");
  }

  void listenForStoreOrders({String message}) async {
    final Stream<StoreOrders> stream = await getStoreOrders();
    stream.listen((StoreOrders _storeOrders) {
//      if (!orders.contains(_storeOrders)) {
//      }
      setState(() {
        orders.add(_storeOrders);
      });
    }, onError: (a) {
      print(a);

    }, onDone: () {

    });
  }
}
