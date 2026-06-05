class FridgeItem {
  final String id;
  final String name;
  final int quantity;
  final String unit;
  final String status;

  FridgeItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.status,
  });

  factory FridgeItem.fromJson(Map<String, dynamic> json) {
    return FridgeItem(
      id: json["id"],
      name: json["name"],
      quantity: json["quantity"],
      unit: json["unit"],
      status: json["status"],
    );
  }
}