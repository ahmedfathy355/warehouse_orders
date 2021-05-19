import 'package:warehouse_orders/Models/user.dart' as userRepo;
import 'package:warehouse_orders/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:warehouse_orders/utility/utils.dart';

class StoreOrderItems {
  String SOC;
  String ItemID;
  String Qty;
  String ItemUnitID;
  String CreatedDate;
  String CreatedBy_UserID;

  StoreOrderItems();

  StoreOrderItems.fromJSON(Map<Object, dynamic> jsonMap) {
    try {
      SOC = jsonMap['SOC'].toString();
      ItemID = jsonMap['ItemID'];
      Qty = jsonMap['Qty'];
      ItemUnitID = jsonMap['ItemUnitID'];
      CreatedDate = jsonMap['CreatedDate'];
      CreatedBy_UserID = jsonMap['CreatedBy_UserID'];

    } catch (e) {
      //print(jsonMap);
    }
  }
  Map toMap() {
    var map = new Map<Object, dynamic>();
    map["SOC"] = SOC;
    map["ItemID"] = ItemID;
    map["Qty"] = Qty;
    map["ItemUnitID"] = ItemUnitID;
    map["CreatedDate"] = CreatedDate;
    map["CreatedBy_UserID"] = CreatedBy_UserID;
    return map;
  }

//  double getOrderStatus() {
//    double result = order.price;
//    if (extras.isNotEmpty) {
//      extras.forEach((Extra extra) {
//        result += extra.price != null ? extra.price : 0;
//      });
//    }
//    return result;
//  }
//  double getOrderClosed() {
//    double result = product.price;
//    if (extras.isNotEmpty) {
//      extras.forEach((Extra extra) {
//        result += extra.price != null ? extra.price : 0;
//      });
//    }
//    return result;
//  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.SOC;
  }
}


Future<StoreOrderItems> updateOrderItm(StoreOrderItems orderItems) async {
  userRepo.User _user = userRepo.currentUser.value;
  if (_user.UserID == null) {
    return new StoreOrderItems();
  }
  Map<Object, dynamic> decodedJSON = {};
  //final String _apiToken = 'api_token=${_user.apiToken}';
  orderItems.CreatedBy_UserID = _user.UserID.toString();
  //final String url = '${Utils.restURL}orderItems/${orderItems.SOC}';
  final String url = '${Utils.restURL}orderItems';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(orderItems.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<Object, dynamic>;
  } on FormatException catch (e) {
    print("The provided string is not valid JSON addOrder");
  }
  return StoreOrderItems.fromJSON(decodedJSON);
}
