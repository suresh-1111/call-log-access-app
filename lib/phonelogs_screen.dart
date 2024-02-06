import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import './phone_textfield.dart';
import './callLogs.dart';

class PhonelogsScreen extends StatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen>
    with WidgetsBindingObserver {
  PhoneTextField pt = PhoneTextField();
  CallLogs cl = new CallLogs();

  late AppLifecycleState _notification;
  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = cl.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Call Logs"),
      ),
      body: Column(
        children: [
          pt,
          FutureBuilder(
            future: logs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Iterable<CallLogEntry>? entries =
                    snapshot.data as Iterable<CallLogEntry>?;
                if (entries != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            child: ListTile(
                              leading: cl.getAvator(
                                  entries.elementAt(index).callType!),
                              title: cl.getTitle(entries.elementAt(index)),
                              subtitle: Text(
                                cl.formatDate(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            entries
                                                .elementAt(index)
                                                .timestamp!)) +
                                    "\n" +
                                    cl.getTime(
                                        entries.elementAt(index).duration!),
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: Icon(Icons.phone),
                                color: Colors.green,
                                onPressed: () {
                                  cl.call(entries.elementAt(index).number!);
                                },
                              ),
                            ),
                          ),
                          onLongPress: () => pt.update!(
                              entries.elementAt(index).number.toString()),
                        );
                      },
                      itemCount: entries.length,
                    ),
                  );
                } else {
                  return Center(child: Text("No call logs available."));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
