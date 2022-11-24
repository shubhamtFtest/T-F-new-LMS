global class ToUnArchiveBatch implements Database.Batchable<sObject> {
    
    
            map<id , case> map_case_unarc ;
            list<case>case_update =  new list<case>();
            
            list<id> attachment_ids = new list<id>() ;
            list<EmailMessage> mail_re = new list<EmailMessage>();
            list<attachment> atmList_del = new list<attachment>();
            list<attachment> atmList = new list<attachment>();
            
            map<integer , list<id> >  map_att = new map<integer , list<id>> ();
            map<id , list<id> >  map_attid = new map<id , list<id>> ();
            
            integer i=0;
    
   
    
    global Database.queryLocator start(Database.BatchableContext ctx ){
      
               
                string Qry = 'SELECT IsArchived__c,CaseNumber,ClosedDate,'+
                    			'CreatedDate,Id,IsClosed,Status,Subject,'+
                    			'Type FROM Case where IsArchived__c = true  limit 50000';
                System.debug('************Qry*************'+Qry);
                return Database.getQueryLocator(Qry);
    }
    
    
    global void execute(Database.BatchableContext ctx, List<case> caseToUnArchive){
                
                map_case_unarc = new map<id , case> (caseToUnArchive) ;  
                
                case_update.clear();
                map_attid.clear();
                mail_re.clear();
                atmList_del.clear(); 
        		i=0;                
                map<id,Attachment> attach = new map<id,Attachment>();
                
                
                
                for( Attachment att :[SELECT Body,ContentType,Description,Id,IsDeleted,
                                                                    IsPrivate,Name,OwnerId,ParentId 
                                                                    FROM Attachment where ParentId in : map_case_unarc.keySet() ]  )
                {  
                    string s = att.Name;
                    if(s.endsWith('_recover.txt') ){
                        
                        blob blb = att.Body;
                        string str = blb.toString();
                        emailRecoveryTextPareser obj = new emailRecoveryTextPareser(str);
                        EmailMessage ecm = new EmailMessage();
                        
                        ecm.BccAddress = obj.BccAddress;
                        ecm.CcAddress = obj.CcAddress;
                        ecm.FromAddress = obj.FromAddress;
                        ecm.FromName = obj.FromName;
                        ecm.Headers = obj.Headers;
                        ecm.Incoming = obj.Incoming;
                        ecm.MessageDate = obj.MessageDate;
                        ecm.TextBody = obj.TextBody;
                        ecm.HtmlBody = obj.HtmlBody;
                        ecm.ParentId = obj.ParentId;
                        if( obj.RelatedToId != ''){
                            ecm.RelatedToId = obj.RelatedToId;
                        }
                        
                        ecm.Status = obj.Status;
                        ecm.ToAddress = obj.ToAddress;
                        ecm.Subject = obj.Subject;
                        ecm.IsUnarchived__c=True;
                        attachment_ids = obj.attachment_ids;
                        
                        mail_re.add(ecm);
                        atmList_del.add(new Attachment(Id=att.Id));
                        
                        map_att.put(i++, attachment_ids);
                       
                        
                    }
                    else if(s.endsWith('_Email.pdf') ){
                        atmList_del.add(new Attachment(Id=att.Id));
                        
                    }else {
                        
                        attach.put(att.Id,att);
                        
                    }
                    
                }
                
                insert mail_re ;
        	i=0;
                
                for( i=0;i<mail_re.size();i++){
                    map_attid.put(mail_re[i].id, map_att.get(i)) ;  
                    map_att.remove(i);
                }
                
                
                
                
                for(id p_id : map_attid.keySet() ){
                    
                    
                    attachment_ids = map_attid.get(p_id);
                    if(map_attid.get(p_id)!=NULL){
                        if(attachment_ids.size()>0){
                            
                            for(id at_id:attachment_ids){
                                if(at_id != null){
                                    attachment attm = attach.get(at_id);
                                    
                                    attachment atch = new attachment();
                                    
                                    atch.Body = attm.Body;
                                    atch.ContentType = attm.ContentType;
                                    atch.Description = attm.Description;
                                    atch.IsPrivate =  attm.IsPrivate;
                                    string tst =  attm.Name ;                    
                                    atch.Name  = tst.substringAfterLast('__Attachment_');
                                    atch.OwnerId = attm.OwnerId;
                                    atch.ParentId =   p_id;
                                    atmList.add(atch);
                                    atmList_del.add(attm);   
                                    attach.remove(attm.Id);     
                                }
                            }
                        } 
                    }                         
                }
                
                for(case c : map_case_unarc.values()){
                    
                    
                    c.IsArchived__c = FALSE;
                    case_update.add(c);
                }
                update case_update;
                
                insert atmList; 
                delete atmList_del;
                atmList_del.clear();
                if(atmList_del.size()>0){database.emptyRecycleBin(atmList_del);} 
                
                mail_re .clear();
                map_attid.clear();
                atmList.clear();
                
                
    }
    
    global void finish(Database.BatchableContext BC) {
       	/*
                AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
                from AsyncApexJob where Id =:BC.getJobId()];
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject(' Batch Process ' +' '+ a.Status);
                mail.setPlainTextBody('Records processed  ' + a.TotalJobItems + '  with  '+a.NumberOfErrors +'  failures.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		*/         
    }
}