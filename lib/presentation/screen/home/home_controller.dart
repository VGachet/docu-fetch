import 'package:clean_architecture_getx/data/datasource/remote/request/coin_list_param.dart';
import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:clean_architecture_getx/domain/usecase/get_coin_list_use_case.dart';
import 'package:clean_architecture_getx/domain/usecase/get_trending_coin_list_use_case.dart';
import 'package:clean_architecture_getx/presentation/main_controller.dart';
import 'package:clean_architecture_getx/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController(
      {required this.getCoinListUseCase,
      required this.getTrendingCoinListUseCase});

  final GetCoinListUseCase getCoinListUseCase;
  final GetTrendingCoinListUseCase getTrendingCoinListUseCase;

  final MainController mainController = Get.find();

  RxList<Coin> coinList = RxList.empty();
  RxList<Coin> trendingCoinList = RxList.empty();

  RxInt tabIndex = 0.obs;

  int coinListPage = 1;
  bool isCoinPageLoading = false;
  RxBool isEndCoinList = false.obs;

  final ScrollController coinListScrollController = ScrollController();

  @override
  void onReady() async {
    super.onReady();

    await getTrendingCoinList();

    coinListScrollController.addListener(() {
      //When the transaction list is fully scrolled => load more transactions
      // and add them to the transaction list
      if (coinListScrollController.position.atEdge &&
          !isCoinPageLoading &&
          !isEndCoinList.value) {
        loadNewCoinPage();
      }
    });
  }

  void onTabSelected(int index) {
    if (tabIndex.value == index) return;

    tabIndex.value = index;

    if (index == 0) {
      getTrendingCoinList();
    } else {
      getCoinList();
    }
  }

  Future<void> getTrendingCoinList() async {
    mainController.isLoading.value = true;

    final trendingCoinListResult = await getTrendingCoinListUseCase();

    if (trendingCoinListResult is Success) {
      trendingCoinList.clear();
      trendingCoinList.value = trendingCoinListResult.data!;
    } else {
      //Display error
    }

    mainController.isLoading.value = false;
  }

  Future<void> getCoinList() async {
    mainController.isLoading.value = true;

    final coinListResult = await getCoinListUseCase(CoinListParam(
        page: coinListPage,
        perPage: 20,
        vsCurrency: 'usd',
        order: 'market_cap_desc',
        sparkline: false));

    if (coinListResult is Success) {
      coinList.clear();
      coinList.value = coinListResult.data!;
    } else {
      //Display error
    }

    mainController.isLoading.value = false;
  }

  void loadNewCoinPage() async {
    isCoinPageLoading = true;
    coinListPage++;

    final coinListResult = await getCoinListUseCase(CoinListParam(
        page: coinListPage,
        perPage: 20,
        vsCurrency: 'usd',
        order: 'market_cap_desc',
        sparkline: false));

    if (coinListResult is Success) {
      coinList.addAll(coinListResult.data!);
      isEndCoinList.value = coinListResult.data!.length < 20;
    } else {
      //Display error
    }

    isCoinPageLoading = false;
  }
}
