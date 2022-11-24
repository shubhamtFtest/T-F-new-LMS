public class TF_downloadPDF {
    // to do -  make endpoint dynamic https://uat-sap-integration-mule-api.ir-e1.cloudhub.io/api/v2.0/download/invoice/0952320698?salesOrg=IN01
    // http://mule-worker-internal-uat-sap-invoice-integration-api.ir-e1.cloudhub.io:8091/api/v3.0/invoice/{invoiceNumber}/download
    // https://uat-sap-integration-mule-api.ir-e1.cloudhub.io 
    private static string hostNameDownloadInvoice = '';
    private static string downloadInvoiceUrl = '/download';
    private static string hostname;
    private static String fetchSpecificOrderURI = '/v1/orders/';
    
    
    private static void init() {
        if(String.isNotBlank(hostname)) {
            // no strings attached   Download_Invoice_Domain__c
        }else {            
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();            
            if (orgSpecificProps != null) {
                hostname = (String) orgSpecificProps.get('UBX_Order_Platform_uri__c');
                hostNameDownloadInvoice = (String) orgSpecificProps.get('Download_Invoice_Domain__c');
                System.debug('hostname-'+hostname);
            }            
        }
    }
    
    @AuraEnabled
    public static Metadata downloadPDF(Id orderId ){
        system.debug('orderId-'+orderId);
        
        try{
            // check if ContentVersion with title SAP Invoice.pdf exist or not ? 
            // 
            // 
            // //query  ContentDocumentLink  LinkedEntityId = orderid then get ContentDocumentId
            // query ContentVersion  with ContentDocumentId ,  check if ContentVersion with title SAP Invoice.pdf exist or not ?
            List<ContentDocumentLink> listContentDocumentLink = new List<ContentDocumentLink>([SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:orderId]);
            if(!listContentDocumentLink.isEmpty()){
                Id conDocumentId = listContentDocumentLink.get(0).ContentDocumentId;
                 List<ContentVersion> conVersion;
                if(conDocumentId != NULL)  conVersion = new List<ContentVersion>([SELECT ContentDocumentId, Title FROM ContentVersion WHERE ContentDocumentId =:conDocumentId AND Title ='SAP Invoice.pdf']);
                if(!conVersion.isEmpty()){
                    Metadata metadataObj = new Metadata('info','Invoice is already available in file section !' );                
                    return metadataObj;
                }
            }   
            
            
            init();
            // fetch order to get orderHUb number
            List<Order> listOrderDb = new List<Order>([SELECT id,OrderReferenceNumber FROM order WHERE id=:orderId]);
            if(listOrderDb.get(0)!=NULL && listOrderDb.get(0).OrderReferenceNumber!= NULL ) 
            {
                fetchSpecificOrderURI = hostname + fetchSpecificOrderURI  + listOrderDb.get(0).OrderReferenceNumber;
                system.debug('fetchSpecificOrderURI-'+fetchSpecificOrderURI);
                // call order detail api
                Map<String, String> mapHeader ;
                mapHeader = new Map<String, String>();
                mapHeader.put('Content-Type','application/json');
                HttpResponse  respSingleOrd = TF_PlatformExecuter.execute(fetchSpecificOrderURI,'GET','idtoken', null, mapHeader, false);
                if (respSingleOrd.getStatusCode() == 201 || respSingleOrd.getStatusCode() == 200) {
                    String responseBody = respSingleOrd.getBody();
                    System.debug('********!' + responseBody);
                    System.debug('****ResponseCode****!' + respSingleOrd.getStatusCode());
                    // System.debug('****responseBody****!' + res.getBody());
                    TF_SingleOrderDetailJsonResponse TF_SingleOrderDetailJsonResponseObj =(TF_SingleOrderDetailJsonResponse) System.JSON.deserialize(respSingleOrd.getBody().replace('"currency":','"currencyy":'), TF_SingleOrderDetailJsonResponse.class);
                    System.debug('TF_SingleOrderDetailJsonResponseObj.order.invoices[0].externalInvoiceRef-'+TF_SingleOrderDetailJsonResponseObj.order.invoices[0].externalInvoiceRef);
                    if (TF_SingleOrderDetailJsonResponseObj!= Null && TF_SingleOrderDetailJsonResponseObj.order!= NULL && TF_SingleOrderDetailJsonResponseObj.order.invoices[0].externalInvoiceRef != NULL   ) {
                        
                        String externlInvoiceNum= TF_SingleOrderDetailJsonResponseObj.order.invoices[0].externalInvoiceRef;
                        system.debug('externlInvoiceNum-'+externlInvoiceNum);
                        HttpResponse  resp = TF_PlatformExecuter.execute(hostNameDownloadInvoice+externlInvoiceNum+downloadInvoiceUrl  ,'GET','idtoken', null, mapHeader, false);
                        if(resp.getStatusCode()==200 || respSingleOrd.getStatusCode() == 201 ){                 
                            //Insert ContentVersion
                            ContentVersion cVersion = new ContentVersion();
                            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                            cVersion.PathOnClient = 'SAP Invoice.pdf';//File name with extention
                            cVersion.Title ='SAP Invoice.pdf';//Name of the file
                            cVersion.VersionData = resp.getBodyAsBlob();//File content
                            Insert cVersion;
                            
                            //After saved the Content Verison, get the ContentDocumentId
                            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
                            
                            //Insert ContentDocumentLink
                            ContentDocumentLink cDocLink = new ContentDocumentLink();
                            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                            cDocLink.LinkedEntityId = orderId;//Add attachment parentId
                            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                            Insert cDocLink;
                            
                            // craetng meta data 
                            Metadata metadataObj = new Metadata('success','The SAP invoice has been downloaded in file section' );                            
                            return metadataObj;
                            
                        }else if(resp.getStatusCode()==404 || resp.getStatus().containsIgnoreCase('Not Found')  ){
                            Metadata metadataObj = new Metadata('error','Invoice is not availble now, check after sometime !' );                
                            return metadataObj;
                        }else{
                             Metadata metadataObj = new Metadata('error','Something went wrong, Please try after sometime' );                
                			return metadataObj;
                        }
                    } else{
                        Metadata metadataObj = new Metadata('error','Something went wrong, Please try after sometime' );                
                       return metadataObj;
                   }                                       
                }
            }else{
                Metadata metadataObj = new Metadata('error','Please enter Order Reference number' );                
                return metadataObj;
            }
        }catch(exception e ){
            // craetng meta data 
            Metadata metadataObj = new Metadata('error', e.getMessage() );            
            return metadataObj;
        }
        return NULL;
    }  
    
    
    public static String mogrifyJSON(String data) {
        // Regex to match the start of the line and the key
        // surrounded by quotes and ending with a colon
        String regexFormat = '(?m)^\\s*"{0}"\\s*:';
        
        // Replacement format of the new key surrounded by
        // quotes and ending with a colon
        String replacementFormat = '"{0}" :';
        
        // A map of existing key to replacement key
        Map<String, String> replacements = new Map<String, String> {
            'currency' => 'currencyy'
                };
                    
                    // Since our JSON can come in formatted however the
                    // endpoint wants, we need to format it to a standard
                    // we know and can handle
                    String formattedJSON = JSON.serializePretty(JSON.deserializeUntyped(data));
        
        // Iterate over all the keys we want to replace
        for (String key : replacements.keySet()) {
            // Generate our regex based on the key
            String regex = String.format(
                regexFormat,
                new List<String> {key}
            );
            
            // Generate our replacement
            String replacement = String.format(
                replacementFormat,
                new List<String> {replacements.get(key)}
            );
            
            // Find all and replace
            formattedJSON = formattedJSON.replaceAll(regex, replacement);
            // System.debug('formattedJSON-'+formattedJSON); 
        }
        
        return formattedJSON;
    }
    public class Metadata{
        @AuraEnabled public String status;
        @AuraEnabled public String message;
        
        public Metadata( String status , String message ){
            this.status = status;
            this.message = message;
        }  
    }
    
    
}

/*
//String base64Response = resp.getBody();
blob response = resp.getBodyAsBlob();
Attachment attach = new Attachment();
attach.contentType = 'application/octet-stream';
attach.name = 'myfile111.pdf';
attach.parentId = '0061l00000K2e18AAB';
//attach.body = EncodingUtil.base64Decode(base64Response);
attach.body = response; 
insert attach;
*/
// inserting content version