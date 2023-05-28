//+------------------------------------------------------------------+
//|                                             mt4_to_telegram.mq4  |
//|                                                          jwtly10 |
//|                                       https://github.com/jwtly10 |
//+------------------------------------------------------------------+
#property copyright "jwtly10"
#property link "https://github.com/jwtly10"
#property version "1.00"
#property strict

#include <send_telegram_messages.mqh>
string TELEGRAM_API_URL = "https://api.telegram.org";

// This should be your own telegram data. Read through the README.md to see how to find.
string TELEGRAM_TOKEN = "";
string TELEGRAM_CHAT = "";
const int UrlDefinedError = 4066;

// I like to use this wrapper method to make future messages as clean as possible.
void telegramMsg(string message, string fileName = ""){
   SendMessage(TELEGRAM_API_URL, TELEGRAM_TOKEN, TELEGRAM_CHAT, message, fileName);
}

int OnInit(){
    telegramMsg("Test");
    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {}

void OnTick(){
}
