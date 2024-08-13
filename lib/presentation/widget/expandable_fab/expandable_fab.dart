import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/widget/expandable_fab/expandable_fab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@immutable
class ExpandableFab extends StatelessWidget {
  ExpandableFab({
    super.key,
    this.initialOpen,
    required this.children,
  });

  final bool? initialOpen;
  final Map<String, Function> children;
  final ExpandableFabController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Obx(
        () => Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            if (controller.isOpen.value) _buildTapToCloseFab(),
            if (controller.isOpen.value) ..._buildExpandingChildrenList(),
            if (!controller.isOpen.value) _buildTapToOpenFab(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExpandingChildrenList() {
    return children.entries
        .map((entry) => Positioned(
              right: 56,
              bottom: (56 *
                      (children.length -
                          children.keys.toList().indexOf(entry.key)))
                  .toDouble(),
              child: IgnorePointer(
                ignoring: !controller.isOpen.value,
                child: AnimatedOpacity(
                  opacity: controller.isOpen.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    child: GestureDetector(
                      onTap: () => entry.value(),
                      child: Padding(
                        padding: const EdgeInsets.all(CustomMargins.margin8),
                        child: Text(
                          entry.key,
                          style:
                              const TextStyle(color: CustomColors.colorBlack),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          //color: CustomColors.colorGreyLight,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: controller.toggle,
            child: Padding(
              padding: const EdgeInsets.all(CustomMargins.margin8),
              child: Icon(
                Icons.close,
                color: Colors.black,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() => FloatingActionButton(
        //backgroundColor: CustomColors.colorGreyLight,
        onPressed: controller.toggle,
        child: Icon(
          Icons.add,
          color: Colors.black,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)
          ],
        ),
      );
}
