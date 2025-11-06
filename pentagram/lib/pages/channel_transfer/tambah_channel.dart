import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class TambahChannelPage extends StatefulWidget {
  const TambahChannelPage({super.key});

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

class _TambahChannelPageState extends State<TambahChannelPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController rekeningController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  String? selectedTipe;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tambah Channel Transfer',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: responsive.fontSize(16),
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.padding(20)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(responsive.padding(24)),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: responsive.elevation(6),
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Form Tambah Channel', responsive),
              SizedBox(height: responsive.spacing(20)),

              _buildTextField(
                label: 'Nama Channel',
                hint: 'Contoh: BCA, Dana, QRIS RT',
                controller: namaController,
                responsive: responsive,
              ),
              _buildDropdownField(
                label: 'Tipe Channel',
                hint: '-- Pilih Tipe --',
                value: selectedTipe,
                items: const ['Bank', 'E-Wallet', 'QRIS'],
                onChanged: (val) => setState(() => selectedTipe = val),
                responsive: responsive,
              ),
              _buildTextField(
                label: 'Nomor Rekening / Akun',
                hint: 'Contoh: 1234567890',
                controller: rekeningController,
                responsive: responsive,
              ),
              _buildTextField(
                label: 'Nama Pemilik',
                hint: 'Contoh: John Doe',
                controller: pemilikController,
                responsive: responsive,
              ),
              _buildUploadField(
                label: 'Upload QR (Opsional)',
                hint: 'Unggah gambar QR',
                responsive: responsive,
              ),
              _buildUploadField(
                label: 'Thumbnail (Opsional)',
                hint: 'Unggah logo channel',
                responsive: responsive,
              ),
              _buildTextArea(
                label: 'Catatan (Opsional)',
                hint: 'Contoh: Transfer hanya dari bank yang sama agar instan.',
                controller: catatanController,
                responsive: responsive,
              ),

              SizedBox(height: responsive.spacing(30)),
              responsive.isCompact
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: simpan logika
                            },
                            icon: Icon(Icons.save_rounded, size: responsive.iconSize(18)),
                            label: Text(
                              'Simpan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              padding: EdgeInsets.symmetric(vertical: responsive.padding(14)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                              ),
                              elevation: responsive.elevation(2),
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing(12)),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              namaController.clear();
                              rekeningController.clear();
                              pemilikController.clear();
                              catatanController.clear();
                              setState(() => selectedTipe = null);
                            },
                            icon: Icon(Icons.refresh_rounded, size: responsive.iconSize(18)),
                            label: Text(
                              'Reset',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              padding: EdgeInsets.symmetric(vertical: responsive.padding(14)),
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: simpan logika
                            },
                            icon: Icon(Icons.save_rounded, size: responsive.iconSize(18)),
                            label: Text(
                              'Simpan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              padding: EdgeInsets.symmetric(vertical: responsive.padding(14)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                              ),
                              elevation: responsive.elevation(2),
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.spacing(12)),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              namaController.clear();
                              rekeningController.clear();
                              pemilikController.clear();
                              catatanController.clear();
                              setState(() => selectedTipe = null);
                            },
                            icon: Icon(Icons.refresh_rounded, size: responsive.iconSize(18)),
                            label: Text(
                              'Reset',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              padding: EdgeInsets.symmetric(vertical: responsive.padding(14)),
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== COMPONENT BUILDERS ====

  Widget _buildSectionHeader(String title, ResponsiveHelper responsive) {
    return Row(
      children: [
        Container(
          width: responsive.isCompact ? 3 : 4,
          height: responsive.isCompact ? 18 : 20,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(responsive.borderRadius(2)),
          ),
        ),
        SizedBox(width: responsive.spacing(8)),
        Text(
          title,
          style: TextStyle(
            fontSize: responsive.fontSize(16),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacing(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacing(6)),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: responsive.fontSize(13)),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.padding(16),
                vertical: responsive.padding(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacing(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacing(6)),
          DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint, style: TextStyle(fontSize: responsive.fontSize(13))),
            items: items
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e, style: TextStyle(fontSize: responsive.fontSize(14))),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.padding(16),
                vertical: responsive.padding(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadField({
    required String label,
    required String hint,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacing(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacing(6)),
          Container(
            height: responsive.isCompact ? 70 : 80,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: responsive.padding(16),
              vertical: responsive.padding(14),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: responsive.fontSize(13),
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: responsive.spacing(8)),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implement upload handler
                  },
                  icon: Icon(
                    Icons.upload_file_rounded,
                    size: responsive.iconSize(18),
                  ),
                  label: Text(
                    'Pilih File',
                    style: TextStyle(fontSize: responsive.fontSize(13)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding(14),
                      vertical: responsive.padding(10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacing(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacing(6)),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: responsive.fontSize(13)),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.padding(16),
                vertical: responsive.padding(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
