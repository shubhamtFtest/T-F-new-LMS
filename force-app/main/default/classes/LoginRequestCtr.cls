/**
* Author     : Avinash Singh
* Company    : Informa
* Date       : 2017-03-16
* Test Class : zTest_LoginRequestCtr 
* Description: For sending request approved notification mail to the requesting user.
* Modified by:   
**/

public class LoginRequestCtr
{
    public string usrId{get;set;}
    public string aprroverId{get;set;}
    public string oid{get;set;}
    public boolean flag{get;set;}
    
    
    
    
    
    Public Class deserializeResponse
    {
        Public String id;
        Public String access_token;
    }
    
    Public Class deserializeUserDetail
    {
        Public String id;
        Public String FirstName;
        Public String LastName ;
        Public String UserName;
        Public Boolean isActive;
        Public String Email;
    }
    
    public PageReference userUpdate()
    {
        if(ApexPages.currentPage().getParameters().containsKey('act')){
            if(ApexPages.currentPage().getParameters().get('act')=='approve')
                approveUserReq();
            else if(ApexPages.currentPage().getParameters().get('act')=='decline')
                declineNotification();
        }
        return null;
    }
    public void approveUserReq()
    {
        flag = false;
        
        aprroverId = ApexPages.currentPage().getParameters().get('requested_uid');        
        system.debug('approver id: '+aprroverId);
        
        usrId = ApexPages.currentPage().getParameters().get('requesting_uid');
        system.debug('approved user id: '+usrId);
        
        oid = ApexPages.currentPage().getParameters().get('oid');
        system.debug('oid : '+ oid);
        
        if(String.isNotBlank(aprroverId) && String.isNotBlank(usrId) && String.isNotBlank(oid))
        {
            system.debug('aprroverId : ' + aprroverId);   
            system.debug('usrId : ' + usrId);
            system.debug('oid : '+ oid);
            
            List<Salesforce_Org__c> tu = [Select ClientKey__c,Target_Oid__c,Package_Name__c, ClientSecret__c, domain__c, Email__c, Org__c, Password__c, User_Name__c from Salesforce_Org__c where Target_Oid__c =: oid  AND User_Type__c =: 'Integration User'];
            
            String reqbody = 'grant_type=password&client_id='+tu[0].ClientKey__c+'&client_secret='+tu[0].ClientSecret__c+'&username='+tu[0].User_Name__c+'&password='+tu[0].Password__c ;
            
            System.debug('test list size' + tu );
            
            Http h = new Http();
            
            HttpRequest req = new HttpRequest();
            req.setBody(reqbody);
            req.setMethod('POST');
            req.setEndpoint(tu[0].domain__c + '/services/oauth2/token');
            
            HttpResponse res;
            
            if(test.isrunningtest())
            {
                res = respond(req);
            }
            else
            {
                res = h.send(req);
            }
            
            deserializeResponse objAuthenticationInfo =(deserializeResponse)JSON.deserialize(res.getbody(), deserializeResponse.class);
            
            system.debug('Body'+ res.getbody());
            system.debug('objAuthenticationInfo'+ objAuthenticationInfo);
            
            if(objAuthenticationInfo.access_token != null)
            {
               
                Http h1 = new Http();
                HttpRequest req1 = new HttpRequest();
                string EndPt;
                if(String.isNotBlank(tu[0].Package_Name__c))
                {
                    EndPt = tu[0].domain__c + '/services/apexrest/'+ tu[0].Package_Name__c +'login_request?' + 'requestinguser=' + usrId + '&requesteduser=' + aprroverId + '&action=approve';                       
                }
                else
                {
                    EndPt = tu[0].domain__c + '/services/apexrest/login_request?' + 'requestinguser=' + usrId + '&requesteduser=' + aprroverId + '&action=approve';                       
                }
 
                req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
                req1.setMethod('GET');
                req1.setEndpoint(EndPt);
                
                HttpResponse res1;
                
                if(test.isrunningtest())
                {
                    res1 = respond(req1);
                }
                else
                {
                    res1 = h1.send(req1);
                }
                
                system.debug('res1.getBody() :' + res1.getBody());                
                system.debug('RESPONSE_BODY '+res1);
                
                String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
                system.debug('trimmedResponse : '+ trimmedResponse);
                
                deserializeUserDetail udetail = (deserializeUserDetail)JSON.deserialize(trimmedResponse, deserializeUserDetail.class);
                system.debug('deserialised : ' + udetail);
                
                String body = 'Hi ' + udetail.FirstName + ',' + '<br/>';
                body += 'Your request has been accepted. You can now login into your organization. <br/>';
                body += '<br/>Thanks & Regards,<br/>';
                body += 'Informa Global.';
                
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
                
                List<String> sendTo = new List<String>();            
                sendTo.add(udetail.Email);           
                
                mail.setToAddresses(sendTo);           
                mail.setSubject('Salesforce Login Request Accepted');            
                mail.setHtmlBody(body);
                
                Messaging.sendEmail(new Messaging.Email[]{mail}); 
                
            }
        }
                              
       
    }
    
    public void declineNotification()
    {
        flag = false;
        
        aprroverId = ApexPages.currentPage().getParameters().get('requested_uid');        
        system.debug('dec id: '+aprroverId);
        
        usrId = ApexPages.currentPage().getParameters().get('requesting_uid');
        system.debug('approved user id: '+usrId);
        
        oid = ApexPages.currentPage().getParameters().get('oid');
        system.debug('oid : '+ oid);
        
        if(String.isNotBlank(aprroverId) && String.isNotBlank(usrId) && String.isNotBlank(oid))
        {
            system.debug('aprroverId : ' + aprroverId);   
            system.debug('usrId : ' + usrId);
            system.debug('oid : '+ oid);
            
            List<Salesforce_Org__c> tu = [Select ClientKey__c,Target_Oid__c,Package_Name__c, ClientSecret__c, domain__c, Email__c, Org__c, Password__c, User_Name__c from Salesforce_Org__c where Target_Oid__c =: oid  AND User_Type__c =: 'Integration User'];
            
            String reqbody = 'grant_type=password&client_id='+tu[0].ClientKey__c+'&client_secret='+tu[0].ClientSecret__c+'&username='+tu[0].User_Name__c+'&password='+tu[0].Password__c ;
            
            System.debug('test list size' + tu );
            
            Http h = new Http();
            
            HttpRequest tokenreq = new HttpRequest();
            tokenreq.setBody(reqbody);
            tokenreq.setMethod('POST');
            tokenreq.setEndpoint(tu[0].domain__c + '/services/oauth2/token');
            
            HttpResponse tokenres;
            
            if(test.isrunningtest())
            {
                tokenres = respond(tokenreq);
            }
            else
            {
                tokenres = h.send(tokenreq);
            }
            
            deserializeResponse objAuthenticationInfo =(deserializeResponse)JSON.deserialize(tokenres.getbody(), deserializeResponse.class);
            
            system.debug('Body'+ tokenres.getbody());
            system.debug('objAuthenticationInfo'+ objAuthenticationInfo);
            
            if(objAuthenticationInfo.access_token != null)
            {
               
                Http h1 = new Http();
                HttpRequest req1 = new HttpRequest();
                string EndPt;
                if(String.isNotBlank(tu[0].Package_Name__c))
                {
                    EndPt = tu[0].domain__c + '/services/apexrest/'+ tu[0].Package_Name__c +'login_request?' + 'requestinguser=' + usrId + '&requesteduser=' + aprroverId + '&action=decline';                       
                }
                else
                {
                    EndPt = tu[0].domain__c + '/services/apexrest/login_request?' + 'requestinguser=' + usrId + '&requesteduser=' + aprroverId + '&action=decline'; 
                }
                
                req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
                req1.setMethod('GET');
                req1.setEndpoint(EndPt);                
                
                HttpResponse res1;
            
                if(test.isrunningtest())
                {
                    res1 = respond(req1);
                }
                else
                {
                    res1 = h.send(req1);
                }
                
                system.debug('res1.getBody() :' + res1.getBody());                
                system.debug('RESPONSE_BODY '+res1);
                
                String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
                system.debug('trimmedResponse : '+ trimmedResponse);
                
                deserializeUserDetail udetail = (deserializeUserDetail)JSON.deserialize(trimmedResponse, deserializeUserDetail.class);
                system.debug('deserialised : ' + udetail);
                
                String body = 'Hi ' + udetail.FirstName + ',' + '<br/>';
                body += 'Your request has been decline. Please try another user or try again later. <br/>';
                body += '<br/>Thanks & Regards,<br/>';
                body += 'Informa Global.';
                
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
                
                List<String> sendTo = new List<String>();            
                sendTo.add(udetail.Email);           
                
                mail.setToAddresses(sendTo);           
                mail.setSubject('Salesforce Login Request Declined');            
                mail.setHtmlBody(body);
                
                Messaging.sendEmail(new Messaging.Email[]{mail}); 
                
            }
        }
                              
        
    }
    // this method is used to get the test class data.
    public HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse(); 
        
        if(req.getMethod().contains('POST'))
        {
            if(req.getEndpoint().contains('/services/oauth2/token'))
            {
                res.setBody('{"access_token":"00D28000001OkO8!ARcAQOe8RnFO8mVASOR_QA2u1snuPT.nuOfxVI0VpsuE0l6qkdfzZnlTQ9fobrta_DD_h3TjZx08LqV70A83F39Nq43I8B1q","instance_url":"https://quicksilver-dev-ed.my.salesforce.com","id":"https://login.salesforce.com/id/00D28000001OkO8EAK/00528000003nx4mAAA","token_type":"Bearer","issued_at":"1491893489576","signature":"Py9jEYzcZ7noPaAYO/Sd87uTzPh8UGxn30VZPKQm0Tc="}');
            }
        }
      
        else if(req.getMethod().contains('GET'))
        {
            if(req.getEndpoint().contains('/services/apexrest/login_request'))
            {
                res.setBody('{\"attributes\":{\"type\":\"User\",\"url\":\"/services/data/v39.0/sobjects/User/00528000003o1f3AAA\"},\"Id\":\"00528000003o1f3AAA\",\"Email\":\"kritika.chaurasia@ideactive.in\",\"Username\":\"nautilus@zenmap.com\",\"FirstName\":\"Kritika\",\"LastName\":\"Nath\",\"IsActive\":false}');            
            }   
        }
        res.setStatus('OK');
        res.setStatusCode(200);
        return res;
    }
}