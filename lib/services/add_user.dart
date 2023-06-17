import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addUser(name, number, address, email) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'number': number,
    'address': address,
    'email': email,
    'id': docUser.id,
    'history': [],
    'location': {'lat': 0.00, 'long': 0.00},
    'favorites': [],
    'notif': [],
    'profilePicture': 'https://cdn-icons-png.flaticon.com/256/149/149071.png',
    'discount': 0,
    'type': 'User'
  };

  await docUser.set(json);
}
