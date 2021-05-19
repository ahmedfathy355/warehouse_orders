import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:warehouse_orders/utility/utils.dart';
import 'itemsection.dart';
import 'itemtype.dart';

class Item {
  String ItemID;
  String ItemName;
  String ItemSectionID;
  String ItemSection;
  String ItemTypeID;
  String ItemType;
  bool selected = false;
  double temp_qty ;

  Item();

  Item.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      ItemID = jsonMap['ItemID'].toString();
      ItemName = jsonMap['ItemName'];
      ItemSectionID = jsonMap['ItemSectionID'];
      ItemSection = jsonMap['ItemSection'];
      ItemTypeID = jsonMap['ItemTypeID'];
      ItemType = jsonMap['ItemType'];
    } catch (e) {
      //print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ItemID"] = ItemID;
    map["ItemName"] = ItemName;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.ItemID == this.ItemID;
  }
}

Future<Stream<Item>> getItems(String orderCode) async {
  final String url = '${Utils.restURL}view_items/$orderCode';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));


  var _code = streamedRest.statusCode;

  return streamedRest
      .stream
      .transform(utf8.decoder)
      .transform(json.decoder)
  //.cast<Map<String, dynamic>>()
  //.map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Item.fromJSON(data));
}


