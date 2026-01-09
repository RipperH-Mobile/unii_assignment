import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/coin_model.dart';

class TopRankSection extends StatelessWidget {
  final List<Coin> coins;
  const TopRankSection({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Top 3 rank crypto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SizedBox(
          height: 160,
          child: Row(
            children: coins.map((coin) => Expanded(child: _buildTopCard(coin))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCard(Coin coin) {
    final bool isPositive = double.parse(coin.change) >= 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(coin.iconUrl, height: 40, width: 40,
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
          Text(coin.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(coin.name, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${isPositive ? '+' : ''}${coin.change}%",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}