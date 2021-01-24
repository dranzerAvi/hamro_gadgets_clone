import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String total, status, orderString, id;
  Timestamp timestamp;
  var date;
  List items, prices, quantities,images;
  Order(
      {this.prices,
        this.quantities,
        this.items,
        this.images,
        this.status,
        this.total,
        this.timestamp,
        this.orderString,
        this.id,
        this.date});
}