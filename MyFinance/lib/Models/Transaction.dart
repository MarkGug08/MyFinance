import 'package:myfinance/Models/User.dart';

class UserTransaction{
  double amount;
  String Description;
  DateTime dateTime;
  String user;

  UserTransaction({
    required this.amount,
    required this.dateTime,
    required this.Description,
    required this.user
  });

}