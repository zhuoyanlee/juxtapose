class Item {
  String id;
  String description;
  bool checked;

  Item(id, description) {
    this.id = id;
    this.description = description;
    this.checked = true;
  }

  @override
  String toString() {
    return 'Item{id: $id, description: $description, checked: $checked}';
  }
}
