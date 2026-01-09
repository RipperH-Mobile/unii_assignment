String formatMarketCap(String? value) {
  if (value == null || value.isEmpty) return '\$ 0.00';
  double amount = double.parse(value);

  if (amount >= 1e12) {
    return '\$ ${(amount / 1e12).toStringAsFixed(2)} trillion';
  } else if (amount >= 1e9) {
    return '\$ ${(amount / 1e9).toStringAsFixed(2)} billion';
  } else if (amount >= 1e6) {
    return '\$ ${(amount / 1e6).toStringAsFixed(2)} million';
  }
  return '\$ ${amount.toStringAsFixed(2)}';
}