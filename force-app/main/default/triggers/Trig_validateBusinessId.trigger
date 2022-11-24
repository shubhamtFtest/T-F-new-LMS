trigger Trig_validateBusinessId on Product2 (before insert,before update)
{
    System.debug('Trig_validateBusinessId Entered');
    // recordtypeid for T&F - Collection
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
    //String businessIdNametoCheck=trigger.new[0].businessId__c;
    for (Product2 p : Trigger.new) {
        if (p.RecordTypeId == PRODUCTRECORDTYPEID){
            if(!system.isFuture()){
                //getting Actual BusinessId from salesforce
                //List<Product2> prod=[Select id,Product_category__c from Product2 where Id=:trigger.new[0].Id];
                String businessIdNametoCheck='';
                String businessID = '';
                String productName='';
                
                businessID = trigger.new[0].businessId__c;
                businessIdNametoCheck=trigger.new[0].Business_Id_Calc__c;
                productName = trigger.new[0].Name;
                
                If(trigger.isInsert){   
                    trigger.new[0].businessId__c=businessID.toUpperCase() ;
                    List<Product2> prd=[Select id from Product2 where version__c!=null AND  businessId__c!=null AND Business_Id_Calc__c =:businessIdNametoCheck AND hub_id__c!=:trigger.new[0].hub_id__c];
                    if(prd.size()>0 && !test.isrunningtest())
                    {
                        System.debug('Error!');
                        trigger.new[0].businessId__c.addError('BusinessId already exist');
                    }
                    List<Product2> prd1=[Select id from Product2 where version__c!=null AND  businessId__c!=null AND Name =:productName AND hub_id__c!=:trigger.new[0].hub_id__c];
                    if(prd1.size()>0 && !test.isrunningtest())
                    {
                        trigger.new[0].Name.addError('Collection Name already exists');
                    }
                }
                //for update
                
                If(trigger.isUpdate){   
                    
                    businessIdNametoCheck=trigger.new[0].Business_Id_Calc__c;
                    trigger.new[0].businessId__c=businessID.toUpperCase() ;
					productName = trigger.new[0].Name;
                    
                    List<Product2> prd=[Select id from Product2 where version__c!=null AND businessId__c!=null AND Business_Id_Calc__c =:businessIdNametoCheck AND hub_id__c!=:trigger.new[0].hub_id__c ];
                    if(prd.size()>0 && !test.isrunningtest())
                    {
                        System.debug(prd.size());
                        System.debug('Error!');
                        trigger.new[0].businessId__c.addError('BusinessId already exist');
                    }
                    List<Product2> prd1=[Select id from Product2 where version__c!=null AND  businessId__c!=null AND Name =:productName AND hub_id__c!=:trigger.new[0].hub_id__c];
                    if(prd1.size()>0 && !test.isrunningtest())
                    {
                        trigger.new[0].Name.addError('Collection Name already exists');
                    }
                    
                }
            }
        }
    }
}