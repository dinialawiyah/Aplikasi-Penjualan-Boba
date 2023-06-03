class IceLevel {
  final String name;
  final double price;
  IceLevel({this.name, this.price});

  factory IceLevel.fromDatabase(Map<String, dynamic> dbrecord) {
    return IceLevel(
      name: dbrecord['name'],
      price: dbrecord['price'],
    );
  }
}

class IceLevels {
  final List<IceLevel> iceLevels;

  IceLevels({this.iceLevels});

  factory IceLevels.fromDatabase(List<dynamic> queryRecord) {
    List<IceLevel> il = List<IceLevel>();
    il = queryRecord.map((e) => IceLevel.fromDatabase(e)).toList();
    return IceLevels(
      iceLevels: il,
    );
  }
}