class ItemSection {
  String ItemSectionID;
  String itemSection;


  ItemSection();

  ItemSection.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      ItemSectionID = jsonMap['ItemSectionID'].toString();
      itemSection = jsonMap['ItemSection1'];
    } catch (e) {
      //print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ItemSectionID"] = ItemSectionID;
    map["ItemSection"] = itemSection;

    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.ItemSectionID == this.ItemSectionID;
  }
}

