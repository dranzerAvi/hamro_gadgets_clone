class RewardProducts {
  String Brand;
  String category;
  String subcategories;
  List<String> colors = [];
  String description;
  Map details;
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
  int rewardpoints;
  RewardProducts(
      this.Brand,
      this.category,
      this.subcategories,
      this.colors,
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
      this.rewardpoints);
}