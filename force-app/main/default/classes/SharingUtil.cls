/*
* This utility is used to create a manual sharing record on an Account record when the user
* user inserting the record is not the owner of the record as sharing is only recalculated 
* when a method completes. In a with sharing class the method will fail as the user won't
* have access to the newly created record. For example when a Workflow Rule reassigns owership
* to a central user. ** NOTE: This class still excecutes as a without sharing class even if 
* the parent class using this Util is a without sharing class.
*
* Created by Hailey Niemand - 2015.02.18 - CHG0064416
*/

public without sharing class SharingUtil{ 

    public static ID createShares(ID AccountId, ID UserId) {
        AccountShare  aShare = new AccountShare();
        aShare.AccountId = AccountId;
        aShare.UserOrGroupId = UserId;
        aShare.accountaccesslevel = 'Edit';
        aShare.OpportunityAccessLevel = 'Edit';
        aShare.CaseAccessLevel = 'Edit';
        insert aShare;
        return aShare.Id;
    }
    
    public static void deleteShares(ID shareIdToDelete) {
        Database.delete(shareIdToDelete);
    }
    
}