import '../../data/models/coin_model.dart';

abstract class CoinState {}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinError extends CoinState {
  final String message;
  CoinError(this.message);
}

class CoinLoaded extends CoinState {
  final List<Coin> coins;
  final bool isSearching;
  final bool hasReachedMax;

  CoinLoaded({
    required this.coins,
    this.isSearching = false,
    this.hasReachedMax = false,
  });

  // ฟังก์ชัน copyWith สำหรับสร้าง State ใหม่โดยอ้างอิงค่าเดิม
  CoinLoaded copyWith({
    List<Coin>? coins,
    bool? isSearching,
    bool? hasReachedMax,
  }) {
    return CoinLoaded(
      coins: coins ?? this.coins,
      isSearching: isSearching ?? this.isSearching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}