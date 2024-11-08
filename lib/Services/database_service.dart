import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static void saveToDatabase(String? name, String? countryCode, String? phone,
      String? address, String? gender, String? email) async {
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email) // Use email as unique identifier
        .get();

    if (userQuery.docs.isNotEmpty){
      // If the user exists, update the existing document
      String userId = userQuery.docs.first.id;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': name,
        'countryCode': countryCode,
        'phone': phone,
        'address': address,
        'gender': gender,
        'email': email,
      }).then((value) {
        log("Details have been saved");
      }).catchError((error) {
        log("Details failed to submit");
        log(error.toString());
      });
    } else {
      // If the user doesn't exist, create a new document
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'countryCode': countryCode,
        'phone': phone,
        'address': address,
        'gender': gender,
        'email': email,
      }).then((value) {
        log("User data saved successfully!");
      }).catchError((error) {
        log("Details failed to submit");
        log(error.toString());
      });
    }
  }
}
