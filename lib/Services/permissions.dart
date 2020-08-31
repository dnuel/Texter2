import 'package:permission_handler/permission_handler.dart';

class Permit{



        
  getContactPermission() async{
    PermissionStatus permissionstatus = await Permission.contacts.request();
    print("permission Status ${permissionstatus.isGranted}");
    
  }

}