public class FutureArchiveUnArchive {
    @future
    public static void FutureArchive( id case_id) {
        list<attachment> mail_insert = new list<attachment>();
        list<attachment> atmList = new list<attachment>();
        list<EmailMessage> mail_del = new list<EmailMessage>();
        list<EmailMessage> mail_case ;
        map<id,EmailMessage> map_mail_case;
        
        list<id>email_list = new list<id>();
        string attach_ids='';
        mail_case  =  [SELECT BccAddress,CcAddress,FromAddress,FromName, HasAttachment,Email_number__c,
                       Id,Incoming,MessageDate,ParentId,RelatedToId,Status,Headers,
                       Subject,TextBody,HtmlBody,ToAddress FROM EmailMessage where ParentId =:case_id ];
        
        map_mail_case = new map<id,EmailMessage>(mail_case);
        
        
        for(attachment attm : [select Body,BodyLength,ContentType,Description,Id,
                               IsPrivate,Name,OwnerId,
                               ParentId from attachment where parentid in : map_mail_case.keySet()]){
                                   EmailMessage ec =  map_mail_case.get(attm.ParentId);
                                   attachment atch = new attachment();
                                   atch.Body = attm.Body;
                                   atch.ContentType = attm.ContentType;
                                   atch.Description = attm.Description;
                                   atch.IsPrivate =  attm.IsPrivate;
                                   atch.Name  =  ec.Email_number__c+'__Attachment_'+ attm.Name;
                                   atch.OwnerId = attm.OwnerId;
                                   atch.ParentId =   case_id;
                                   atmList.add(atch);
                               }   
        insert atmList;
        
        for( EmailMessage caseMial : mail_case ){
            
            attach_ids = '';  
            
            for(attachment a : atmList ){
                
                string s = a.Name;
                if(s.startsWith(caseMial.Email_number__c+'__Attachment_')){  
                    attach_ids = attach_ids+'#;#'+a.Id ;
                } 
            }
            
            attachment atch = new attachment();
            
            atch.ParentId =  case_id;
            
            if(caseMial.Subject != NULL && caseMial.Subject.length() > 200){
                atch.Name = caseMial.Email_number__c+' _'+caseMial.Subject.substring(0, 150) +'. . ._'+'_Email.pdf';
            }
            else{
                if(caseMial.Subject == NULL){
                    
                    atch.Name = caseMial.Email_number__c+' __'+'_Email.pdf'; 
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
            
            // atch.Body = blob.toPDF(caseMial.FromName+'<br/>'+caseMial.FromAddress+'<br/>'+caseMial.CcAddress +'<br/>' +
            // caseMial.CcAddress+'<br/>'+caseMial.Subject+'<br/>'+  bdy + '<br/>' +'<a href="/5007F00000HCfFsQAL" color="blue">CaseTest</a>'  );
            
            mail_insert.add(atch);  
            
            attachment atchtxt = new attachment();
            
            atchtxt.ParentId = case_id;
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
                                         '#%#ParentId='+case_id+
                                         '#%#RelatedToId='+caseMial.RelatedToId+
                                         '#%#Status='+caseMial.Status+
                                         '#%#ToAddress='+caseMial.ToAddress+
                                         '#%#Subject='+caseMial.Subject+
                                         '#%#Attachment='+attach_ids);
            mail_insert.add(atchtxt);
            
            EmailMessage casemail_del = new EmailMessage();
            casemail_del.Id= caseMial.id;
            mail_del.add(casemail_del);
            
            
        }
        case c = new case();
        c.Id = case_id;
        c.IsArchived__c = true;
      
        update c;
        
        insert mail_insert;
        
        delete mail_del;
        if(mail_del.size()>0){database.emptyRecycleBin(mail_del);}
        
        
        list<task> t = [SELECT Id,TaskSubtype,WhatId,WhoId FROM Task WHERE TaskSubtype = 'email' AND WhatId =: case_id];
        delete t;
        
        if(t.size()>0){database.emptyRecycleBin(t);}
    }
    
    

    public static void FutureUnArchive(case c) {
      
        
        list<attachment> atmList_del = new list<attachment>();
        list<attachment> atmList = new list<attachment>();
        
        list<EmailMessage> mail_re = new list<EmailMessage>(); 
        
        map<integer , list<id> >  map_att = new map<integer , list<id>> ();
        map<id , list<id> >  map_attid = new map<id , list<id>> ();
        
        list<id> attachment_ids; 
        
        
        map<id ,Attachment> attach;
        integer i=0;
        
        
        
        
        attach  = new map<id,Attachment>( );
        
        
        for( Attachment att : [SELECT Body,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,
                               IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId,SystemModstamp 
                               FROM Attachment where ParentId =:c.id  ])          // attachment of cases 
        {  
            string s = att.Name;                      
            if(s.endsWith('_recover.txt') ){            // finding recovery files from attachments for emails
                
                blob blb = att.Body;                                                         
                string str = blb.toString();
                emailRecoveryTextPareser obj = new emailRecoveryTextPareser(str);  // creating instance of pareser class(emailRecoveryTextPareser) 
                EmailMessage ecm = new EmailMessage();
                ecm.BccAddress = obj.BccAddress;
                ecm.CcAddress = obj.CcAddress;
                ecm.FromAddress = obj.FromAddress;
                ecm.FromName = obj.FromName;
                ecm.Headers = obj.Headers;
                ecm.Incoming = obj.Incoming;
                   
                if(obj.Incoming == True){
                    ecm.Incoming = True;
                }
                else{
                    ecm.Incoming = False;
                }
                ecm.MessageDate = obj.MessageDate;
                ecm.TextBody = obj.TextBody;
                ecm.HtmlBody = obj.HtmlBody;
                ecm.ParentId = obj.ParentId;
                if(obj.RelatedToId != ''){
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
            } else {
                attach.put(att.Id,att);
            }
        }
        insert  mail_re ;
        i=0;
        for( i=0;i<mail_re.size();i++){
            map_attid.put(mail_re[i].id, map_att.get(i)) ;  
            map_att.remove(i);
        }
        for(id p_id : map_attid.keySet() ){
            
            attachment_ids = map_attid.get(p_id);
            
            if(attachment_ids.size()>0){
                
                for(id at_id:attachment_ids){
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
                }
            }
        }     
        case c1 = new Case();
  		c1.id = c.id;
        c1.IsArchived__c = False;
        c1.Inbound__c = c.Inbound__c;
        c1.outbound__c = c.outbound__c;
        System.debug('### New  : '+c.Inbound__c+'### OLD : '+c.outbound__c);
        update c1;
        insert atmList; 
        delete atmList_del;
        if(atmList_del.size()>0){database.emptyRecycleBin(atmList_del); atmList.clear(); }          
    }
}