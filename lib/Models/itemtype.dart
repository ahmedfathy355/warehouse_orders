class ItemType {
  String ItemTypeID;
  String itemType;


  ItemType();

  ItemType.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      ItemTypeID = jsonMap['ItemTypeID'].toString();
      itemType = jsonMap['ItemType1'];
    } catch (e) {
      //print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ItemTypeID"] = ItemTypeID;
    map["ItemType"] = itemType;

    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.ItemTypeID == this.ItemTypeID;
  }
}

