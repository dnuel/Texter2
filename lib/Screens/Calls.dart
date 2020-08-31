import 'package:flutter/material.dart';


class Calls extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return CallState();
  }
  
}

class CallState extends State<Calls>{

  int count = 4 ;
  String name = "Dummy Name";
  String lastMessage = "Last Message";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: getChatListView(),
    );

  }

  ListView getChatListView(){
       TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
       return ListView.builder(
         itemCount: count,
         itemBuilder: (BuildContext context, int position){
           return Card(
             color: Colors.teal,
             child: ListTile(
               title: Text(name),
               subtitle: Text(lastMessage),
              leading: GestureDetector(
                child: Icon(Icons.person_outline),
                onTap: (){
                  setState(() {
                    
                  });
                },
              ),
              onTap: (){
                setState(() {
                  
                });
              },
             ),
           );
         }
         );
  }

}