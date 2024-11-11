import 'package:calculator/Provider/auth_provider.dart';
import 'package:calculator/Services/auth_service.dart';
import 'package:calculator/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage; // To store the selected image

  String? _name;
  String? _countryCode;
  String? _phone;
  String? _address;
  String? _gender="Male";

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<String> countryCodes = [
    "+1",
    "+91",
    "+44",
    "+33",
    "+61",
    "+81",
    "+49",
    "+55",
    "+7"
  ]; // List of country codes
  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen:false);

    // Ensure the method always returns a valid widget
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text('Pick from Gallery'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Take a Photo'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Name TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 16),

              // Country Code and Phone Number Row
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a country code';
                          }
                          return null; // Return null if validation passes
                        },
                          value: _countryCode,
                          items: countryCodes
                              .map((code) => DropdownMenuItem<String>(
                                    value: code,
                                    child: Text(code),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _countryCode = value;
                            });
                          }, decoration: InputDecoration(
                        labelText: 'Country Code', // Label added here

                      ),)),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter number';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return '10 digits only';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _phone = value;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Address TextFormField (Multiline)
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value;
                },
              ),
              SizedBox(height: 16),

              // Gender Radio Buttons
              Text("Gender", style: TextStyle(fontSize: 16)),
              RadioListTile<String>(
                title: Text("Male"),
                value: "Male",
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text("Female"),
                value: "Female",
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text("Other"),
                value: "Other",
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              if (_gender == null)
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Please select your gender',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email ID'),
                initialValue: authProvider.user?.email,
                enabled: false, // Make this field read-only
                style: TextStyle(color: Colors.white),
              ),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _gender != null) {
                    _formKey.currentState!.save();



                    print("Name: $_name");
                    print("Country Code: $_countryCode");
                    print("Phone: $_phone");
                    print("Address: $_address");
                    print("Gender: $_gender");

                    DatabaseService.saveToDatabase(_name, _countryCode, _phone, _address, _gender, "mailchittadeep@gmail.com");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Form Submitted Successfully!")),
                    );

                  } else {
                    setState(() {});
                  }
                },
                child: Text("Submit"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
