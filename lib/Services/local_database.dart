import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static final _dbVersion = 1 ;
  static final  _loginTable = 'login';
  static final columnId = '_id';
  static final _email = 'email' ;
  static final _password = 'password';
  static final _phoneNumber = 'phoneNumber' ;
  static final _isLoggedIn = 'isLoggedIn' ;

  static final _contactTable = 'contactTable';
  static final _contactEmail = 'contactEmail';
  static final _contactUsername = 'contactUsername';
  static final _contactName = 'contactname';
  static final _contactPhoneNumber = 'contactPhoneNumber';
  
  static final _chatRoomContactTable = 'chatRoomContactTable';
  static final _chatContactEmail = 'chatContactEmail';
  static final _chatContactUsername = 'chatContactUsername';
  static final _chatContactName = 'chatContactName';
  static final _chatContactNumber  = 'chatContactNumber ';

  static final _chatRoomTable = 'chatRoomTable';
  static final _message = 'message';
  static final _time = 'time';
  static final _sendBy = 'sendBy';
  static final _chatRoomId = 'chatRoomId';

 


  static final _dbName = 'Texter.db';
  DatabaseHelper._privateConstructor();
  
  static Database _database; 

  Future<Database> get database async{

    if(_database != null) return _database;

    _database = await _initiateDatabase();
    
    return _database;
  }


  _initiateDatabase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _dbName; 
   return await openDatabase(path,version: _dbVersion,onCreate: _onCreate);

  }

  void _onCreate(Database db, int version)async{
//     print("this table was 1created");
        await db.execute(
             '''

            CREATE TABLE $_chatRoomContactTable($columnId  INTEGER PRIMARY KEY AUTOINCREMENT,
                                                      $_chatContactEmail TEXT NOT NULL,
                                                      $_chatContactUsername TEXT NOT NULL,
                                                      $_chatContactName TEXT NOT NULL,
                                                      $_chatContactNumber TEXT NOT NULL

                                                      )


            '''
        );

//print("this table 5 is breated");
   await  db.execute(

     
        ''' 
        CREATE TABLE $_loginTable ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                      $_email TEXT  NOT NULL,
                      $_password TEXT  NOT NULL,
                      $_phoneNumber TEXT NOT NULL,
                      $_isLoggedIn INTEGER  DEFAULT 0   NOT NULL )



        
        '''

     );   
     //print("this table was 2created");
     await db.execute(      
         
         '''
           CREATE TABLE $_contactTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                    $_contactEmail TEXT NOT NULL,
                    $_contactName TEXT NOT NULL,
                    $_contactUsername TEXT NOT NULL,
                    $_contactPhoneNumber TEXT NOT NULL

              )

        ''');
     //  print("this table was 3created");

          await  db.execute(

        ''' 
        CREATE TABLE $_chatRoomTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                                      $_message TEXT  NOT NULL,
                                      $_time INTEGER NOT NULL,
                                      $_sendBy TEXT NOT NULL,
                                      $_chatRoomId INTEGER NOT NULL
                                      )    
        '''

     );
  }


  // For Loggin Details
  Future<int> insertLoginDetails(Map<String,dynamic> row) async{
    Database db = await instance.database;
    var val = await db.insert(_loginTable,row);
    return val ;
  }


  Future<List<Map<String,dynamic>>> queryLogginDetails() async{
     Database db = await instance.database; 
     return await db.query(_loginTable);
  }

  Future updateLogginDetails(Map<String,dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
   return  await  db.update(_loginTable,row, where: '$columnId = ? ', whereArgs: [id]);
  }

  Future<int> deleteLogginDetails(int id) async {
    Database db = await instance.database ;
    return await db.delete(_loginTable,where: '$columnId = ?', whereArgs: [id]);
  }


  // For contacts 
  Future<int> insertContactDetails(Map<String,dynamic>row)async{
    Database db = await instance.database;
    return await db.insert(_contactTable,row);
  }

  Future<List<Map<String,dynamic>>> queryContacts() async{
    Database db = await instance.database;
    return await db.query(_contactTable);
  }
  Future updateContactDetails(Map<String,dynamic>row) async {
    Database db = await instance.database; 
    int id = row[columnId];
    return await db.update(_contactTable,row,where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteContactDetails(int id) async {
    Database db = await instance.database;
    return await db.delete(_contactTable,where: '$columnId = ?', whereArgs: [id]);
  }

  // For ChatRoomContacts

    Future<int> insertChatRoomContacts(Map<String,dynamic>row)async{
    Database db = await instance.database;
    return await db.insert(_chatRoomContactTable,row);
  }

  Future<List<Map<String,dynamic>>> queryChatRoomContacts() async{
    Database db = await instance.database;
    return await db.query(_chatRoomContactTable);
  }
  Future updateChatRoomContactDetails(Map<String,dynamic>row) async {
    Database db = await instance.database; 
    int id = row[columnId];
    return await db.update(_chatRoomContactTable,row,where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteChatRoomContact(int id) async {
    Database db = await instance.database;
    return await db.delete(_chatRoomContactTable,where: '$columnId = ?', whereArgs: [id]);
  }


// FOR MESSAGES
    Future<int> insertMessage(Map<String,dynamic>row)async{
    Database db = await instance.database;
    return await db.insert(_chatRoomTable,row);
  }

  Future<List<Map<String,dynamic>>> queryMessages() async{
    Database db = await instance.database;
    return await db.query(_chatRoomTable);
  }
  Future updateMessage(Map<String,dynamic>row) async {
    Database db = await instance.database; 
    int id = row[columnId];
    return await db.update(_chatRoomTable,row,where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteMessage(int id) async {
    Database db = await instance.database;
    return await db.delete(_chatRoomTable,where: '$columnId = ?', whereArgs: [id]);
  }




}