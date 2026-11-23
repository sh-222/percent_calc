import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/tax_result.dart';

class TaxResultCard extends StatelessWidget {
  final TaxResult result;
  final Color themeColor;

  const TaxResultCard({
    super.key,
    required this.result,
    required this.themeColor,
  });

  void _copy(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: themeColor.withValues(alpha: 0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: themeColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: themeColor.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, size: 20, color: themeColor),
                const SizedBox(width: 12),
                Text(
                  result.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  "Налог к уплате:",
                  result.taxAmount.toStringAsFixed(2),
                  isBold: true,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  "Выставить счет на:",
                  result.totalToInvoice.toStringAsFixed(2),
                  isPrimary: true,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _copy(context, result.formula, "Формула скопирована"),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "КАК ЭТО РАБОТАЕТ",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            Icon(Icons.copy, size: 14, color: Colors.grey[400]),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          result.formula,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool isBold = false, bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        InkWell(
          onTap: () => _copy(context, value, "Сумма $value ₽ скопирована"),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Text(
                  "$value ₽",
                  style: TextStyle(
                    fontSize: isPrimary ? 18 : 16,
                    fontWeight: (isBold || isPrimary) ? FontWeight.bold : FontWeight.normal,
                    color: isPrimary ? themeColor : Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.copy, size: 14, color: themeColor.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
