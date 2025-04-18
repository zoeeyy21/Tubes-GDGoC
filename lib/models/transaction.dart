abstract class Transaction {
  final String _id;
  final String _userId;
  final String _categoryId;
  final String _type; // income atau expense
  final String _title;
  final double _amount;
  final String _description;
  final DateTime date;

  Transaction(
    this._id,
    this._userId,
    this._categoryId,
    this._type,
    this._title,
    this._amount,
    this._description,
    this.date,
  );

  // Getters
  String get id => _id;
  String get userId => _userId;
  String get categoryId => _categoryId;
  String get type => _type;
  String get title => _title;
  double get amount => _amount;
  String get description => _description;
}