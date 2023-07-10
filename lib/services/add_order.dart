import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addOrder(
    username,
    usernumber,
    useraddress,
    userlat,
    userlong,
    stationid,
    payment,
    String gallonType,
    qty,
    userprofile,
    orderType,
    String mode) async {
  final docUser = FirebaseFirestore.instance.collection('Orders').doc();

  final json = {
    'username': username,
    'usernumber': usernumber,
    'useraddress': useraddress,
    'stationid': stationid,
    'id': docUser.id,
    'payment': payment,
    'gallonType': gallonType,
    'qty': qty,
    'dateTime': DateTime.now(),
    'location': {'lat': userlat, 'long': userlong},
    'status': 'Pending',
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'userprofile': userprofile,
    'orderType': orderType,
    'mode': mode,
  };

  await docUser.set(json);
}
