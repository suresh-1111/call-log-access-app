import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogs {
  void call(String text) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(text);
  }

  getAvator(CallType callType) {
    switch (callType) {
      case CallType.outgoing:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.green,
          backgroundColor: Colors.greenAccent,
          child: Icon(
            Icons.call_made_outlined,
          ),
        );
      case CallType.missed:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.red[400],
          backgroundColor: Colors.red[400],
          child: Icon(
            Icons.call_missed_outgoing_rounded,
            color: Colors.white,
          ),
        );
      case CallType.rejected:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.red[400],
          backgroundColor: Colors.red[400],
          child: Icon(
            Icons.call_end_rounded,
            color: Colors.white,
          ),
        );
      case CallType.unknown:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.red[400],
          backgroundColor: Colors.red[400],
          child: Icon(
            Icons.call_rounded,
            color: Colors.white,
          ),
        );
      default:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.indigo[700],
          backgroundColor: Colors.indigo[700],
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
        );
    }
  }

  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  String formatDate(DateTime dt) {
    return DateFormat('d-MMM-y H:m:s').format(dt);
  }

  // getTitle(CallLogEntry entry){

  //   if(entry.name == null)
  //     return Text(entry.number);
  //   if(entry.name.isEmpty)
  //     return Text(entry.number);
  //   else
  //     return Text(entry.name);
  // }
  Text getTitle(CallLogEntry entry) {
    final String? displayText =
        entry.name?.isNotEmpty ?? false ? entry.name : entry.number;
    return Text(displayText!);
  }

  String getTime(int duration) {
    Duration d1 = Duration(seconds: duration);
    String formatedDuration = "";
    if (d1.inHours > 0) {
      formatedDuration += d1.inHours.toString() + "h ";
    }
    if (d1.inMinutes > 0) {
      formatedDuration += d1.inMinutes.toString() + "m ";
    }
    if (d1.inSeconds > 0) {
      formatedDuration += d1.inSeconds.toString() + "s";
    }
    if (formatedDuration.isEmpty) return "0s";
    return formatedDuration;
  }
}
