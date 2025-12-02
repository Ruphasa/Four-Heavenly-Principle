import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/pages/activity_broadcast/activity_add_step_1.dart';
import 'package:pentagram/pages/activity_broadcast/activity_add_step_2.dart';
import 'package:pentagram/pages/activity_broadcast/activity_add_step_3.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/common/snackbar_helper.dart';

class ActivityAdd extends ConsumerStatefulWidget {
  const ActivityAdd({super.key});

  @override
  ConsumerState<ActivityAdd> createState() => _ActivityAddState();
}

class _ActivityAddState extends ConsumerState<ActivityAdd> {
  final _formKey = GlobalKey<FormState>();
  final _namaKegiatanController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedKategori;
  String? _selectedLokasi;
  String? _selectedPenanggungJawab;
  DateTime? _selectedDate;

  int _currentStep = 0;

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tambah Kegiatan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Buat kegiatan baru untuk RT',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress Indicator
                  Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          height: 6,
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getStepTitle(_currentStep),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentStep == 0) ...[
                        ActivityAddStep1(
                          namaController: _namaKegiatanController,
                          selectedKategori: _selectedKategori,
                          onKategoriChanged: (value) {
                            setState(() {
                              _selectedKategori = value;
                            });
                          },
                        ),
                      ] else if (_currentStep == 1) ...[
                        ActivityAddStep2(
                          selectedDate: _selectedDate,
                          onDateTap: _selectDate,
                          selectedLokasi: _selectedLokasi,
                          onLokasiChanged: (value) {
                            setState(() {
                              _selectedLokasi = value;
                            });
                          },
                        ),
                      ] else ...[
                        ActivityAddStep3(
                          deskripsiController: _deskripsiController,
                          selectedPenanggungJawab: _selectedPenanggungJawab,
                          onPenanggungJawabChanged: (value) {
                            setState(() {
                              _selectedPenanggungJawab = value;
                            });
                          },
                          namaController: _namaKegiatanController,
                          selectedKategori: _selectedKategori,
                          selectedDate: _selectedDate,
                          selectedLokasi: _selectedLokasi,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text(
                          'Kembali',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleNext,
                      icon: Icon(
                        _currentStep == 2 ? Icons.check : Icons.arrow_forward,
                      ),
                      label: Text(
                        _currentStep == 2 ? 'Simpan' : 'Lanjut',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Langkah 1: Informasi Dasar';
      case 1:
        return 'Langkah 2: Waktu & Tempat';
      case 2:
        return 'Langkah 3: Detail & Konfirmasi';
      default:
        return '';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleNext() {
    if (_currentStep < 2) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      _submitForm();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_namaKegiatanController.text.trim().isEmpty) {
          SnackbarHelper.show(
            context,
            'Nama kegiatan harus diisi',
            backgroundColor: Colors.red,
          );
          return false;
        }
        if (_selectedKategori == null) {
          SnackbarHelper.show(
            context,
            'Kategori harus dipilih',
            backgroundColor: Colors.red,
          );
          return false;
        }
        return true;
      case 1:
        if (_selectedDate == null) {
          SnackbarHelper.show(
            context,
            'Tanggal harus dipilih',
            backgroundColor: Colors.red,
          );
          return false;
        }
        if (_selectedLokasi == null) {
          SnackbarHelper.show(
            context,
            'Lokasi harus dipilih',
            backgroundColor: Colors.red,
          );
          return false;
        }
        return true;
      case 2:
        if (_selectedPenanggungJawab == null) {
          SnackbarHelper.show(
            context,
            'Penanggung jawab harus dipilih',
            backgroundColor: Colors.red,
          );
          return false;
        }
        if (_deskripsiController.text.trim().isEmpty) {
          SnackbarHelper.show(
            context,
            'Deskripsi harus diisi',
            backgroundColor: Colors.red,
          );
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final repo = ref.read(activityRepositoryProvider);
        final activity = Activity(
          id: 0,
          nama: _namaKegiatanController.text.trim(),
          kategori: _selectedKategori!,
          penanggungJawab: _selectedPenanggungJawab!,
          tanggal: _selectedDate!,
          waktu: '00:00',
          deskripsi: _deskripsiController.text.trim(),
          lokasi: _selectedLokasi!,
          peserta: 0,
        );
        await repo.create(activity);

        SnackbarHelper.show(
          context,
          'Kegiatan berhasil ditambahkan!',
          backgroundColor: Colors.green,
        );
        Navigator.pop(context, true);
      } catch (e) {
        SnackbarHelper.show(
          context,
          'Gagal menyimpan: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
