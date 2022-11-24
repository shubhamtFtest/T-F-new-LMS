global class ToArchiveBatch implements Database.Batchable<sObject> {
    
    

    global Database.queryLocator start(Database.BatchableContext ctx ){
        
        Archive_UnArchive_Emails__c ac = Archive_UnArchive_Emails__c.getInstance('Archive'); 
        
        Transient string Closed_older_then =  ac.Case_Closed_older_Then__c ;
        Transient string Query_limit =    ac.Batch_Limit__c;
        string Qry;
        if(!test.isRunningTest()){
            
         Qry= 'SELECT IsArchived__c,Id FROM Case where id in (Select ParentId from EmailMessage where ParentId != null) '   +
          ' And Isclosed = True And ClosedDate < LAST_N_DAYS : '+ Closed_older_then +' limit ' + Query_limit;
        
        }
        else{
            
             Qry = 'SELECT IsArchived__c,Id FROM Case where id in (Select ParentId from EmailMessage where ParentId != null) '   +
          ' And Isclosed = True And ClosedDate <= LAST_N_DAYS : '+ Closed_older_then +' limit ' + Query_limit;
        }
         System.debug('########Archive Quary =  '+ Qry);
        
        return Database.getQueryLocator(Qry);
        
    }
    
    global void execute(Database.BatchableContext ctx, List<case> caseToArchive){
        
        try{
       // System.debug('$$$$$$$$$$$$'+Limits.getHeapSize());
    
                   
            
            list<EmailMessage> mail_del = new list<EmailMessage>();         //list to delete the archived mails 
            Transient list<attachment> att_insert = new list<attachment>();           //list to insert archived attachment
            Transient list<attachment> mail_insert = new list<attachment>();          //list to insert mails in attachments 
      
            /*  Query to get mails from cases to archive  */ 
        
            //system.debug('case idds'+map_case_arc);
            
          map<id, EmailMessage> map_mail = new map<id, EmailMessage>([SELECT BccAddress,CcAddress,FromAddress,FromName, HasAttachment,Email_number__c,
                                                  Id,Incoming,MessageDate,ParentId,RelatedToId,Status,Headers,
                                                  Subject,TextBody,HtmlBody,ToAddress FROM EmailMessage where ParentId IN : caseToArchive ]) ;
            
          
            
            /*  Query to get attachments realted to mails  from cases to archive  */ 
            

            
            for(attachment att : [select Body,BodyLength,ContentType,
                                                 Description,Id,IsPrivate,Name,OwnerId,
                                                 ParentId from attachment where ParentId in : map_mail.keySet()]){
                
                attachment atch = new attachment();
                
                EmailMessage ec =  map_mail.get(att.ParentId);
                
                atch.Body = att.Body;
                atch.ContentType = att.ContentType;
                atch.Description = att.Description;
                atch.IsPrivate =  att.IsPrivate;
                atch.Name  =  ec.Email_number__c+'__Attachment_'+ att.Name;
                atch.OwnerId = att.OwnerId;
                atch.ParentId = ec.ParentId ;
                
                //system.debug('##############'+ atch);
                att_insert.add(atch);
                
            } 
            
            insert att_insert;    // inserting attachments 
            
            /*  moving all the mails related to cases to there attachments  */ 
            for( EmailMessage caseMial : map_mail.values() ){
                
                string attach_ids = '';  
                for(attachment a:att_insert ){
                    string s = a.Name;
                    if(s.startsWith(caseMial.Email_number__c+'__Attachment_')){  
                        attach_ids = attach_ids+'#;#'+a.Id ;
                    } 
                }
                
                attachment atch = new attachment();   //creating pdf attachment from mail
                
                atch.ParentId =  caseMial.ParentId;
                
                if(caseMial.Subject != NULL && caseMial.Subject.length() > 200){
                    atch.Name = caseMial.Email_number__c+' _'+caseMial.Subject.substring(0, 150) +'. . ._'+'_Email.pdf';
                }
                else{
                    if(caseMial.Subject == NULL){
                        
                        atch.Name = caseMial.Email_number__c+'<NO SUBJECT>_'+'_Email.pdf'; 
                    }else{
                        atch.Name = caseMial.Email_number__c+' _'+caseMial.Subject+'_'+'_Email.pdf';   
                    }
                }
                
                
                atch.Body =  blob.toPDF('<br/><b>Name : </b>'+(caseMial.FromName==Null? ' ' : caseMial.FromName)+
                                        '<br/><b>Address : </b>'+(caseMial.FromAddress==Null? ' ' : caseMial.FromAddress)+
                                        '<br/><b>BccAddress : </b>'+(caseMial.BccAddress==Null? ' ' : caseMial.BccAddress)+
                                        '<br/><b>CcAddress : </b>'+(caseMial.CcAddress==Null? ' ' : caseMial.CcAddress)+
                                        '<br/><br/><b>Subject : </b>'+(caseMial.Subject==Null? ' ' :caseMial.Subject.replaceAll('<','^').replaceAll('\n','<br/>') )+
                                        '<br/><br/>' +(caseMial.TextBody==Null? ' ' :caseMial.TextBody.replaceAll('<','^').replaceAll('\n','<br/>') )  +
                                        '<br/>'  );
                
                mail_insert.add(atch);
                
                attachment atchtxt = new attachment();    // creating attachment recovery file for the mail 
                
                atchtxt.ParentId = caseMial.ParentId;
                atchtxt.Name = caseMial.Email_number__c+'_'+'_recover.txt';
                atchtxt.Body =  blob.valueOf('#%#BccAddress='+caseMial.BccAddress+
                                             '#%#CcAddress='+caseMial.CcAddress+
                                             '#%#FromAddress='+caseMial.FromAddress+
                                             '#%#FromName='+caseMial.FromName+
                                             '#%#Headers='+caseMial.Headers+
                                             '#%#Incoming='+caseMial.Incoming+
                                             '#%#MessageDate='+caseMial.MessageDate+
                                             '#%#TextBody='+caseMial.TextBody +
                                             '#%#HtmlBody='+caseMial.HtmlBody +
                                             '#%#ParentId='+caseMial.ParentId+
                                             '#%#RelatedToId='+caseMial.RelatedToId+
                                             '#%#Status='+caseMial.Status+
                                             '#%#ToAddress='+caseMial.ToAddress+
                                             '#%#Subject='+caseMial.Subject+
                                             '#%#Attachment='+attach_ids);
                mail_insert.add(atchtxt);
                
                mail_del.add(new EmailMessage(Id=caseMial.Id));  
                
            }
        	Transient set<id> case_set = new Set<id>();
            
            for(case c : caseToArchive){
                
                // system.debug('###############'+c);
                c.IsArchived__c = TRUE;
                case_set.add(c.Id);
               
            }
            
            update caseToArchive;
            
            insert mail_insert;      
            delete mail_del;  
            if(mail_del.size()>0){database.emptyRecycleBin(mail_del);}
            
            
            /*  deleting all the privious tasks realted to to archive case   */ 
            
            list<task> t = [SELECT Id,TaskSubtype,WhatId,WhoId FROM Task WHERE TaskSubtype = 'email' AND WhatId in: case_set];
            delete t;
            if(t.size()>0){database.emptyRecycleBin(t);}
            
    }  
        catch(exception e){
            
            system.debug('exception  = ' + String.valueOf(e) );
        } 
       
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
        /* AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
		TotalJobItems, CreatedBy.Email
		from AsyncApexJob where Id =:BC.getJobId()];

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject(' Batch Process ' +' '+ a.Status);
		mail.setPlainTextBody('Cases Archived with  '+a.NumberOfErrors +'  failures in'+ a.TotalJobItems + 'iteration' );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */
    }
    
}