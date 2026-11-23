import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/tax_result.dart';
import 'widgets/result_card.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'НПД Калькулятор',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          surface: Colors.grey[50],
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.indigo,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  CalculatorPageState createState() => CalculatorPageState();
}

class CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _inputController = TextEditingController();
  TaxResult? _result4;
  TaxResult? _result6;

  void _calculate() {
    final input = _inputController.text.replaceAll(',', '.');
    final x = double.tryParse(input);

    if (x == null || x <= 0) {
      setState(() {
        _result4 = null;
        _result6 = null;
      });
      return;
    }

    setState(() {
      final y4 = x / 0.96;
      _result4 = TaxResult(
        baseAmount: x,
        taxRate: 0.04,
        totalToInvoice: y4,
        taxAmount: y4 * 0.04,
      );

      final y6 = x / 0.94;
      _result6 = TaxResult(
        baseAmount: x,
        taxRate: 0.06,
        totalToInvoice: y6,
        taxAmount: y6 * 0.06,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('ПРОФНАЛОГ')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputSection(),
              const SizedBox(height: 32),
              if (_result4 != null && _result6 != null) ...[
                TaxResultCard(result: _result4!, themeColor: Colors.green[700]!),
                const SizedBox(height: 12),
                TaxResultCard(result: _result6!, themeColor: Colors.indigo[700]!),
              ] else
                _buildThemedPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 18, color: Colors.indigo.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              const Text(
                "СУММА НА РУКИ",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            decoration: InputDecoration(
              hintText: '0.00',
              suffixText: '₽',
              suffixStyle: const TextStyle(fontSize: 24, color: Colors.indigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.all(18),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
            onChanged: (_) => _calculate(),
          ),
        ],
      ),
    );
  }

  Widget _buildThemedPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
              const Icon(Icons.account_balance_wallet_rounded, size: 60, color: Colors.indigo),
              Positioned(
                right: 0,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "%",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Быстрый расчет налогов\nдля самозанятых",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Просто введите сумму,\nкоторую планируете получить",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
