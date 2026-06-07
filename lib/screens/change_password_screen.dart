import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool hideOld = true;
  bool hideNew = true;
  bool hideConfirm = true;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> changePassword() async {
    if (oldPasswordController.text.trim().isEmpty) {
      showMessage('Please enter old password');
      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      showMessage('Please enter new password');
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      showMessage('Please confirm new password');
      return;
    }

    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      showMessage('Passwords do not match');
      return;
    }

    if (UserSession.userId == null) {
      showMessage('User not found. Please login again.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final success = await ApiService.changePassword(
      userId: UserSession.userId!,
      oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      showMessage('Password changed successfully');
      Navigator.pop(context);
    } else {
      showMessage('Failed to change password');
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Change Password'),
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
              const SizedBox(height: 30),

              const Icon(
                Icons.lock_reset,
                size: 80,
                color: primary,
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Update Password',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'Enter your old and new password',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: oldPasswordController,
                obscureText: hideOld,
                decoration: InputDecoration(
                  hintText: 'Old Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideOld ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideOld = !hideOld;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: newPasswordController,
                obscureText: hideNew,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideNew = !hideNew;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: confirmPasswordController,
                obscureText: hideConfirm,
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  prefixIcon: const Icon(Icons.verified_user),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideConfirm = !hideConfirm;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
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
                  onPressed: isLoading ? null : changePassword,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Change Password',
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
}