import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final Function(String name, String? category, bool? showOnlyAvailable)?
      onFilterSelected;
  final List<String>? filterOptions;
  final String? selectedCategory;
  final bool? showOnlyAvailable;

  const FilterButton({
    Key? key,
    this.onFilterSelected,
    this.filterOptions,
    this.selectedCategory,
    this.showOnlyAvailable,
  }) : super(key: key);

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  TextEditingController nameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String nameFilter = '';
  bool showOnlyAvailable = false;
  String? selectedCategory;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    nameFilter = '';
    showOnlyAvailable = widget.showOnlyAvailable ?? false;
    selectedCategory = widget.selectedCategory;
  }

  void _updateFilters() {
    widget.onFilterSelected!(nameFilter, selectedCategory, showOnlyAvailable);
  }

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
        onDateSelected(picked);
      });
    }
  }

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
                                'Filter Requests',
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
                                    value: selectedCategory,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCategory = newValue;
                                      });
                                      _updateFilters();
                                    },
                                    items: widget.filterOptions
                                        ?.map((String category) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Only show available'),
                                  Checkbox(
                                    value: showOnlyAvailable,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        showOnlyAvailable = value ?? false;
                                      });
                                      _updateFilters();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      nameController.clear();
                                      startDateController.clear();
                                      endDateController.clear();
                                      setState(() {
                                        nameFilter = '';
                                        showOnlyAvailable = false;
                                        selectedCategory = null;
                                        startDate = null;
                                        endDate = null;
                                      });
                                      widget.onFilterSelected!('', null, false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black12,
                                    ),
                                    child: const Text('Clear All'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _updateFilters();
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
          if (nameFilter.isNotEmpty ||
              selectedCategory != null ||
              startDate != null ||
              endDate != null)
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
                      showOnlyAvailable = false;
                      selectedCategory = null;
                      startDate = null;
                      endDate = null;
                    });
                    widget.onFilterSelected!('', null, false);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
