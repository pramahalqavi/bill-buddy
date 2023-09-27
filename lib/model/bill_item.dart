class BillItem {
  String name;
  int quantity;
  int price;
  int amount;
  Set<int> participantsId;

  BillItem({this.name = "", this.quantity = 1, this.price = 0, this.amount = 0, required this.participantsId});

  int getTotalPrice() {
    return quantity * price;
  }
}