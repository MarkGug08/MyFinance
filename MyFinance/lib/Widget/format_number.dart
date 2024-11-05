String formatNumber(double value) {

  if (value >= 1e9 || value * -1 >= 1e9) {
    return '${(value / 1e9).toStringAsFixed(2)}B';
  } else if (value >= 1e6 || value * -1 >= 1e6) {
    return '${(value / 1e6).toStringAsFixed(2)}M';
  } else if (value >= 1e3 || value * -1 >= 1e3) {
    return '${(value / 1e3).toStringAsFixed(2)}k';
  } else {
    return value.toStringAsFixed(2);
  }
}