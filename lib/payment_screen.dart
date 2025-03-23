import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? totalPrice;
  List<Map<String, dynamic>>? cartItems;

  // 0: Credit Card, 1: Apple Pay
  int _selectedPaymentMethod = 0;

  // Controllers cho Credit Card form
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();

  String _errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      totalPrice = args['total'] as int?;
      cartItems = args['cartItems'] as List<Map<String, dynamic>>?;
    }
  }

  void _payForOrder() {
    if (_selectedPaymentMethod == 0) {
      // Kiểm tra form Credit Card
      if (_cardNumberController.text.isEmpty ||
          _cardHolderNameController.text.isEmpty ||
          _expiryMonthController.text.isEmpty ||
          _expiryYearController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        setState(() {
          _errorMessage = "Please fill all the fields!";
        });
        return;
      }
    }
    // Nếu hợp lệ, navigate sang SuccessScreen
    Navigator.pushReplacementNamed(
      context,
      '/success',
      arguments: {'total': totalPrice, 'cartItems': cartItems},
    );
  }

  Widget _buildPaymentMethodButton(String text, int value) {
    final isSelected = (_selectedPaymentMethod == value);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
            _errorMessage = '';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border:
                isSelected
                    ? Border.all(color: Colors.green, width: 2)
                    : Border.all(color: Colors.transparent),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // Card Number
        TextField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Card number",
            hintText: "5261 4141 0151 8472",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        // Cardholder Name
        TextField(
          controller: _cardHolderNameController,
          decoration: const InputDecoration(
            labelText: "Cardholder name",
            hintText: "Christie Doe",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        // Expiry Date and CVV
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryMonthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Expiry month",
                  hintText: "06",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _expiryYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Expiry year",
                  hintText: "2024",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "CVV/CVC",
                  hintText: "915",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApplePayInfo() {
    return Column(
      children: const [
        SizedBox(height: 20),
        Icon(Icons.phone_iphone, size: 80, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          "Apple Pay is ready!",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayTotal = totalPrice ?? 0;
    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2FFF0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Checkout 🛍", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tổng giá và GST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "₹ (Including GST 18%)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "₹ $displayTotal",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Payment Method buttons
            Row(
              children: [
                _buildPaymentMethodButton("Credit card", 0),
                const SizedBox(width: 8),
                _buildPaymentMethodButton("Apple Pay", 1),
              ],
            ),
            const SizedBox(height: 20),
            // Form hiển thị theo phương thức
            _selectedPaymentMethod == 0
                ? _buildCreditCardForm()
                : _buildApplePayInfo(),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _payForOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Pay for the order",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
