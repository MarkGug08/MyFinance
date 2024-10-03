import 'package:myfinance/Models/User.dart';

class UserTransaction{
  double amount;
  String title;
  DateTime dateTime;
  String user;

  UserTransaction({
    required this.amount,
    required this.dateTime,
    required this.title,
    required this.user
  });

}