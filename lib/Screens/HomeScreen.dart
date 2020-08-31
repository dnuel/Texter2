import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import './Chats.dart';
import './Status.dart';
import './Calls.dart';
import './Room.dart';
import 'package:brew_crew/Services/contact.dart';



//import 'package:flutter/rendering.dart';



class HomeScreen extends StatefulWidget{

  @override

  State<StatefulWidget> createState(){
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
   

  TabController _tabController ;
  ScrollController _scrollViewController;

  @override
  void initState(){
    super.initState();
    _scrollViewController = ScrollController();
     _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose(){
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
       
        body: new NestedScrollView(
          
          controller: _scrollViewController,

          headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled){
            return <Widget>[
              new SliverAppBar(
                title: new Text("My Chat App"),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: new TabBar(
                  tabs: <Widget>[
                      new Tab(
                        text: "CHATS",
                        icon: Icon(Icons.chat)),
                      new Tab(text: "STATUS" ),
                      new Tab(
                        text: "CALLS",
                        icon: Icon(Icons.call)
                        )
                  ],

                  controller: _tabController,
                  ),
              ),
            ];
          },

          body: new TabBarView(
            children: <Widget>[
              
              Chat(),
              Status(),
              Calls()
            ],
            controller: _tabController,
            ),
 

        ),


      );
  }
     // ScrollController _scrollController = new ScrollController();



  


}