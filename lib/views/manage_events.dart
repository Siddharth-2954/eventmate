import 'package:appwrite/models.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/database.dart';
import 'package:event_management_app/views/create_event_page.dart';
import 'package:event_management_app/views/edit_event_page.dart';
import 'package:flutter/material.dart';

class ManageEvents extends StatefulWidget {
  const ManageEvents({super.key});

  @override
  State<ManageEvents> createState() => _ManageEventsState();
}

class _ManageEventsState extends State<ManageEvents> {
  List<Document> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    setState(() {
      isLoading = true;
      events = [];
    });

    try {
      final userEvents = await manageEvents();
      if (mounted) {
        setState(() {
          events = userEvents;
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
        title: Text("Manage Events"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refresh,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateEventPage()),
            ).then((_) => refresh()),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: kLightGreen),
                      SizedBox(height: 16),
                      Text(
                        "No Events Created",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kLightGreen,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Create your first event by tapping the + button",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEventPage(
                            image: events[index].data["image"],
                            name: events[index].data["name"],
                            desc: events[index].data["description"],
                            loc: events[index].data["location"],
                            datetime: events[index].data["datetime"],
                            guests: events[index].data["guests"],
                            sponsers: events[index].data["sponsers"],
                            docID: events[index].$id,
                            isInPerson: events[index].data["isInPerson"],
                          ),
                        ),
                      ).then((_) => refresh()),
                      title: Text(
                        events[index].data["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        events[index].data["location"],
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        Icons.edit,
                        color: kLightGreen,
                      ),
                    ),
                  ),
                ),
    );
  }
}
