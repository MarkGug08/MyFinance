
class UserTransaction{
  String id;
  double amount;
  String title;
  DateTime dateTime;
  String user;

  UserTransaction({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.title,
    required this.user
  });

}