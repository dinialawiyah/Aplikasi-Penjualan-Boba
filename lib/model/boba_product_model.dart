class BobaProductModel {
  String name;
  String description;
  double price;
  String imageId;

  BobaProductModel({this.name, this.description, this.price, this.imageId});

  factory BobaProductModel.fromDatabase(Map<String, dynamic> dbrecord) {
    return BobaProductModel(
      name: dbrecord['name'],
      description: dbrecord['description'],
      price: dbrecord['price'],
      imageId: dbrecord['imageId'],
    );
  }
}

class BobaProducts {
  final List<BobaProductModel> products;

  BobaProducts({this.products});

  factory BobaProducts.fromDatabase(List<dynamic> queryRecords) {
    List<BobaProductModel> bobaProducts = List<BobaProductModel>();
    bobaProducts = queryRecords.map((e) => BobaProductModel.fromDatabase(e)).toList();
    return BobaProducts(products: bobaProducts);
  }
}