import 'package:flutter/material.dart';

class StumpDetailsField extends StatelessWidget {
  final String labelText;
  final bool needColumn;
  final String initialValue;
  final Function(String value) onSetState;

  const StumpDetailsField({
    super.key,
    required this.labelText,
    required this.onSetState,
    required this.initialValue,
    this.needColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    return needColumn
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(labelText),
              ),
              TextFormField(
                initialValue: initialValue,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 10,
              ),
            ],
          )
        : Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(labelText),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: initialValue,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      return;
                    }
                    onSetState(value);
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          );
  }
}
