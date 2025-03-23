import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Danh sách dữ liệu sản phẩm (sử dụng placeholder image links)
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': "Lauren's\nOrange Juice",
      'price': 149,
      'quantity': 2,
      'imageUrl': 'https://via.placeholder.com/150?text=Orange+Juice',
    },
    {
      'name': "Baskin's\nSkimmed Milk",
      'price': 129,
      'quantity': 1,
      'imageUrl': 'https://via.placeholder.com/150?text=Skimmed+Milk',
    },
    {
      'name': "Marley's\nAloe Vera Lotion",
      'price': 1249,
      'quantity': 1,
      'imageUrl': 'https://via.placeholder.com/150?text=Aloe+Vera+Lotion',
    },
  ];

  // Hàm tính tổng giá trị giỏ hàng
  int get _totalPrice {
    num sum = 0;
    for (var item in _cartItems) {
      sum += (item['price'] as num) * (item['quantity'] as num);
    }
    return sum.toInt();
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }

  void _proceedToCheckout() {
    Navigator.pushNamed(context, '/payment', arguments: {
      'total': _totalPrice,
      'cartItems': _cartItems,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF9F4),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Your Cart 👍",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: const SizedBox(), // Ẩn nút back
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Ảnh sản phẩm
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['imageUrl'],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tên sản phẩm + giá
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹ ${item['price']}",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Nút tăng giảm số lượng
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _decrementQuantity(index),
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                            ),
                            Text("${item['quantity']}"),
                            IconButton(
                              onPressed: () => _incrementQuantity(index),
                              icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            // Tổng và Proceed button
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        "₹ $_totalPrice",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _proceedToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd79b83), // Màu cam nhạt
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Proceed to checkout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFFd79b83),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
        ],
      ),
    );
  }
}
