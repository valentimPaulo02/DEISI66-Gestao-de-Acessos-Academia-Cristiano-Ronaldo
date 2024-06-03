import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const Dropdown({
    Key? key,
    required this.labelText,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText,
              style: const TextStyle(
                color: Color.fromRGBO(79, 79, 79, 0.8),
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(0, 128, 87, 0.4),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            value: _selectedItem,
            onChanged: (String? newValue) {
              setState(() {
                _selectedItem = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            selectedItemBuilder: (BuildContext context) {
              return widget.items.map<Widget>((String item) {
                return Text(
                  item,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                );
              }).toList();
            },
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Color.fromRGBO(79, 79, 79, 0.8),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}