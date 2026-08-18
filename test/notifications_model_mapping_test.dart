// اختبارات mapping لـ NotificationModel/NotificationListModel: التحقق من
// قراءة id كـ String (UUID)، read_at=null => غير مقروء، وقراءة unread_count
// من meta تمامًا كما يصلان من الـ Backend.
import 'package:car_care/features/notifications/data/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _rawNotification({
  String id = 'a1b2c3d4-0000-4000-8000-000000000001',
  String type = 'fuel_order_accepted',
  String? readAt,
}) {
  return {
    'id': id,
    'type': type,
    'title': 'تم قبول طلب الوقود',
    'body': 'قام المزود بقبول طلبك',
    'data': {
      'entity_type': 'fuel_order',
      'entity_id': 123,
      'action': 'open_details',
      'status': 'accepted',
    },
    'read_at': readAt,
    'created_at': '2026-08-18T10:00:00.000000Z',
  };
}

void main() {
  group('NotificationModel.fromJson', () {
    test('id is mapped as a String (UUID), not int', () {
      final model = NotificationModel.fromJson(_rawNotification());
      expect(model.id, isA<String>());
      expect(model.id, 'a1b2c3d4-0000-4000-8000-000000000001');
    });

    test('read_at=null maps to isUnread=true on the entity', () {
      final model = NotificationModel.fromJson(_rawNotification(readAt: null));
      expect(model.readAt, isNull);
      expect(model.toEntity().isUnread, isTrue);
    });

    test('a non-null read_at maps to isUnread=false', () {
      final model = NotificationModel.fromJson(
        _rawNotification(readAt: '2026-08-18T11:00:00.000000Z'),
      );
      expect(model.readAt, isNotNull);
      expect(model.toEntity().isUnread, isFalse);
    });

    test('title/body/type are preserved verbatim from the backend', () {
      final model = NotificationModel.fromJson(_rawNotification());
      expect(model.type, 'fuel_order_accepted');
      expect(model.title, 'تم قبول طلب الوقود');
      expect(model.body, 'قام المزود بقبول طلبك');
      expect(model.data['entity_id'], 123);
    });
  });

  group('NotificationListModel.fromJson', () {
    test('maps the data array and unread_count from meta', () {
      final json = {
        'success': true,
        'data': [
          _rawNotification(id: '1', readAt: null),
          _rawNotification(id: '2', readAt: '2026-08-18T09:00:00.000000Z'),
        ],
        'meta': {
          'total': 2,
          'per_page': 30,
          'current_page': 1,
          'unread_count': 1,
        },
      };

      final result = NotificationListModel.fromJson(json);

      expect(result.data, hasLength(2));
      expect(result.data.first.id, '1');
      expect(result.meta.unreadCount, 1);
      expect(result.meta.total, 2);
      expect(result.meta.perPage, 30);
      expect(result.meta.currentPage, 1);
    });

    test('an empty data array maps to an empty list, not an error', () {
      final json = {
        'success': true,
        'data': [],
        'meta': {
          'total': 0,
          'per_page': 30,
          'current_page': 1,
          'unread_count': 0,
        },
      };

      final result = NotificationListModel.fromJson(json);

      expect(result.data, isEmpty);
      expect(result.meta.unreadCount, 0);
    });
  });
}
