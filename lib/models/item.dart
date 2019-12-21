class Item {
  String id;
  String description;
  bool checked;


  Item(description) {
    this.description = description;
    this.checked = true;
  }

  @override
  String toString() {
    return 'Item{id: $id, description: $description, checked: $checked}';
  }
}
