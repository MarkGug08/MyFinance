import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/Controller/transaction_controller.dart';

class TransactionForm extends StatefulWidget {
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      transactionController.saveTransaction(
        amountController: _amountController,
        descriptionController: _descriptionController,
        selectedDate: _selectedDate,
        context: context,
        tipeTransaction: _isIncome,
      ).then((_) {
        _amountController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedDate = DateTime.now();
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
              DateFormat.yMMMd().format(_selectedDate),
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: _pickDate,
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
