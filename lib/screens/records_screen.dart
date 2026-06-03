import 'package:flutter/material.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: ListView(
          children: const [

            RecordCard(
              title: 'Blood Test',
              doctor: 'Dr. Ahmed Khaled',
              date: 'May 20, 2026',
              status: 'Completed',
            ),

            RecordCard(
              title: 'MRI Scan',
              doctor: 'Dr. Sarah Mohammed',
              date: 'May 18, 2026',
              status: 'Pending',
            ),

            RecordCard(
              title: 'Dental Checkup',
              doctor: 'Dr. Mohammed Ali',
              date: 'May 10, 2026',
              status: 'Completed',
            ),
          ],
        ),
      ),
    );
  }
}

class RecordCard extends StatelessWidget {

  final String title;
  final String doctor;
  final String date;
  final String status;

  const RecordCard({
    super.key,
    required this.title,
    required this.doctor,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    const primary = Color(0xff5B2EFF);

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
              Icons.description,
              color: primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  doctor,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 8),

                Text(date),

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
        ],
      ),
    );
  }
}