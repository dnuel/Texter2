import 'package:brew_crew/Services/database.dart';
import 'package:brew_crew/modals/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './Room.dart';
import 'package:brew_crew/Services/contact.dart';
import 'package:brew_crew/Services/local_database.dart';


class Chat extends StatefulWidget {


  @override
  State<StatefulWidget> createState(){
    return ChatState();
  }
  
}

class ChatState extends State<Chat>{
 


  
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String lastMessage = "Last Message";
   String chatRoomId;
   String _phone;

   List<UserInfo> _user = [];
   @override
   void initState() {
    // TODO: implement initState
      super.initState();
    getContacts();
    print("contacts have been gotten");
  
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: getChatListView(_user),
    );

  }

  ListView getChatListView(user){

       TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
       return ListView.builder(
         itemCount: user.length,
         itemBuilder: (BuildContext context, index){
           return Card(
             color: Colors.teal,
             child: ListTile(
               title: Text(user[index].name) ,
               subtitle: Text(lastMessage),

              onTap: (){

                    sendMessage(user[index].phoneNumber);
                  navigateToDetailScreen(user[index]);
              },
             ),
           );
         }
         );
  }


      void navigateToDetailScreen(var currentUser) async{

              Navigator.push(context,MaterialPageRoute(builder: (context){

                  return Rooms(currentUser,chatRoomId,_phone);
                })
                
                );

    }
    sendMessage(String phone){
    List<String> users = [_phone,phone];

     chatRoomId = getChatRoomId(_phone,phone);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

   databaseMethods.addChatRoom(chatRoom, chatRoomId);
   

 

  }

  getChatRoomId(String phone1 ,String phone2){
  int phone3 = int.parse(phone1) ;
  int phone4 = int.parse(phone2);
  String chatid ;

    if(phone3>phone4){
      chatid = "$phone1"+"$phone2" ;

    }else{
      chatid = "$phone2"+"$phone1";
    }

      return chatid;   
  }


  getContacts() async {
    var b = await DatabaseHelper.instance.queryLogginDetails();
    _phone = b[0]['phoneNumber'];

   print("this is getting list of contacts");

   List<Map<String,dynamic>> a = await DatabaseHelper.instance.queryChatRoomContacts();
   var leng = a.length;
   print("this is leng $leng");
   for(int i = 0 ; i<a.length ;i++){
      UserInfo user = new UserInfo();
      user.email = a[i]['chatContactEmail'];
      user.username = a[i]['chatContactUsername'];
      user.phoneNumber = a[i]['chatContactNumber'];
      user.name = a[i]['chatContactName'];

      print (user.phoneNumber);
      
      setState(() {
        _user.add(user);
      });
      
   }
                 
  }



}