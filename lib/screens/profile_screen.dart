import 'package:flutter/material.dart';
import '../services/user_session.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    final fullName = UserSession.fullName ?? 'No Name';
    final email = UserSession.email ?? 'No Email';
    final phone = UserSession.phoneNumber ?? 'Not Available';
    final address = UserSession.address ?? 'Not Available';
    final gender = UserSession.gender ?? 'Not Available';

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Profile'),
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

              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  email,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  'User ID: ${UserSession.userId}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              FutureBuilder<int>(
                future: ApiService.getAppointmentCountByUser(
                  UserSession.userId ?? 0,
                ),
                builder: (context, snapshot) {
                  String value = 'Loading...';

                  if (snapshot.hasData) {
                    value = '${snapshot.data} Appointments';
                  }

                  if (snapshot.hasError) {
                    value = '0 Appointments';
                  }

                  return ProfileItem(
                    icon: Icons.calendar_month,
                    title: 'My Appointments',
                    value: value,
                  );
                },
              ),

              const ProfileItem(
                icon: Icons.medical_services,
                title: 'Medical Records',
                value: 'From Database',
              ),

              ProfileItem(
                icon: Icons.phone,
                title: 'Phone Number',
                value: phone,
              ),

              ProfileItem(
                icon: Icons.location_on,
                title: 'Address',
                value: address,
              ),

              ProfileItem(
                icon: Icons.person,
                title: 'Gender',
                value: gender,
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );

                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.lock),
                  label: const Text('Change Password'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () async {
                    await UserSession.clear();

                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                          (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xffEDE7FF),
            child: Icon(icon, color: primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}