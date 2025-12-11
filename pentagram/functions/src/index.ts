import {onRequest} from 'firebase-functions/https';
import * as logger from 'firebase-functions/logger';
import {onDocumentCreated} from 'firebase-functions/v2/firestore';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Simple HTTP function so onRequest/logger imports are used
export const helloWorld = onRequest((request, response) => {
    logger.info('Hello from Firebase Functions');
    response.send('OK');
});

export const sendQueuedNotification = onDocumentCreated(
    'notifications/{notifId}',
    async (event) => {
        const snap = event.data;
        if (!snap) {
            logger.error('No snapshot data for notification event');
            return;
        }

        const data = snap.data() as any;

        const topic: string | undefined = data.topic;
        const token: string | undefined = data.token;

        const message: any = {
            notification: {
                title: data.title ?? 'Notifikasi',
                body: data.body ?? '',
            },
            data: {
                ...(data.data ?? {}),
            },
        };

        try {
            if (topic) {
                message.topic = topic;
            } else if (token) {
                message.token = token;
            } else {
                logger.error('No topic or token in notification doc', data);
                return;
            }

            await admin.messaging().send(message);

            await snap.ref.update({
                processed: true,
                sentAt: admin.firestore.FieldValue.serverTimestamp(),
            });
        } catch (err) {
            logger.error('Error sending FCM:', err as any);
            await snap.ref.update({
                processed: false,
                error: String(err),
            });
        }
    },
);