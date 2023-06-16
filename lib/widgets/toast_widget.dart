import 'package:agos/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast(msg) {
  return Fluttertoast.showToast(
  backgroundColor: primary,
    toastLength: Toast.LENGTH_LONG,
    msg: msg,
  );
}
