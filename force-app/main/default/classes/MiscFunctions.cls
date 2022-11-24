public class MiscFunctions {

    public static Set<Id> getRecordtypeIds(String objName, String rtNames) {
        Set<Id> rtIds = new Set<Id>();
        List<String> listNames = rtNames.split(',', 0);
        for (Integer i = 0; i < listNames.size() ; i++) {
            rtIds.add(getRecordtypeId(objName, listNames[i]));
        }
        return rtIds;
    }

    public static Id getRecordtypeId(String objName, String rtName) {
        if (PublicVariables.mapRecordtype.containsKey(objName+'.'+rtName)) {
            return PublicVariables.mapRecordtype.get(objName+'.'+rtName);
        } else {
            Id returnVal;
            if (objName == 'Account')
                returnVal = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Contact')
                returnVal = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Lead')
                returnVal = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Opportunity')
                returnVal = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Campaign')
                returnVal = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Event')
                returnVal = Schema.SObjectType.Event.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Task')
                returnVal = Schema.SObjectType.Task.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Fusion_Project__c')
                returnVal = Schema.SObjectType.Fusion_Project__c.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Billing__c')
                returnVal = Schema.SObjectType.Billing__c.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'Product2')
                returnVal = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else if (objName == 'CampaignMember')
                returnVal = [select Id from RecordType where Name = :rtName].Id; // KC Tquila: Following does not work (don't know why) hence SOQL : Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            else { //this will work for every object - Jeff Lup - 2013.07.11
                SObjectType objToken = Schema.getGlobalDescribe().get(objName);
                DescribeSObjectResult objDef = objToken.getDescribe();
                returnVal = objDef.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            }

            if (returnVal != null) {
                PublicVariables.mapRecordtype.put(objName+'.'+rtName, returnVal);
                return returnVal;
            } else
                return null;
        }
    }

    public static Double getDatedConversionRate(Date conversionDate, String oldCurrencyIsoCode, String newCurrencyIsoCode) {
        //CHG0045045
        if (oldCurrencyIsoCode == newCurrencyIsoCode) {
            return 1;
        } else {
            try {
                List<DatedConversionRate> dcrs = [SELECT IsoCode, ConversionRate
                                                  FROM DatedConversionRate
                                                  WHERE (IsoCode = :oldCurrencyIsoCode OR IsoCode = :newCurrencyIsoCode)
                                                    AND StartDate <= :conversionDate
                                                    AND NextStartDate >= :conversionDate];
                
                if (dcrs[0].IsoCode == oldCurrencyIsoCode && dcrs[1].IsoCode == newCurrencyIsoCode) {
                    return ((double)dcrs[1].ConversionRate) / ((double)dcrs[0].ConversionRate);

                } else if (dcrs[1].IsoCode == oldCurrencyIsoCode && dcrs[0].IsoCode == newCurrencyIsoCode) {
                    return ((double)dcrs[0].ConversionRate) / ((double)dcrs[1].ConversionRate);

                } else {
                    return 0; //There were issues with the supplied parameters
                }
                                
            } catch (Exception e) {
                return 0;
            }       
        }
    }
    
    public static Decimal convertCurrency(Decimal amount, String oldCurrencyIsoCode, String newCurrencyIsoCode) {
        if (oldCurrencyIsoCode == newCurrencyIsoCode) {
            return amount;
        } else {
            //CHG0045045
            try {
                List<DatedConversionRate> dcrs = [SELECT IsoCode, ConversionRate
                                                  FROM DatedConversionRate
                                                  WHERE (IsoCode = :oldCurrencyIsoCode OR IsoCode = :newCurrencyIsoCode)
                                                    AND NextStartDate = 9999-12-31];
                
                if (dcrs[0].IsoCode == oldCurrencyIsoCode && dcrs[1].IsoCode == newCurrencyIsoCode) {
                    return amount * (((double)dcrs[1].ConversionRate) / ((double)dcrs[0].ConversionRate));

                } else if (dcrs[1].IsoCode == oldCurrencyIsoCode && dcrs[0].IsoCode == newCurrencyIsoCode) {
                    return amount * (((double)dcrs[0].ConversionRate) / ((double)dcrs[1].ConversionRate));

                } else {
                    return 0; //There were issues with the supplied parameters
                }
                                
            } catch (Exception e) {
                return 0;
            }       
        }
    }

    public static Decimal convertDatedCurrency(Date conversionDate, Decimal amount, String oldCurrencyIsoCode, String newCurrencyIsoCode) {
        if (oldCurrencyIsoCode == newCurrencyIsoCode) {
            return amount;
        } else {
            try {
                //CHG0045045
                List<DatedConversionRate> dcrs = [SELECT IsoCode, ConversionRate
                                                  FROM DatedConversionRate
                                                  WHERE (IsoCode = :oldCurrencyIsoCode OR IsoCode = :newCurrencyIsoCode)
                                                    AND StartDate <= :conversionDate
                                                    AND NextStartDate >= :conversionDate];
                
                if (dcrs[0].IsoCode == oldCurrencyIsoCode && dcrs[1].IsoCode == newCurrencyIsoCode) {
                    return amount * (((double)dcrs[1].ConversionRate) / ((double)dcrs[0].ConversionRate));

                } else if (dcrs[1].IsoCode == oldCurrencyIsoCode && dcrs[0].IsoCode == newCurrencyIsoCode) {
                    return amount * (((double)dcrs[0].ConversionRate) / ((double)dcrs[1].ConversionRate));

                } else {
                    return 0; //There were issues with the supplied parameters
                }
                                
            } catch (Exception e) {
                return 0;
            }       
        }
    }

    public static String DualCurrencyDisplay (Date conversionDate, Decimal amount, String recordCurrencyIsoCode, Boolean twoLines) {
        if (recordCurrencyIsoCode == Userinfo.getDefaultCurrency()) {
            return recordCurrencyIsoCode + ' ' + formattedAmount(amount);
        } else {
            if (twoLines)
                return recordCurrencyIsoCode + ' ' + formattedAmount(amount) + '<br>(' + Userinfo.getDefaultCurrency() + ' ' + formattedAmount(convertDatedCurrency(conversionDate, amount, recordCurrencyIsoCode, Userinfo.getDefaultCurrency())) + ')';
            else
                return recordCurrencyIsoCode + ' ' + formattedAmount(amount) + ' (' + Userinfo.getDefaultCurrency() + ' ' + formattedAmount(convertDatedCurrency(conversionDate, amount, recordCurrencyIsoCode, Userinfo.getDefaultCurrency())) + ')';
        }
    }
    
    public static String formattedAmount(decimal amountDouble) {
        if (amountDouble == null)
            amountDouble = 0;
        amountDouble = (Double)((amountDouble * 100).round()) / 100;
        String amountString = amountDouble.format();
        Integer dotIndex = amountString.indexOf('.');
        if (dotIndex < 0)
            amountString += '.00';
        else if (amountString.length() - dotIndex == 2) 
            amountString += '0';
        return amountString;                
    }
    
    public static String checkForNulls(String oldValue) {
        if (oldValue == null)
            return '';
        else
            return oldValue;
    }
    
    public static String convertDecimalToString(Decimal num) {
        if (num == null)
            return '0';
        else
            return num.format();
    }
    
    public static String convertDateToString_MMM_d_yyyy(Date d) {
        if (d == null) {
            return '';
        } else {
            String sMonth;
            if (d.month() == 1)
                sMonth = 'January';        // see CHG0075877
            else if (d.month() == 2)
                sMonth = 'February';        // see CHG0075877.....
            else if (d.month() == 3)
                sMonth = 'March';
            else if (d.month() == 4)
                sMonth = 'April';
            else if (d.month() == 5)
                sMonth = 'May';
            else if (d.month() == 6)
                sMonth = 'June';
            else if (d.month() == 7)
                sMonth = 'July';
            else if (d.month() == 8)
                sMonth = 'August';
            else if (d.month() == 9)
                sMonth = 'September';
            else if (d.month() == 10)
                sMonth = 'October';
            else if (d.month() == 11)
                sMonth = 'November';
            else if (d.month() == 12)
                sMonth = 'December';
            
            return sMonth + ' ' + d.day().format() + ', ' + d.year().format().replace(',','');
        }
    }

    public static String convertDateToString_d_MMM_yy(Date d) {
        if (d == null) {
            return '';
        } else {
            String sMonth;
            if (d.month() == 1)
                sMonth = 'Jan';
            else if (d.month() == 2)
                sMonth = 'Feb';
            else if (d.month() == 3)
                sMonth = 'Mar';
            else if (d.month() == 4)
                sMonth = 'Apr';
            else if (d.month() == 5)
                sMonth = 'May';
            else if (d.month() == 6)
                sMonth = 'Jun';
            else if (d.month() == 7)
                sMonth = 'Jul';
            else if (d.month() == 8)
                sMonth = 'Aug';
            else if (d.month() == 9)
                sMonth = 'Sep';
            else if (d.month() == 10)
                sMonth = 'Oct';
            else if (d.month() == 11)
                sMonth = 'Nov';
            else if (d.month() == 12)
                sMonth = 'Dec';
            
            return d.day().format() + '-' + sMonth + '-' + d.year().format().right(2);
        }
    }

    public static String convertDateToString_MMM_yyyy(Date d) {
        if (d == null) {
            return '';
        } else {
            String sMonth;
            if (d.month() == 1)
                sMonth = 'Jan';
            else if (d.month() == 2)
                sMonth = 'Feb';
            else if (d.month() == 3)
                sMonth = 'Mar';
            else if (d.month() == 4)
                sMonth = 'Apr';
            else if (d.month() == 5)
                sMonth = 'May';
            else if (d.month() == 6)
                sMonth = 'Jun';
            else if (d.month() == 7)
                sMonth = 'Jul';
            else if (d.month() == 8)
                sMonth = 'Aug';
            else if (d.month() == 9)
                sMonth = 'Sep';
            else if (d.month() == 10)
                sMonth = 'Oct';
            else if (d.month() == 11)
                sMonth = 'Nov';
            else if (d.month() == 12)
                sMonth = 'Dec';
            
            return sMonth + ' ' + d.year().format().replace(',','');
        }
    }
    
    public static String convertDateToString_MMM_yy(Date d) {
        if (d == null) {
            return '';
        } else {
            String sMonth;
            if (d.month() == 1)
                sMonth = 'Jan';
            else if (d.month() == 2)
                sMonth = 'Feb';
            else if (d.month() == 3)
                sMonth = 'Mar';
            else if (d.month() == 4)
                sMonth = 'Apr';
            else if (d.month() == 5)
                sMonth = 'May';
            else if (d.month() == 6)
                sMonth = 'Jun';
            else if (d.month() == 7)
                sMonth = 'Jul';
            else if (d.month() == 8)
                sMonth = 'Aug';
            else if (d.month() == 9)
                sMonth = 'Sep';
            else if (d.month() == 10)
                sMonth = 'Oct';
            else if (d.month() == 11)
                sMonth = 'Nov';
            else if (d.month() == 12)
                sMonth = 'Dec';
            
            return sMonth + ' ' + d.year().format().replace(',','').right(2);
        }
    }
    

    public static Decimal NEXT_NUMBER; //because salesforce sometimes runs triggers twice
    public static Decimal getNextNumber(String business, String objectName, String fieldName) {
        return getNextNumber(business, objectName, fieldName, 1);
    }   
    public static Decimal getNextNumber(String business, String objectName, String fieldName, Decimal batchSize) {
        if (NEXT_NUMBER == null || NEXT_NUMBER == 0) {
            String object_field = objectName + '.' + fieldName;
            List<NextNum__c> nns = [SELECT Business__c, Object_Field__c, NextNum__c
                                    FROM NextNum__c
                                    WHERE Business__c = :business
                                        AND Object_Field__c = :object_field];
                    
            Decimal nextNum;
            if (nns.size() > 0) {
                nextNum = nns[0].NextNum__c;
                nns[0].NextNum__c = nextNum + batchSize;
                update nns;
            } else {
                nextNum = 1;
                NextNum__c nnToInsert = new NextNum__c();
                nnToInsert.Business__c = business;
                nnToInsert.Object_Field__c = object_field;
                nnToInsert.NextNum__c = nextNum + batchSize;
                insert nnToInsert;
            }
            NEXT_NUMBER = nextNum;
            return nextNum;
        } else {
            return NEXT_NUMBER; //this is the second call, so just return the value provided last time
        }
    }

    public static List<String> getListFromPicklist(Schema.sObjectField objectField) {
        List<Schema.PicklistEntry> ple;
        Schema.DescribeFieldResult fieldResult;   
        
        fieldResult = objectField.getDescribe();
        ple = fieldResult.getPicklistValues();
        
        List<String> returnVal = new List<String>();
        for(Schema.PicklistEntry f : ple)
            returnVal.add(f.getLabel());
        
        return returnVal;    
    }

    public static Set<String> getSetFromPicklist(Schema.sObjectField objectField) {
        List<Schema.PicklistEntry> ple;
        Schema.DescribeFieldResult fieldResult;   
        
        fieldResult = objectField.getDescribe();
        ple = fieldResult.getPicklistValues();
        
        Set<String> returnVal = new Set<String>();
        for(Schema.PicklistEntry f : ple)
            returnVal.add(f.getLabel());
        
        return returnVal;    
    }
    
    public static List<SelectOption> getOptionsFromPicklist(Schema.sObjectField objectField, boolean includeNone) {
        List<Schema.PicklistEntry> ple;
        List<SelectOption> options;
        Schema.DescribeFieldResult fieldResult;   
        
        options = new List<SelectOption>();        
        fieldResult = objectField.getDescribe();
        ple = fieldResult.getPicklistValues();
        
        if (includeNone)
            options.add(new SelectOption('--None--', '--None--'));
        
        for(Schema.PicklistEntry f : ple)         
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        
        return options;    
    }
    
    public static Set<String> setTriggersEnabled = new Set<String>();
    public static Boolean triggerEnabled(String triggerName) {
        if (Test.isRunningTest()) {
            return zTEST_Shared.runTriggers.contains(triggerName);
        } else {
            
            if (setTriggersEnabled.size() == 0) {
                List<Trigger__c> trigs = [SELECT Name FROM Trigger__c WHERE Enabled__c = true];
                for (Trigger__c t : trigs) {
                    setTriggersEnabled.add(t.Name);
                }
            }
            
            if (setTriggersEnabled.contains(triggerName))
                return true;
            else
                return false;
        }
        
        /*  Sample code to call this method from a trigger
            
            if (MiscFunctions.triggerEnabled('triggerName')) {
                //then do this
            }
    
        */
    }
    
    public static Map<String,Set<Id>> mapTriggerRecordtypesEnabled = new Map<String,Set<Id>>();
    public static Set<Id> triggerEnabledRecordtypes(String triggerName) {
        //This method does NOT require you to also call triggerEnabled
        if (Test.isRunningTest()) {
            Set<Id> rtIds = zTEST_Shared.runTriggersForRecordtypes.get(triggerName);
            if (rtIds == null)
                return new Set<Id>();
            else
                return rtIds;
        } else {
            if (mapTriggerRecordtypesEnabled.size() == 0) {
                List<Trigger_Recordtype__c> rts = [SELECT Trigger__r.Name, Recordtype_Id__c,
                                                        Excluded_Profiles__c, Excluded_Users__c //CHG0049560
                                                   FROM Trigger_Recordtype__c
                                                   WHERE Trigger__r.Enabled__c = true
                                                        AND Enabled__c = true];
                String profileId = String.valueOf(UserInfo.getProfileId()).left(15);
                String userId = String.valueOf(UserInfo.getUserId()).left(15);
                for (Trigger_Recordtype__c rt : rts) {
                    if ((rt.Excluded_Profiles__c == null || !rt.Excluded_Profiles__c.contains(profileId)) && (rt.Excluded_Users__c == null || !rt.Excluded_Users__c.contains(userId))) { //CHG0049560
                        set<Id> rtIds;
                        if (mapTriggerRecordtypesEnabled.containsKey(rt.Trigger__r.Name))
                            rtIds = mapTriggerRecordtypesEnabled.get(rt.Trigger__r.Name);
                        else
                            rtIds = new set<Id>();
                        rtIds.add(rt.Recordtype_Id__c);                 
                        mapTriggerRecordtypesEnabled.put(rt.Trigger__r.Name, rtIds);
                    }
                }
            }
            if (mapTriggerRecordtypesEnabled.containsKey(triggerName))
                return mapTriggerRecordtypesEnabled.get(triggerName);
            else
                return new Set<Id>();
        }       
        
        /*  Sample code to call this method from a trigger
        
            Set<Id> rtsToRun = MiscFunctions.triggerEnabledRecordtypes('triggerName');
            for (Integer i = 0; i < trigger.size(); i++) {
                if (rtsToRun.contains(trigger.new[i].recordtypeid)) {
                    //then do this
                }
            }
    
        */
    }

    public static Map<String,Map<Id,Map<String,String>>> mapTriggerRecordtypesEnabledWithParams = new Map<String,Map<Id,Map<String,String>>>();
    public static Map<Id,Map<String,String>> triggerEnabledRecordtypesWithParams(String triggerName) {
        //This method does NOT require you to also call triggerEnabled
        if (Test.isRunningTest()) {
            Map<Id,Map<String,String>> mapRtIdsAndParams = zTEST_Shared.runTriggersForRecordtypesWithParams.get(triggerName);
            if (mapRtIdsAndParams == null)
                return new Map<Id,Map<String,String>>();
            else
                return mapRtIdsAndParams;
        } else {
            if (mapTriggerRecordtypesEnabledWithParams.size() == 0) {
                List<Trigger_Recordtype__c> rts = [SELECT Trigger__r.Name, Recordtype_Id__c,
                                                        Excluded_Profiles__c, Excluded_Users__c,
                                                        Parameters__c
                                                   FROM Trigger_Recordtype__c
                                                   WHERE Trigger__r.Enabled__c = true
                                                        AND Enabled__c = true];
                String profileId = String.valueOf(UserInfo.getProfileId()).left(15);
                String userId = String.valueOf(UserInfo.getUserId()).left(15);
                for (Trigger_Recordtype__c rt : rts) {
                    if ((rt.Excluded_Profiles__c == null || !rt.Excluded_Profiles__c.contains(profileId)) && (rt.Excluded_Users__c == null || !rt.Excluded_Users__c.contains(userId))) { //CHG0049560
                        Map<Id,Map<String,String>> mapRtIdsAndParams = new Map<Id,Map<String,String>>();
                        if (mapTriggerRecordtypesEnabledWithParams.containsKey(rt.Trigger__r.Name))
                            mapRtIdsAndParams = mapTriggerRecordtypesEnabledWithParams.get(rt.Trigger__r.Name);
                        else
                            mapRtIdsAndParams = new Map<Id,Map<String,String>>();
                        Map<String,String> mapParams = new Map<String,String>();
                        if (rt.Parameters__c != null) {
                          List<String> split1 = rt.Parameters__c.split(';');
                          for (String param : split1) {
                            if (param.contains('=')) {
                              List<String> split2 = param.split('=');
                              mapParams.put(split2[0], split2[1]);
                            } else {
                              mapParams.put('Parameters', param);
                            }
                          }
                        }
                        mapRtIdsAndParams.put(rt.Recordtype_Id__c, mapParams);              
                        mapTriggerRecordtypesEnabledWithParams.put(rt.Trigger__r.Name, mapRtIdsAndParams);
                    }
                }
            }
            if (mapTriggerRecordtypesEnabledWithParams.containsKey(triggerName))
                return mapTriggerRecordtypesEnabledWithParams.get(triggerName);
            else
                return new Map<Id,Map<String,String>>();
        }       
        
        /*  Sample code to call this method from a trigger
        
            Map<Id,String> mapRtsToRun = MiscFunctions.triggerEnabledRecordtypesWithParams('triggerName');
            for (Integer i = 0; i < trigger.size(); i++) {
                if (mapRtsToRun.containsKey(trigger.new[i].recordtypeid)) {
                    if (mapRtsToRun.get(trigger.new[i].recordtypeid) == 'this value') {
                      //then do it this way
          } else if (mapRtsToRun.get(trigger.new[i].recordtypeid) == 'that value') {
            //then do it that way
          }                     
                }
            }
    
        */
    }

/*
    public static Map<String,Map<Id,String>> mapTriggerRecordtypesEnabledWithParams = new Map<String,Map<Id,String>>();
    public static Map<Id,String> triggerEnabledRecordtypesWithParams(String triggerName) {
        //This method does NOT require you to also call triggerEnabled
        if (Test.isRunningTest()) {
            Map<Id,String> mapRtIdsAndParams = zTEST_Shared.runTriggersForRecordtypesWithParams.get(triggerName);
            if (mapRtIdsAndParams == null)
                return new Map<Id,String>();
            else
                return mapRtIdsAndParams;
        } else {
            if (mapTriggerRecordtypesEnabledWithParams.size() == 0) {
                List<Trigger_Recordtype__c> rts = [SELECT Trigger__r.Name, Recordtype_Id__c,
                                                        Excluded_Profiles__c, Excluded_Users__c,
                                                        Parameters__c
                                                   FROM Trigger_Recordtype__c
                                                   WHERE Trigger__r.Enabled__c = true
                                                        AND Enabled__c = true];
                String profileId = String.valueOf(UserInfo.getProfileId()).left(15);
                String userId = String.valueOf(UserInfo.getUserId()).left(15);
                for (Trigger_Recordtype__c rt : rts) {
                    if ((rt.Excluded_Profiles__c == null || !rt.Excluded_Profiles__c.contains(profileId)) && (rt.Excluded_Users__c == null || !rt.Excluded_Users__c.contains(userId))) { //CHG0049560
                        Map<Id,String> mapRtIdsAndParams = new Map<Id,String>();
                        if (mapTriggerRecordtypesEnabledWithParams.containsKey(rt.Trigger__r.Name))
                            mapRtIdsAndParams = mapTriggerRecordtypesEnabledWithParams.get(rt.Trigger__r.Name);
                        else
                            mapRtIdsAndParams = new Map<Id,String>();
                        mapRtIdsAndParams.put(rt.Recordtype_Id__c, rt.Parameters__c);                 
                        mapTriggerRecordtypesEnabledWithParams.put(rt.Trigger__r.Name, mapRtIdsAndParams);
                    }
                }
            }
            if (mapTriggerRecordtypesEnabledWithParams.containsKey(triggerName))
                return mapTriggerRecordtypesEnabledWithParams.get(triggerName);
            else
                return new Map<Id,String>();
        }       
    }
*/
    
    public static Date addBusinessDays(Date startDate, Integer businessDays) {
        Date endDate = startDate.addDays(businessDays);
        Integer daysOff = nonBusinessDaysBetween(startDate, endDate);
        return endDate.addDays(daysOff);
    }

    public static Datetime addBusinessDays(Datetime startDatetime, Integer businessDays) {
        Datetime endDatetime = startDatetime.addDays(businessDays);
        Integer daysOff = nonBusinessDaysBetween(startDatetime.Date(), endDatetime.Date());
        return endDatetime.addDays(daysOff);
    }
    
    public static Integer nonBusinessDaysBetween(Date startDate, Date endDate) {
        return startDate.daysBetween(endDate) - businessDaysBetween(startDate, endDate);
    }

    public static Integer businessDaysBetween(Date startDate, Date endDate) {
        Date referencePoint = date.newinstance(1900, 1, 7);
        Double fullWeekDays = 0;
        Double partialWeekDays = 0;
                    
        Date gDate;
        Date sDate;
        if (endDate > startDate) {
            gDate = endDate;
            sDate = startDate;          
        }
        else {
            gDate = startDate;
            sDate = endDate;          
        }

        fullWeekDays = math.floor(sDate.daysBetween(gDate)/7) * 5;
        
        if (math.mod(referencePoint.daysBetween(sDate), 7) == math.mod(referencePoint.daysBetween(gDate), 7))
            partialWeekDays = 0;
        else {
            if (math.mod(referencePoint.daysBetween(sDate), 7) > math.mod(referencePoint.daysBetween(gDate), 7)) {
                if (math.mod(referencePoint.daysBetween(sDate), 7) == 6)
                    partialWeekDays = math.mod(referencePoint.daysBetween(gDate), 7);
                else
                    partialWeekDays = 5 - math.mod(referencePoint.daysBetween(sDate), 7) + math.mod(referencePoint.daysBetween(gDate), 7);
            }
            else {
                if (math.mod(referencePoint.daysBetween(gDate), 7) == 6)
                    partialWeekDays = 5 - math.mod(referencePoint.daysBetween(sDate), 7);
                else
                    partialWeekDays = math.mod(referencePoint.daysBetween(gDate), 7) - math.mod(referencePoint.daysBetween(sDate), 7);
            }
        } 

        if (endDate > startDate) {
            return integer.valueOf(fullWeekDays + partialWeekDays);
        }
        else {
            return integer.valueOf(0 - (fullWeekDays + partialWeekDays));
        }
    }

    public static String cleanAddress(String street, String city, String state, String postalCode, String country, Boolean oneLine) {
        String address = '';
        if (street != null)
            address += street;
        if (city != null) {
            if (address != '') address += (oneLine ? ', ' : '<br/>');           
            address += city;
        }
        if (state != null) {
            if (address != '') address += ', ';         
            address += state;
        }
        if (postalCode != null) {
            if (address != '') address += ' ';          
            address += postalCode;
        }
        if (country != null) {
            if (address != '' && postalCode != null) address += ' ';            
            if (address != '' && postalCode == null) address += ', ';           
            address += country;
        }
        return address;
    }
    
    public static String allFieldsFromObject(String objName) {
        Map<String, Schema.SObjectField> fldObjMap;
        if (objName == 'Opportunity')
            fldObjMap = Schema.SObjectType.Opportunity.fields.getMap(); 
        else if (objName == 'Setting__c')
            fldObjMap = Schema.SObjectType.Setting__c.fields.getMap();
        else if (objName == 'Setting_Item__c')
            fldObjMap = Schema.SObjectType.Setting_Item__c.fields.getMap();
            
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();

        String soql = '';
        for(Schema.SObjectField s : fldObjMapValues) {
            String fldName = s.getDescribe().getName();
            soql += fldName + ',';
        }
        soql = soql.subString(0, soql.length() - 1); //Trim last comma
        return soql;
    }
    
    public static Set<String> getFieldSetFromObject(String objName, Boolean onlyCreateable, Boolean excludeLookups) {
        SObjectType objToken = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fldObjMap = objDef.fields.getMap();
        Set<String> flds = new Set<String>();
        for(Schema.SObjectField s : fldObjMap.values()) {
            Schema.DescribeFieldResult f = s.getDescribe();
            if ((f.isCreateable() || !onlyCreateable) && f.isAccessible() && (f.getType() != Schema.Displaytype.Reference || !excludeLookups))
                flds.add(f.getName().toLowerCase());
        }
        return flds;
    }

    public static String getFieldsFromObject(String objName, Boolean onlyCreateable, Boolean excludeLookups) {
        SObjectType objToken = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fldObjMap = objDef.fields.getMap();
        Set<String> flds = new Set<String>();
        String soql = '';
        for(Schema.SObjectField s : fldObjMap.values()) {
            Schema.DescribeFieldResult f = s.getDescribe();
            if ((f.isCreateable() || !onlyCreateable) && f.isAccessible() && (f.getType() != Schema.Displaytype.Reference || !excludeLookups))
                soql += f.getName().toLowerCase() + ',';
        }
        soql = soql.subString(0, soql.length() - 1); //Trim last comma
        return soql;
    }
        
    public static String convertIdSetToString(Set<Id> setIds) {
        String temp = '';
        for (Id theId : setIds) {
            temp += '\'' + String.valueOf(theId) + '\',';
        }
        if (temp != '')
            temp = temp.subString(0, temp.length() - 1); //Trim last comma
        return temp;
    }
    
    public static Boolean isProduction() {
        /*
        http://help.salesforce.com/help/doc/en/data_sandbox_implementation_tips.htm 
        "Salesforce inserts the new value in any place the organization ID is used, such as text values and metadata."
        So the below code splits the OrgId into two parts to prevent this from happening
        */
        String orgId = Userinfo.getOrganizationId();
        if ((orgId.startsWith('00D30000000') && orgId.substring(11,15) == '1NXO')  //Main org Production
          ||(orgId.startsWith('00D0Y000003') && orgId.substring(11,15) == '5Iji')) //T&F Production
            return true;
        else
            return false;
    }
    
    public static String getSandboxName() {
        if (isProduction())
            return '';
        else {
            String usr = UserInfo.getUserName();
            Integer lastdot = usr.lastIndexOf('.');
            String sandbox = usr.substring(lastdot+1, usr.length());
            return sandbox;
        }
    }
    
    
    //*********************************************************/
    //******************* Legacy Methods **********************/
    //***** Going forward, all new methods will be static *****/
    //*********************************************************/
    
    public String MMM_d_yyyy(Date d) {
        if (d == null) {
            return '';
        } else {
            String sMonth;
            if (d.month() == 1)
                sMonth = 'Jan';
            else if (d.month() == 2)
                sMonth = 'Feb';
            else if (d.month() == 3)
                sMonth = 'Mar';
            else if (d.month() == 4)
                sMonth = 'Apr';
            else if (d.month() == 5)
                sMonth = 'May';
            else if (d.month() == 6)
                sMonth = 'Jun';
            else if (d.month() == 7)
                sMonth = 'Jul';
            else if (d.month() == 8)
                sMonth = 'Aug';
            else if (d.month() == 9)
                sMonth = 'Sep';
            else if (d.month() == 10)
                sMonth = 'Oct';
            else if (d.month() == 11)
                sMonth = 'Nov';
            else if (d.month() == 12)
                sMonth = 'Dec';
            
            return sMonth + ' ' + d.day().format() + ', ' + d.year().format().replace(',','');
        }
    }


    public Double WeekdaysDate1MinusDate2(Date date1, Date date2) {

        Date referencePoint = date.newinstance(1900, 1, 7);
        Double fullWeekDays = 0;
        Double partialWeekDays = 0;
                    
        Date gDate;
        Date sDate;
        if (date1 > date2) {
            gDate = date1;
            sDate = date2;          
        }
        else {
            gDate = date2;
            sDate = date1;          
        }

        fullWeekDays = math.floor(sDate.daysBetween(gDate)/7) * 5;
        
        if (math.mod(referencePoint.daysBetween(sDate), 7) == math.mod(referencePoint.daysBetween(gDate), 7))
            partialWeekDays = 0;
        else {
            if (math.mod(referencePoint.daysBetween(sDate), 7) > math.mod(referencePoint.daysBetween(gDate), 7)) {
                if (math.mod(referencePoint.daysBetween(sDate), 7) == 6)
                    partialWeekDays = math.mod(referencePoint.daysBetween(gDate), 7);
                else
                    partialWeekDays = 5 - math.mod(referencePoint.daysBetween(sDate), 7) + math.mod(referencePoint.daysBetween(gDate), 7);
            }
            else {
                if (math.mod(referencePoint.daysBetween(gDate), 7) == 6)
                    partialWeekDays = 5 - math.mod(referencePoint.daysBetween(sDate), 7);
                else
                    partialWeekDays = math.mod(referencePoint.daysBetween(gDate), 7) - math.mod(referencePoint.daysBetween(sDate), 7);
            }
        } 

        if (date1 > date2) {
            return fullWeekDays + partialWeekDays;
        }
        else {
            return 0 - (fullWeekDays + partialWeekDays);
        }

    }
    
    static testMethod void Test_WeekdaysDate1MinusDate2() {
        Date date1 = date.newinstance(2009, 12, 15);
        Date date2 = date.newinstance(2009, 12, 10);
        Double datedif = 0;
        MiscFunctions misc = new MiscFunctions();
        datedif = misc.WeekdaysDate1MinusDate2(date1, date2);
        datedif = misc.WeekdaysDate1MinusDate2(date2, date1);

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