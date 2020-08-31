import 'package:brew_crew/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:brew_crew/Services/local_database.dart';
import 'package:brew_crew/Services/contact.dart';
class Rooms extends StatefulWidget{
  var _user ;
  var _chatRoomId;
  var _phone; 
  Rooms(var user,var chatRoomId,var phone){
    
    _user = user ;
    _chatRoomId = chatRoomId; 
    _phone = phone; 
  }
@override
  State<Rooms> createState(){
    return RoomState(_user,_chatRoomId,_phone);
  }
}

class RoomState extends State<Rooms>{
  var _user;
  var _chatRoomId; 
  var _phone;

    RoomState(var user, var chatRoomId, var phone){
      _chatRoomId = chatRoomId ;
      _user = user ;
      _phone = phone;
    }
  String name = "Dummy Name";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();
   ScrollController _scrollController = new ScrollController();
  Mymessages myMessages = new Mymessages();
  List<Mymessages> messagesList = [];

  Stream<List<Mymessages>> _getChats (List<Mymessages> a)async*{
    yield a; 
  }

    @override
  void initState() {
    // TODO: implement initState
    DatabaseMethods().getChats(_chatRoomId).then((val){

       Map<String, dynamic> chatMessageMap = {
        "chatRoomId": _chatRoomId,
        "sendBy": val.data.documents[0].data["sendBy"],
        "message": val.data.documents[0].data["message"],
        'time': val.data.documents[0].data["time"],
      };
      DatabaseHelper.instance.insertMessage(chatMessageMap);
      getAllMessages();

    });
    super.initState();
  }
  
    Widget chatMessages(){
    return StreamBuilder<List<Mymessages>>(
      stream: _getChats(messagesList),
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
       // reverse: true,
          itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data[index].message,
                sendByMe: _phone == snapshot.data[index].sendBy,
              );
            }) : Container();
      },
    );
  }


  @override
  Widget build(BuildContext context) {

            return Scaffold(
                appBar: AppBar(
                // title: Text(name),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(name),
                      onPressed: (){
                        setState(() {
                          
                        });
                      },
                    ),

                    FlatButton.icon(
                      onPressed: (){
                        setState(() {
                          
                        });
                      },
                      icon: Icon(Icons.videocam), 
                      label: Text("dk")),

                    FlatButton.icon(
                      onPressed: (){
                        setState(() {
                          
                        });
                      },
                      icon: Icon(Icons.call), 
                      label: Text("kdf")),

                      FlatButton.icon(
                      onPressed: (){
                        setState(() {
                          
                        });
                      },
                      icon: Icon(Icons.format_list_bulleted), 
                      label: Text("kdf"))

                  ],
                ),

                body:Container(
                    child: Column(children: <Widget>[
                      Expanded(child: chatMessages() ,
                      ),

                      SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                             // color: Colors.tealAccent,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.teal,
                              ),
                              child: TextField(
                                controller: messageEditingController,
                                decoration: InputDecoration(
                                                hintText: "Message"
                                )     
                              ),),),
                           SizedBox(width: 16,),

                            GestureDetector(
                      onTap: () {
                        addMessagetoDatabase();
                        addMessage();
                            _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      );
 
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color.fromRGBO(40, 77, 64, 20),
                                    const Color.fromRGBO(112, 148, 135, 20)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),
                        ],
                      )
                    )
                    ],)
                )
            ); 

 }


   addMessage(){
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": _phone,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(_chatRoomId, chatMessageMap);

     
    }
  }

  addMessagetoDatabase()async{

    if(messageEditingController.text.isNotEmpty){
            Map<String, dynamic> chatMessageMap = {
        "chatRoomId": _chatRoomId,
        "sendBy": _phone,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      await DatabaseHelper.instance.insertMessage(chatMessageMap);
       setState(() {
        messageEditingController.text = "";
      });
    }

  }

  getAllMessages()async{
    List<Map<String,dynamic>> allChats = await DatabaseHelper.instance.queryMessages();

    for(int i = 0 ; i<allChats.length; i++){

     setState(() {
      Mymessages messages = new Mymessages();
      messages.sendBy = allChats[i]["sendBy"];
      messages.message = allChats[i]["message"];
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      messagesList.add(messages);

        });
    }
      


  }

 

  
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                                    const Color.fromRGBO(40, 77, 64, 20),
                                    const Color.fromRGBO(112, 148, 135, 20)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}

class Mymessages{
String sendBy = "";
String message = "";
}
