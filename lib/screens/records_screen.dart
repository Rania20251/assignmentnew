import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
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

  Future<void> uploadReport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    final file = result.files.single;
    final fileName = file.name;

    try {
      await ApiService.createMedicalRecord(
        patientId: UserSession.userId ?? 0,
        doctorId: 1,
        title: fileName,
        description: 'Uploaded medical report',
        recordDate: DateTime.now().toString().split(' ')[0],
        status: 'Uploaded',
        fileUrl: file.path ?? fileName,
      );

      refreshRecords();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report uploaded successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload report'),
        ),
      );
    }
  }

  Future<void> deleteRecord(int recordId) async {
    try {
      await ApiService.deleteMedicalRecord(recordId);

      refreshRecords();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record deleted successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete record'),
        ),
      );
    }
  }

  Future<void> confirmDelete(int recordId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Record'),
          content: const Text(
            'Are you sure you want to delete this medical record?',
          ),
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
      await deleteRecord(recordId);
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshRecords,
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: uploadReport,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: recordsFuture,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: 6),
                          Text(
                            record['description']?.toString() ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(record['recordDate']?.toString() ?? ''),
                          const SizedBox(height: 8),
                          Text(
                            record['status']?.toString() ?? '',
                            style: const TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if ((record['fileUrl'] ?? '').toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                record['fileUrl'].toString(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        confirmDelete(recordId);
                      },
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