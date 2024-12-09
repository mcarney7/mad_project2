String formatPrice(double price) {
  return price.toStringAsFixed(2);
}

String formatChange(double change) {
  return change > 0 ? "+${change.toStringAsFixed(2)}%" : "${change.toStringAsFixed(2)}%";
}
