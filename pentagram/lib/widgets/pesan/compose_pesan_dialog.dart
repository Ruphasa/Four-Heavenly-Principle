import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/providers/fcm_providers.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class ComposePesanDialog extends ConsumerStatefulWidget {
  const ComposePesanDialog({super.key});

  @override
  ConsumerState<ComposePesanDialog> createState() => _ComposePesanDialogState();
}

class _ComposePesanDialogState extends ConsumerState<ComposePesanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _pesanController = TextEditingController();
  String? _selectedCitizenId;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  Future<void> _sendPesan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final fcmNotificationService = ref.read(fcmNotificationServiceProvider);

      // Send pesan with FCM notification
      await fcmNotificationService.sendPesanNotification(
        citizenId: _selectedCitizenId ?? 'admin',
        nama: _namaController.text.trim(),
        pesan: _pesanController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesan berhasil dikirim'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim pesan: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final citizensAsync = ref.watch(citizensWithUserStreamProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.padding(24)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kirim Pesan Baru',
                  style: TextStyle(
                    fontSize: responsive.fontSize(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.spacing(16)),

                // Recipient dropdown
                citizensAsync.when(
                  data: (citizensWithUser) {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Penerima',
                        labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(8),
                          ),
                        ),
                      ),
                      value: _selectedCitizenId,
                      items: citizensWithUser.map((cw) {
                        return DropdownMenuItem(
                          value: cw.documentId,
                          child: Text(
                            cw.name,
                            style: TextStyle(fontSize: responsive.fontSize(14)),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCitizenId = value);
                        if (value != null) {
                          final citizenWithUser = citizensWithUser.firstWhere(
                            (cw) => cw.documentId == value,
                          );
                          _namaController.text = citizenWithUser.name;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih penerima';
                        }
                        return null;
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Text(
                    'Error loading citizens: $error',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: responsive.fontSize(12),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spacing(16)),

                // Message field
                TextFormField(
                  controller: _pesanController,
                  decoration: InputDecoration(
                    labelText: 'Pesan',
                    labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        responsive.borderRadius(8),
                      ),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  style: TextStyle(fontSize: responsive.fontSize(14)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Masukkan pesan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: responsive.spacing(24)),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        'Batal',
                        style: TextStyle(fontSize: responsive.fontSize(14)),
                      ),
                    ),
                    SizedBox(width: responsive.spacing(8)),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendPesan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.padding(24),
                          vertical: responsive.padding(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: responsive.iconSize(16),
                              height: responsive.iconSize(16),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Kirim',
                              style: TextStyle(
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
