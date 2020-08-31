import 'package:brew_crew/Screens/Chats.dart';
import 'package:flutter/material.dart';
import './Screens/SignIn.dart' ;
import './Screens/SignUp.dart';
import 'package:brew_crew/Services/local_database.dart';
import 'package:brew_crew/Services/auth.dart';
import './Screens/ErrorScreen.dart';
import './Screens/HomeScreen.dart';



void main(){
  
 runApp(SharedPreference());
      
}

class SharedPreference extends StatefulWidget{
  @override
  State<SharedPreference> createState() {
    return _SharedPreferenceState();
  }

}

class  _SharedPreferenceState  extends State<SharedPreference>{
     AuthMethods authMethods = new AuthMethods() ;
    bool userIsLoggedIn ;


    List<Map<String,dynamic>> val;
    
    Future<bool> getLoggedInState() async{
            
            
      val = await DatabaseHelper.instance.queryLogginDetails();
      print("thiere a ");


      print(val.length);
    
    if(val.length == 0){
      print("the length is zero");
    Map<String,dynamic> myLogIn = {
                  "email": "",
                  "password": "",
                  "phoneNumber": "",
                  "isLoggedIn": 0
                };
      await DatabaseHelper.instance.insertLoginDetails(myLogIn);
      print("loggin details is inserted here");

      val = await DatabaseHelper.instance.queryLogginDetails();
    }
     int value = val[0]['isLoggedIn'];
     print("thi is value loggin ");
     print(value);
     if(value == 1){
       setState(() {
         userIsLoggedIn = true ;
       });
       
     }
      return userIsLoggedIn ;
  }
    logginUser() async{

      try{
           authMethods.signinWithEmailAndPassword(val[0]['email'],val[0]['password']).then((val)async{
          
           });
      }catch(e){
        print(e);
      }
     

    }


 
   @override
   void initState() {

    // TODO: implement initState
      print("starter");
      FutureBuilder<bool>(
        future: getLoggedInState(),
        builder:(BuildContext context, snapshot){
            setState(() {
              userIsLoggedIn = snapshot.data;
            });
        }
      );
    if(userIsLoggedIn == true){
      logginUser() ;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Amebo",
      debugShowCheckedModeBanner:  false, 
      theme: ThemeData(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.deepOrange,
          accentColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
       home: userIsLoggedIn != null ?  userIsLoggedIn ? HomeScreen() : Signin()

          : Container(
        child: Center(
          child: Signin()

        ),
      ),
    );

  }

  
  }

