import 'package:intl/intl.dart';

extension NumberExtension on num {
  String thousandFormat() {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(this);
  }
}
