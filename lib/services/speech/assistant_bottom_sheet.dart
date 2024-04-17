import 'package:flutter/material.dart';
import '../../utilities/widgets/assistant/text_widget.dart';


class AssistantBottomSheet {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.grey[200],
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextWidget(
                    label: "Chosen Model:",
                    fontSize: 16,
                  ),
                ),
                // Flexible(flex: 2, child: ModelsDrowDownWidget()),
              ],
            ),
          );
        });
  }
}
