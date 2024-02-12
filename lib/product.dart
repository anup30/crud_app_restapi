// json to dart: https://javiercbk.github.io/json_to_dart/ // just paste an input of an item there.
class Product {
  String? id; // _id
  String? productName;
  String? productCode;
  String? image;
  String? unitPrice;
  String? quantity;
  String? totalPrice;
  String? createdDate;

  Product(
      {this.id,
        this.productName,
        this.productCode,
        this.image,
        this.unitPrice,
        this.quantity,
        this.totalPrice,
        this.createdDate}
      );
  // model(pazo) class
  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    image = json['Img'];
    unitPrice = json['UnitPrice'];
    quantity = json['Qty'];
    totalPrice = json['TotalPrice'];
    createdDate = json['CreatedDate'];
  }
  Map<String, dynamic> toJson() {
    return{
    "_id" : id,
    "ProductName" : productName,
    "ProductCode" : productCode,
    "Img" : image,
    "UnitPrice" : unitPrice,
    "Qty" : quantity,
    "TotalPrice" : totalPrice,
    "CreatedDate" : createdDate,
    };
  }

  /*Map<String, dynamic> toJson() { // <---------------------
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id; // _id
    data["ProductName"] = productName;
    data["ProductCode"] = productCode;
    data["Img"] = image;
    data["UnitPrice"] = unitPrice;
    data["Qty"] = quantity;
    data["TotalPrice"] = totalPrice;
    data["CreatedDate"] = createdDate;
    return data;
  }*/
}