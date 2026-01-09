abstract class CoinEvent {}

// ดึงข้อมูลครั้งแรก หรือ Pull to Refresh
class FetchCoins extends CoinEvent {
  final bool isRefresh;
  FetchCoins({this.isRefresh = false});
}

// อัปเดตราคาอัตโนมัติ (จะยิงทุก 10 วินาที)
class AutoUpdatePrices extends CoinEvent {}

// ค้นหาเหรียญตาม Keyword
class SearchCoins extends CoinEvent {
  final String keyword;
  SearchCoins(this.keyword);
}

// โหลดเหรียญเพิ่มอีก 10-20 รายการเมื่อเลื่อนลงล่างสุด
class LoadMoreCoins extends CoinEvent {}