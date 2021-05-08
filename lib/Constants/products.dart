class Products {
  String Brand;
  List<String> category;
  String subcategories;
//  List<String> colors = [];
  String description;
  String details;
  List<String> detailsurls = [];
  int disprice;
  String docid;
  List<String> imageurls = [];
  int mp;
  String name;
  int noOfPurchases;
  int quantity;
  String rating;
  Map specs;
  String status;
  bool inStore;
  String productId;
  String varientId;
  String varientcolor;
  String varientsize;
  Products(
      this.Brand,
      this.category,
      this.subcategories,
      this.description,
      this.details,
      this.detailsurls,
      this.disprice,
      this.docid,
      this.imageurls,
      this.mp,
      this.name,
      this.noOfPurchases,
      this.quantity,
      this.rating,
      this.specs,
      this.status,
      this.inStore,
      this.productId,
      this.varientId,
      this.varientcolor,
      this.varientsize);
}
// class Details{
//   String display;
//   String graphic;
//   Details(this.display,this.graphic);
// }
// class Specs{
//   String cpu;
//   String model;
//   String ram;
//   String storage;
//   Specs(this.cpu,this.model,this.ram,this.storage);
// }
