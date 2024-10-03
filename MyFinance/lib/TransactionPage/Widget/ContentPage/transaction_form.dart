import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/User.dart';

class TransactionForm extends StatefulWidget {
  UserApp user;

  TransactionForm({required this.user});
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  TransactionController transactionController = TransactionController();
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isIncome = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      transactionController.saveTransaction(
        amountController: _amountController,
        descriptionController: _descriptionController,
        selectedDate: selectedDateTime,
        context: context,
        tipeTransaction: _isIncome,
        user: widget.user,
      ).then((_) {
        _amountController.clear();
        _descriptionController.clear();
        widget.user.control = true;
        setState(() {
          _selectedDate = DateTime.now();
          _selectedTime = TimeOfDay.now();
          _isIncome = true;
        });
      });
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            value: _isIncome,
            decoration: InputDecoration(labelText: 'Type'),
            items: [
              DropdownMenuItem(
                value: true,
                child: Text('Income'),
              ),
              DropdownMenuItem(
                value: false,
                child: Text('Expense'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _isIncome = value;
                });
              }
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text(
              'Transaction Date: ${DateFormat.yMMMd().format(_selectedDate)}',
            ),
            subtitle: Text('Tap to select a date'),
            trailing: Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          ListTile(
            title: Text(
              'Transaction Time: ${_selectedTime.format(context)}',
            ),
            subtitle: Text('Tap to select a time'),
            trailing: Icon(Icons.access_time),
            onTap: _pickTime,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Save Transaction'),
          ),
        ],
      ),
    );
  }
}
