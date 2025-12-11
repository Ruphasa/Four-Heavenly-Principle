import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class RumahCard extends StatelessWidget {
  final String alamat;
  final String rt;
  final String rw;
  final String namaKeluarga;
  final String status;
  final Color statusColor;

  const RumahCard({
    super.key,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.namaKeluarga,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
        onTap: () => _showDetailDialog(context, responsive),
        child: Container(
          padding: EdgeInsets.all(responsive.padding(16)),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: responsive.elevation(8),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
            children: [
              Container(
                width: responsive.isCompact ? 45 : 50,
                height: responsive.isCompact ? 45 : 50,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                ),
                child: Icon(
                  Icons.home_rounded,
                  color: AppColors.textOnPrimary,
                  size: responsive.iconSize(28),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alamat,
                      style: TextStyle(
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    Text(
                      'RT $rt / RW $rw',
                      style: TextStyle(
                        fontSize: responsive.fontSize(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(10),
                  vertical: responsive.padding(4),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: responsive.fontSize(11),
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(12)),
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: responsive.iconSize(16),
                color: AppColors.iconSecondary,
              ),
              SizedBox(width: responsive.spacing(6)),
              Expanded(
                child: Text(
                  namaKeluarga == '-' || namaKeluarga.isEmpty
                      ? 'Tidak ada keluarga terdaftar'
                      : (namaKeluarga.toLowerCase().startsWith('keluarga ')
                          ? namaKeluarga
                          : 'Keluarga $namaKeluarga'),
                  style: TextStyle(
                    fontSize: responsive.fontSize(13),
                    color: AppColors.textSecondary,
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

  void _showDetailDialog(BuildContext context, ResponsiveHelper responsive) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: responsive.isCompact ? double.infinity : 500,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(responsive.padding(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: responsive.isCompact ? 50 : 60,
                          height: responsive.isCompact ? 50 : 60,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                          ),
                          child: Icon(
                            Icons.home_rounded,
                            color: AppColors.textOnPrimary,
                            size: responsive.iconSize(32),
                          ),
                        ),
                        SizedBox(width: responsive.spacing(16)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alamat,
                                style: TextStyle(
                                  fontSize: responsive.fontSize(20),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: responsive.spacing(4)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.padding(10),
                                  vertical: responsive.padding(4),
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(12),
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            size: responsive.iconSize(24),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(24)),
                    Divider(height: 1, color: AppColors.border),
                    SizedBox(height: responsive.spacing(24)),
                    _buildDetailRow(
                      'RT / RW',
                      'RT $rt / RW $rw',
                      Icons.map_rounded,
                      responsive,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildDetailRow(
                      'Nama Keluarga',
                      namaKeluarga == '-' || namaKeluarga.isEmpty
                        ? 'Tidak ada keluarga terdaftar'
                        : (namaKeluarga.toLowerCase().startsWith('keluarga ')
                          ? namaKeluarga
                          : 'Keluarga $namaKeluarga'),
                      Icons.person_rounded,
                      responsive,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildDetailRow(
                      'Status Hunian',
                      status,
                      Icons.home_work_rounded,
                      responsive,
                    ),
                    SizedBox(height: responsive.spacing(24)),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Navigate to edit page
                        },
                        icon: Icon(Icons.edit_rounded, size: responsive.iconSize(18)),
                        label: Text(
                          'Edit Data Rumah',
                          style: TextStyle(
                            fontSize: responsive.fontSize(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: EdgeInsets.symmetric(vertical: responsive.padding(14)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, ResponsiveHelper responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(responsive.padding(8)),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
          ),
          child: Icon(
            icon,
            size: responsive.iconSize(20),
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: responsive.spacing(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.fontSize(12),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                value,
                style: TextStyle(
                  fontSize: responsive.fontSize(15),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
