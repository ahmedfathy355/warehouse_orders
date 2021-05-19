import 'package:warehouse_orders/Models/store.dart';
import 'package:warehouse_orders/Models/user.dart' as userRepo;
import 'package:warehouse_orders/Models/store.dart' as storeRepo;
import 'package:warehouse_orders/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:warehouse_orders/utility/utils.dart';

class StoreOrders {

  String SOC;
  int SenderID;
  int ReceiverID;
  String CreatedDate;
  String CreatTime;
  int Createdby_UserID;
  String DeletedDate;
  int DeletedBy_UserID;
//  String Received;
//  String ReceivedDate;
//  String ReceivedTime;
//  String ReceivedBy;
  bool IsSend;

  StoreOrders();

  StoreOrders.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      SOC = jsonMap['SOC'] as String;
      SenderID = jsonMap['SenderID'];
      ReceiverID = jsonMap['ReceiverID'];
      CreatedDate = jsonMap['CreatedDate'] as String;
      CreatTime = jsonMap['CreatTime'] as String;
      Createdby_UserID = jsonMap['Createdby_UserID'];
      DeletedDate = jsonMap['DeletedDate'] as String;
      DeletedBy_UserID = jsonMap['DeletedBy_UserID'];
//      Received = jsonMap['Received'];
//      ReceivedDate = jsonMap['ReceivedDate'];
//      ReceivedTime = jsonMap["ReceivedTime"];
//      ReceivedBy = jsonMap["ReceivedBy"];
      IsSend = jsonMap["IsSend"] as bool;

    } catch (e) {
      //print(jsonMap);
    }
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["SOC"] = SOC as String;
    map["SenderID"] = SenderID as int;
    map["ReceiverID"] = ReceiverID as int;
    map["CreatedDate"] = CreatedDate as String;
    map["CreatTime"] = CreatTime as String;
    map["Createdby_UserID"] = Createdby_UserID as int;
    map["DeletedDate"] = DeletedDate as String;
    map["DeletedBy_UserID"] = DeletedBy_UserID as int;
//    map["Received"] = Received;
//    map["ReceivedDate"] = ReceivedDate;
//    map["ReceivedTime"] = ReceivedTime;
//    map["ReceivedBy"] = ReceivedBy;
    map["IsSend"] = IsSend as bool;
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

Future<Stream<StoreOrders>> getStoreOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.UserID == null) {
    return new Stream.value(null);
  }
  //final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${Utils.restURL}storeorders/${_user.UserID}';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  //return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
  return streamedRest
      .stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((data) => (data as List))
      .map((data) => StoreOrders.fromJSON(data));

}

Future<StoreOrders> addOrder(StoreOrders order) async {
  User _user = userRepo.currentUser.value;
  Store _store = storeRepo.currentStore.value;
  if (_user.UserID == null) {
    return new StoreOrders();
  }
  Map<String, dynamic> decodedJSON = {};
//  final String _apiToken = 'api_token=${_user.apiToken}';
//  final String _resetParam = 'reset=${reset ? 1 : 0}';
  order.Createdby_UserID = _user.UserID;
  order.SenderID = int.parse(_store.StoreID) ;
  final String url = '${Utils.restURL}orders';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
  } on FormatException catch (e) {
    print("The provided string is not valid JSON addOrder");
  }
  return StoreOrders.fromJSON(decodedJSON);
}

Future<StoreOrders> updateSendOrder(StoreOrders order) async {
//  User _user = userRepo.currentUser.value;
//  if (_user.apiToken == null) {
//    return new StoreOrders();
//  }
  final String url = '${Utils.restURL}orders/${order.SOC}';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.toMap()),
  );
  return StoreOrders.fromJSON(json.decode(response.body)['data']);
}


