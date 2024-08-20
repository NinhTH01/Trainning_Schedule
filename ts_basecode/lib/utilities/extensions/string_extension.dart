extension TextCapitalize on String {
  String capitalizeFirstLetter() {
    return isNotEmpty ? (this[0].toUpperCase() + substring(1)) : '';
  }
}
