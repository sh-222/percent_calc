class TaxResult {
  final double baseAmount;
  final double taxRate; // 0.04 или 0.06
  final double totalToInvoice;
  final double taxAmount;

  TaxResult({
    required this.baseAmount,
    required this.taxRate,
    required this.totalToInvoice,
    required this.taxAmount,
  });

  String get formula =>
      "${baseAmount.toStringAsFixed(2)} + ${taxAmount.toStringAsFixed(2)} (налог) = ${totalToInvoice.toStringAsFixed(2)}";
  
  String get title => taxRate == 0.04 ? "Физлица (4%)" : "Юрлица / ИП (6%)";
}
