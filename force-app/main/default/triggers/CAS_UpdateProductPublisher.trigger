/**************************************************
* Created by Jeff Douglas
* jeff.douglas@informausa.com / 941-554-3584
**************************************************/

trigger CAS_UpdateProductPublisher on Product2 (before insert, before update) {
	
	// recordtypeid for CAS - Competitor Products
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'CAS - Competitor Products'); //CHG0038379
	
	// only fires for a single insert/update -- no bulk processing
	if (Trigger.new.size() == 1) {	
		
	    for (Product2 p : Trigger.new) {
	    	// only do the update/insert if it is a CAS - Competitor Products recordtype
	    	if (p.RecordTypeId == PRODUCTRECORDTYPEID && p.Competitor_Publisher__c != null) {
	        	p.Publisher__c = p.Competitor_Publisher__c;
	    	}
		}	
	
	}

}