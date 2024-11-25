import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static void saveToDatabase(String? name, String? countryCode, String? phone,
      String? address, String? gender, String? email) async {

    log(email.toString());

    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email) // Use email as unique identifier
        .get();

    if (userQuery.docs.isNotEmpty) {
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

  static void deleteFromDatabase(String? email) async {


    log(email.toString());

    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email) // Use email as unique identifier
        .get();

    if (userQuery.docs.isNotEmpty) {
      // If the user exists, delete the existing document
      String userId = userQuery.docs.first.id;
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      log("User account data of $email deleted successfully");
    }
  }

  static Future<Map<String, dynamic>?> getDataByEmail(String? email) async {
    // Reference to Firestore collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

    try {
      // Query Firestore where the uniqueField matches the uniqueFieldValue
      QuerySnapshot querySnapshot = await collectionRef
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the document is found, access the document data
        var documentData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        //log(documentData as String);
        return documentData;
        print("Document found: $documentData");
      } else {
        print("No document found with the unique field value: $email");
        return null;
      }
    } catch (e) {
      print("Error retrieving document: $e");
    }
    return null;
  }

}
