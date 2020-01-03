class ListType {
  static const String DEFAULT = 'Default';
  static const String ASIAN = 'Asian';
  static const String ALDI = 'Aldi';
  static const String COSTCO = 'Costco';
  static const String OTHER = 'Other';
  static const String BUSHFIRE = 'Bushfire';
  // After adding here, remember to update the functions below too

  static String getListNameByIndex(int index) {
    switch (index) {
      case 0:
        {
          return DEFAULT;
        }
      case 1:
        {
          return ASIAN;
        }
      case 2:
        {
          return ALDI;
        }
      case 3:
        {
          return COSTCO;
        }
      case 4:
        {
          return OTHER;
        }
      case 5:
        {
          return BUSHFIRE;
        }
    }
  }

  static int getIndexByListName(var listName) {
    switch (listName) {
      case DEFAULT:
        {
          return 0;
        }
      case ASIAN:
        {
          return 1;
        }
      case ALDI:
        {
          return 2;
        }
      case COSTCO:
        {
          return 3;
        }
      case OTHER:
        {
          return 4;
        }
      case BUSHFIRE:
        {
          return 5;
        }
      default:
        return 0;
    }
  }
}
