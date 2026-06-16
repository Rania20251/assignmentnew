import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final nameController = TextEditingController();
  final specialtyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addDoctor() async {
    if (nameController.text.trim().isEmpty) {
      showMessage('Please enter doctor name');
      return;
    }

    if (specialtyController.text.trim().isEmpty) {
      showMessage('Please enter specialty');
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.createDoctor(
        fullName: nameController.text.trim(),
        specialty: specialtyController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        email: emailController.text.trim(),
        image: '',
      );

      if (!mounted) return;

      showMessage('Doctor added successfully');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        showMessage('Failed to add doctor');
      }
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    specialtyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Add Doctor'),
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

              const Icon(
                Icons.local_hospital,
                size: 80,
                color: primary,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: inputDecoration(
                  hint: 'Doctor Full Name',
                  icon: Icons.person,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: specialtyController,
                decoration: inputDecoration(
                  hint: 'Specialty',
                  icon: Icons.medical_services,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration(
                  hint: 'Phone Number',
                  icon: Icons.phone,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  hint: 'Email',
                  icon: Icons.email,
                ),
              ),

              const SizedBox(height: 26),

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
                  onPressed: isLoading ? null : addDoctor,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Add Doctor',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}