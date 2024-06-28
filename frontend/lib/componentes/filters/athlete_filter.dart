import 'package:flutter/material.dart';

class AthleteFilter extends StatefulWidget {
  final String? initialNameFilter;
  final String? initialCategoryFilter;
  final ValueChanged<String> onNameFilterChanged;
  final ValueChanged<String?> onCategoryFilterChanged;
  final VoidCallback? onClearFilters;

  const AthleteFilter({
    Key? key,
    this.initialNameFilter,
    this.initialCategoryFilter,
    required this.onNameFilterChanged,
    required this.onCategoryFilterChanged,
    this.onClearFilters,
  }) : super(key: key);

  @override
  _AthleteFilterState createState() => _AthleteFilterState();
}

class _AthleteFilterState extends State<AthleteFilter> {
  TextEditingController nameController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.initialNameFilter ?? '';
    selectedCategory = widget.initialCategoryFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FloatingActionButton(
          onPressed: () {
            nameController.text = widget.initialNameFilter ?? '';
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
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
                            TextField(
                              controller: nameController,
                              onChanged: (value) {
                                widget.onNameFilterChanged(value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Name:',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(79, 79, 79, 0.8),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(79, 79, 79, 0.8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(79, 79, 79, 0.8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedCategory,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue;
                                });
                                widget.onCategoryFilterChanged(newValue);
                              },
                              items:
                                  ['under15', 'under16', 'under17', 'under19']
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                              decoration: const InputDecoration(
                                labelText: 'Category:',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(79, 79, 79, 0.8),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(79, 79, 79, 0.8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(79, 79, 79, 0.8),
                                  ),
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
                                      selectedCategory = null;
                                    });
                                    widget.onClearFilters?.call();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black12,
                                  ),
                                  child: const Text('Clear All'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
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
            );
          },
          backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
        if (nameController.text.isNotEmpty || selectedCategory != null)
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
                    selectedCategory = null;
                  });
                  widget.onClearFilters?.call();
                },
              ),
            ),
          ),
      ],
    );
  }
}
