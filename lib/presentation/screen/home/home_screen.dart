import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:clean_architecture_getx/presentation/screen/home/home_controller.dart';
import 'package:clean_architecture_getx/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) => PageContainer(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.trending_up),
                label: 'trending'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.currency_bitcoin),
                label: 'coins'.tr,
              ),
            ],
            currentIndex: controller.tabIndex.value,
            onTap: controller.onTabSelected,
          )),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: <Widget>[
              controller.trendingCoinList.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.trendingCoinList.length,
                      itemBuilder: (context, index) {
                        final Coin currentCoin =
                            controller.trendingCoinList[index];

                        return ListTile(
                          leading: Image.network(currentCoin.image),
                          title: Text(currentCoin.name),
                          subtitle: Text(currentCoin.symbol.toUpperCase()),
                          trailing: currentCoin.marketCapRank != -1
                              ? Text(currentCoin.marketCapRank.toString())
                              : const SizedBox(),
                        );
                      })
                  : const SizedBox(),
              controller.coinList.isNotEmpty
                  ? ListView.builder(
                      controller: controller.coinListScrollController,
                      itemCount: controller.coinList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == controller.coinList.length) {
                          if (controller.isEndCoinList.value) {
                            return const SizedBox();
                          } else {
                            return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        } else {
                          final Coin currentCoin = controller.coinList[index];

                          return ListTile(
                            leading: Image.network(currentCoin.image),
                            title: Text(currentCoin.name),
                            subtitle: Text(currentCoin.symbol.toUpperCase()),
                            trailing: Text(
                                '${currentCoin.currentPrice.toString()}\$'),
                          );
                        }
                      },
                    )
                  : const SizedBox(),
            ],
          )));
}
