import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';
import 'doctor_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  String searchText = '';
  String selectedSpecialty = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('د.', '')
        .replaceAll('dr.', '')
        .replaceAll('dr', '')
        .replaceAll('.', '')
        .trim();
  }

  void selectSpecialty(String specialty) {
    setState(() {
      selectedSpecialty = selectedSpecialty == specialty ? '' : specialty;
    });
  }

  bool matchesSelectedSpecialty(String specialty) {
    final value = normalizeText(specialty);

    if (selectedSpecialty.isEmpty) return true;

    if (selectedSpecialty == 'Heart') {
      return value.contains('heart') ||
          value.contains('cardio') ||
          value.contains('cardiology') ||
          value.contains('قلب');
    }

    if (selectedSpecialty == 'Neuro') {
      return value.contains('neuro') ||
          value.contains('brain') ||
          value.contains('neurology') ||
          value.contains('اعصاب');
    }

    if (selectedSpecialty == 'Pedia') {
      return value.contains('pedia') ||
          value.contains('child') ||
          value.contains('children') ||
          value.contains('pediatrics') ||
          value.contains('اطفال');
    }

    if (selectedSpecialty == 'Eye') {
      return value.contains('eye') ||
          value.contains('vision') ||
          value.contains('ophthalmology') ||
          value.contains('عيون');
    }

    return true;
  }

  bool matchesArabicEnglishSearch({
    required String search,
    required String name,
    required String specialty,
  }) {
    final normalizedSearch = normalizeText(search);
    final normalizedName = normalizeText(name);
    final normalizedSpecialty = normalizeText(specialty);

    if (normalizedSearch.isEmpty) return true;

    if (normalizedName.contains(normalizedSearch) ||
        normalizedSpecialty.contains(normalizedSearch)) {
      return true;
    }

    if (normalizedSearch.contains('قلب')) {
      return normalizedSpecialty.contains('cardio') ||
          normalizedSpecialty.contains('cardiology') ||
          normalizedSpecialty.contains('heart');
    }

    if (normalizedSearch.contains('اعصاب')) {
      return normalizedSpecialty.contains('neuro') ||
          normalizedSpecialty.contains('neurology') ||
          normalizedSpecialty.contains('brain');
    }

    if (normalizedSearch.contains('اطفال')) {
      return normalizedSpecialty.contains('pedia') ||
          normalizedSpecialty.contains('pediatrics') ||
          normalizedSpecialty.contains('child') ||
          normalizedSpecialty.contains('children');
    }

    if (normalizedSearch.contains('عيون')) {
      return normalizedSpecialty.contains('eye') ||
          normalizedSpecialty.contains('vision') ||
          normalizedSpecialty.contains('ophthalmology');
    }

    if (normalizedSearch.contains('cardio') ||
        normalizedSearch.contains('cardiology') ||
        normalizedSearch.contains('heart')) {
      return normalizedSpecialty.contains('قلب');
    }

    if (normalizedSearch.contains('neuro') ||
        normalizedSearch.contains('neurology')) {
      return normalizedSpecialty.contains('اعصاب');
    }

    if (normalizedSearch.contains('pedia') ||
        normalizedSearch.contains('pediatrics')) {
      return normalizedSpecialty.contains('اطفال');
    }

    if (normalizedSearch.contains('eye') ||
        normalizedSearch.contains('ophthalmology')) {
      return normalizedSpecialty.contains('عيون');
    }

    return false;
  }

  String getDoctorImage(int doctorId) {
    switch (doctorId) {
      case 1:
        return 'assets/images/doctor1.jpg';
      case 2:
        return 'assets/images/doctor3.jpg';
      case 3:
        return 'assets/images/doctor2.jpg';
      case 4:
        return 'assets/images/doctor4.jpg';
      default:
        return 'assets/images/doctor1.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 390,
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: [
                Row(
                  children: [
                    const Text(
                      'MedLink',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: primary.withOpacity(.12),
                      child: const Icon(Icons.person, color: primary),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff6A3CFF),
                        Color(0xff4D1FFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need a consultation?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Book your appointment with the best doctors easily.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: searchController,
                  textDirection: TextDirection.rtl,
                  onChanged: (value) {
                    setState(() {
                      searchText = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search doctors or specialty',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchText = '';
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Specialties',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SpecialtyCard(
                      icon: Icons.favorite,
                      title: 'Heart',
                      isSelected: selectedSpecialty == 'Heart',
                      onTap: () => selectSpecialty('Heart'),
                    ),
                    SpecialtyCard(
                      icon: Icons.psychology,
                      title: 'Neuro',
                      isSelected: selectedSpecialty == 'Neuro',
                      onTap: () => selectSpecialty('Neuro'),
                    ),
                    SpecialtyCard(
                      icon: Icons.child_care,
                      title: 'Pedia',
                      isSelected: selectedSpecialty == 'Pedia',
                      onTap: () => selectSpecialty('Pedia'),
                    ),
                    SpecialtyCard(
                      icon: Icons.visibility,
                      title: 'Eye',
                      isSelected: selectedSpecialty == 'Eye',
                      onTap: () => selectSpecialty('Eye'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  'Featured Doctors',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                FutureBuilder<List<dynamic>>(
                  future: ApiService.getDoctors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text(
                        'Failed to load doctors',
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    final doctors = snapshot.data ?? [];

                    final filteredDoctors = doctors.where((doctor) {
                      final name = doctor['fullName']?.toString() ?? '';
                      final specialty = doctor['specialty']?.toString() ?? '';

                      final matchesSearch = matchesArabicEnglishSearch(
                        search: searchText,
                        name: name,
                        specialty: specialty,
                      );

                      final matchesSpecialty =
                      matchesSelectedSpecialty(specialty);

                      return matchesSearch && matchesSpecialty;
                    }).toList();

                    if (filteredDoctors.isEmpty) {
                      return const Text('No doctors found');
                    }

                    return Column(
                      children: filteredDoctors.map((doctor) {
                        final doctorId = int.tryParse(
                          doctor['doctorId']?.toString() ?? '0',
                        ) ??
                            0;

                        return DoctorCard(
                          name: doctor['fullName']?.toString() ?? 'Doctor',
                          specialty:
                          doctor['specialty']?.toString() ?? 'Specialist',
                          rating: '4.8',
                          time: '10:30 AM',
                          doctorId: doctorId,
                          imagePath: getDoctorImage(doctorId),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SpecialtyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialtyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : primary,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String rating;
  final String time;
  final int doctorId;
  final String imagePath;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.time,
    required this.doctorId,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorDetailsScreen(
              doctorId: doctorId,
              name: name,
              specialty: specialty,
              rating: rating,
              time: time,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xffEDE7FF),
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                      Text(' $rating'),
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(' $time'),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.bookAppointment(
                    patientId: UserSession.userId ?? 1,
                    doctorId: doctorId,
                    appointmentDate: DateTime.now().add(
                      const Duration(days: 1),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment booked successfully'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to book appointment'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Book'),
            ),
          ],
        ),
      ),
    );
  }
}