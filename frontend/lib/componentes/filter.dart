import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final Function(String name, String? category) onFilterSelected;
  final List<String> filterOptions;
  final String? selectedCategory;

  const FilterButton({
    Key? key,
    required this.onFilterSelected,
    required this.filterOptions,
    this.selectedCategory,
  }) : super(key: key);

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  TextEditingController nameController = TextEditingController();
  String nameFilter = '';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              nameController.text = nameFilter;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Filter Athletes',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Name:',
                              border: OutlineInputBorder(),
                            ),
                            child: TextField(
                              controller: nameController,
                              onChanged: (value) {
                                setState(() {
                                  nameFilter = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Category:',
                              border: OutlineInputBorder(),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: widget.selectedCategory,
                                onChanged: (String? newValue) {
                                  Navigator.of(context).pop();
                                  widget.onFilterSelected(nameFilter, newValue);
                                },
                                items:
                                    widget.filterOptions.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  nameController.clear();
                                  setState(() {
                                    nameFilter = '';
                                  });
                                  widget.onFilterSelected('', null);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                child: const Text('Clear All'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  widget.onFilterSelected(
                                      nameFilter, widget.selectedCategory);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 128, 87, 0.7),
                                ),
                                child: const Text('Filter'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
          if (nameFilter.isNotEmpty || widget.selectedCategory != null)
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.clear, size: 12, color: Colors.white),
                  onPressed: () {
                    nameController.clear();
                    setState(() {
                      nameFilter = '';
                    });
                    widget.onFilterSelected('', null);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
