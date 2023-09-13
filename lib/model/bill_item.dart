class BillItem {
  String name;
  int quantity;
  int price;

  BillItem({this.name = "", this.quantity = 1, this.price = 0});

  int getTotal() {
    return quantity * price;
  }
}