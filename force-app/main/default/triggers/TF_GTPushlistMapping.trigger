/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-02-22
***************************************************************************/
trigger TF_GTPushlistMapping on T_F_GT_Pushlist_Mappings__c (after insert, after update,before insert, before update) {
	
	
	List<T_F_GT_Pushlist_Mappings__c> deletePushMappings = new List<T_F_GT_Pushlist_Mappings__c>();
	Set<String> isbns = new Set<String>();
	Set<String> profileIds = new Set<String>();
	
	
	for (Integer i=0;i<Trigger.new.size();i++) 
	{
		//if (Trigger.new[i].Process__c == 'D' ||
		//	Trigger.new[i].ISBN__c == Null || Trigger.new[i].ISBN__c != Trigger.old[i].ISBN__c || 
		//	Trigger.new[i].Name == Null || Trigger.new[i].Name != Trigger.old[i].Name)
		//{
		//Cant Deletein 
		if (Trigger.new[i].Process__c == 'D')
		{
			//deleteIds.add(Trigger.new[i].Id); 
			deletePushMappings.add(new T_F_GT_Pushlist_Mappings__c(Id = Trigger.new[i].Id));
		}
		else
		{
			String isbn = Trigger.new[i].ISBN__c;
			isbn = isbn.Replace('-','');
			isbn = isbn.Replace(' ','');
			isbns.add(isbn);
			profileIds.add(Trigger.new[i].Name);
		}
		//}
	}
	
	System.debug('###isbns.Size():' + isbns.Size());
	System.debug('###profileIds.Size():' + profileIds.Size());
	
	
	if(trigger.isBefore)
	{
	Map<String,Id> pushlistsMap = new Map<String,Id> ();//([Select SEL_ID_PROFILE__c, Id from T_F_GT_Pushlists__c Where SEL_ID_PROFILE__c IN :profileIds]);
	Map<String,Id> productsMap = new Map<String,Id>();// ([Select ProductCode, Id from Product2 Where Productcode IN :isbns]);
	
	for (T_F_GT_Pushlists__c pushlist : [Select SEL_ID_PROFILE__c, Id from T_F_GT_Pushlists__c Where SEL_ID_PROFILE__c IN :profileIds])
	{pushlistsMap.put(pushlist.SEL_ID_PROFILE__c, pushlist.Id);}
	
	for (Product2 product :[Select ProductCode, Id from Product2 Where ProductCode IN :isbns])
	{
		productsMap.put(product.ProductCode,product.Id);
	}
	
	
	
	System.debug('###pushlistsMap:' + pushlistsMap.Size());
	System.debug('###productsMap:' + productsMap.Size());
	System.debug('###productsMap.get(9780415249379):' + productsMap.get('9780415249379'));
	//List<T_F_GT_Pushlist_Mappings__c> updatePushMappings = new List<T_F_GT_Pushlist_Mappings__c>();
	
	for (Integer i=0;i<Trigger.new.size();i++) 
	{
		if (Trigger.new[i].Process__c != 'D')
		{
			//updatePushMappings.add(new T_F_GT_Pushlist_Mappings__c ( Id=Trigger.new[i].Id,Product__c=productsMap.get(Trigger.new[i].ISBN__c), T_F_GT_Pushlists__c = pushlistsMap.get(Trigger.new[i].Name)));
		String isbn = Trigger.new[i].ISBN__c;
			isbn = isbn.Replace('-','');
			isbn = isbn.Replace(' ','');
			isbns.add(isbn);	
		Trigger.new[i].Product__c = productsMap.get(isbn);
		Trigger.new[i].T_F_GT_Pushlists__c = pushlistsMap.get(Trigger.new[i].Name);
		
		System.debug('###productsMap.get(' + Trigger.new[i].ISBN__c + '):' + productsMap.get(Trigger.new[i].ISBN__c));
		System.debug('###pushlistsMap.get(' +Trigger.new[i].Name + '):' + pushlistsMap.get(Trigger.new[i].Name));
		}
		
	}
	
	//if(updatePushMappings.Size() > 0)
	//{
	//	update updatePushMappings;
	//}  
	}
	
	if (Trigger.isAfter && deletePushMappings.Size()>0){delete deletePushMappings;}
	

}