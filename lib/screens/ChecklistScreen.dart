import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_checklist/components/ChecklistItemList.dart';
import 'package:travel_checklist/screens/ChecklistFormScreen.dart';
import 'package:travel_checklist/screens/ChecklistItemFormScreen.dart';
import '../models/Checklist.dart';

class ChecklistScreen extends StatefulWidget {
  final Checklist checklist;

  ChecklistScreen({ Key key, this.checklist }) : super(key: key);

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checklist.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {} ),
        ],
      ),
      body: Column(
        children: <Widget> [
          Container(
            child: Text(
              'ITENS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
          ),
          Expanded(
            child: ChecklistItemList(checklist: widget.checklist.id),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            label: 'Deletar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Colors.green,
            label: 'Editar',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistFormScreen(checklist: widget.checklist)));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.playlist_add_check),
            backgroundColor: Colors.blue,
            label: 'Adicionar Item',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistItemFormScreen(checklist: widget.checklist.id)));
            },
          ),
        ],
      ),
    );
  }
}