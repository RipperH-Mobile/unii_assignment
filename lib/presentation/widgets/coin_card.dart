import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/coin_model.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;

  const CoinCard({super.key, required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = double.parse(coin.change) >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F5FF), // สีพื้นหลังอ่อนๆ ตามรูป
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.network(
              coin.iconUrl,
              width: 40,
              height: 40,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(),
              ),
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.monetization_on,
                color: Colors.grey,
                size: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(coin.symbol, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${double.parse(coin.price).toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    Text(
                      coin.change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
