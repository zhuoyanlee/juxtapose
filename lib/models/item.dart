class Item {
  String id;
  String description;
  bool checked;


  Item(description) {
    this.description = description;
    this.checked = true;
  }

  Item.fromMap(Map snapshot,String id) :
        id = id ?? '',
        description = snapshot['description'] ?? '',
        checked = snapshot['checked'] ?? '';

  toJson() {
    return {
      "description": description,
      "checked": checked,
    };
  }

  @override
  String toString() {
    return 'Item{id: $id, description: $description, checked: $checked}';
  }

  Item.fromJson(this.id, Map data) {
    this.description = data['description'];
    this.checked = data['checked'];
  }
}
