import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/helper/hex_colors.dart';
import '../../data/helper/luancher_url.dart';
import '../../data/helper/num_format.dart';
import '../../data/models/coin_model.dart';
import '../../logic/bloc/coin_bloc.dart';
import '../../logic/bloc/coin_event.dart';
import '../../logic/bloc/coin_state.dart';
import '../widgets/coin_card.dart';
import '../widgets/top_rank_card.dart';
import '../widgets/empty_search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CoinBloc>().add(FetchCoins());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<CoinBloc>().add(LoadMoreCoins());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<CoinBloc>().add(SearchCoins(""));
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                    context.read<CoinBloc>().add(SearchCoins(value)),
              ),
            ),

            Expanded(
              child: BlocBuilder<CoinBloc, CoinState>(
                builder: (context, state) {
                  if (state is CoinLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CoinLoaded) {
                    if (state.coins.isEmpty && state.isSearching) {
                      return EmptySearchWidget(keyword: _searchController.text);
                    }

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<CoinBloc>().add(
                            FetchCoins(isRefresh: true),
                          ),
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          bool isLandscape =
                              orientation == Orientation.landscape;

                          return CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              if (!state.isSearching)
                                SliverToBoxAdapter(
                                  child: TopRankSection(
                                    coins: state.coins.take(3).toList(),
                                  ),
                                ),

                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Buy, sell and hold crypto",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              if (!isLandscape)
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                        CoinCard(
                                          coin: state.coins[index],
                                          onTap: () =>
                                              _showDetail(
                                                context,
                                                state.coins[index],
                                              ),
                                        ),
                                    childCount: state.coins.length,
                                  ),
                                )
                              else
                                SliverGrid(
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.2,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                        CoinCard(
                                          coin: state.coins[index],
                                          onTap: () =>
                                              _showDetail(
                                                context,
                                                state.coins[index],
                                              ),
                                        ),
                                    childCount: state.coins.length,
                                  ),
                                ),

                              if (!state.hasReachedMax)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  if (state is CoinError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Coin coin) {
    log("Check Coin ${coin}");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40, height: 4, color: Colors.grey[300]),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.network(
                      coin.iconUrl,
                      width: 50,
                      height: 50,
                      errorBuilder: (c, e, s) =>
                      const Icon(Icons.generating_tokens),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${coin.name} ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: hexToColor(coin.color),
                              ),
                            ),
                            Text(
                              "(${coin.symbol})",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "PRICE  \$ ${double.parse(coin.price).toStringAsFixed(
                              2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "MARKET CAP  ${formatMarketCap(coin.marketCap)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  coin.description ?? "No description available.",
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      launchURL(coin.websiteUrl ?? "https://www.unii.co.th");
                    },
                    child: const Text(
                      "GO TO WEBSITE",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
