class BillItem {
  String name;
  int quantity;
  int price;
  int amount;

  BillItem({this.name = "", this.quantity = 1, this.price = 0, this.amount = 0});

  int getTotalPrice() {
    return quantity * price;
  }
}