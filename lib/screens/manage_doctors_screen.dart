import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_doctor_screen.dart';
import 'edit_doctor_screen.dart';

class ManageDoctorsScreen extends StatefulWidget {
  const ManageDoctorsScreen({super.key});

  @override
  State<ManageDoctorsScreen> createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen> {
  late Future<List<dynamic>> doctorsFuture;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  void loadDoctors() {
    doctorsFuture = ApiService.getDoctors();
  }

  void refreshDoctors() {
    setState(() {
      loadDoctors();
    });
  }

  Future<void> openAddDoctor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddDoctorScreen(),
      ),
    );

    if (result == true) {
      refreshDoctors();
    }
  }

  Future<void> openEditDoctor(Map<String, dynamic> doctor) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditDoctorScreen(
          doctor: doctor,
        ),
      ),
    );

    if (result == true) {
      refreshDoctors();
    }
  }

  Future<void> deleteDoctor(int doctorId) async {
    await ApiService.deleteDoctor(doctorId);
    refreshDoctors();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Doctor deleted successfully'),
      ),
    );
  }

  Future<void> confirmDelete(int doctorId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Doctor'),
          content: const Text('Are you sure you want to delete this doctor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await deleteDoctor(doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Manage Doctors'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshDoctors,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddDoctor,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: doctorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load doctors',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final doctors = snapshot.data ?? [];

          if (doctors.isEmpty) {
            return const Center(
              child: Text('No doctors found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];

              final doctorId = int.tryParse(
                doctor['doctorId']?.toString() ?? '0',
              ) ??
                  0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffEDE7FF),
                      child: Icon(
                        Icons.medical_services,
                        color: primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['fullName']?.toString() ?? 'Doctor',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            doctor['specialty']?.toString() ?? 'Specialist',
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            doctor['email']?.toString() ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            openEditDoctor(doctor);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            confirmDelete(doctorId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}