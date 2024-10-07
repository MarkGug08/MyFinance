import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/User.dart';

class TransactionForm extends StatefulWidget {
  final UserApp user;
  final Function onTransactionSaved;
  TransactionController transactionController = TransactionController();

  TransactionForm({required this.user, required this.onTransactionSaved, required this.transactionController});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
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

      widget.transactionController.saveTransaction(
        amountController: _amountController,
        titleController: _titleController,
        selectedDate: selectedDateTime,
        context: context,
        tipeTransaction: _isIncome,
        user: widget.user,
      ).then((_) {
        _amountController.clear();
        _titleController.clear();
        widget.user.control = true;
        widget.user.chart = true;
        Navigator.pop(context);
        widget.onTransactionSaved();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'New Transaction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
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
            decoration: InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
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
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
            label: Text('Save Transaction'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
