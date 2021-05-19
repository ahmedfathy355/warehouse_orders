import 'package:flutter/material.dart';
import 'package:warehouse_orders/Models/item.dart';


class ItemGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Item item;
  final VoidCallback onPressed;

  ItemGridItemWidget({Key key, this.heroTag, this.item, this.onPressed}) : super(key: key);

  @override
  _ItemGridItemWidgetState createState() => _ItemGridItemWidgetState();
}

class _ItemGridItemWidgetState extends State<ItemGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        //Navigator.of(context).pushNamed('/Food', arguments: new RouteArgument(heroTag: this.widget.heroTag, id: this.widget.food.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.item.ItemID,
                  child: Container(
                    decoration: BoxDecoration(
                      //image: DecorationImage(image: NetworkImage(this.widget.food.image.thumb), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.item.ItemName,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                widget.item.ItemSection,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                print('onpressed');
                widget.onPressed();
              },
              child: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
