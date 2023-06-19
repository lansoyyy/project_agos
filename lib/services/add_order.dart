import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addOrder(username, usernumber, useraddress, userlat, userlong, stationid,
    payment, size, qty) async {
  final docUser = FirebaseFirestore.instance
      .collection('Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'username': username,
    'usernumber': usernumber,
    'useraddress': useraddress,
    'stationid': stationid,
    'id': docUser.id,
    'payment': payment,
    'size': size,
    'qty': qty,
    'dateTime': DateTime.now(),
    'location': {'lat': userlat, 'long': userlong},
    'status': 'Pending'
  };

  await docUser.set(json);
}
