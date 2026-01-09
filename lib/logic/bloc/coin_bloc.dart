import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/coin_repository.dart';
import '../../data/models/coin_model.dart';
import 'coin_event.dart';
import 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository repository;
  Timer? _autoUpdateTimer;

  int _currentOffset = 0;
  final int _limit = 20; // จำนวนรายการต่อการโหลด 1 ครั้ง
  String _currentSearch = "";
  bool _isFetchingMore = false;

  CoinBloc(this.repository) : super(CoinLoading()) {
    on<FetchCoins>(_onFetchCoins);
    on<SearchCoins>(_onSearchCoins);
    on<LoadMoreCoins>(_onLoadMoreCoins);
    on<AutoUpdatePrices>(_onAutoUpdatePrices);

    // เริ่มระบบ Auto-update ราคาใน List ทุก 10 วินาที
    _startAutoUpdate();
  }

  void _startAutoUpdate() {
    _autoUpdateTimer?.cancel();
    _autoUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(AutoUpdatePrices());
    });
  }

  // โหลดข้อมูลปกติ หรือ Refresh
  Future<void> _onFetchCoins(FetchCoins event, Emitter<CoinState> emit) async {
    if (!event.isRefresh) emit(CoinLoading());
    try {
      _currentOffset = 0;
      final coins = await repository.getCoins(
          offset: _currentOffset,
          limit: _limit,
          search: _currentSearch
      );
      emit(CoinLoaded(
          coins: coins,
          isSearching: _currentSearch.isNotEmpty,
          hasReachedMax: coins.length < _limit
      ));
    } catch (e) {
      emit(CoinError("Failed to fetch data: ${e.toString()}"));
    }
  }

  // อัปเดตราคาโดยไม่เปลี่ยนสถานะหน้าจอเป็น Loading
  Future<void> _onAutoUpdatePrices(AutoUpdatePrices event, Emitter<CoinState> emit) async {
    if (state is CoinLoaded && _currentSearch.isEmpty) {
      try {
        // อัปเดตเฉพาะรายการที่มีอยู่แล้ว (ตั้งแต่ index 0 จนถึงปัจจุบัน)
        final updatedCoins = await repository.getCoins(
            offset: 0,
            limit: _currentOffset + _limit,
            search: _currentSearch
        );
        emit(CoinLoaded(
            coins: updatedCoins,
            isSearching: false,
            hasReachedMax: (state as CoinLoaded).hasReachedMax
        ));
      } catch (_) { /* ปล่อยผ่านเพื่อให้ราคาเดิมยังคงอยู่ */ }
    }
  }

  // ค้นหาเหรียญ
  Future<void> _onSearchCoins(SearchCoins event, Emitter<CoinState> emit) async {
    _currentSearch = event.keyword;
    add(FetchCoins());
  }

  // โหลดหน้าถัดไป (Infinite Scroll)
  Future<void> _onLoadMoreCoins(LoadMoreCoins event, Emitter<CoinState> emit) async {
    final currentState = state;
    if (currentState is CoinLoaded && !currentState.hasReachedMax && !_isFetchingMore) {
      _isFetchingMore = true;
      try {
        _currentOffset += _limit;
        final nextCoins = await repository.getCoins(
            offset: _currentOffset,
            limit: _limit,
            search: _currentSearch
        );

        if (nextCoins.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(CoinLoaded(
              coins: currentState.coins + nextCoins,
              isSearching: _currentSearch.isNotEmpty,
              hasReachedMax: nextCoins.length < _limit
          ));
        }
      } catch (e) {
        // Handle error
      } finally {
        _isFetchingMore = false;
      }
    }
  }

  @override
  Future<void> close() {
    _autoUpdateTimer?.cancel(); // สำคัญ: ต้องหยุด Timer เมื่อ Bloc ถูกทำลาย
    return super.close();
  }
}