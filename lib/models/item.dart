class Item {
  String id;
  String name;
  String description;
  bool checked;

  Item(name, description) {
    this.name = name;
    this.description = description;
    this.checked = false;
  }

  Item.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'],
        description = snapshot['description'] ?? '',
        checked = snapshot['checked'] ?? '';

  toJson() {
    return {
      "name": name,
      "description": description,
      "checked": checked,
    };
  }

  @override
  String toString() {
    return 'Item{id: $id, name: $name, description: $description, checked: $checked}';
  }

  Item.fromJson(this.id, Map data) {
    this.name = data['name'];
    this.description = data['description'];
    this.checked = data['checked'];
  }
}
