class Chat{
   final String chatId;
   final String receiverName;

   Chat(this.chatId,this.receiverName);
   Map<String, dynamic> toMap() {
      return {
         'chatId': chatId,
         'receiverName': receiverName,
      };
   }

   Chat.fromJson(Map<String, dynamic> json)
       : chatId = json['chatId'],
         receiverName = json['receiverName'];
}