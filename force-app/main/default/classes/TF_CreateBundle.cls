public class TF_CreateBundle {
    
    public static String addMultipleProductsToCollection(String parentProductID, List<String>listProductIds, String IsInclude) {
        
        Try{
            System.debug('===addMultipleProductsToCollection===');
            list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();  
            integer position = 1;
            List<product2> prdLst = new List<product2>();
            String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
            prdLst = [SELECT id,Name,Author__c, Hub_Id__c,Publication_Date__c,doi__c,recordtypeid,Publisher__c  FROM product2 WHERE id in :listProductIds];
            
            List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID ORDER BY Content_Position__c DESC LIMIT 1];
            
            if(lineItms.size() > 0){
                position = Integer.valueOf(lineItms[0].Content_Position__c) + 1;
            }
            
            for (product2 strProduct : prdLst) {
                String productDoi = strProduct.doi__c +'||'+ parentProductID;
                Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                lineItem.Product_Bundle_Parent__c = parentProductID;
                lineitem.Journal__c = strProduct.Name;
                lineitem.Authors__c = strProduct.Author__c;
                lineitem.Publisher__c=strProduct.Publisher__c;
                lineitem.doi__c = strProduct.doi__c;
                // lineitem.uuid__c = strProduct.Hub_Id__c;
                lineitem.Publication_Date__c = strProduct.Publication_Date__c;
                lineItem.Product_Doi__c =  productDoi;
                lineItem.Product__c = strProduct.id;
                lineItem.Source__c = 'Salesforce';
                if(IsInclude=='Include'){
                    lineItem.IsIncluded__c=true;
                }
                else if (IsInclude=='Exclude'){
                    lineItem.IsIncluded__c=false;
                }
                
                if(strProduct.recordtypeid==productRecordtypeId){                
                    lineItem.Type__c = 'Collection';
                    lineItem.Valid__c = strProduct.Hub_Id__c != null && strProduct.Hub_Id__c != '' ? 'true' : 'false';
                    lineitem.uuid__c = strProduct.Hub_Id__c;
                    lineItem.Product_Doi__c = strProduct.Hub_Id__c +'||'+ parentProductID;
                    lineitem.doi__c = strProduct.Hub_Id__c;
                    
                }
                else if(strProduct.recordtypeid!=productRecordtypeId){
                    lineItem.Type__c = 'Book';
                    lineItem.Valid__c ='';
                }
                lineItem.Content_Position__c  = position++ ;
                listofLineItems.add(lineItem); 
            }
            system.debug('listofLineItems'+listofLineItems);            
            Database.UpsertResult[] srList = Database.upsert(listofLineItems,bundle_line_item__c.Product_Doi__c,false);
            
            String jsonString = TF_GenerateJson.GenerateCommonModelJson(parentProductID, listofLineItems,null);
            submitStaticPackageToPCMCommonModel(parentProductID,jsonString);
            
            return 'Selected Products have been added into the Collection';
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
            return 'There was an issue in adding the products, please try later or contact SFDC system admin';
        }        
        
    }
    
    public static void submitStaticPackageToPCMCommonModel(String bundleId,String jsonRequest) {
        String StaticPackageEndpoint = '';
        String searchResponse='';
        String orgPrdId;
        String uuid;
        Map<String, String> headers = new Map<String,String>(); 
        
        Product2 prdt=[SELECT originalProductId__c,hub_Id__c FROM Product2 WHERE id = :bundleID]; 
        orgPrdId=prdt.originalProductId__c;
        uuid=prdt.hub_Id__c;
        if(!String.isBlank(jsonRequest)){
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            StaticPackageEndpoint = (String) orgSpecificProps.get('Dynamic_Package_API_URL__c');
            headers.put('Content-Type', 'application/json');
            
            HttpResponse res = new HttpResponse();
            if(orgPrdId==null || orgPrdId==''){
                res = TF_PlatformExecuter.execute(StaticPackageEndpoint,'POST','idtoken', jsonRequest, headers, false);
                
            }
            else if(orgPrdId!=null || orgPrdId!=''){
                StaticPackageEndpoint=StaticPackageEndpoint + '/'+ uuid;
                res = TF_PlatformExecuter.execute(StaticPackageEndpoint,'PUT','idtoken', jsonRequest, headers, false);
                
            }
            
            if (res.getStatusCode() == 202) { 
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Success';
                prd.API_Error_Cause__c='Submit To PCM Success';
                update prd ;
            }else{
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Failed';
                prd.API_Error_Cause__c='Submit To PCM Failed';
                update prd ;
            }
        }
        else{
            
        }
    }
    //SFAL-51 Added by shubham kumar(To get the Products corresponding to a bundle. Id)
    public static List<string> getproductListfromPCM(String PCMUUId){
        try {
            list<String> PcmIsbnNumbers = new  list<String>();
            system.debug('PCMUUId'+PCMUUId);
            Map<String, String> mapHeader = new Map<String, String>();
            mapHeader.put('Content-Type','application/json');
            
            String pcmproductURL = [SELECT UBX_Order_Platform_uri__c FROM TF_OrgSpecificProps__c ].UBX_Order_Platform_uri__c + '/v4/products/'+PCMUUId+'?apiVersion=4.0.1&responseGroup=large';
            
            system.debug('pcmproductURL'+pcmproductURL);
            //https://api-uat.taylorfrancis.com/v4/products/0002d4d1-e71b-472d-8689-05e74f740339?apiVersion=4.0.1&responseGroup=large
            httpResponse res = TF_PlatformExecuter.execute(pcmproductURL,'GET','idtoken',null, mapHeader, false);
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200)
            {
                System.debug('****responseBody****!' + res.getBody());
                
                PCMProductResponseWrapper productlistresponse =(PCMProductResponseWrapper) System.JSON.deserialize(res.getBody(), PCMProductResponseWrapper.class);
                System.debug('****responseBody****!'+productlistresponse.product.identifiers.isbn);
                //system.debug('productlistresponse.data.orderNumber-'+TF_EntitlementResponseObj.data[0].product);
                PcmIsbnNumbers.add(productlistresponse.product.identifiers.isbn);
                return PcmIsbnNumbers;
            }
            else{
                System.debug('bad response-'+ res.getStatus());
                System.debug('bad res.getBody()-'+ res.getBody());
                return null;
            }     
            
        } catch (Exception e) {
            System.debug('error -'+e.getMessage()+'----'+e.getLineNumber());
            return null;
        } 
    }
    /*//SFAL-51 Added by shubham kumar(To get the sum of prices of childs corresponding to a bundle)
    public static Integer getListPriceSumBundleItems(String PCMUUId){
        try {
            list<String> PcmIsbnNumbers = new  list<String>();
            system.debug('PCMUUId'+PCMUUId);
            Map<String, String> mapHeader = new Map<String, String>();
            mapHeader.put('Content-Type','application/json');
            
            String pcmproductURL = [SELECT UBX_Order_Platform_uri__c FROM TF_OrgSpecificProps__c ].UBX_Order_Platform_uri__c + '/v4/products/'+PCMUUId+'?apiVersion=4.0.1&responseGroup=large';
            system.debug('pcmproductURL'+pcmproductURL);
            //https://api-uat.taylorfrancis.com/v4/products/0002d4d1-e71b-472d-8689-05e74f740339?apiVersion=4.0.1&responseGroup=large
            httpResponse res = TF_PlatformExecuter.execute(pcmproductURL,'GET','idtoken',null, mapHeader, false);
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200)
            {
                System.debug('****responseBody****!' + res.getBody());
                
                PCMProductResponseWrapper productlistresponse =(PCMProductResponseWrapper) System.JSON.deserialize(res.getBody(), PCMProductResponseWrapper.class);
                System.debug('****responseBody****!'+productlistresponse.product.prices);
                //system.debug('productlistresponse.data.orderNumber-'+TF_EntitlementResponseObj.data[0].product);
                
                //PcmIsbnNumbers.add(productlistresponse.product.identifiers.isbn);
                return productlistresponse.product.prices[0].price;
            }
            else{
                System.debug('bad response-'+ res.getStatus());
                System.debug('bad res.getBody()-'+ res.getBody());
                return null;
            }     
            
        } catch (Exception e) {
            System.debug('error -'+e.getMessage()+'----'+e.getLineNumber());
            return null;
        } 
    }*/
}