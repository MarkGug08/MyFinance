import 'package:flutter/material.dart';

Widget periodDropdown({
  required String selectedPeriod,
  required ValueChanged<String> onPeriodChanged,
}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: selectedPeriod,
      items: <String>[
        'Today',
        'This Week',
        'This Month',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 14), // Imposta la dimensione del testo
          ),
        );
      }).toList(),
      onChanged: (String? newPeriod) {
        if (newPeriod != null) {
          onPeriodChanged(newPeriod);
        }
      },
      icon: Icon(
        Icons.arrow_drop_down,
        size: 24,
      ),
      iconSize: 24,
      dropdownColor: Colors.white,
    ),
  );
}