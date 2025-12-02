import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/broadcast_message.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class BroadcastCreatePage extends ConsumerStatefulWidget {
  const BroadcastCreatePage({super.key});

  @override
  ConsumerState<BroadcastCreatePage> createState() => _BroadcastCreatePageState();
}

class _BroadcastCreatePageState extends ConsumerState<BroadcastCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  String _selectedCategory = 'Informasi Umum';
  bool _isUrgent = false;
  String _selectedRecipient = 'Semua Warga RT 01';

  final List<String> _categories = [
    'Informasi Umum',
    'Kegiatan',
    'Iuran',
    'Keamanan',
    'Kesehatan',
  ];

  final List<String> _recipients = [
    'Semua Warga RT 01',
    'Ketua RT',
    'Warga Belum Bayar',
    'Grup Khusus',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Broadcast'),
        backgroundColor: AppColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Broadcast',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Content
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Isi Pesan',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isi pesan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Recipient
            DropdownButtonFormField<String>(
              value: _selectedRecipient,
              decoration: const InputDecoration(
                labelText: 'Penerima',
                border: OutlineInputBorder(),
              ),
              items: _recipients.map((recipient) {
                return DropdownMenuItem(
                  value: recipient,
                  child: Text(recipient),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRecipient = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Urgent checkbox
            CheckboxListTile(
              title: const Text('Tandai sebagai Urgent'),
              value: _isUrgent,
              onChanged: (value) {
                setState(() {
                  _isUrgent = value!;
                });
              },
              activeColor: Colors.red,
            ),
            const SizedBox(height: 24),
            
            // Send button
            ElevatedButton(
              onPressed: _sendBroadcast,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kirim Broadcast',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendBroadcast() async {
    if (_formKey.currentState!.validate()) {
      final message = BroadcastMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        isUrgent: _isUrgent,
        sender: 'Admin Jawara',
        sentDate: DateTime.now(),
        recipientCount: 85,
        readCount: 0,
        recipients: [_selectedRecipient],
      );

      try {
        final repo = ref.read(broadcastRepositoryProvider);
        await repo.create(message);
        if (!mounted) return;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Broadcast berhasil dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim broadcast: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}