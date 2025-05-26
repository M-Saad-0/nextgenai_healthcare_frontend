import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showItemDurationDialog(BuildContext context) {
  return showDialog<Map<String, dynamic>>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      bool setInput = false;
      int days = 0;
      int hours = 0;

      return StatefulBuilder(
        builder: (context, setState) {
          final now = DateTime.now();
          final returnDate = now.add(Duration(days: days, hours: hours));

          return AlertDialog(
            title: const Text("Set Duration"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("From: ${now.toLocal()}"),
                const SizedBox(height: 8),
                const Icon(Icons.arrow_downward),
                const SizedBox(height: 8),
                if (setInput)
                  Text("To: ${returnDate.toLocal()}")
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dropdownMenuTheme: const DropdownMenuThemeData(
                                  textStyle: TextStyle(fontSize: 12),
                                  menuStyle: MenuStyle(
                                    visualDensity:
                                        VisualDensity(horizontal: -2, vertical: -2),
                                  ),
                                ),
                              ),
                              child: DropdownMenu<int>(
                                label: const Text("Days"),
                                onSelected: (v) => setState(() => days = v ?? 0),
                                dropdownMenuEntries: List.generate(
                                  11,
                                  (index) => DropdownMenuEntry(
                                      value: index, label: "$index Days"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dropdownMenuTheme: const DropdownMenuThemeData(
                                  textStyle: TextStyle(fontSize: 12),
                                  menuStyle: MenuStyle(
                                    visualDensity:
                                        VisualDensity(horizontal: -2, vertical: -2),
                                  ),
                                ),
                              ),
                              child: DropdownMenu<int>(
                                label: const Text("Hours"),
                                onSelected: (v) => setState(() => hours = v ?? 0),
                                dropdownMenuEntries: List.generate(
                                  11,
                                  (index) => DropdownMenuEntry(
                                      value: index, label: "$index Hours"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => setInput = true),
                          child: const Text("Preview Return Time"),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'returnDate': returnDate.toLocal().toString(),
                  });
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );
    },
  );
}
