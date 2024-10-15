import 'package:flutter/material.dart';

Widget periodDropdown({
  required String selectedPeriod,
  required ValueChanged<String> onPeriodChanged,
  required bool flag
}) {

  List<String> menu = Menu(flag);

  return Container(
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedPeriod,
        items: menu.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
        onChanged: (String? newPeriod) {
          if (newPeriod != null) {
            onPeriodChanged(newPeriod);
          }
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 19,
        ),
        dropdownColor: Colors.white,
      ),
    ),
  );
}


List<String> Menu(bool flag){
  if(flag){
    return [
      'Today',
      'This Week',
      'This Month',
      'All'
    ];
  }else{
    return [
      'Today',
      'This Week',
      'This Month',
    ];
  }
}
