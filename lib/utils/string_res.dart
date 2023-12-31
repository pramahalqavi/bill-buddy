class StringRes {
  static const String appName = "Bill Buddy";
  static const String addBill = "Add bill";
  static const String yourBill = "Your Bill";
  static const String errorOccurred = "Error occurred";
  static const String noData = "No data";

  static const String newBill = "New Bill";
  static const String billItems = "Bill Items";
  static const String billItemsInstruction = "Add bill title, date, price & quantity of each item";
  static const String title = "Title";
  static const String itemName = "Item name";
  static const String price = "Price";
  static const String qty = "Qty";
  static const String amount = "Amount";
  static const String addItem = "Add item";
  static const String billDate = "Bill date";

  static const String summary = "Summary";
  static const String subtotal = "Subtotal";
  static const String tax = "Tax";
  static const String serviceCharge = "Service charge";
  static const String discount = "Discount";
  static const String others = "Others";
  static const String totalAmount = "Total amount";
  static const String next = "Next";
  static const String bill = "Bill";
  static const String item = "Item";
  static const String invalidInput = "Invalid input";
  static const String othersErrorMsg = "This field should not have a negative value";
  static const String totalErrorMsg = "This field should be greater than zero";
  static const String itemsLengthErrorMsg = "Please add item first";
  static const String itemQtyErrorMsg = "Item quantity should be greater than zero";

  static const String editParticipant = "Edit Participant";
  static const String delete = "Delete";
  static const String add = "Add";
  static const String participant = "Participant";
  static const String addParticipant = "Add Bill Participant";
  static const String maxParticipantError = "Maximum participant limit has been reached";

  static const String assignParticipant = "Assign Participant";
  static const String assignParticipantToItems = "Assign participants to items";
  static const String assignParticipantInstruction = "Tap a participant and choose their items";
  static const String proceed = "Proceed";
  static const String saveAndBackToHome = "Save & Back to Home";
  static const String share = "Share";

  static const String sTotal = "'s total";
  static const String billTotal = "Bill Total:";
  static String itemAndParticipantCount(int itemCount, int participantCount) {
    String itemText = itemCount > 1 ? "items" : "item";
    String participantText = participantCount > 1 ? "participants" : "participant";
    return "$itemCount $itemText • $participantCount $participantText";
  }
  static const String seeDetail = "See Detail";
  static const String deleteBillSuccessMsg = "Delete successful";
  static const String deleteBillErrorMsg = "Delete failed";
  static const String edit = "Edit";

  static const String participantNotAssignedErrorMsg = "All participants must be assigned to at least one item";
  static const String billItemNotAssignedErrorMsg = "All items must be assigned to at least one participant";
  static const String addManually = "Add manually";
  static const String addFromImage = "Add from image";
  static const String addFromCamera = "Add from camera";
}