import 'package:appwrite/models.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/database.dart';
import 'package:event_management_app/utils/saved_data.dart';
import 'package:event_management_app/views/event_details.dart';
import 'package:flutter/material.dart';

class RSVPEvents extends StatefulWidget {
  const RSVPEvents({super.key});

  @override
  State<RSVPEvents> createState() => _RSVPEventsState();
}

class _RSVPEventsState extends State<RSVPEvents> {
  List<Document> events = [];
  List<Document> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    setState(() {
      isLoading = true;
      userEvents = [];
    });

    String userId = SavedData.getUserId();
    try {
      final allEvents = await getAllEvents();
      if (mounted) {
        setState(() {
          events = allEvents;
          for (var event in events) {
            List<dynamic> participants = event.data["participants"] ?? [];
            if (participants.contains(userId)) {
              userEvents.add(event);
            }
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RSVP Events"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refresh,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userEvents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: kLightGreen),
                      SizedBox(height: 16),
                      Text(
                        "No RSVP'd Events",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kLightGreen,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "You haven't RSVP'd to any events yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: userEvents.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetails(data: userEvents[index]),
                        ),
                      ).then((_) => refresh()),
                      title: Text(
                        userEvents[index].data["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        userEvents[index].data["location"],
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        Icons.check_circle,
                        color: kLightGreen,
                      ),
                    ),
                  ),
                ),
    );
  }
}
