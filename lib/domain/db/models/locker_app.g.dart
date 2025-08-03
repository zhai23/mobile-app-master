// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locker_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LockerApp _$LockerAppFromJson(Map<String, dynamic> json) => LockerApp(
      id: json['id'] as String,
      uuid: const NonNullUuidConverter().fromJson(json['uuid'] as String),
      version: json['version'] as String,
      apliteIcon: json['apliteIcon'] as String?,
      basaltIcon: json['basaltIcon'] as String?,
      chalkIcon: json['chalkIcon'] as String?,
      dioriteIcon: json['dioriteIcon'] as String?,
      apliteList: json['apliteList'] as String?,
      basaltList: json['basaltList'] as String?,
      chalkList: json['chalkList'] as String?,
      dioriteList: json['dioriteList'] as String?,
      markedForDeletion: json['markedForDeletion'] == null
          ? false
          : const BooleanNumberConverter()
              .fromJson((json['markedForDeletion'] as num).toInt()),
    );

Map<String, dynamic> _$LockerAppToJson(LockerApp instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': const NonNullUuidConverter().toJson(instance.uuid),
      'version': instance.version,
      'apliteIcon': instance.apliteIcon,
      'basaltIcon': instance.basaltIcon,
      'chalkIcon': instance.chalkIcon,
      'dioriteIcon': instance.dioriteIcon,
      'apliteList': instance.apliteList,
      'basaltList': instance.basaltList,
      'chalkList': instance.chalkList,
      'dioriteList': instance.dioriteList,
      'markedForDeletion':
          const BooleanNumberConverter().toJson(instance.markedForDeletion),
    };
