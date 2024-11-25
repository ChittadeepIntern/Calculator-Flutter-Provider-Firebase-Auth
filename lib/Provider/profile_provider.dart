import 'dart:developer';

import 'package:calculator/Services/database_service.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {

  bool isLoading = true;


  String? _name;
  String? _countryCode;
  String? _phone;
  String? _address;
  String? _gender = "Male";

  // Getters
  String? get name => _name;

  String? get countryCode => _countryCode;

  String? get phone => _phone;

  String? get address => _address;

  String? get gender => _gender;

  // Setters
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  set countryCode(String? value) {
    _countryCode = value;
    notifyListeners();
  }

  set phone(String? value) {
    _phone = value;
    notifyListeners();
  }

  set address(String? value) {
    _address = value;
    notifyListeners();
  }

  set gender(String? value) {
    _gender = value;
    notifyListeners();
  }

  // Load data from database
  void loadData(String email) {

    log("Load data function called");

      Future<Map<String, dynamic>?> data = DatabaseService.getDataByEmail(
          email);
      log("Email $email");

      data.then((data) {
        _name = data!['name'] as String?;
        _countryCode = data['countryCode'] as String?;
        _phone = data['phone'] as String?;
        _address = data['address'] as String?;
        _gender = data['gender'] as String?;

        log(_name.toString());
        log(_gender.toString());
        log(_countryCode.toString());
        log(_address.toString());
        log(_gender.toString());
      });

      data.whenComplete(() {
        isLoading = false;
        notifyListeners();
      });
    }

  @override
  void dispose() {
    _name=null;
    _countryCode=null;
    _phone=null;
    _address=null;
    _gender = "Male";
    isLoading=true;
    log("Profile provider disposed");
    notifyListeners();
    super.dispose();
  }
}
