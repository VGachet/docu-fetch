import 'package:docu_fetch/presentation/widget/expandable_fab/expandable_fab_controller.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_button.dart';
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
                  child: NeumorphicButton(
                      onTap: () => entry.value(), text: entry.key),
                ),
              ),
            ))
        .toList();
  }

  Widget _buildTapToCloseFab() => NeumorphicButton(
      icon: Icons.close, onTap: controller.toggle, isRound: true);

  Widget _buildTapToOpenFab() =>
      NeumorphicButton(icon: Icons.menu, onTap: controller.toggle);
}
