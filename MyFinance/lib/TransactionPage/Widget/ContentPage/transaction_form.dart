import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/User.dart';

class TransactionForm extends StatefulWidget {
  final UserApp user;
  final Function onTransactionSaved;
  final TransactionController transactionController;

  const TransactionForm({super.key, 
    required this.user,
    required this.onTransactionSaved,
    required this.transactionController,
  });

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  bool _isIncome = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late int _seconds = 0;
  bool _isSaving = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });


      final selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
        _seconds
      );

      await widget.transactionController.saveTransaction(
        amountController: _amountController,
        titleController: _titleController,
        selectedDate: selectedDateTime,
        context: context,
        tipeTransaction: _isIncome,
        user: widget.user,
      ).then((_) {
        _amountController.clear();
        _titleController.clear();
        widget.transactionController.canReload = true;

        if (mounted) {
          Navigator.of(context).pop();
        }

        widget.onTransactionSaved();

        setState(() {
          _selectedDate = DateTime.now();
          _selectedTime = TimeOfDay.now();
          _isIncome = true;
          _isSaving = false;
        });
      }).catchError((error) {
        setState(() {
          _isSaving = false;
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.grey[200],
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.grey[200],
              dialHandColor: Colors.black,
              dialBackgroundColor: Colors.white,
              hourMinuteColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
            ),

          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    _seconds = now.second;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Transaction',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Transaction Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  prefixIcon: const Icon(Icons.title, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }else if(value.length > 20){
                    return 'Please enter a title with max 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  prefixIcon: const Icon(Icons.money, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }else{
                    try{
                      double? amount = double.tryParse(value);
                      if(amount! > 1e9){
                        return 'Number is too big (max is 1 billion)';
                      }
                    }catch(error){
                      return 'Invalid format';
                    }

                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                value: _isIncome,
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),

                  ),
                ),
                dropdownColor: Colors.white,
                items: const [
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
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Transaction Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  style: const TextStyle(color: Colors.black87),
                ),
                subtitle: const Text('Tap to select a date'),
                trailing: const Icon(Icons.calendar_today, color: Colors.black),
                onTap: _pickDate,
              ),
              ListTile(
                title: Text(
                  'Transaction Time: ${_selectedTime.format(context)}',
                  style: const TextStyle(color: Colors.black87),
                ),
                subtitle: const Text('Tap to select a time'),
                trailing: const Icon(Icons.access_time, color: Colors.black),
                onTap: _pickTime,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _submitForm,
                icon: const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Transaction'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

