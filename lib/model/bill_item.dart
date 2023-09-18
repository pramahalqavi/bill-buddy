class BillItem {
  String name;
  int quantity;
  int price;
  int amount;
  List<int> participantsId;

  BillItem({this.name = "", this.quantity = 1, this.price = 0, this.amount = 0, this.participantsId = const []});

  int getTotalPrice() {
    return quantity * price;
  }
}