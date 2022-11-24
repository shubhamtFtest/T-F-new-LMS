/*Created By: Sidhant Chauhan
 *Test Class: ztest_TF_UpdateProductHubIdForFSDProduct
 *Description: Using this class to sync the Journal Master and service products to PCM 
*/
global with sharing class TF_FSDSyncCallout {
    
    private static String productHubURI = '/v4/products';
    
    global class UpdateProductRequest {
        public String Id;
    }
    
    @InvocableMethod(Label = 'TF_FSDSyncCallout')
    public static void doAction(List < Product2 > requests) {
        if (requests.size() > 0) {
            for(product2 prodObj:requests){
                if (!system.isFuture()) {
                    if (prodObj.Hub_Id__c == null && prodObj.Family=='Journal Service Product')
                        //If the product is service product and hub id is not there
                        getHubID(prodObj.id);
                    else
                        //If it is Not a Service Product or does have UUID and it's a service Product
                        updateCall(prodObj.id, prodObj.Hub_Id__c, 'PUT');
                }
            }
        }
    }
    
    @future(callout = true)
    Public static void getHubID(String Id) {
        List<product2> prodObjList=new List<product2>();
        prodObjList=[select id from product2 where Family='Journal Service Product' and Hub_Id__c=null and id=:Id];
        if(prodObjList.size()>0)
            getHubIDSync(Id);
    }
    
    @future(callout = true)
    Public static void updateCall(String SFProductId, String productHubID, String methodName) {
        syncCallout(SFProductId, productHubID, methodName);
    }
    
    Public static void getHubIDSync(String Id) {
        String productHubID = null;
        Map < String, String > headers = new Map < String, String > ();
        headers.put('Content-Type', 'application/json');
        String requestJSON = '{"action": "new-id","apiVersion": "4.0.1"}';
        
        try {
            HttpResponse res = null;
            
            res = TF_PlatformExecuter.execute(productHubURI, 'POST', 'idtoken', requestJSON, headers, false);
            
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                
                String responseBody = res.getBody();
                responseBody = responseBody.replace('_id', 'newId');
                Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
                System.debug('********!' + (String) results.get('id_token')); //results.id_token);
                System.debug('****ResponseCode****!' + res.getStatusCode());
                ProductHubResponse productHubRes = (ProductHubResponse) JSON.deserialize(responseBody, ProductHubResponse.class);
                productHubID = productHubRes.newId;
                if (productHubID != null) {
                    syncCallout(Id, productHubID, 'POST');
                }
                updateProductHubId(productHubID, Id);
            } else {
                system.debug('#####!DEBUG' + '' + res);
                system.debug('#####!DEBUG' + '' + Id);
                product2 obj=new product2();
                obj.id=Id;
                obj.APIStatus__c='GetUUID Incomplete';
                update obj;
            }
        } catch (Exception ex) {
            System.debug('******** Exception : ' + ex.getMessage());
        }
    }
    @TestVisible
    private static String updateProductHubId(String productHubID, String SFProductId) {
        If(productHubID != '') {
            try {
                system.debug('SFProductId' + ' ' + SFProductId);
                Product2 prd = [SELECT Id, Name FROM Product2 Where id =: SFProductId];
                prd.Hub_Id__c = productHubID;
                update prd;
                system.debug('update Success');
                Return 'Success';
            } catch (exception e) {
                system.debug(e.getmessage() + ' ' + 'update failed');
                Return 'Failed';
            }
        }
        else {
            if (productHubID == '' || String.isBlank(productHubID)) {
                Return 'Failed';
            }
            
        }
        Return 'Success';
    }
    
    //common function getting called after getting service product uuid or making an master product sync call 
    @testvisible
    private static String syncCallout(String SFProductId, String productHubID, String methodName) {
        Map < String, String > headers = new Map <String, String> ();
        headers.put('Content-Type', 'application/json');
        productHubID = '' + productHubID + '';
        product2 prodObj;
        List < pricebookentry > pbeObjList;
        
        if (SFProductId != null) {
            prodObj = [select id,Sales_Organization__c,Commissioning_Editor_Name__c,Commissioning_Editor_Email__c,Sub_Type__c,Open_Access_Category__c,Product_Status__c, Name,productcode, family from product2 where id =: SFProductId];
            pbeObjList = [select id, currencyISOCode, unitprice from pricebookentry where product2id =: SFProductId
                          and Pricebook2Id IN(SELECT Id FROM PriceBook2 WHERE Name = 'OA APC PriceBook')
                         ];
        }
        
        cls_identifiers cls_identifiersObj = new cls_identifiers();
        cls_identifiersObj.publishingServiceId = 'oama22';
        
        List < cls_prices > pricesList = new List < cls_prices > ();
        for (pricebookentry pbe: pbeObjList) {
            cls_prices cls_pricesObj = new cls_prices();
            cls_pricesObj.price = Integer.valueof(pbe.unitprice);
            cls_pricesObj.currncy = pbe.currencyISoCode;
            cls_pricesObj.validFrom = '2019-03-01T14:16:27.308Z';
            pricesList.add(cls_pricesObj);
        }
        
        cls_publishingService cls_publishingServiceObj = new cls_publishingService();
        /* if(prodObj.Product_Status__c==''  || prodObj.Product_Status__c==null){
cls_publishingServiceObj.status ='Available';   
}
else{*/
        cls_publishingServiceObj.status = prodObj.Product_Status__c;//'available';
        //  }
        cls_publishingServiceObj.description = '';
        
        
        
        cls_product clProd = new cls_product();
        clProd.type = 'publishingService';
        clProd.title = prodObj.Name;
        // if(prodObj.Sub_Type__c==''){
        // clProd.subType='submissionFee';
        //}else{
        // clProd.subType='submissionFee';
        clProd.subType= prodObj.Sub_Type__c;
        // }
        clProd.version = '1.0.0';
        clProd.publishingService = cls_publishingServiceObj;
        clProd.prices = pricesList;
        clProd.identifiers = cls_identifiersObj;
        //Add permission
        
        
        clProd.contributors = new List < cls_contributors > {};
            clProd.categories = new List < cls_categories > {};
                clProd.classifications = new List < cls_classifications > {};
                    clProd.permissions = new List < cls_permissions >{};
                        clProd.rights = new List < cls_rights > {};
                            
                            String requestJSON = '';
        request_Body reqBody = new request_Body();
        journalRequestBody journalreq = new journalRequestBody();
        
        if (prodObj.family == 'Journal Service Product') {
            productHubURI = productHubURI + '/' + productHubID;
            reqBody.apiVersion = '4.0.1';
            reqBody.product = clProd;
            requestJSON = JSON.serialize(reqBody).replace('"currncy":', '"currency":');
            system.debug('requestJSON=='+requestJSON);
        } else {
            map<String,String> mapcatwithCode=new map<String,String>{'open-select' => 'OS', 'open-access' => 'OA'};
               List<cls_permissions> permissionList=new List<cls_permissions>();
                cls_permissions clPermission=new cls_permissions();
            String openAccessCat=prodObj.Open_Access_Category__c;
            if(openAccessCat=='Open')
                openAccessCat='open-access';
            else if(openAccessCat=='Open Select'){
                openAccessCat='open-select';
            }
            if(prodObj.Open_Access_Category__c!=null){
                clPermission.name=openAccessCat;
            }
            clPermission.code=mapcatwithCode.get(openAccessCat);  
            clPermission.text='';
            clPermission.type='access';
            clPermission.description=null;
            clPermission.validTo=null;
            clPermission.validFrom=null;
            permissionList.add(clPermission);
            
            List<cls_contributors> cls_contributorsList=new List<cls_contributors>();
            if(prodObj.Commissioning_Editor_Email__c!=null && prodObj.Commissioning_Editor_Email__c!=''){
            cls_contributors conObj=new cls_contributors();
            conObj.roles=new List<String>{'commissioningEditor'};
                conObj.givenName=null;
            conObj.familyName=null;
            conObj.fullName=prodObj.Commissioning_Editor_Name__c;//null;
            conObj.email=prodObj.Commissioning_Editor_Email__c;//'JohnMullan@tandf.co.uk';
            conObj.bio=null;
            conObj.orcid=null;
            conObj.collab=null;
            conObj.position=1;
            conObj.affiliations=new List<String>{};
                cls_contributorsList.add(conObj);
            }
                productHubURI = productHubURI + '/' + prodObj.ProductCode + '?productIdentifierName=journalAcronym';// +prodObj.ProductCode;
            methodName='PUT';
            
            List <cls_Journalsclassifications> classificationsList = new List < cls_Journalsclassifications > ();
            for(Article_Type__c arTypeObj:[Select id,Article_Name__c,cat_Article_Type__c from Article_Type__c where Product__c!=null  and Product__c=:prodObj.Id]){
                if(arTypeObj.Article_Name__c!=null){
                    cls_Journalsclassifications journalclassificationObj = new cls_Journalsclassifications();
                    journalclassificationObj.level = null;
                    journalclassificationObj.priority = null;
                    journalclassificationObj.groupKey = 'apc';
                    journalclassificationObj.code = null;
                    journalclassificationObj.name =arTypeObj.Article_Name__c;
                    journalclassificationObj.type = 'article-type';
                    
                    classificationsList.add(journalclassificationObj);
                }
                
                if(arTypeObj.cat_Article_Type__c!=null){
                    cls_Journalsclassifications journalclassificationObjCats = new cls_Journalsclassifications();
                    journalclassificationObjCats.level = null;
                    journalclassificationObjCats.priority = null;
                    journalclassificationObjCats.groupKey = 'apc';
                    journalclassificationObjCats.code = null;
                    journalclassificationObjCats.name =arTypeObj.cat_Article_Type__c;
                    journalclassificationObjCats.type = 'cats-article-type';
                    classificationsList.add(journalclassificationObjCats);
                }
            }
            
            cls_journal ob=new cls_journal();
             if(prodObj.Sales_Organization__c=='IN03'){
                ob.legalOwner='US';
            }else if(prodObj.Sales_Organization__c=='IN01'){
                ob.legalOwner='UK';
            }
            
            cls_Journalsproduct journproductReq = new cls_Journalsproduct();
            journproductReq.journal=ob;
            journproductReq.type = 'journal';
            journproductReq.classifications = classificationsList;
            if(prodObj.Commissioning_Editor_Email__c!=null && prodObj.Commissioning_Editor_Email__c!=''){
            journproductReq.contributors=cls_contributorsList;//conObj;
            }else{
             journproductReq.contributors=new List<cls_contributors>();//conObj;
            }
            journproductReq.permissions=permissionList;//clPermission;
            journalreq.apiVersion = '4.0.1';
            journalreq.product = journproductReq;
            requestJSON = JSON.serialize(journalreq).replace('"groupKey":', '"group":');
            requestJSON=requestJSON.replace('groupKey','group');
            system.debug('requestJSON'+requestJSON);
            system.debug('reqBody==' + journalreq);
        }
        
        
        try {
            HttpResponse res = null;
            
            res = TF_PlatformExecuter.execute(productHubURI, methodName, 'idtoken', requestJSON, headers, false);
            
            product2 updateProdobj = new product2();
            updateProdobj.id = SFProductId;
            
            if (res.getStatusCode() == 202) {
                string resposeStr = res.getBody();
                responsejason obj = (responsejason) System.JSON.deserialize(resposeStr, responsejason.class);
                updateProdobj.PCM_Sync_Reponse_Msg__c = obj.metadata.message;
                updateProdobj.Approval_Status__c='Draft';
                updateProdobj.IsActive = true;
                updateProdobj.APIStatus__c = 'Success';
            } else {
                updateProdobj.PCM_Sync_Reponse_Msg__c = res.getBody();
                updateProdobj.APIStatus__c = 'Failure';
            }
            
            if (prodObj.family == 'Journal Service Product') {
                update updateProdobj;
            }
            syncServiceProductAssociteMappingCallout(SFProductId,headers);
            
            System.debug('My Response' + res.getBody());
        } catch (Exception ex) {
            System.debug('******** Exception : ' + ex.getMessage());
        }
        return null;
    }
    @TestVisible
    private static String syncServiceProductAssociteMappingCallout(Id SFProductId,Map<String,String> headers){
        try{
            Product2 prodObj=[select id,Hub_Id__c,Family,productcode from product2 where id=:SFProductId limit 1];
            if(prodObj.Family=='Journal Master Product'){
                
                String productURI = '/v4/products'; 
                productURI=productURI + '/' + prodObj.ProductCode + '/publishing-services?productIdentifierName=journalAcronym';// +prodObj.ProductCode;
                String methodName='PUT';
                List<String> articaleName=new List<String>();
                List<String> catarticaleName=new List<String>();
                List <cls_Journalsclassifications> classificationsList = new List < cls_Journalsclassifications > ();
                List<cls_publishingServices> cls_publishingServicesList=new List<cls_publishingServices>();
                cls_SecondJournlCalldata wrapobj=new cls_SecondJournlCalldata();
                for(Article_Type__c arTypeObj:[Select id,Price_Point__r.Hub_Id__c,Article_Name__c,cat_Article_Type__c from Article_Type__c where Product__c!=null and Price_Point__c!=null  and Product__c=:prodObj.id]){
                    cls_classification classificationOne=new cls_classification();
                    classificationOne.name=arTypeObj.Article_Name__c;
                    classificationOne.type='article-type';
                    
                    /*cls_publishingServices pulshingServiceOne=new cls_publishingServices();
                    pulshingServiceOne.id=arTypeObj.Price_Point__r.Hub_Id__c;
                    pulshingServiceOne.validFrom=null;
                    pulshingServiceOne.validTo=null;
                    pulshingServiceOne.classification=classificationOne;*/
                    
                    cls_classification classificationSecond=new cls_classification();
                    classificationSecond.name=arTypeObj.cat_Article_Type__c;//'PR1';
                    classificationSecond.type='cats-article-type';
                    
                  /*  cls_publishingServices pulshingServiceSecond=new cls_publishingServices();
                    pulshingServiceSecond.id=arTypeObj.Price_Point__r.Hub_Id__c;
                    pulshingServiceSecond.validFrom=null;
                    pulshingServiceSecond.validTo=null;
                    pulshingServiceSecond.classification=classificationSecond;
                    */
                    if(!articaleName.contains(arTypeObj.Article_Name__c+'#'+arTypeObj.Price_Point__r.Hub_Id__c)){
                    cls_publishingServices pulshingServiceOne=new cls_publishingServices();
                    pulshingServiceOne.id=arTypeObj.Price_Point__r.Hub_Id__c;
                    pulshingServiceOne.validFrom=null;
                    pulshingServiceOne.validTo=null;
                    pulshingServiceOne.classification=classificationOne;
                    articaleName.add(String.valueof(classificationOne.name+'#'+arTypeObj.Price_Point__r.Hub_Id__c));
                    cls_publishingServicesList.add(pulshingServiceOne);
                    }
                    if(!catarticaleName.contains(arTypeObj.cat_Article_Type__c+'#'+arTypeObj.Price_Point__r.Hub_Id__c)){
                    cls_publishingServices pulshingServiceSecond=new cls_publishingServices();
                    pulshingServiceSecond.id=arTypeObj.Price_Point__r.Hub_Id__c;
                    pulshingServiceSecond.validFrom=null;
                    pulshingServiceSecond.validTo=null;
                    pulshingServiceSecond.classification=classificationSecond;
                    cls_publishingServicesList.add(pulshingServiceSecond);
                    catarticaleName.add(String.valueof(classificationSecond.name+'#'+arTypeObj.Price_Point__r.Hub_Id__c));
                    }
                    
                }
                 wrapobj.publishingServices=cls_publishingServicesList;
                calssificationMappingCalloutReqBody objMap=new calssificationMappingCalloutReqBody();
                objMap.apiVersion='4.0.1';
                objMap.data=wrapobj;
                String requestJSON = JSON.serialize(objMap).replace('"id":', '"_id":');
                //requestJSON=requestJSON.replace('groupKey','group');
                system.debug('SecondrequestJSON'+requestJSON);
                HttpResponse res = null;
                
                res = TF_PlatformExecuter.execute(productURI, methodName, 'idtoken', requestJSON, headers, false);
                product2 updateProdobj = new product2();
                updateProdobj.id = SFProductId; 
                if (res.getStatusCode() == 202) {
                    string resposeStr = res.getBody();
                    responsejason obj = (responsejason) System.JSON.deserialize(resposeStr, responsejason.class);
                    updateProdobj.PCM_Sync_Reponse_Msg__c = obj.metadata.message;
                    
                    updateProdobj.IsActive = true;
                    updateProdobj.APIStatus__c = 'Success';
                    if(prodObj.Hub_Id__c==null){
                        Map < String, String > headersUUid = new Map < String, String > ();
                        headersUUid.put('Content-Type', 'application/json');
                        String requestJSONUUid = '{"action": "new-id","apiVersion": "4.0.1"}';
                        HttpResponse resgetUUid = null;
                        system.debug('headersUUid='+headersUUid);
                        resgetUUid = TF_PlatformExecuter.execute('/v4/products?identifierName=journalAcronym&identifierValues='+prodObj.ProductCode+'&apiVersion=4.0.1&responseGroup=medium', 'GET', 'idtoken', null, headersUUid, false);
                        system.debug('Journal HubId map=>'+resgetUUid.getBody());
                        system.debug('TansectionId'+resgetUUid.getHeader('x-transaction-id'));
                        List<Object> results = (List<Object>)JSON.deserializeUntyped(resgetUUid.getBody());
                        system.debug('results==='+results);

                        if(results.size()>0){
                         Map<String, Object> mapresults = (Map<String, Object>)(results[0]);
                         Map<String, Object> map_Id = (Map<String, Object>)(mapresults.get('product'));
                         system.debug(String.valueof(map_Id.get('_id'))+'mapresults'+mapresults);
                         updateProdobj.Hub_Id__c=String.valueof(map_Id.get('_id')); 
                         updateProdobj.Approval_Status__c='Draft';
                        }else{
                            updateProdobj.PCM_Sync_Reponse_Msg__c = resgetUUid.getBody();
                            updateProdobj.APIStatus__c = 'Failure';
                        }
                    }
                    else updateProdobj.Approval_Status__c='Draft';
                } else {
                    updateProdobj.PCM_Sync_Reponse_Msg__c = res.getBody();
                    updateProdobj.APIStatus__c = 'Failure';
                }
                update updateProdobj;
                System.debug('My ResponseSecond' + res.getBody());
            }
        } catch (Exception ex) {
            System.debug('******** Exception : ' + ex.getMessage());
        }
        return null;        
    }
    
    class ProductHubResponse {
        private String newId;
    }
    
    
    
    
    public String apiVersion; //4.0.1
    public cls_product product;
    class cls_product {
        public String type; //publishingService
        public String title; //Submission Fee
        public String version; //1.0.0
        public String subType;//
        public cls_publishingService publishingService;
        public cls_prices[] prices;
        public cls_identifiers identifiers;
        public cls_contributors[] contributors;
        public cls_categories[] categories;
        public cls_classifications[] classifications;
        public cls_permissions[] permissions;
        public cls_rights[] rights;
    }
    class cls_publishingService {
        public String status; //available
        public String description; //
    }
    class cls_prices {
        public Integer price; //3350
        public String currncy; //AUD
        public String validFrom; //2019-03-01T14:16:27.308Z
    }
    class cls_identifiers {
        public String publishingServiceId; //oama22
    }
    class cls_categories {}
    class cls_classifications {}
    class cls_permissions {
        public String name;
        public String code;
        public String text=null;
        public String type='access';
        public String description=null;
        public String validTo=null;
        public String validFrom=null;
        
    }
    class cls_rights {}
    
    class request_Body {
        public String apiVersion; //4.0.1
        public cls_product product;
    }
    
    public class responsejason {
        public cls_metadata metadata;
        public cls_data data;
    }
    
    class cls_metadata {
        public String message; //Publishing-Service product update request for id 5e860d69-7506-43ea-b762-93b8b064913e is accepted successfully, it will be processed soon.
    }
    class cls_data {}
    
    
    public class journalRequestBody {
        public String apiVersion; //4.0.1
        public cls_Journalsproduct product;
    }
    
    class cls_Journalsproduct {
        public cls_journal journal;
        public String type; //journal
        public List < cls_Journalsclassifications > classifications;
        public cls_contributors[] contributors;
        public cls_permissions[] permissions;
        
    }
    
    class cls_contributors {
        public List<String> roles;
        public String givenName;
        public String familyName;
        public String fullName;
        public String email;
        public String bio;
        public String orcid;
        public String collab;
        public List<String> affiliations=new List<String>();
        public Integer position;
    }
    
   
    
    class cls_Journalsclassifications {
        public cls_level level;
        public cls_priority priority;
        public String groupKey; //apc
        public cls_code code;
        public String name; //Review
        public String type; //article-type
    }
    
    class cls_level {}
    class cls_priority {}
    class cls_code {}
    
    class calssificationMappingCalloutReqBody{
        public String apiVersion;   //4.0.1
        public cls_SecondJournlCalldata data;
    }
    
    class cls_SecondJournlCalldata {
        public List<cls_publishingServices> publishingServices;
    }
    class cls_publishingServices {
        public String id;   //fd428c4f-edc2-4dcc-9f04-376fa52d8ac4
        public String validFrom;    //2019-03-01T14:16:27.308Z
        public String validTo;  //2019-03-01T14:16:27.308Z
        public cls_classification classification;
    }
    
    class cls_journal {
        public string legalOwner='';
    }
    
    class cls_classification {
        public String name; //Product Review
        public String type; //article-type
    }
}