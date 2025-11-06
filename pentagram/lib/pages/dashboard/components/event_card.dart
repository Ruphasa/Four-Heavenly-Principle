import 'package:flutter/material.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/utils/activity_helper.dart';
import 'package:pentagram/pages/activity_broadcast/activity_detail.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class EventCard extends StatelessWidget {
  final Activity activity;
  final int index;

  const EventCard({
    required this.activity,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final categoryColor = ActivityHelper.getCategoryColor(activity.kategori);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetail(activity: activity),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: responsive.spacing(12)),
        padding: EdgeInsets.all(responsive.padding(20)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor,
              categoryColor.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.3),
              blurRadius: responsive.elevation(10),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Category badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.padding(12),
                vertical: responsive.padding(6),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
              ),
              child: Text(
                activity.kategori,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.fontSize(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Event name
            Text(
              activity.nama,
              style: TextStyle(
                fontSize: responsive.fontSize(20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Date and location
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(responsive.padding(10)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: responsive.iconSize(16),
                        ),
                        SizedBox(width: responsive.spacing(8)),
                        Expanded(
                          child: Text(
                            ActivityHelper.formatDate(activity.tanggal, short: true),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontSize(13),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacing(8)),
                Container(
                  padding: EdgeInsets.all(responsive.padding(10)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: responsive.iconSize(16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}