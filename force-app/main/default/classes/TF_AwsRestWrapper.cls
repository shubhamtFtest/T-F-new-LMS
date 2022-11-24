public class TF_AwsRestWrapper {   
    String awsFileLocation;
    public class AwsException extends Exception {}
    
    public String put(String payload, String contentType, String region, String folderPath, String objectName, String objectId, String key, String secret, String host) {
        
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        
        String httpMethod = 'PUT';
        String canonicalURI ;
        String canonicalQueryString = ''; 
        String signedHeaders = 'host;x-amz-content-sha256;x-amz-date;x-amz-acl'; 
        String hashedPayload = HexSHA256Hash(payload);
        if(String.isEmpty(folderPath)){
            
            canonicalURI = String.join(new String[]{'', objectName}, '/');
            
        }else{
            canonicalURI = String.join(new String[]{'', folderPath, objectName}, '/');
        }
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('x-amz-acl', 'private');
        canonicalHeaders.put('x-amz-content-sha256', hashedPayload);
        canonicalHeaders.put('Content-Type', contentType);
        canonicalHeaders.put('Content-Length', payload.length().format());
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, 
                                                         canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 's3');
        
        System.debug('canonicalRequest'+canonicalRequest);
        String stringToSign = createStringToSign(now, region, canonicalRequest,'s3');        
        String signature = calculateSignature(now, secret, region, 's3', stringToSign);
        
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 's3'),canonicalHeaders, canonicalURI, payload, host, canonicalQueryString, 's3');
        if(String.valueOf(resp.getStatusCode()).startsWith('2')){
            system.debug('resp'+resp);
            return awsFileLocation;
        }else{
            system.debug('error resp'+resp);
        }
        return null;
    }
    
     
    
    /**
* Fetch a textual object from an S3 bucket.
*/
    public String get(String region, String folderPath, String objectName, String objectId, String key, String secret, String host) {
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        
        String httpMethod = 'GET';  
        String canonicalURI ;
        String canonicalQueryString = ''; 
        String signedHeaders = 'host;x-amz-content-sha256;x-amz-date'; 
        String payload = '';
        String hashedPayload = HexSHA256Hash(payload);
        if(String.isEmpty(folderPath)){
            
            canonicalURI = String.join(new String[]{'', objectName}, '/');
            
        }else{
            canonicalURI = String.join(new String[]{'', folderPath, objectName}, '/');
        }
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('x-amz-content-sha256', hashedPayload);
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 's3');
        String stringToSign = createStringToSign(now, region, canonicalRequest, 's3');        
        String signature = calculateSignature(now, secret, region, 's3', stringToSign);
        
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 's3'),canonicalHeaders, canonicalURI, null, host, canonicalQueryString, 's3');
        
        if(String.valueOf(resp.getStatusCode()).startsWith('2')){
            return resp.getBody();
        }
        return null;
    }
    
    /*Fetch Image from S3 */
      /**
* Fetch a textual object from an S3 bucket.
*/
    public String getImage(String region, String folderPath, String objectName, String objectId, String key, String secret, String host) {
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        
        String httpMethod = 'GET';  
        String canonicalURI ;
        String canonicalQueryString = ''; 
        String signedHeaders = 'host;x-amz-content-sha256;x-amz-date'; 
        String payload = '';
        String hashedPayload = HexSHA256Hash(payload);
      
        if(String.isEmpty(folderPath)){
            
            canonicalURI = String.join(new String[]{'', objectName}, '/');
            
        }else{
            canonicalURI = String.join(new String[]{'', folderPath, objectName}, '/');
        }
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z'); 
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('x-amz-content-sha256', hashedPayload);
        canonicalHeaders.put('Content-Encoding', 'UTF-8');
        canonicalHeaders.put('Content-Disposition', 'attachment; filename=' + objectName);
        canonicalHeaders.put('Date', formattedDateString);
        canonicalHeaders.put('ACL', 'public-read');
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 's3');
        String stringToSign = createStringToSign(now, region, canonicalRequest, 's3');        
        String signature = calculateSignature(now, secret, region, 's3', stringToSign);
        
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 's3'),canonicalHeaders, canonicalURI, null, host, canonicalQueryString, 's3');
        
        if(String.valueOf(resp.getStatusCode()).startsWith('2')){
            system.debug('resp.getBodyAsBlob()####' + resp.getBodyAsBlob());
            return  EncodingUtil.Base64Encode(resp.getBodyAsBlob()); 
            
        }
        return null;
    }
    
    //Add Method have MessageAttributes parameter for SNS - SFSD-1939
    public HttpResponse postToSNSFsd(String message,map<string,string> MessageAttMap, String contentType, String region, String key, String secret, String host, String topicARN) {
        
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        string Msgstr='';
        decimal i = 1;
        for(String Msgkey: MessageAttMap.keyset()) 
        {
              Msgstr = Msgstr + '&MessageAttributes.entry.'+i+'.Name='+Msgkey+'&MessageAttributes.entry.'+i+'.Value.DataType=String&MessageAttributes.entry.'+i+'.Value.StringValue='+MessageAttMap.get(Msgkey);
              i++;
        } 
        String httpMethod = 'POST';
        String canonicalURI = '/';
      //  String canonicalQueryString = 'Action=Publish&Version=2010-03-31'+'&Message='+message+'&TopicArn='+topicARN+'&MessageAttributes='+MessageAtt;
        String canonicalQueryString = 'Action=Publish&Version=2010-03-31'+'&Message='+message+'&TopicArn='+topicARN+Msgstr;
        String signedHeaders = 'content-type;host;x-amz-date';
        String payload = '';
        String hashedPayload = HexSHA256Hash(payload);
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('content-type', contentType);
        canonicalHeaders.put('content-length', payload.length().format());
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 'sns');
        String stringToSign = createStringToSign(now, region, canonicalRequest, 'sns');        
        String signature = calculateSignature(now, secret, region, 'sns', stringToSign);
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 'sns'),canonicalHeaders, canonicalURI, payload, host, canonicalQueryString,'sns');
        
        return resp;
        
    }
    
    public HttpResponse postToSNS(String message, String contentType, String region, String key, String secret, String host, String topicARN) {
        
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        
        String httpMethod = 'POST';
        String canonicalURI = '/';
        String canonicalQueryString = 'Action=Publish&Version=2010-03-31'+'&Message='+message+'&TopicArn='+topicARN; 
        String signedHeaders = 'content-type;host;x-amz-date';
        String payload = '';
        String hashedPayload = HexSHA256Hash(payload);
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('content-type', contentType);
        canonicalHeaders.put('content-length', payload.length().format());
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 'sns');
        String stringToSign = createStringToSign(now, region, canonicalRequest, 'sns');        
        String signature = calculateSignature(now, secret, region, 'sns', stringToSign);
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 'sns'),canonicalHeaders, canonicalURI, payload, host, canonicalQueryString,'sns');
        
        return resp;
        
    }
    
    public HttpResponse postToSNSLMS(String message, Map<String, String> MessageAttributeMap, String contentType, String region, String key, String secret, String host, String topicARN) {
        
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        String messageAttStr = '';
        integer i = 1;
        for ( String msgkey: MessageAttributeMap.keyset() ) {
            messageAttStr += '&MessageAttributes.entry.'+i+'.Name='+msgkey+'&MessageAttributes.entry.'+i+'.Value.DataType=String&MessageAttributes.entry.'+i+'.Value.StringValue='+MessageAttributeMap.get(msgkey);
            i++;
        }
        String httpMethod = 'POST';
        String canonicalURI = '/';
        String hexMessageId = generateSNSMessageId();
        String canonicalQueryString = 'Action=Publish&Version=2010-03-31'+'&Message='+message+'&TopicArn='+topicARN+messageAttStr+'&MessageId='+hexMessageId;
        String signedHeaders = 'content-type;host;x-amz-date';
        String payload = '';
        String hashedPayload = HexSHA256Hash(payload);
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('content-type', contentType);
        canonicalHeaders.put('content-length', payload.length().format());
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 'sns');
        String stringToSign = createStringToSign(now, region, canonicalRequest, 'sns');        
        String signature = calculateSignature(now, secret, region, 'sns', stringToSign);
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 'sns'),canonicalHeaders, canonicalURI, payload, host, canonicalQueryString,'sns');
        
        return resp;
        
    }
    
    public HttpResponse postToSQS(String messageBody, String contentType, String region, String key, String secret, String host, String queue) {
        
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        
        String httpMethod = 'POST';
        String canonicalURI = queue;
        String canonicalQueryString = 'Action=SendMessage&MessageBody='+messageBody+'&Version=2012-11-05'; 
        String signedHeaders = 'content-type;host;x-amz-date';
        String payload = '';
        String hashedPayload = HexSHA256Hash(payload);
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('content-type', contentType);
        canonicalHeaders.put('content-length', payload.length().format());
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 'sqs');
        String stringToSign = createStringToSign(now, region, canonicalRequest, 'sqs');        
        String signature = calculateSignature(now, secret, region, 'sqs', stringToSign);
        HttpResponse resp = makeRequest(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 'sqs'),canonicalHeaders, canonicalURI, payload, host, canonicalQueryString,'sqs');
        
        return resp;
    }
    
    /**
* Take the input and make the HTTP request.  
*/
    private HTTPResponse makeRequest(String method, String authString, Map<String, String> headers, String uri, String payload, String host, String canonicalQuerySTring, String service) {
        canonicalQuerySTring = '?'+ createEncodedCanonicalQueryParm(canonicalQuerySTring);
        String endpoint ;
        if(service == 's3'){
            endpoint = host + createEncodedCanonicalURI(uri, service);
            awsFileLocation = endpoint;
        }else{
            endpoint = host + createEncodedCanonicalURI(uri, service) + canonicalQuerySTring;
        }
        HTTPRequest req = new HTTPRequest();
        HttpResponse response = new HttpResponse();
        system.debug('authString'+authString);
        try{
            req.setMethod(method);
            req.setHeader('Authorization', authString);
            req.settimeout(120000);
            for (String key : headers.keySet()) {
                if (!key.equals('host')) {
                    req.setHeader(key, headers.get(key));
                }
            }
            req.setEndpoint(endpoint.replace(' ', '%20'));
            if (!String.isEmpty(payload)) {
                req.setBody(payload);
            }
            
            System.debug('req'+req);
            Http http = new Http();
            response = http.send(req);
            System.debug('======endpoint===='+endpoint);
           // System.debug('======getBody===='+response.getBody());
            System.debug('======getStatus===='+response.getStatus());
            System.debug('======getStatusCode===='+response.getStatusCode());
            
        } catch(Exception e){
            
            System.debug('AWS exception'+e.getMessage());
        }
        return response;
    }
    
    /**
* Creates the canonical request string.
* See: http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
*/
    @TestVisible
    private String createCanonicalRequest(String httpMethod, String canonicalURI, String canonicalQueryString,Map<String, String> canonicalHeaders, String signedHeaders, String hashedPayload, String service) {
        String encodedUriOutputString = '/' ;
        
        //encode the uri
        encodedUriOutputString = createEncodedCanonicalURI(canonicalURI, service);
        
        //encode the uri query params...
        String encodedQueryParamOutput;
        
        encodedQueryParamOutput = createEncodedCanonicalQueryParm(canonicalQueryString);
        
        //add the canonical headers, in alphabetical order...
        String headers = '';
        String sortedHeaders = sortSignedHeaders(signedHeaders);
        List<String> headerKeys = sortedHeaders.split(';');
        List<String> headerOutputList = new List<String>();
        
        for (String headerKey : headerKeys) {
            if (canonicalHeaders.containsKey(headerKey)) {
                headerOutputList.add(String.join(new String[]{headerKey.trim().toLowerCase(), canonicalHeaders.get(headerKey).trim()}, ':'));
            } 
            else {
                throw new AwsException('Key from signed headers not found in canonical header map!');
            }
        }
        
        //create the canonical request from all of the parts...
        String cReq = String.join(new String[]{
            httpMethod,
                encodedUriOutputString,
                encodedQueryParamOutput,
                String.join(headerOutputList, '\n'),
                '', //need to add blank line
                sortedHeaders,
                hashedPayload
                }, '\n');
        return cReq;                                      
    }
    @TestVisible
    private String createEncodedCanonicalURI(String canonicalURI, String service) {
        
        //encode the uri but don't encode the slashes...
        List<String> uriParts = canonicalURI.split('/');
        String encodedUriOutputString = '/' ;
        List<String> encodedUriOutputList = new List<String>();
        
        if(service == 's3'){
            for (String part : uriParts) {
                encodedUriOutputList.add(EncodingUtil.urlEncode(part, 'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E','~'));
            }
        }else{
            
            for (String part : uriParts) {
                encodedUriOutputList.add(EncodingUtil.urlEncode(EncodingUtil.urlEncode(part, 'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E','~'), 'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E','~'));
            }    
            
        }
        
        if(encodedUriOutputList != null && encodedUriOutputList.size() >0){
            encodedUriOutputString = String.join(encodedUriOutputList, '/');
        }
        return encodedUriOutputString;
    }
    @TestVisible
    private String createEncodedCanonicalQueryParm(String canonicalQueryString) {
        
        List<String> encodedQueryParamOutputList = new List<String>();
        if (!String.isEmpty(canonicalQueryString)) { 
            Map<String, String> queryParamMap = new Map<String, String>(); //query params must be added in alphabetical order
            List<String> queryStrPairs = canonicalQueryString.split('&'); //split the query params into name/value pairs
            
            //iterate name/value pairs and build query parameter map
            for (String queryStrPair : queryStrPairs) { 
                Integer eqIdx = queryStrPair.indexOf('=');
                if (eqIdx > -1) {
                    queryParamMap.put(queryStrPair.substring(0, eqIdx), queryStrPair.subString(eqIdx+1));                        
                } 
                else {
                    queryParamMap.put(queryStrPair, '');
                }
            }
            //sort the keys of the query param name/value map...
            List<String> sortedKeys = new List<String>(queryParamMap.keySet());
            sortedKeys.sort();
            
            //iterate the query params and add to the canonical request...
            for (String key : sortedKeys) {
                //encode only the name and value...
                system.debug('query key'+key);
                system.debug('query value'+queryParamMap.get(key));
                
                encodedQueryParamOutputList.add(String.join(new String[]{EncodingUtil.urlEncode(key, 'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E','~'),EncodingUtil.urlEncode(queryParamMap.get(key), 'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E','~')},'='));
            }
            system.debug('String.join encodedQueryParamOutputList'+String.join(encodedQueryParamOutputList, '&'));
            return String.join(encodedQueryParamOutputList, '&');
        }
        return null;
    }
    
    /**
* Create the string to sign.
* See: http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
*/
    @TestVisible
    private String createStringToSign(DateTime timeStamp, String region, String canonicalRequest, String api) {
        String scope = String.join(new String[] {formatShort(timeStamp), region, api, 'aws4_request'}, '/');
        String stringToSign = String.join(new String[] {'AWS4-HMAC-SHA256', formatAmzLong(timeStamp), scope, HexSHA256Hash(canonicalRequest)}, '\n');
        System.debug('stringToSign:'+stringToSign);
        return stringToSign;
    }
    
    /**
* Calculates the signature.
* See: http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
*/
    @TestVisible
    private String calculateSignature(DateTime timeStamp, String secret, String region, String service, String stringToSign) {
        Blob signingKey = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'),
                                             Crypto.generateMac('hmacSHA256', Blob.valueOf(service),
                                                                Crypto.generateMac('hmacSHA256', Blob.valueOf(region),
                                                                                   Crypto.generateMac('hmacSHA256', Blob.valueOf(formatShort(timeStamp)), Blob.valueOf('AWS4' + secret))
                                                                                  )
                                                               )
                                            );
           String signature = EncodingUtil.convertToHex(Crypto.generateMac('hmacSHA256', Blob.valueOf(stringToSign), signingKey));
          //String signature =  EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256', Blob.valueOf(stringToSign), signingKey));
       
        system.debug('signature:'+signature);
        return signature;
    }        
    
    /**
* Construct the string to use as the Authorization header value in the request.
*/
    @TestVisible
    private String createAuthorizationHeader(DateTime timeStamp, String key, String region, String signedHeaders, String signature, String service) {
        String credential = String.join(new String[] {key, formatShort(timeStamp), region, service, 'aws4_request'}, '/');
        String auth = String.join(new String[] {
            String.join(new String[]{'AWS4-HMAC-SHA256 Credential',credential}, '='),
                String.join(new String[]{'SignedHeaders', sortSignedHeaders(signedHeaders)}, '='),
                String.join(new String[]{'Signature', signature}, '=')
                }, ',');
        return auth;
    }
    
    
   /**
* Sorts the headers in the signed header string alphabetically.
*/
    private String sortSignedHeaders(String signedHeaders) {
        List<String> headerList = signedHeaders.split(';');
        headerList.sort();
        String sortedHeaders = '';
        boolean firstIteration = true;
        for (String header : headerList) {
            sortedHeaders += (!firstIteration ? ';' : '') + header;
            firstIteration = false;
        }
        return sortedHeaders;
    }
    
    /**
* Method to convert the input string to a hex representation of a SHA-256 hash.
*/
    @TestVisible
    private String HexSHA256Hash(String str) {
        return EncodingUtil.convertToHex(Crypto.generateDigest('sha256', Blob.valueOf(str)));
    }
    
    /**
* Computes HMAC by using the SHA256 algorithm with the signing key provided.
*/
    private Blob HMAC_SHA256(Blob input, String privateKey) { 
        return Crypto.generateMac('hmacSHA256', input, Blob.valueOf(privateKey));
    }
    
    /**
* Common date formatting method returning the proper long format of 
* [Day of Week, day month year hour:minute:second timezone] in GMT.
* Ex: Thu, 14 Sep 2017 11:59:23 GMT
*/
    @TestVisible
    private String formatLong(DateTime timestamp) {
        return timestamp.formatGmt('EEE, dd MMM yyyy HH:mm:ss zzz');
    }
    
    /**
* Common date formatting method returning the proper short format of [day month year] in GMT.
* Ex: 20170914
*/
    @TestVisible
    private String formatShort(DateTime timestamp) {
        return timestamp.formatGMT('yyyyMMdd');
    }
    /**
* X-Amz-Date date formatting
* Ex: YYYYMMDD'T'HHMMSS'Z'
*/
    @TestVisible
    private String formatAmzLong(DateTime timestamp) {
        
        String formatted = timestamp.formatGMT('yyyyMMdd')+'T'+ timestamp.formatGMT('HHmmss')+'Z';
        system.debug('formatted====='+formatted);
        return formatted;
    }
    
    public String putCollectionImageonS3(Blob payload, String contentType, String region, String folderPath, String objectName, String objectId, String key, String secret, String host) {
        
        DateTime now = DateTime.now();  //all request components need to have the same timestamp
        
        String httpMethod = 'PUT';
        String canonicalURI ;
        String canonicalQueryString = ''; 
        String signedHeaders = 'host;x-amz-content-sha256;x-amz-date;x-amz-acl'; 
        String hashedPayload=  EncodingUtil.convertToHex(Crypto.generateDigest('sha256', payload));
        if(String.isEmpty(folderPath)){
              
            canonicalURI = String.join(new String[]{'', objectName}, '/');
            
        }else{
            canonicalURI = String.join(new String[]{'', folderPath, objectName}, '/');
        }
        
        Map<String, String> canonicalHeaders = new Map<String, String>();
        canonicalHeaders.put('host', host.substring(host.indexOf('//') + 2));
        canonicalHeaders.put('x-amz-date', formatAmzLong(now));
        canonicalHeaders.put('x-amz-acl', 'public-read');
        canonicalHeaders.put('x-amz-content-sha256', hashedPayload);
        canonicalHeaders.put('Content-Type', contentType);
        //canonicalHeaders.put('Content-Length', payload.length().format());
        
        String canonicalRequest = createCanonicalRequest(httpMethod, canonicalURI, 
                                                         canonicalQueryString, canonicalHeaders, signedHeaders, hashedPayload, 's3');
        
        System.debug('canonicalRequest'+canonicalRequest);
        String stringToSign = createStringToSign(now, region, canonicalRequest,'s3');        
        String signature = calculateSignature(now, secret, region, 's3', stringToSign);
        
        HttpResponse resp = makeRequestForImageUpload(httpMethod, createAuthorizationHeader(now, key, region, signedHeaders, signature, 's3'),canonicalHeaders, canonicalURI, payload, host, canonicalQueryString, 's3');
        if(String.valueOf(resp.getStatusCode()).startsWith('2')){
            system.debug('resp'+resp);
            return awsFileLocation;
        }else{
            system.debug('error resp'+resp);
        }
        return null;
    }
    
   
    
    
    private HTTPResponse makeRequestForImageUpload(String method, String authString, Map<String, String> headers, String uri, Blob payload, String host, String canonicalQuerySTring, String service) {
        canonicalQuerySTring = '?'+ createEncodedCanonicalQueryParm(canonicalQuerySTring);
        String endpoint ;
        if(service == 's3'){
            endpoint = host + createEncodedCanonicalURI(uri, service);
            awsFileLocation = endpoint;
        }else{
            endpoint = host + createEncodedCanonicalURI(uri, service) + canonicalQuerySTring;
        }
        HTTPRequest req = new HTTPRequest();
        HttpResponse response = new HttpResponse();
        system.debug('authString'+authString);
        try{
            req.setMethod(method);
            req.setHeader('Authorization', authString);
            req.settimeout(120000);
            for (String key : headers.keySet()) {
                if (!key.equals('host')) {
                    req.setHeader(key, headers.get(key));
                }
            }
            req.setEndpoint(endpoint.replace(' ', '%20'));
           // if (!String.isEmpty(payload)) {
                req.setBodyAsBlob(payload);
          //  }
            
            System.debug('req'+req);
            Http http = new Http();
            response = http.send(req);
            System.debug('======endpoint===='+endpoint);
           // System.debug('======getBody===='+response.getBody());
            System.debug('======getStatus===='+response.getStatus());
            System.debug('======getStatusCode===='+response.getStatusCode());
            
        } catch(Exception e){
            
            System.debug('AWS exception'+e.getMessage());
        }
        return response;
    }
    
    /*
        Generates SNS MessageId in thr format (8-4-4-4-12)
    */
    @TestVisible
    private String generateSNSMessageId () {
        String hashStr = '' + Crypto.getRandomInteger() + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hashDigestBlob = Crypto.generateDigest('MD5', Blob.valueOf(hashStr));
        String hexStr = EncodingUtil.convertToHex(hashDigestBlob);
        hexStr = hexStr.substring(0, 8) + '-' + hexStr.substring(8);
        hexStr = hexStr.substring(0, 13) + '-' + hexStr.substring(13);
        hexStr = hexStr.substring(0, 18) + '-' + hexStr.substring(18);
        hexStr = hexStr.substring(0, 23) + '-' + hexStr.substring(23);
        
        return hexStr;
    }
}