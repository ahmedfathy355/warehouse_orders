import 'package:flutter/material.dart';
import '../Models/item.dart';


class ItemWidget extends StatelessWidget {
  final String heroTag;
  final Item item;

  const ItemWidget({Key key, this.item, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => ItemWidget(item: item, heroTag: this.heroTag)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + item.ItemName,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
//                child: CachedNetworkImage(
//                  height: 60,
//                  width: 60,
//                  fit: BoxFit.cover,
//                  imageUrl: food.image.thumb,
//                  placeholder: (context, url) => Image.asset(
//                    'assets/img/loading.gif',
//                    fit: BoxFit.cover,
//                    height: 60,
//                    width: 60,
//                  ),
//                  errorWidget: (context, url, error) => Icon(Icons.error),
//                ),
              ),
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
                          item.ItemName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          item.ItemSection,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2),
                  //Helper.getPrice(food.price, context, style: Theme.of(context).textTheme.display1),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
