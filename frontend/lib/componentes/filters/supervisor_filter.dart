import 'package:flutter/material.dart';

class SupervisorFilter extends StatefulWidget {
  final String? initialNameFilter;
  final String? initialCategoryFilter;
  final ValueChanged<String> onNameFilterChanged;
  final VoidCallback? onClearFilters;

  const SupervisorFilter({
    Key? key,
    this.initialNameFilter,
    this.initialCategoryFilter,
    required this.onNameFilterChanged,
    this.onClearFilters,
  }) : super(key: key);

  @override
  _SupervisorFilterState createState() => _SupervisorFilterState();
}

class _SupervisorFilterState extends State<SupervisorFilter> {
  TextEditingController nameController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.initialNameFilter ?? '';
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
                                border: OutlineInputBorder(),
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
