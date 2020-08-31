import 'dart:async';

import 'package:flutter/material.dart';
import './SignUp.dart';
import 'package:brew_crew/Services/auth.dart';
import 'package:brew_crew/Services/database.dart';
import 'HomeScreen.dart';
import 'package:brew_crew/Services/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/Services/local_database.dart';










class Signin extends StatefulWidget{
  
  @override
  State<Signin> createState() {
    
    return SigninState();

    // TODO: implement createState
    //throw UnimplementedError();
  }


}


class SigninState extends State<Signin>{



  final formKey = GlobalKey<FormState>() ;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
    AuthMethods authMethods = new AuthMethods() ;
  DatabaseMethods databaseMethods = new DatabaseMethods() ;
  MyContacts myContact = new MyContacts();
  List<UserInfo> userInfo = [];
   String  myphone = "" ; 
   QuerySnapshot emailSnapShot ;
   Stream<UserInfo> myStream  ;
   UserInfo myUser = new UserInfo();
    
   
   

  
 
  UserInfo myuser = new UserInfo ();
  
  bool isLoading = false ;
  
   Stream<UserInfo>liveStream( UserInfo myUser)async*{
     
     yield myUser;

   }
 
    Widget streamer() {
    // TODO: implement build
   
       return StreamBuilder<UserInfo>(
         

      stream: liveStream(myUser),
      initialData: myuser,
   
      builder: (context, snapshot){

        double tot = snapshot.data.total ;
        double initval = snapshot.data.counter.toDouble() ;
        double total1 = initval/tot ; 
        print(tot);
        int amount = ((initval/tot)*100).toInt();
        


        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 500),
              Text("Initializing..."),
              LinearProgressIndicator(value: total1),
              Text(amount.toString() + "% done!")

            ],
          )
        );
   
      }

    );
     
  }

   SignMeIn()async{

          
            authMethods.signinWithEmailAndPassword(emailController.text, passwordController.text).then((val)async{
                print(val);
              if(val== null){

                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Signin()));
                 
              }
              if(val!= null){

              emailSnapShot =  await  databaseMethods.getUserByEmail(emailController.text);
              myphone = emailSnapShot.documents[0].data["phone"].toString() ;

                try{
                   var a = await DatabaseHelper.instance.queryLogginDetails();
                   var b = a[0]["_id"];
                     Map<String,dynamic> myLogIn = {
                  "_id" : b,
                  "email": emailController.text,
                  "password": passwordController.text,
                  "phoneNumber": myphone,
                  "isLoggedIn": 1
                };
                  await DatabaseHelper.instance.updateLogginDetails(myLogIn) ;
                  print('Loggin details is updated here');
                }catch(e){
                  print(e);
                }
                
                 
               
                    await for(UserInfo user in myContact.getContacts()) {

                       setState(() {
                         myUser = user ;
                       });
                      // liveStream(user);
                      

                     } 
                 
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=> HomeScreen()
                  ));
              }
  
             });
      

  }
  @override 
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();

    return Scaffold(
      appBar: AppBar(
        title: Text('Texter'),      
      ),

    body  : isLoading? streamer()
        
        :SingleChildScrollView(

      child: Container(

                alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height -50,
           color: Colors.teal,
           
         child: Container(
        color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          SizedBox(height:200.0,),
          Form(

            key: formKey,
            child:Column(
              children: <Widget>[

           TextField(
            controller : emailController,
             decoration : InputDecoration(
               hintText: "Email",
               hintStyle: TextStyle(
                 
                    color:  Colors.white30
               )
             ),
          ),
          TextField(

            controller: passwordController,
            decoration : InputDecoration(
              hintText: "password",
              hintStyle: TextStyle(
                  color: Colors.white30
              )
            ),
            
          ),
              ],
              ) 
              ,),
   
          SizedBox(height: 8.0),

          Container(
            alignment: Alignment.centerRight,
            child: Container(
              padding : EdgeInsets.symmetric(horizontal:16,vertical:8),
              child: Text("Forget Password?"),
            ),
          ),

          GestureDetector(
            onTap: (){


                setState(() {
                  
                  isLoading = true ;
          });
             
              SignMeIn();
             
            },
                      child: Container(
              
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical:20),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              
                gradient: LinearGradient(
                  colors: [
                    //const Color.fromRGBO(58, 74, 68,40),
                   // const Color.fromRGBO(54, 128, 100,50),
                    const Color.fromRGBO(18, 94, 153,50),
                    const Color.fromRGBO(12, 117, 96,50),
                  ])
              ),
              child: Text("SignIn"),

            ),
          ),


            SizedBox(height: 20.0),
            GestureDetector(

              
               child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical:20),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white70,
              ),
              child: Text("SignIn with Google"),

          ),
            ),

          SizedBox(height: 8.0,),

          GestureDetector(
             child:Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?", style: TextStyle(fontSize:17)),
                SizedBox(width: 4.0,),
                Text("Register Now!", style: TextStyle(fontSize: 17))
              ],),
          ),

          onTap: (){
            setState(() {
                
            Navigator.push(context,MaterialPageRoute(builder: (context){
                  return Signup();
                })
                
                );

            });
          },
      

          )
         
        ],
      ),
      ),
      ),
     
       
    )
          );
  }

}