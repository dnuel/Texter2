import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import './permissions.dart';
import 'database.dart';
import 'package:brew_crew/Services/local_database.dart';

class UserInfo{
  String name = ""; 
  String phoneNumber = ""; 
  String username = ""; 
  String email = ""; 
  int counter = 0; 
  double total = 1;

  
}

class MyContacts {
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  List<UserInfo> phone = [];
  QuerySnapshot snapShot;
  List<UserInfo> userInfoList = [];
  List<Contact> _contacts = [];
  int size ;
  

 Stream<UserInfo>getContacts() async*{
       Permit permit = new Permit();
       await permit.getContactPermission();
        try{
          _contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();
        
        }catch(e){
          print(e);
        }
         size = _contacts.length; 

        var retunval = searchContacts();
        yield* retunval ;
  }


  Stream<UserInfo> searchContacts()async*{
    
    for(int i = 0 ; i< size ;i++){
      try{
        UserInfo phoneinfo = new UserInfo();
        phoneinfo.name = _contacts[i].displayName;
        phoneinfo.phoneNumber = _contacts[i].phones.first.value;
        phone.add(phoneinfo);
      }catch(e){
        print(e);
       }
    }

    for(int i = 0 ; i<phone.length; i++){
print("this is phone ${phone.length}");
       snapShot  = await  _databaseMethods.searchMyPhone(phone[i].phoneNumber);
       UserInfo userinfo = new UserInfo();
       if(snapShot.documents.isEmpty){  
         userinfo.counter = i ;
         userinfo.total = phone.length.toDouble() ;
             Map<String,dynamic> mycontacts = {
              'contactEmail': "",
              'contactPhoneNumber' :phone[i].phoneNumber ,
              'contactName' : phone[i].name,
              'contactUserName' : ""

            };
            print("contact infomations");
            print(phone[i].phoneNumber);
            print(phone[i].name);
             await   DatabaseHelper.instance.insertContactDetails(mycontacts);
         
       }else{
         
        

         userinfo.email = snapShot.documents[0].data["email"];
         userinfo.username = snapShot.documents[0].data["name"];
         userinfo.name = phone[i].name ;
         userinfo.phoneNumber = snapShot.documents[0].data["phone"];
         userinfo.counter = i ;
         userinfo.total = phone.length.toDouble();
         print("dkdfjdf");
         print(userinfo.name);
         print(userinfo.phoneNumber);
           Map<String,dynamic> mycontacts = {
              'contactEmail': userinfo.email,
              'contactPhoneNumber' :phone[i].phoneNumber ,
              'contactName' : phone[i].name,
              'contactUsername' : userinfo.username

            };
         
            await   DatabaseHelper.instance.insertContactDetails(mycontacts);
            
            Map<String,dynamic> chatList = {
              'chatContactEmail': userinfo.email,
              'chatContactNumber' :userinfo.phoneNumber ,
              'chatContactName' : phone[i].name,
              'chatContactUsername' : userinfo.username

            };
           int  x = await DatabaseHelper.instance.insertChatRoomContacts(chatList);
           print("this is $x");

            }



        

        yield userinfo; 
       
    }
    
  }
    
 
  
 

  }

  
