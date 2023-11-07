import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, dynamic> filters;
  final Future<void> Function() onFinish;

  const FilterDialog(
      {super.key, this.filters = const {}, required this.onFinish});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final List<bool> _selectedItems = [false, false, false, false];
  final List<String> _items = ['Indian', 'Japanese', 'Hawaiian', 'Spanish'];

  @override
  Widget build(BuildContext context) {
    if (widget.filters['tipo_comida'] != null) {
      int index = _items.indexOf(widget.filters['tipo_comida']);
      _selectedItems[index] = true;
    }

    return SimpleDialog(
      alignment: Alignment.topCenter,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  )),
            )),
        Column(
          children: [
            ToggleButtons(
              isSelected: _selectedItems,
              onPressed: (index) {
                setState(() {
                  widget.filters[Constants.categoriaKey] = _items[index];
                  for (int i = 0; i < _selectedItems.length; i++) {
                    _selectedItems[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: AppTheme.primaryColor,
              selectedColor: Colors.white,
              fillColor: Colors.red[300],
              color: AppTheme.primaryColor,
              children: _items
                  .map(
                    (e) => Text(e),
                  )
                  .toList(),
            ),
            const Divider(
              height: 40,
              thickness: 2,
              indent: 40,
              endIndent: 40,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.attach_money_outlined,
                color: Colors.black,
              ),
              Slider.adaptive(
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: Colors.red[300],
                  divisions: 4,
                  min: 0,
                  max: 4,
                  label: Constants.dollar *
                      double.parse(widget.filters[Constants.precioMedioKey]?.toString() ?? '0')
                          .round(),
                  value: widget.filters[Constants.precioMedioKey] ?? 0,
                  onChanged: (value) {
                    widget.filters[Constants.precioMedioKey] = value;
                    setState(() {});
                  }),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.star,
                color: Colors.black,
              ),
              Slider.adaptive(
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: Colors.red[300],
                  divisions: 5,
                  min: 0,
                  max: 5,
                  label: double.parse(
                          widget.filters['valoracion']?.toString() ?? '0')
                      .round()
                      .toString(),
                  value: widget.filters['valoracion'] ?? 0,
                  onChanged: (value) {
                    widget.filters['valoracion'] = value;
                    setState(() {});
                  }),
            ]),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 15),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                widget.onFinish();
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(100, 30)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade400),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)))),
              child: const Text(Constants.ok),
            ),
          ),
        )
      ],
    );
  }
}
