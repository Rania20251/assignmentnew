import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final int doctorId;
  final String name;
  final String specialty;
  final String rating;
  final String time;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Doctor Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: const Color(0xffEDE7FF),
                backgroundImage: AssetImage(
                  doctorId == 1
                      ? 'assets/images/doctor1.jpg'
                      : doctorId == 2
                      ? 'assets/images/doctor2.jpg'
                      : 'assets/images/doctor3.jpg',
                ),
              ),
            ),

            const SizedBox(height: 22),

            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                specialty,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  detailRow(Icons.star, 'Rating', rating),
                  detailRow(Icons.access_time, 'Available Time', time),
                  detailRow(Icons.medical_services, 'Specialty', specialty),
                  detailRow(Icons.badge, 'Doctor ID', doctorId.toString()),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 17),
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String title, String value) {
    const primary = Color(0xff5B2EFF);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xffEDE7FF),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}