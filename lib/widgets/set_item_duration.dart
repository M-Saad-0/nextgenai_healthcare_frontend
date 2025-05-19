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
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("From "),
                    Text(now.toLocal().toString())
                  ],
                ),
                const Icon(Icons.arrow_downward),
                setInput
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("To "),
                          Text(returnDate.toLocal().toString()),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownMenu<int>(
                            onSelected: (v) =>
                                setState(() => days = v ?? 0),
                            label: const Text("Set Days"),
                            dropdownMenuEntries: List.generate(
                              10,
                              (index) =>
                                  DropdownMenuEntry(value: index, label: "$index Days"),
                            ),
                          ),
                          const SizedBox(width: 5),
                          DropdownMenu<int>(
                            onSelected: (v) =>
                                setState(() => hours = v ?? 0),
                            label: const Text("Set Hours"),
                            dropdownMenuEntries: List.generate(
                              10,
                              (index) =>
                                  DropdownMenuEntry(value: index, label: "$index Hours"),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() => setInput = true),
                            child: const Text("Set"),
                          )
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
                    'return_date': returnDate.toLocal().toString()
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
