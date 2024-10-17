import 'dart:ui';

import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// This class manage system colors and full screen loader

class PageContainer extends StatelessWidget {
  PageContainer({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.hideLoadingOverlay,
    this.floatingActionButton,
    this.drawer,
    this.appBar,
  });

  final _mainController = Get.find<MainController>();

  final Widget body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? hideLoadingOverlay;
  final Widget? floatingActionButton;
  final Drawer? drawer;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) =>
      Stack(fit: StackFit.expand, children: <Widget>[
        Scaffold(
          appBar: appBar,
          drawer: drawer,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: bottomNavigationBar,
          //This background color is displayed in the status bar and bottom bar of iOS devices
          backgroundColor: backgroundColor ?? CustomColors.colorGreyLight,
          //AnnotatedRegion is used to display the background color & the status bar and navigation bar of Android devices
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                statusBarColor: backgroundColor ?? CustomColors.colorGreyLight,
                systemNavigationBarColor:
                    backgroundColor ?? CustomColors.colorGreyLight),
            child: SafeArea(child: body),
          ),
          floatingActionButton: floatingActionButton,
        ),
        Obx(() => _mainController.isLoadingCanStop.value ||
                hideLoadingOverlay == true
            ? const SizedBox()
            : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()))))
      ]);
}
