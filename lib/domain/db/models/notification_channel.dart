import 'package:cobble/domain/db/converters/sql_json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_channel.g.dart';

@JsonSerializable()
@UuidConverter()
@BooleanNumberConverter()
class NotificationChannel {
  final String packageId;
  final String channelId;
  final String? name;
  final String? description;
  bool shouldNotify;

  NotificationChannel(
    this.packageId,
    this.channelId,
    this.shouldNotify,
  {
    this.name = null,
    this.description = null
  }
  );

  Map<String, dynamic> toMap() {
    return _$NotificationChannelToJson(this);
  }

  factory NotificationChannel.fromMap(Map<String, dynamic> map) {
    return _$NotificationChannelFromJson(map);
  }
}