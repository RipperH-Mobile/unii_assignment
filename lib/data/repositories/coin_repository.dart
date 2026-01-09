import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/coin_model.dart';

class CoinRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.coinranking.com/v2';

  Future<List<Coin>> getCoins({
    int offset = 0,
    int limit = 20,
    String? search,
  }) async {
    final response = await _dio.get(
      '$_baseUrl/coins',
      options: Options(
        headers: {
          'x-access-token': 'coinranking0956a10a569f40323c8911b974bd452bb1a4c0fdad6dbd65', // ใส่ Key ที่ได้จากเว็บ
        },
      ),
      queryParameters: {
        'offset': offset,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final List data = response.data['data']['coins'];
    log("Check Response ${data}");
    return data.map((e) => Coin.fromJson(e)).toList();
  }

  Future<Coin> getCoinDetail(String uuid) async {
    final response = await _dio.get('$_baseUrl/coin/$uuid');
    log("Check Response ${response.data['data']['coin']}");
    return Coin.fromJson(response.data['data']['coin']);
  }
}
