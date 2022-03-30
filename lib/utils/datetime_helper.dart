import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper();

  //from MM/dd/yyyy to dd/MM/yyyy
  static String convertDate(String date) {
    try {
      DateFormat inputFormat = DateFormat('MM/dd/yyyy');
      DateTime inputDate = inputFormat.parse(date);

      DateFormat outputFormat = DateFormat('dd/MM/yyyy');
      String outputDate = outputFormat.format(inputDate);
      return outputDate;
    } catch (e) {
      print('convertDate error: ' + e.toString());
      return '';
    }
  }
}
