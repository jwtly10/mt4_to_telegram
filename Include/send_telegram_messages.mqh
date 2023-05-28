//+------------------------------------------------------------------+
//|                                       send_telegram_messages.mqh |
//|                                                          jwtly10 |
//|                                       https://github.com/jwtly10 |
//+------------------------------------------------------------------+

// This is the underlying set of methods that are used to send data to and from telegram.
// File mt4_to_telegram.mq4 will show you exactly HOW you can use this. 

bool SendMessage( string url, string token, string chat, string text, string fileName = "" ) {
    string headers    = "";
    string requestUrl = "";
    char   postData[];
    char   resultData[];
    string resultHeaders;
    int    timeout = 5000; // 1 second, may be too short for a slow connection

    ResetLastError();

    if ( fileName == "" ) {
        requestUrl =
            StringFormat( "%s/bot%s/sendmessage?chat_id=%s&parse_mode=HTML&text=%s", url, token, chat, text );
    }
    else {
        requestUrl = StringFormat( "%s/bot%s/sendPhoto", url, token );
        if ( !GetPostData( postData, headers, chat, text, fileName ) ) {
            return ( false );
        }
    }

    ResetLastError();

    int response =
        WebRequest( "POST", requestUrl, headers, timeout, postData, resultData, resultHeaders );

    switch ( response ) {
        case -1: {
                     int errorCode = GetLastError();
                     Print("ERROR : in WebRequest. Error code  =", errorCode );
                     if ( errorCode == UrlDefinedError ) {
                         //--- url may not be listed
                         PrintFormat( "ERROR : Add the address '%s' in the list of allowed URLs", url );
                     }
                     break;
                 }

        case 200:
                 //--- Success
                 Print( "INFO : The message has been successfully sent, - ", text );
                 break;
        default: {
                     string result = CharArrayToString( resultData );
                     PrintFormat( "ERROR : Unexpected Response '%i', '%s'", response, result );
                     break;
                 }
    }

    return ( response == 200 );
}

bool GetPostData( char &postData[], string &headers, string chat, string text, string fileName ) {
    ResetLastError();

    if ( !FileIsExist( fileName ) ) {
        Alert( "File '%s' does not exist", fileName );

        return ( false );
    }

    int flags = FILE_READ | FILE_BIN;
    int file  = FileOpen( fileName, flags );

    if ( file == INVALID_HANDLE ) {
        int err = GetLastError();
        Alert( "Could not open file '%s', error=%i", fileName, err );
        return ( false );
    }

    int   fileSize = ( int )FileSize( file );
    uchar photo[];
    ArrayResize( photo, fileSize );
    FileReadArray( file, photo, 0, fileSize );
    FileClose( file );

    string hash = "";

    AddPostData( postData, hash, "chat_id", chat );

    if ( StringLen( text ) > 0 ) {
        AddPostData( postData, hash, "caption", text );
    }

    AddPostData( postData, hash, "photo", photo, fileName );
    ArrayCopy( postData, "--" + hash + "--\r\n" );
    headers = "Content-Type: multipart/form-data; boundary=" + hash + "\r\n";

    return ( true );
}

void AddPostData( uchar &data[], string &hash, string key = "", string value = "" ) {
    uchar valueArr[];

    StringToCharArray( value, valueArr, 0, StringLen( value ) );

    AddPostData( data, hash, key, valueArr );

    return;
}

void AddPostData( uchar &data[], string &hash, string key, uchar &value[], string fileName = "" ) {
    if ( hash == "" ) {
        hash = Hash();
    }

    ArrayCopy( data, "\r\n" );
    ArrayCopy( data, "--" + hash + "\r\n" );

    if ( fileName == "" ) {
        ArrayCopy( data, "Content-Disposition: form-data; name=\"" + key + "\"\r\n" );
    }
    else {
        ArrayCopy( data, "Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" +
                fileName + "\"\r\n" );
    }

    ArrayCopy( data, "\r\n" );
    ArrayCopy( data, value, ArraySize( data ) );
    ArrayCopy( data, "\r\n" );

    return;
}

void ArrayCopy( uchar &dst[], string src ) {
    uchar srcArray[];
    StringToCharArray( src, srcArray, 0, StringLen( src ) );
    ArrayCopy( dst, srcArray, ArraySize( dst ), 0, ArraySize( srcArray ) );

    return;
}

string Hash() {
    uchar  tmp[];
    string seed = IntegerToString( TimeCurrent() );
    int    len  = StringToCharArray( seed, tmp, 0, StringLen( seed ) );
    string hash = "";

    for ( int i = 0; i < len; i++ )
        hash += StringFormat( "%02X", tmp[i] );

    hash = StringSubstr( hash, 0, 16 );
    return ( hash );

}
