/**
   Author : shashank
   Test class : zTestTF_OrderHubIntegrationSchduled
   Description : This class is scheduled to schdule a further schdule "TF_OhOrderTypeSpecSchdlChain" class according to the mapping in setting Obj "OrderHubInt_SalesTypeToProductMapping".    
 */
global class TF_OhIntSchduleChain implements Schedulable 
{
    global void execute(SchedulableContext sc) {
        try 
        {			
            //looping here for other sales type in setting to set channel - fetch setting here & include other code inside it
            List<Setting__c> ListSalesTypProdMapgObj  = [SELECT Id,Name FROM Setting__c WHERE Name = 'OrderHubInt_SalesTypeToProductMapping' limit 1];
            if (ListSalesTypProdMapgObj!=NUll && ListSalesTypProdMapgObj.size() > 0 )
            {
                DateTime now = DateTime.now();	
                //  checking for ALL
                List<Setting_Item__c>  listSetgItemAll = [SELECT Checkbox_1__c, Text_1__c, Text_2__c, Text_3__c,Setting__c FROM Setting_Item__c where Setting__c = :ListSalesTypProdMapgObj.get(0).Id AND Text_1__c='all' AND Checkbox_1__c=True ];
                //  consider all sales types in Text_1__c
                if (listSetgItemAll != NULL && listSetgItemAll.size() > 0 ) {
                    List<Setting_Item__c>  ListSetgItem = [SELECT Checkbox_1__c, Text_1__c, Text_2__c, Text_3__c,Setting__c FROM Setting_Item__c where Setting__c =:ListSalesTypProdMapgObj.get(0).Id AND Text_1__c!='all'];
                            
                    for (Setting_Item__c settgObj : ListSetgItem) {
                        System.debug('settgObj.Text_1__c-'+settgObj.Text_1__c);
                        System.debug('settgObj.Text_2__c-'+settgObj.Text_2__c);
                        if (String.isNotBlank(settgObj.Text_1__c ) && String.isNotBlank(settgObj.Text_2__c)  ) {
                            //  schdule another class
                            now = now.addMinutes(2);
                            TF_OhOrderTypeSpecSchdlChain orderSchObj = new TF_OhOrderTypeSpecSchdlChain(settgObj.Text_1__c,settgObj.Text_2__c);
                            String month = String.valueOf(now.month());
                            String day = String.valueOf(now.day());
                            String minute = String.valueOf(now.minute());
                            String hour = String.valueOf(now.hour());			
                            String year = String.valueOf(now.year());			
                            // Seconds Minutes Hours Day_of_month Month ?Day_of_week    .addMinutes(7)
                            String sch = '00 '+minute+' '+hour+' '+day+ ' '+ month +' ? '+year;
                            System.debug('cron expr - '+sch);
                            String jobID = System.schedule('orderHub'+settgObj.Text_1__c.trim()+'-'+month+'-'+day+'-'+now.year()+'| '+hour +':'+minute, sch, orderSchObj);
                            now = now.addMinutes(50);
                            System.debug('added minutes');

                        }else {
                            TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
                            TF_OhIntclneChainObj.sendEmail( 'Channel or productId not mentioned', true,'No data' );
                        }
                    }
                }else {
                    //  consider only Active sales types
                    List<Setting_Item__c>  listSetgItemDb = [SELECT Checkbox_1__c, Text_1__c, Text_2__c, Text_3__c,Setting__c FROM Setting_Item__c where Setting__c = :ListSalesTypProdMapgObj.get(0).Id AND Text_1__c!='all' AND Checkbox_1__c=true ];
                    if (listSetgItemDb != NULL && listSetgItemDb.size() > 0 ) {

                        for (Setting_Item__c settgObj : listSetgItemDb) {
                            if(settgObj.Checkbox_1__c==true) {
                                System.debug('settgObj.Text_1__c-'+settgObj.Text_1__c);
                                System.debug('settgObj.Text_2__c-'+settgObj.Text_2__c);
                                if (String.isNotBlank(settgObj.Text_1__c ) && String.isNotBlank(settgObj.Text_2__c) ) {
                                    //  schdule another class
                                    now = now.addMinutes(2);
                                    System.debug('now-'+now.minute());
                                    TF_OhOrderTypeSpecSchdlChain orderSchObj = new TF_OhOrderTypeSpecSchdlChain(settgObj.Text_1__c,settgObj.Text_2__c);
                                    String month = String.valueOf(now.month());
                                    String day = String.valueOf(now.day());
                                    String minute = String.valueOf(now.minute());
                                    String hour = String.valueOf(now.hour());		
                                    String year = String.valueOf(now.year());						
                                    // Seconds Minutes Hours Day_of_month Month ?Day_of_week    .addMinutes(7)
                                    String sch = '00 '+minute+' '+hour+' '+day+ ' '+ month +' ? '+year;
                                    System.debug('cron expr - '+sch);
                                    String jobID = System.schedule('orderHub'+settgObj.Text_1__c.trim()+'-'+month+'-'+day+'-'+now.year()+'| '+hour +':'+minute, sch, orderSchObj);
                                    now = now.addMinutes(50);
                                    System.debug('added minutes'+now.minute());

                                }else {
                                    TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
                                    TF_OhIntclneChainObj.sendEmail( 'Channel or productId not mentioned', true,'No data' );
                                }
                            }
                        }
                    }
                }
            }	
        } 
        catch (Exception e ) 
        {
            if(e!= NULL) System.debug(' ******** Exception : ' + e.getMessage());
            TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
            TF_OhIntclneChainObj.sendEmail( String.valueOf(e.getMessage()),true, 'NO DATA' );
        } 
    }
}