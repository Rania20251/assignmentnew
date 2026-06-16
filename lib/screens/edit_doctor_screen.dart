import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditDoctorScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const EditDoctorScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final nameController = TextEditingController();
  final specialtyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.doctor['fullName']?.toString() ?? '';
    specialtyController.text = widget.doctor['specialty']?.toString() ?? '';
    phoneController.text = widget.doctor['phoneNumber']?.toString() ?? '';
    emailController.text = widget.doctor['email']?.toString() ?? '';
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> updateDoctor() async {
    final doctorId = int.tryParse(
      widget.doctor['doctorId']?.toString() ?? '0',
    ) ??
        0;

    if (doctorId == 0) {
      showMessage('Invalid doctor ID');
      return;
    }

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
      await ApiService.updateDoctor(
        doctorId: doctorId,
        fullName: nameController.text.trim(),
        specialty: specialtyController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        email: emailController.text.trim(),
        image: widget.doctor['image']?.toString() ?? '',
      );

      if (!mounted) return;

      showMessage('Doctor updated successfully');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        showMessage('Failed to update doctor');
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
        title: const Text('Edit Doctor'),
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
                Icons.edit,
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
                  onPressed: isLoading ? null : updateDoctor,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Update Doctor',
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