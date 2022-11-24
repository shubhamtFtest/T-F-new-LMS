/**
* Author     : Avinash Singh
* Company    : Informa
* Date       : 2017-03-15
* Test Class : zTest_AdminLoginCtr 85%
* Description: Admin User License Management System
* Modified by :   
**/

public Class AdminLoginCtr
{
    
    public String configId{get;set;}
    public String requested_userid{get;set{requested_userid = value;}}
    public String requesting_userid;    
    public String requesting_uname;   
    public String usr_Oid;
    public Boolean showuserList {get;set;}
        
    public Class deserializeResponse
    {
        public String id;
        public String access_token;
    }
    
    
    public Class UserDetails
    {
        public String id {get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String UserName {get;set;}
        public Boolean isActive {get;set;}
        public String Email {get;set;}
    }
    
    public List<UserDetails> ActiveuserDetail{get;set;}
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        
        for(Salesforce_Org__c tg : [Select Id,Name from Salesforce_Org__c limit 999])
        {
            options.add(new SelectOption(tg.Id,tg.Name));     
        }
        
        return options;
    }
    
    
    /*----------------------------------------------------------------------------------------------------------------------
Next() : Checks whether a valid user exists in the target orgs , if exists redirects to the target org requested else
returns a list of active logged-in users in the target org to request login permission.
-----------------------------------------------------------------------------------------------------------------------*/
    public PageReference Next(){
        system.debug('configIdTest'+configId);
        if(configId == '--None--'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR,'You must select an org in order to proceed!'));
        }
        
        else{
            
            List<Salesforce_Org__c> sfOrg = [Select Name,ClientKey__c,Target_Oid__c, ClientSecret__c,
                                          Package_Name__c, domain__c, Email__c, Org__c, Password__c, 
                                          User_Name__c from Salesforce_Org__c where Id=:configId];
           
            system.debug('list sfOrg : ' + sfOrg );
            
            if(sfOrg.size() > 0){
                
                String strToken = getToken(sfOrg[0]);
                system.debug('strToken : '+ strToken);
                
                if(strToken !=null)
                {
                    
                    Http h1 = new Http();
                    HttpRequest requestToken = new HttpRequest();
                    string EndPt;
                    system.debug('sfOrg[0].Package_Name__c : ' + sfOrg[0].Package_Name__c);
                    
                    if(String.isNotBlank(sfOrg[0].Package_Name__c)){
                        
                        system.debug('inside endpoint if conditional block');
                        EndPt = sfOrg[0].domain__c + '/services/apexrest/'+ sfOrg[0].Package_Name__c+'GetUserDetails?'+'Email='+UserInfo.getUserEmail()+'&FirstName='+UserInfo.getFirstName()+'&LastName='+UserInfo.getLastName();                       
                    }
                    else{
                        EndPt = sfOrg[0].domain__c + '/services/apexrest/GetUserDetails?'+'Email='+UserInfo.getUserEmail()+'&FirstName='+UserInfo.getFirstName()+'&LastName='+UserInfo.getLastName();
                    }
                    
                    requestToken.setHeader('Authorization','Bearer '+strToken);
                    requestToken.setMethod('GET');
                    requestToken.setEndpoint(EndPt);
                    System.debug('requestToken : '+requestToken);
                    HttpResponse tokenResponse;
                    
                    if(test.isrunningtest()){
                        tokenResponse = getTestResponse(requestToken);
                    }
                    else{
                        tokenResponse = h1.send(requestToken);
                    }
                    
                    system.debug('tokenresponse : '+tokenResponse.getBody());
                    String trimmedResponse = tokenResponse.getBody().unescapeCsv().remove('\\');   
					
                    system.debug('trimmedResponse : ' + trimmedResponse);                    
                    
                    if(trimmedResponse == '"UserNotFound"'){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR,'You are not an authorized user of the selected org'));
                        return null;
                    }
                    else if(trimmedResponse == '"ActiveUserExist"' || trimmedResponse == '"UserActivated"' || trimmedResponse == '"UserActivatedWithNoLicense"'){
						PageReference p = new Pagereference('/apex/InformaLogin');
                        p.getParameters().put('Oid', sfOrg[0].Target_Oid__c);
                        p.getParameters().put('Org', sfOrg[0].Name);
                        p.getParameters().put('username', UserInfo.getUserName());
						return p;
					}
					else{
						ActiveuserDetail = (List<UserDetails>)JSON.deserialize(trimmedResponse, List<UserDetails>.class);
						
						for(Integer i= 0 ; i < ActiveuserDetail.size();i++){
                            System.debug(' Loop : '+ActiveuserDetail[i].FirstName+'=='+UserInfo.getFirstName());
							if(ActiveuserDetail[i].FirstName == UserInfo.getFirstName() && ActiveuserDetail[i].LastName == UserInfo.getLastName() && ActiveuserDetail[i].Email == UserInfo.getUserEmail()){
								requesting_userid = ActiveuserDetail[i].id;
								ActiveuserDetail.remove(i);
                                System.debug('i = '+i);
                                System.debug('i ActiveuserDetail = '+ActiveuserDetail);
								break;
							}
						}
						system.debug('deserialised : ' + ActiveuserDetail);
						
						usr_Oid =  sfOrg[0].Target_Oid__c;                        
						system.debug('usr_Oid : '+usr_Oid);
						
						if(ActiveuserDetail.size() > 0){
							showuserList = true;
						}
					}
                     
                }
            }
        }    
        system.debug('outer block');           
        
        return null;
    }
    
    public String getToken(Salesforce_Org__c tu)
    {
        
        system.debug('tu : ' + tu);
        String reqbody = 'grant_type=password'+'&client_id='+tu.ClientKey__c+'&client_secret='+tu.ClientSecret__c+'&username='+tu.User_Name__c+'&password='+tu.Password__c;
        
        Http h = new Http();
        
        HttpRequest tokenRequest = new HttpRequest();
        tokenRequest.setBody(reqbody);
        
        system.debug('tokenRequest : ' + tokenRequest);
        system.debug('reqbody : ' + reqbody);
        
        tokenRequest.setMethod('POST');
        tokenRequest.setEndpoint(tu.domain__c + '/services/oauth2/token');
        
        system.debug('tokenRequest : ' + tokenRequest);
        
        HttpResponse tokenResponse;
        deserializeResponse objAuthenticationInfo;
            
        if(test.isrunningtest()){
           tokenResponse = getTestResponse(tokenRequest);
        }
        else{
            tokenResponse = h.send(tokenRequest);        
        }

        system.debug('tokenResponse : ' + tokenResponse);        
        System.debug('Body ' + tokenResponse.getBody());        
        
        objAuthenticationInfo =(deserializeResponse)JSON.deserialize(tokenResponse.getbody(), deserializeResponse.class);
        
        system.debug('Body'+ tokenResponse.getbody());
        system.debug('objAuthenticationInfotest'+objAuthenticationInfo);
        system.debug('objAuthenticationInfo'+ objAuthenticationInfo.access_token);
        
        return objAuthenticationInfo.access_token;
    }
    
    
    /*----------------------------------------------------------------------------------------------------------------------
deactivate() : This function handles login requested from any user in the active user list from previous step.
And sends an email alert to the requested user on the behalf of requesting user to approve or 
decline the request.
----------------------------------------------------------------------------------------------------------------------*/
    
    
    Public PageReference deactivate(){
        
        system.debug('requesteduserid : ' + requested_userid);
        system.debug('ActiveuserDetail : ' + ActiveuserDetail);
        
        List<String> sendTo;
        
        String siteUrl;
        String declineUrl;
        String body;
        
        Boolean flag = false;
        
        for(UserDetails u : ActiveuserDetail)     
        {            
            system.debug('requested_useridtest : '+ requested_userid);
            system.debug('u.idTest : '+ u.id);
            if(u.id == requested_userid)
            {
                system.debug('user email : '+ u.Email);
                system.debug('usr_Oid : '+ usr_Oid);
                
                siteUrl = Label.LMA_Source_Org_Url+'/ApproveUser?requested_uid=' + u.id + '&requesting_uid=' + requesting_userid + '&oid=' + usr_Oid+'&act=approve';
                system.debug('approve url : ' + siteUrl);
                
                declineUrl = Label.LMA_Source_Org_Url+'/ApproveUser?requested_uid=' + u.id + '&requesting_uid=' + requesting_userid + '&oid=' + usr_Oid+'&act=decline';
                system.debug('decline url : ' + declineUrl);
                
                body = 'Hi '+ u.FirstName+ ',' + '<br/>';
                body += UserInfo.getName() + ' has requested to deactivate you. ';
                body += 'Please click below to approve or decline. '+'<br/>'; 
               // body += '<a href="'+siteUrl+'">Approve</a>' + ' | ';
                body += '<a href="#">Approve</a>' + ' | ';
                //body += '<a href="'+declineUrl+'">Decline</a>' + '<br/>' ;
                body += '<a href="#">Decline</a>' + '<br/>' ;
                body +='<br/>Thanks & Regards<br/>';
                body +='Informa Global';
                
                sendTo = new List<String>();            
                sendTo.add(u.email);           
                
                system.debug(sendTo);
                
                system.debug('mail action');            
                //List<Messaging.SingleEmailMessage > mails = new List<Messaging.SingleEmailMessage >();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setToAddresses(sendTo);           
                mail.setSubject('Login Request');            
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.Email[]{mail});
                break;
            }            
        }
        return null;
    }
    
    public HTTPResponse getTestResponse(HTTPRequest req) {
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
            if(req.getEndpoint().contains('/services/apexrest/GetUserDetails'))
            {
                res.setBody('[{\"attributes\":{\"type\":\"User\",\"url\":\"/services/data/v39.0/sobjects/User/00528000003o1f3AAA\"},\"Id\":\"00528000003o1f3AAA\",\"Email\":\"kritika.chaurasia@ideactive.in\",\"Username\":\"nautilus@zenmap.com\",\"FirstName\":\"Kritika\",\"LastName\":\"Nath\",\"IsActive\":false}]');            
            }
            else if(req.getEndpoint().contains('/services/apexrest/getActiveUserlist'))
            {
                res.setBody('[{\"attributes\":{\"type\":\"User\",\"url\":\"/services/data/v39.0/sobjects/User/00528000003nx4mAAA\"},\"Id\":\"00528000003nx4mAAA\",\"Email\":\"kritika.1967@gmail.com\",\"Username\":\"quicksilver@marvels.com\",\"FirstName\":\"kritika\",\"LastName\":\"chaurasia\",\"IsActive\":true,\"ProfileId\":\"00e28000001aghYAAQ\"},{\"attributes\":{\"type\":\"User\",\"url\":\"/services/data/v39.0/sobjects/User/00528000005GuVXAA0\"},\"Id\":\"00528000005GuVXAA0\",\"Email\":\"kritika.chaurasia@ideactive.in\",\"Username\":\"vibhunarayan@informa.com\",\"FirstName\":\"Vibhuti\",\"LastName\":\"Narayan\",\"IsActive\":true,\"ProfileId\":\"00e28000001aghYAAQ\"}]');
            }    
        }
        res.setStatus('OK');
        res.setStatusCode(200);
        return res;
    }
}