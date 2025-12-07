import 'package:flutter/material.dart';
import 'package:pentagram/models/broadcast_message.dart';
import 'package:pentagram/pages/broadcast/broadcast_detail.dart';
import 'package:pentagram/utils/broadcast_helper.dart';
import 'package:pentagram/utils/responsive_helper.dart';

/// Card widget for displaying a broadcast message in the list
class BroadcastMessageCard extends StatelessWidget {
  final BroadcastMessage message;

  const BroadcastMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BroadcastDetailPage(message: message),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.spacing(12)),
        padding: EdgeInsets.all(responsive.padding(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          border: message.isUrgent
              ? Border.all(color: Colors.red, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: responsive.elevation(10),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.padding(8)),
                  decoration: BoxDecoration(
                    color: BroadcastHelper.getCategoryColor(message.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                  ),
                  child: Icon(
                    BroadcastHelper.getCategoryIcon(message.category),
                    color: BroadcastHelper.getCategoryColor(message.category),
                    size: responsive.iconSize(20),
                  ),
                ),
                SizedBox(width: responsive.spacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.title,
                              style: TextStyle(
                                fontSize: responsive.fontSize(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (message.isUrgent)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.padding(8),
                                vertical: responsive.padding(4),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(responsive.borderRadius(6)),
                              ),
                              child: Text(
                                'URGENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.fontSize(10),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: responsive.spacing(4)),
                      Text(
                        message.category,
                        style: TextStyle(
                          fontSize: responsive.fontSize(12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(12)),
            Text(
              message.content,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                color: Colors.grey[800],
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: responsive.spacing(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: responsive.iconSize(14), color: Colors.grey[600]),
                    SizedBox(width: responsive.spacing(4)),
                    Text(
                      message.sender,
                      style: TextStyle(
                        fontSize: responsive.fontSize(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.schedule, size: responsive.iconSize(14), color: Colors.grey[600]),
                    SizedBox(width: responsive.spacing(4)),
                    Text(
                      BroadcastHelper.formatDate(message.sentDate),
                      style: TextStyle(
                        fontSize: responsive.fontSize(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(8)),
            Row(
              children: [
                Icon(Icons.people, size: responsive.iconSize(14), color: Colors.grey[600]),
                SizedBox(width: responsive.spacing(4)),
                Text(
                  '${message.recipientCount} penerima',
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: responsive.spacing(16)),
                Icon(Icons.check_circle, size: responsive.iconSize(14), color: Colors.green),
                SizedBox(width: responsive.spacing(4)),
                Text(
                  '${message.readCount} dibaca',
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: Colors.grey[600],
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
