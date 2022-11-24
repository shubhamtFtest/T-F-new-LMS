@isTest
private class zTEST_MiscFunctions {

    static testMethod void Test_WeekdaysDate1MinusDate2() {


        Date date1 = date.newinstance(2009, 12, 15);
        Date date2 = date.newinstance(2009, 12, 10);

        datetime myDateTime = datetime.now();
        Double datedif = 0;
        MiscFunctions misc = new MiscFunctions();

        MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');   
        MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');   
        MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads');
        MiscFunctions.getRecordtypeId('Campaign', 'T&F Campaigns');
        MiscFunctions.getRecordtypeId('Task', 'T&F - Tasks');
        MiscFunctions.getRecordtypeId('Event', 'T&F - Events');
        MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');
        //MiscFunctions.getRecordtypeId('Fusion_Project__c', 'Greenfield Project');

        MiscFunctions.getDatedConversionRate(date1,'AED','AUD');
        MiscFunctions.convertCurrency(100,'AED','AUD');
        MiscFunctions.convertDatedCurrency(date1,100,'AED','AUD');    
        MiscFunctions.DualCurrencyDisplay(date1,100,'AED',true);  
        MiscFunctions.formattedAmount(100); 
        MiscFunctions.checkForNulls('test'); 
        MiscFunctions.convertDecimalToString(100); 

        datedif = misc.WeekdaysDate1MinusDate2(date1, date2);
        datedif = misc.WeekdaysDate1MinusDate2(date2, date1);

        MiscFunctions.convertDateToString_MMM_yy(date1);
        MiscFunctions.convertDateToString_MMM_yyyy(date1);
        MiscFunctions.convertDateToString_d_MMM_yy(date1);
        MiscFunctions.convertDateToString_MMM_d_yyyy(date1);
        misc.MMM_d_yyyy(date1);

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 1, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 1, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 1, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 1, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 1, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 2, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 2, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 2, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 2, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 2, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 3, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 3, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 3, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 3, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 3, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 4, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 4, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 4, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 4, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 4, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 5, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 5, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 5, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 5, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 5, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 6, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 6, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 6, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 6, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 6, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 7, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 7, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 7, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 7, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 7, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 8, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 8, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 8, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 8, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 8, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 9, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 9, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 9, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 9, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 9, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 10, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 10, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 10, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 10, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 10, 10));

        MiscFunctions.convertDateToString_MMM_yy(date.newinstance(2009, 11, 10));
        MiscFunctions.convertDateToString_MMM_yyyy(date.newinstance(2009, 11, 10));
        MiscFunctions.convertDateToString_d_MMM_yy(date.newinstance(2009, 11, 10));
        MiscFunctions.convertDateToString_MMM_d_yyyy(date.newinstance(2009, 11, 10));
        misc.MMM_d_yyyy(date.newinstance(2009, 11, 10));

        MiscFunctions.getNextNumber('testbusiness','Account','Name');
        MiscFunctions.getNextNumber('testbusiness','Account','Name',5);

        Schema.DescribeFieldResult F = Account.Industry.getDescribe();
        Schema.sObjectField T = F.getSObjectField();
        MiscFunctions.getSetFromPicklist(T);
        MiscFunctions.getOptionsFromPicklist(T,true);
        MiscFunctions.getOptionsFromPicklist(T,false);

        MiscFunctions.triggerEnabled('TEst trigger');
        MiscFunctions.triggerEnabledRecordtypes('Test Trigger');
        MiscFunctions.triggerEnabledRecordtypesWithParams('Test Trigger');

        MiscFunctions.allFieldsFromObject('Opportunity');
        MiscFunctions.allFieldsFromObject('Setting__c');
        MiscFunctions.allFieldsFromObject('Setting_Item__c');

        MiscFunctions.getFieldSetFromObject('Opportunity',true,true);
        MiscFunctions.getFieldsFromObject('Opportunity',true,true);

        MiscFunctions.addBusinessDays(date1,4);
        MiscFunctions.addBusinessDays(myDateTime,4);
        MiscFunctions.cleanAddress('teststreet','testcity','teststate','zip123','country',true);
        MiscFunctions.getSandboxName();

        Set<Id> setids = new Set<Id>();
        MiscFunctions.convertIdSetToString(setids);

        date1 = date.newinstance(2009, 12, 10);
        date2 = date.newinstance(2009, 12, 18);
        datedif = misc.WeekdaysDate1MinusDate2(date1, date2);
        datedif = misc.WeekdaysDate1MinusDate2(date2, date1);

        date1 = date.newinstance(2009, 12, 10);
        date2 = date.newinstance(2009, 12, 19);
        datedif = misc.WeekdaysDate1MinusDate2(date1, date2);
        datedif = misc.WeekdaysDate1MinusDate2(date2, date1);

    }
}