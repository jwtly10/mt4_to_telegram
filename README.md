# mt4_to_telegram
This simple library allows you to easily send messages to Telegram within an MT4/5 EA.

## Description

This library utilizes the in built webrequest function to ping the telegram API - [Telegram Docs](https://core.telegram.org/)

## Getting Started

### Dependencies

This works on both Windows and Mac versions of MT4/5.

### Installing

Copy the /includes folder into your own /MQL4/Includes folder.

### Executing program

You need to #Include the lib file (send_telegram_message.mqh) in the EA where you wish to call the Telegram API. 
```
// I like to use this wrapper method to make future messages as clean as possible.
void telegramMsg(string message, string fileName = ""){
   SendMessage(TELEGRAM_API_URL, TELEGRAM_TOKEN, TELEGRAM_CHAT, message, fileName);
}
```
You can use this wrapper to make sending telegram messages cleaner. The follow are *Required* for this library to work. I have linked how to retrieve this information for your own telegram setup.

TELEGRAM_API_URL = "https://api.telegram.org";
TELEGRAM_TOKEN : https://www.youtube.com/watch?v=bgFAgZCP7yQ&ab_channel=Dignited
TELEGRAM_CHAT : https://github.com/GabrielRF/telegram-id#app-channel-id

## Version History

* 0.1
    * Initial Release
