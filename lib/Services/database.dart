import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByEmail(String email)async{
    try{
      return await Firestore.instance.collection("users").where("email", isEqualTo : email).getDocuments();
    }catch(e){
      print(e);
    }
  }

  uploadUserInfo(userMap){
      Firestore.instance.collection("users").add(userMap).catchError((e){
          print((e).toString());
      });
  }

  searchMyPhone(String phone) async{
    try{
      return await Firestore.instance.collection("users").where("phone", isEqualTo : phone).getDocuments();
    }catch(e){
      print(e);
    }
    
  }
    Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

    getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots(); 
  }


  Future<void> addMessage(String chatRoomId, chatMessageData){

    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}