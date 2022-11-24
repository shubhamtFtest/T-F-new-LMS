/** Created By: Shalini Singh
    Test Class: downloadPDFCreditNoteTest
	Description: Using to download the credit note invoice
**/
public class downloadPDFCreditNote {
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
            // check if ContentVersion with title SAP Invoice For Credit Note.pdf exist or not ? 
            List<ContentDocumentLink> listContentDocumentLink = new List<ContentDocumentLink>([SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:orderId]);
            if(!listContentDocumentLink.isEmpty()){
                Id conDocumentId = listContentDocumentLink.get(0).ContentDocumentId;
                 List<ContentVersion> conVersion;
                if(conDocumentId != NULL)  conVersion = new List<ContentVersion>([SELECT ContentDocumentId, Title FROM ContentVersion WHERE ContentDocumentId =:conDocumentId AND Title ='SAP Invoice For Credit Note.pdf']);
                if(!conVersion.isEmpty()){
                    Metadata metadataObj = new Metadata('info','Invoice is already available in file section !' );                
                    return metadataObj;
                }
            }   
            
            
            init();
            // fetch order to get orderHUb number
            List<Order> listOrderDb = new List<Order>([SELECT id,OrderReferenceNumber,Cancelled_Order_Reference_Number__c FROM order WHERE id=:orderId]);
            if(listOrderDb.get(0)!=NULL && listOrderDb.get(0).Cancelled_Order_Reference_Number__c!= NULL ) 
            {
                fetchSpecificOrderURI = hostname + fetchSpecificOrderURI  + listOrderDb.get(0).Cancelled_Order_Reference_Number__c;
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
                    
                    TF_SingleOrderDetailJsonResponse TF_SingleOrderDetailJsonResponseObj =(TF_SingleOrderDetailJsonResponse) System.JSON.deserialize(respSingleOrd.getBody().replace('"currency":','"currencyy":'), TF_SingleOrderDetailJsonResponse.class);
                    
                    if (TF_SingleOrderDetailJsonResponseObj!= Null && TF_SingleOrderDetailJsonResponseObj.order!= NULL){
                        
                        if(TF_SingleOrderDetailJsonResponseObj.order.invoices != null && !TF_SingleOrderDetailJsonResponseObj.order.invoices.isEmpty()
                           && TF_SingleOrderDetailJsonResponseObj.order.invoices[0].externalInvoiceRef != NULL )
                        {
                            String externlInvoiceNum= TF_SingleOrderDetailJsonResponseObj.order.invoices[0].externalInvoiceRef;
                            system.debug('externlInvoiceNum-'+externlInvoiceNum);
                            HttpResponse  resp = TF_PlatformExecuter.execute(hostNameDownloadInvoice+externlInvoiceNum+downloadInvoiceUrl  ,'GET','idtoken', null, mapHeader, false);
                            if(resp.getStatusCode()==200 || respSingleOrd.getStatusCode() == 201 ){                 
                                //Insert ContentVersion
                                ContentVersion cVersion = new ContentVersion();
                                cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                                cVersion.PathOnClient = 'SAP Invoice For Credit Note.pdf';//File name with extention
                                cVersion.Title ='SAP Invoice For Credit Note.pdf';//Name of the file
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
                        }
                        else{
                            Metadata metadataObj = new Metadata('error','Invoice Number is not available now, please check after sometime!!' );                
                            return metadataObj;
                        }
                        
                        
                    } else{
                        Metadata metadataObj = new Metadata('error','Something went wrong, Please try after sometime' );                
                        return metadataObj;
                    }                                       
                }
            }else{
                Metadata metadataObj = new Metadata('error','Please enter Cancelled Order Reference number' );                
                return metadataObj;
            }
        }catch(exception e ){
            // craetng meta data 
            Metadata metadataObj = new Metadata('error', e.getMessage() );            
            return metadataObj;
        }
        return NULL;
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