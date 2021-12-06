import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:popup_meeting_rooms/business/room.dart';
import 'package:popup_meeting_rooms/config/strings.dart';
import 'package:popup_meeting_rooms/widgets/room_details.dart';
import 'about.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;


  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder<List<Room>>(
          stream: updateRooms(Duration(seconds: 5), http.Client()), // fetchRooms(http.Client()),
          //initialData: getAllRooms(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot);
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                    'Error: ${snapshot.error}'
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
              return CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 120.0,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        Strings.appTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                          ),
                        ),
                      background: Image.asset(
                          Strings.appBanner,
                          fit: BoxFit.scaleDown,
                          scale: 2
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _buildCard(snapshot.data![index]);
                          },
                      childCount: snapshot.data!.length,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellowAccent,
          child: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {

          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.yellowAccent,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => About()),
                  );
                },
              ),
            ],
          ),
          elevation: 5.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCard(Room room) {

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetails(
                room: room,
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                room.room_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  //color: Colors.white,
                ),
              ),
              minVerticalPadding: 2, // TODO find how implement a greater space between title and subtitle
              subtitle: Text(
                room.detected.toString(),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  //color: Colors.white,
                ),
              ),
            ),
            /*Container(
              margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                child: RoomsByFloor(
                  floor: floor,
                ),
              ),
            ),*/
          ],
        ),
      ),
      elevation: 1.0,
      color: Colors.white, // _changeFloorColor(floor),
    );

  }
/*
  int _countAvailableRooms(Floor floor) {
    int availableRooms = 0;
    for(Room room in floor.rooms) {
      if (room.detected == false) {
        availableRooms++;
      }
    }
    return availableRooms;
  }

  Color _changeFloorColor(Floor floor) {
    if(_countAvailableRooms(floor) > 0) {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }
*/
}
/*
Future<List<Building>> fetchData(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://206.189.16.14/getAllRoomsTesting'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return parseData(response.body);
}

// A function that converts a response body into a List<Photo>.
List<Building> parseData(String responseBody) {

  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Building>((json) => Building.fromJson(json)).toList();
}
*/
Future<List<Room>> getAllRooms(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://206.189.16.14/getAllRooms'));

  return parseData(response.body);
}

List<Room> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Room>((json) => Room.fromJson(json)).toList();
}

Stream<List<Room>> updateRooms(Duration refreshTime, http.Client client) async* {
  while (true) {
    await Future.delayed(refreshTime);
    yield await getAllRooms(client);
  }
}
/*
update(http.Client client) async {
  final updateResponse = await client
      .get(Uri.parse('http://206.189.16.14:8080/register'));

  final parsedUpdate = jsonDecode(updateResponse.body).cast<Map<String, dynamic>>();

  int floorToUpdate = parsedUpdate.building_floor;
  int roomToUpdate = parsedUpdate.id;

  findRoom(floorToUpdate, roomToUpdate);

}

Room? findFloor(int floorNumber, int roomId) {
  for (Floor floor in snapshot.data![0].floors) {
    if (floor.id == floorNumber) {
      for (Room room in floor.rooms) {
        if (room.id == roomId) {
          return room;
        }
      }
    }
  }
}
*/