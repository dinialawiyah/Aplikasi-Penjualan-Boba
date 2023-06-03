class Topping {
  final String name;
  final double price;

  Topping({this.name, this.price});

  factory Topping.fromDatabase(Map<String, dynamic> dbRecords) {
    return Topping (
      name: dbRecords['name'],
      price: dbRecords['price'],
    );
  }
}

class Toppings {
  final List<Topping> toppings;

  Toppings({this.toppings});

  factory Toppings.fromDatabase(List<dynamic> queryRecord) {
    List<Topping> toppingsTemp = List<Topping>();

    toppingsTemp = queryRecord.map((e) => Topping.fromDatabase(e)).toList();

    return Toppings(
      toppings: toppingsTemp,
    );
  }
}