import 'package:flutter/material.dart';

class Status extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return StatusState();
  }
  
}

class StatusState extends State<Status>{

  int count = 4 ;
  String Name = "Dummy Name";
  String LastMessage = "Last Message";
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
               title: Text(Name),
               subtitle: Text(LastMessage),
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