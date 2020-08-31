import 'package:brew_crew/Services/auth.dart';
import 'package:brew_crew/Services/database.dart';
import 'HomeScreen.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'package:brew_crew/Services/contact.dart';

class Signup extends StatefulWidget{
  @override
  State<Signup> createState() {
    
    return SignupState();

    // TODO: implement createState
    //throw UnimplementedError();
  }


}


class SignupState extends State<Signup>{


  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  AuthMethods authMethods = new AuthMethods() ;
  DatabaseMethods databaseMethods = new DatabaseMethods() ;
  MyContacts myContact = new MyContacts();
  List<UserInfo> userInfo ;
  bool isLoading = false ;
  String  myphone = "" ;


 
  double val = 0 ;
  SignMeUp()async{
    if(formKey.currentState.validate()){


              Map<String,String> userInfoMap ={
        "name" : userNameController.text,
        "email" : emailController.text,
        "phone" : phoneNumberController.text,
        "password" : passwordController.text

      };

      
      setState(() {

        isLoading = true ;
      });



      authMethods.SignUpWithEmailAndPassword(emailController.text, passwordController.text).then((val)async{
        print("$val");

        databaseMethods.uploadUserInfo(userInfoMap) ;
    
                    
                 await for(UserInfo user in myContact.getContacts()) { userInfo.add(user); }
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=> HomeScreen()
                  ));
        
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();

    return Scaffold(
      appBar: AppBar(
        title: Text('Texter'),      
      ),

    body: isLoading? Container(
      child: Center(
        child: CircularProgressIndicator()),
    ) :SingleChildScrollView(
      
      
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
            child: Column(
              children: [
              
             TextFormField(
            validator: (val){
              return val.isEmpty || val.length <3 ? "Please provide Username" : null ;
              
            },      
            controller : userNameController,
             decoration : InputDecoration(
               hintText: "Username",
               hintStyle: TextStyle(
                   
                      color:  Colors.white30
               ) 
             ),
          ),          
           TextFormField(
              validator: (val){
                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)?null : "please Enter Correct Email";
              },
              controller: emailController,
              decoration : InputDecoration(
                hintText: "email",
                hintStyle: TextStyle(
                    color: Colors.white30
                )
              ),
              
            ),
                       TextFormField(
              validator: (val){
                return val.length < 10 ? "please Enter correct phone number": null ;
              },
              controller: phoneNumberController,
              decoration : InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(
                    color: Colors.white30
                )
              ),
              
            ),
            TextFormField(
              validator: (val){
                return val.length < 6 ?  " please provide a password of at least 6 characters":null;
              },
              controller: passwordController,
              decoration : InputDecoration(
                //labelText: "Password should be at least 8 characters",
                hintText: "Password",
                hintStyle: TextStyle(
                    color: Colors.white30
                )
              ),
              
          ),
          
              ],)
          )
          ,



          SizedBox(height: 8.0),


          GestureDetector(

            onTap: (){
                SignMeUp();
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
              child: Text("SignUp"),

            ),
          ),



          SizedBox(height: 8.0,),

          GestureDetector(

            onTap: (){
                setState(() {
                  
                  Navigator.pushReplacement(context, MaterialPageRoute(
                                                        builder: (context) => Signin(),
                                                        ));

                });
            },
              child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(fontSize:17)),
                  SizedBox(width: 4.0,),
                  Text("SignIn Now!", style: TextStyle(fontSize: 17))
                ],),
            ),
          ),
          
        ],
      ),),
 
     
      ),
       
    
    )
          );
  }

}