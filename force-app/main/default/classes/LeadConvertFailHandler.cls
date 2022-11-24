//Created by Renil Rejith and Sidhant Chauhan on 14.12.2021 for user story [SAL-4582]

public class LeadConvertFailHandler {
    public String errorMsgOne		='Enrollment Number Too Low';
    public String errorMsgSecond	='Book Price Too High';
    public String errorMsgThird		='Country Not Supported';
    public String errorMsgfourth	='Book Request Limit Reached';
    public String errorMsgfifth		='Product Already Requested';
    
    @future
    public static void processFailLeadConvert(map<Id,String> failedleadIdsErrorMap)
    {
        List<Lead> leadlist=new List<Lead>();
        for(lead lobj:[select id,Lead_Auto_Convert_Failed_Reason__c from lead where id in:failedleadIdsErrorMap.keyset()]){
            lobj.Lead_Auto_Convert_Failed_Reason__c=failedleadIdsErrorMap.get(lobj.id);
            leadlist.add(lobj);
        }
        update leadlist;
    }
}