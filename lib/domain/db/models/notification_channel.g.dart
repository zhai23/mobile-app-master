// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationChannel _$NotificationChannelFromJson(Map<String, dynamic> json) =>
    NotificationChannel(
      json['packageId'] as String,
      json['channelId'] as String,
      const BooleanNumberConverter()
          .fromJson((json['shouldNotify'] as num).toInt()),
      name: json['name'] as String? ?? null,
      description: json['description'] as String? ?? null,
    );

Map<String, dynamic> _$NotificationChannelToJson(
        NotificationChannel instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'channelId': instance.channelId,
      'name': instance.name,
      'description': instance.description,
      'shouldNotify':
          const BooleanNumberConverter().toJson(instance.shouldNotify),
    };
