import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  Room(this.id, this.room_name, this.building_floor, this.detected);

  int id;
  String room_name;
  int building_floor;
  bool detected;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);

}