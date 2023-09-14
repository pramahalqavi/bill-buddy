class BillItem {
  int position;
  String name;
  int quantity;
  int price;
  int amount;

  BillItem({this.position = 0, this.name = "", this.quantity = 1, this.price = 0, this.amount = 0});

  int getTotalPrice() {
    return quantity * price;
  }
}