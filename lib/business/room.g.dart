// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      json['id'] as int,
      json['room_name'] as String,
      json['building_floor'] as int,
      json['detected'] as bool,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'room_name': instance.room_name,
      'building_floor': instance.building_floor,
      'detected': instance.detected,
    };
