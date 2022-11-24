/**
* @description Helper class to clone parent, its children and grandchildren
*/
public class TF_QuoteCloneController {
       
    /**
    * @description Clone parent, its children and grandchildren
    * @param id of the parent sObject
    * @return String Serialized result
    */
    
    public static void clone(List<Id> sObjectId, Boolean isFromTrigger) {
        List<String> returnString = new List<String>();
        List<SBQQ__Quote__c> parentSObjects;
        SBQQ__Quote__c parent;
        List<SBQQ__QuoteLine__c> children = new List<SBQQ__QuoteLine__c>();
        List<Society_Quote__c> grandchildren = new List<Society_Quote__c>();
        CloneModel cloneModelResult = new CloneModel();
        
        // Parent query
        String query1 = String.format(
            'SELECT {0} FROM {1} WHERE Id = \'\'{2}\'\'',
            new String[] {
                String.join(
                    new List<String>(
                        SBQQ__Quote__c.SObjectType.getDescribe().fields.getMap().keySet()
                    ),
                    ','
                ),
                String.valueOf(SBQQ__Quote__c.SObjectType),
                sObjectId[0]
           }
        );
        
        // Children query  for QuoteLine
        String query2 = String.format(
            'SELECT {0} FROM {1} WHERE SBQQ__Quote__c = \'\'{2}\'\'',
            new String[] {
                String.join(
                    new List<String>(
                        SBQQ__QuoteLine__c.SObjectType.getDescribe().fields.getMap().keySet()
                    ),
                    ','
                ),
                String.valueOf(SBQQ__QuoteLine__c.SObjectType),
                sObjectId[0]
           }
        );
        
        // Fetch quote line of old quote 
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        quoteLineList = Database.query(query2);
        
        // Children query  for Quote Approval
        String query4 = String.format(
            'SELECT {0} FROM {1} WHERE Quote__c = \'\'{2}\'\'',
            new String[] {
                String.join(
                    new List<String>(
                        Quote_Approval__c.SObjectType.getDescribe().fields.getMap().keySet()
                    ),
                    ','
                ),
                String.valueOf(Quote_Approval__c.SObjectType),
                sObjectId[0]
           }
        );
        
        // Fetch Quote Approval of old quote 
        List<Quote_Approval__c> quoteApprovalList = new List<Quote_Approval__c>();
        quoteApprovalList = Database.query(query4);
        
        String prepayFlag = 'None';
        String societyFlag = 'None';
        string mpdlflag ='None';
        
        for(Quote_Approval__c quoteApprovalObj : quoteApprovalList){
            if(quoteApprovalObj.Approval_Type__c == 'Prepay'){
                prepayFlag = quoteApprovalObj.Quote_Approval_Status__c;
            }
            
            if(quoteApprovalObj.Approval_Type__c == 'Society'){
                societyFlag = quoteApprovalObj.Quote_Approval_Status__c;
            }
            
             if(quoteApprovalObj.Approval_Type__c == 'Third Party'){
             mpdlflag= quoteApprovalObj.Quote_Approval_Status__c;  
            }
        }
        
        String query3;
        if(quoteLineList.size() > 0){
            //Grand children query
            query3 = String.format(
            'SELECT {0} FROM {1} WHERE Quote_Line__c = \'\'{2}\'\'',
            new String[] {
                String.join(
                    new List<String>(
                        Society_Quote__c.SObjectType.getDescribe().fields.getMap().keySet()
                    ),
                    ','
                ),
                String.valueOf(Society_Quote__c.SObjectType),
                quoteLineList[0].Id
            }
            );
        }
        
        try {
            
            // Query and gets results
            parentSObjects = Database.query(query1);         
            
            // Clone the original object. Here you can change anything without affecting the original sObject
            parent = parentSObjects[0].clone(false, true, false, false);
            if (isFromTrigger ||parent.Use_Prepay_Budget__c) {
                parent.Payer_Account__c = null;
                parent.Payer_Contact__c = parent.SBQQ__PrimaryContact__c;
            }

            //parent.Name = parent.Name + ' CLONED';
           parent.CSD_Approval_Status__c = '';
            parent.Author_Status__c = '';
            parent.SBQQ__Status__c = 'Draft';
            parent.Society_Manual_Check__c = false;
            parent.Quote_Cloned__c = true;
            parent.SBQQ__Primary__c = true;
            parent.No_Prepay_Process__c = false;
            parent.No_Society_Process__c  = false;
            parent.No_MPDL_Process__c  = false;
            parent.Payer_Contact_Name__c = null;
            parent.Payer_Email__c = null;
            parent.Payer_Organization_Name__c = null;
            parent.Payer_Campus__c = null;
            parent.Payer_Department__c = null;
            parent.VAT_Number__c = null;
            parent.Purchase_Order_Number__c = null;
            parent.Payer__c = 'Self';
            parent.SBQQ__ShippingName__c = null;
            parent.Ship_to_Organization__c = null;
            parent.SBQQ__ShippingStreet__c = null;
            parent.SBQQ__ShippingName__c = null;
            parent.SBQQ__ShippingStreet__c = null;
            parent.Ship_To_Street_2__c = null;
            parent.SBQQ__ShippingCity__c = null;
            parent.SBQQ__ShippingState__c= null;
            parent.SBQQ__ShippingPostalCode__c = null;
            parent.SBQQ__ShippingCountry__c = null;
            parent.SBQQ__BillingCity__c =null;
            parent.SBQQ__BillingState__c = null;
            parent.Bill_To_Street_2__c = null;
            parent.SBQQ__BillingStreet__c = null;
            parent.SBQQ__BillingPostalCode__c = null;
            parent.SBQQ__BillingCountry__c = null;
            
            
            
    
            if(prepayFlag == 'Rejected'){
                parent.Use_Prepay_Budget__c = false;
                parent.Previous_Quote_Rejection_Reason__c ='Prepay Rejected';
            }
            if(societyFlag == 'Rejected'){
                parent.Previous_Quote_Rejection_Reason__c ='Society Rejected';
            }
            if(mpdlflag =='Rejected'){
             parent.Previous_Quote_Rejection_Reason__c ='CSD Rejected';
            
           }
            
        /*    if(mpdlflag == 'Rejected'){
                parent.Previous_Quote_Rejection_Reason__c ='Manual Rejected';
            } */
          
            
            Database.insert(parent);
            
            //Make the original parent read only
            Id TFReadOnlyQuoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - Read Only Quote').getRecordTypeId();
            parentSObjects[0].RecordTypeId = TFReadOnlyQuoteRecordTypeId;
            parentSObjects[0].Approved_Rejected_Date__c = system.today();
            Database.update(parentSObjects);  
       
            // Query and clone the children. Here you can change anything without affecting the original sObject
            for (SBQQ__QuoteLine__c child:(List<SBQQ__QuoteLine__c>)Database.query(query2)) {
                children.add(child.clone(false,true,false,false));
            }
            
            // If there isn't any children ends the process and return success
            if (children.isEmpty()) {
                cloneModelResult.isSuccess = true;
                cloneModelResult.message = 'Object is successfully cloned!';                
                cloneModelResult.url = getUrlRedirect(parent.Id);
                returnString.add(JSON.serialize(cloneModelResult)); 
                System.debug('returnString******'+returnString);
                //return returnString;  
            }
            
            // Set the parent's Id
            for (SBQQ__QuoteLine__c child : children) {
                child.SBQQ__Quote__c = parent.Id;
                child.Hold_Amount__c = Null;
                child.Hold_Percent__c = Null;
                child.Best_Discount_Rule__c = Null;
                child.Discount_Display_Name__c = Null;
                child.Recent_Discount_Display_Name__c = Null;
                
                if(prepayFlag == 'Rejected'){
                    child.No_Prepay__c = true;
                } 
            }
        
            Database.insert(children);  
            
            if(prepayFlag == 'Rejected'){
                //Delete Prepay Account Transactions from cloned Quote
                delete [SELECT Id,Name FROM Prepay_Account_Transactions__c WHERE Quote_ID__c = :parent.Id];
            }
            
            //Clone the grandchildren
            if(quoteLineList.size() > 0){
                for (Society_Quote__c grandchild:(List<Society_Quote__c>)Database.query(query3)) {
                     grandchildren.add(grandchild.clone(false,true,false,false));
                }
            }
            
            // If there isn't any grandchildren ends the process and return success
            if (grandchildren.isEmpty()) {
                cloneModelResult.isSuccess = true;
                cloneModelResult.message = 'Object & its children are successfully cloned!';                
                cloneModelResult.url = getUrlRedirect(parent.Id);
                returnString.add(JSON.serialize(cloneModelResult)); 
                System.debug('returnString******'+returnString);
                //return returnString;   
            }
            
            // Set the parent's Id
            for (Society_Quote__c grandchild : grandchildren) {
                grandchild.Quote_Line__c = children[0].Id;
            }
        
            Database.insert(grandchildren);  
            
            //Delete discount applied society quote record
            if(societyFlag == 'Rejected'){
                delete [SELECT Id,Name FROM Society_Quote__c WHERE Quote_Line__c = :children[0].Id AND Society__c = :children[0].Best_Discount_Society_Id__c]; 
            }
            
            
           
             
        }  catch(DMLException error) {
            cloneModelResult.message = 'An error occurred while cloning the object.' + error.getMessage();
            returnString.add(JSON.serialize(cloneModelResult)); 
            //return returnString;   
        }
         
        // Return success at the end of the process
        cloneModelResult.isSuccess = true;
        cloneModelResult.message = 'Object and its children are successfully cloned!';
        cloneModelResult.url = getUrlRedirect(parent.Id);
        
        returnString.add(JSON.serialize(cloneModelResult)); 
        //return returnString;  
        
    }

    private static String getUrlRedirect(String sObjectId){
        PageReference page = new PageReference('/'+ sObjectId);
        return page.getUrl();
    }
    
    public class CloneModel {
        Boolean isSuccess;
        String message;
        String url;
    }
}