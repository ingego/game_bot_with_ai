
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:logger/logger.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelBot {
  final TeleDart _teledart;
  TelBot._private(this._teledart, ); 
   late final int _chatRoom; 
   late final Cloudinary  _cloud; 
   bool isInitUser = false; 
  static Future<TelBot> init(String botToken)async{

      final username = (await Telegram(botToken).getMe()).username;
        var teledart = TeleDart(botToken, Event(username!));
        teledart.start();
        var telBot = TelBot._private(teledart);
        telBot._initUser();
    return telBot;
  }

  void _initUser(){ 
    _teledart.onCommand("start").listen((event) { 
      isInitUser = true; 
      _chatRoom = event.chat.id; 
      
    });

  }
  Future _test(){ 
    var file = File.fromUri(Uri.file("C:/development/projects/dart/pets/game_bot_with_ai/exmp.jpg")); 
   return file.readAsBytes();
  }
Future<void> sendPhoto({required List<int> photo, String? error})async{ 
  
      _cloud = Cloudinary.full(
  apiKey: "145798324541421",
  apiSecret: "-vkujhxoSM_trz0UNFyoTRWMdn4",
  cloudName: "dbjkrzg3a",);
  
  var file =  CloudinaryUploadResource(fileBytes: photo, fileName: "alert", resourceType: CloudinaryResourceType.image, publicId: "${_chatRoom}_and_${DateTime.now().toIso8601String()}");
var res = await _cloud.uploadResource(file); 
var url = res.cloudinaryImage!.transform().generate();
  sendAlert(url??"photo", error: error);
}
  void sendAlert(String msg, {String? error}  ){ 


    if(isInitUser) {
      _teledart.sendMessage(_chatRoom, msg);
      
    }
    else { 
      if(error == null)
{      throw "Пользователь не инициализирован";
}
else { 
  Logger().e(error);
}
    }
  }
}