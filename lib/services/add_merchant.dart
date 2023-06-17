import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addMerchant(
    name, number, address, email, businessHours, price, stationImage) async {
  final docUser = FirebaseFirestore.instance
      .collection('Merchant')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'number': number,
    'address': address,
    'email': email,
    'id': docUser.id,
    'history': [],
    'location': {'lat': 0.00, 'long': 0.00},
    'profilePicture': 'https://cdn-icons-png.flaticon.com/256/149/149071.png',
    'type': 'Merchant',
    'offer': 'No Offer',
    'stars': 0,
    'reviews': []
  };

  await docUser.set(json);
}
