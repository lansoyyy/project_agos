import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addMerchant(name, number, address, email, businessHours, price,
    stationImage, List offers, gallonPrice, deliveryFee) async {
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
    'reviews': [],
    'businessHours': businessHours,
    'price': price,
    'stationImage': stationImage,
    'dateTime': DateTime.now(),
    'offers': offers,
    'gallonPrice': gallonPrice,
    'deliveryFee': deliveryFee
  };

  await docUser.set(json);
}
