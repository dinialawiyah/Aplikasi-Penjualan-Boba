class MilkType {
  final String name;
  final double price;

  MilkType({this.name, this.price});

  factory MilkType.fromDatabase(Map<String, dynamic> dbRecord) {
    return MilkType(
      name: dbRecord['name'],
      price: dbRecord['price'],
    );
  }
}

class MilkTypes {
  final List<MilkType> milkTypes;

  MilkTypes({this.milkTypes});

  factory MilkTypes.fromDatabase(List<dynamic> queryRecord) {
    List<MilkType> milkTypesTemp = List<MilkType>();
    milkTypesTemp = queryRecord.map((e) => MilkType.fromDatabase(e)).toList();

    return MilkTypes(
      milkTypes: milkTypesTemp,
    );
  }
}