import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController genderController;
  late TextEditingController birthController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: UserSession.fullName ?? '');
    emailController = TextEditingController(text: UserSession.email ?? '');
    phoneController = TextEditingController(text: UserSession.phoneNumber ?? '');
    addressController = TextEditingController(text: UserSession.address ?? '');
    genderController = TextEditingController(text: UserSession.gender ?? '');
    birthController = TextEditingController(text: UserSession.dateOfBirth ?? '');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 390,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(height: 20),

              buildField('Full Name', Icons.person, nameController),
              buildField('Email', Icons.email, emailController),
              buildField('Phone Number', Icons.phone, phoneController),
              buildField('Address', Icons.location_on, addressController),
              buildField('Gender', Icons.wc, genderController),
              buildField('Date of Birth', Icons.cake, birthController),

              const SizedBox(height: 20),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() {
                      isLoading = true;
                    });

                    final success = await ApiService.updateUser(
                      userId: UserSession.userId!,
                      fullName: nameController.text,
                      email: emailController.text,
                      password: '123456',
                      phoneNumber: phoneController.text,
                      address: addressController.text,
                      gender: genderController.text,
                      dateOfBirth: birthController.text,
                      profileImage:
                      UserSession.profileImage ?? 'assets/images/profile.jpg',
                    );

                    setState(() {
                      isLoading = false;
                    });

                    if (success) {
                      UserSession.fullName = nameController.text;
                      UserSession.email = emailController.text;
                      UserSession.phoneNumber = phoneController.text;
                      UserSession.address = addressController.text;
                      UserSession.gender = genderController.text;
                      UserSession.dateOfBirth = birthController.text;

                      Navigator.pop(context);
                    } else {
                      showMessage('Failed to update profile');
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
      String hint,
      IconData icon,
      TextEditingController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}