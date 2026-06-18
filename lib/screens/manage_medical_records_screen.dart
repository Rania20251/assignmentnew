import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ManageMedicalRecordsScreen extends StatefulWidget {
  const ManageMedicalRecordsScreen({super.key});

  @override
  State<ManageMedicalRecordsScreen> createState() =>
      _ManageMedicalRecordsScreenState();
}

class _ManageMedicalRecordsScreenState
    extends State<ManageMedicalRecordsScreen> {
  late Future<List<dynamic>> recordsFuture;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  void loadRecords() {
    recordsFuture = ApiService.getMedicalRecords();
  }

  void refreshRecords() {
    setState(() {
      loadRecords();
    });
  }

  Future<void> deleteRecord(int recordId) async {
    await ApiService.deleteMedicalRecord(recordId);
    refreshRecords();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record deleted successfully')),
    );
  }

  Future<void> confirmDelete(int recordId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteRecord(recordId);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Manage Medical Records'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshRecords,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load records',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(child: Text('No medical records found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

              final recordId = int.tryParse(
                record['recordId']?.toString() ?? '0',
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
                        Icons.description,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record['title']?.toString() ?? 'Medical Record',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record['description']?.toString() ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text('Patient ID: ${record['patientId']}'),
                          Text('Doctor ID: ${record['doctorId']}'),
                          const SizedBox(height: 6),
                          Text(record['recordDate']?.toString() ?? ''),
                          const SizedBox(height: 6),
                          Text(
                            record['status']?.toString() ?? '',
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
                      onPressed: () => confirmDelete(recordId),
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