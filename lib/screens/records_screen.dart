import 'package:flutter/material.dart';
import '../services/api_service.dart';

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

      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getMedicalRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(
              child: Text('No medical records found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

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
                            record['title']
                                ?.toString() ??
                                'Medical Record',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            record['description']
                                ?.toString() ??
                                '',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            record['recordDate']
                                ?.toString() ??
                                '',
                          ),

                          const SizedBox(height: 8),

                          Text(
                            record['status']
                                ?.toString() ??
                                '',
                            style: const TextStyle(
                              color: primary,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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