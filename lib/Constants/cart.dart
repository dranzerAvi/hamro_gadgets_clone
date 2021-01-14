import 'package:hamro_gadgets/services/database_helper.dart';

class Cart {
  int id;
  String productName, imgUrl, price, qtyTag, productDesc;
//  String details;
  int qty;

  Cart(this.id, this.productName, this.imgUrl, this.price, this.qty,
      this.productDesc);

  Cart.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productName = map['productName'];
    imgUrl = map['imgUrl'];
    productDesc = map['productDesc'];
    price = map['price'];
    qty = map['qty'];

//    details = map['details'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnProductName: productName,
      DatabaseHelper.columnImageUrl: imgUrl,
      DatabaseHelper.columnProductDescription: productDesc,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnQuantity: qty,

//      DatabaseHelper.columnDetail: details
    };
  }
}
