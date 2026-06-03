import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'book_appointment_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<List<dynamic>> appointmentsFuture;

  @override
  void initState() {
    super.initState();
    appointmentsFuture = ApiService.getAppointments();
  }

  void refreshAppointments() {
    setState(() {
      appointmentsFuture = ApiService.getAppointments();
    });
  }

  String formatDateTime(String value) {
    final dateTime = DateTime.parse(value);

    final date =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$date  $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load appointments',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final appointments = snapshot.data ?? [];

          if (appointments.isEmpty) {
            return const Center(
              child: Text('No appointments found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];

              return AppointmentCard(
                appointmentId: appointment['appointmentId'],
                doctorId: appointment['doctorId'],
                patientId: appointment['patientId'].toString(),
                dateTime: formatDateTime(
                  appointment['appointmentDate'].toString(),
                ),
                status: appointment['status'] ?? 'Pending',
                onDeleted: refreshAppointments,
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BookAppointmentScreen(),
            ),
          );

          refreshAppointments();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final int appointmentId;
  final int doctorId;
  final String patientId;
  final String dateTime;
  final String status;
  final VoidCallback onDeleted;

  const AppointmentCard({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.dateTime,
    required this.status,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return FutureBuilder<dynamic>(
      future: ApiService.getDoctorById(doctorId),
      builder: (context, snapshot) {
        String doctorName = 'Doctor';
        String specialty = 'Specialist';

        if (snapshot.hasData) {
          doctorName = snapshot.data['fullName'] ?? 'Doctor';
          specialty = snapshot.data['specialty'] ?? 'Specialist';
        }

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
                  Icons.calendar_month,
                  color: primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
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

                    Text('Patient ID: $patientId'),

                    const SizedBox(height: 8),

                    Text('Date & Time: $dateTime'),

                    const SizedBox(height: 8),

                    Text(
                      status,
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  try {
                    await ApiService.deleteAppointment(appointmentId);

                    onDeleted();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appointment deleted successfully'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to delete appointment'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}