public class TF_SplitLeadSource implements TriggerInterface_Lead.Runnable
{

     public void run(TriggerInterface_Lead.Trig trig) 
     {
         system.debug('!!!!!!!'+trig.newList);
         for(Lead leadRec : trig.newList)
        {
                if (trig.isBefore && (trig.isInsert || trig.isUpdate))
                {
                    system.debug('leadRec.LeadSource'+leadRec.LeadSource);
                    system.debug('leadRec.label'+system.label.T_F_Lead_Source_Webform_Mapping);
                      if(leadRec.LeadSource != null && leadRec.LeadSource.contains('::') && system.label.T_F_Lead_Source_Webform_Mapping == 'On')
                      {
                          system.debug('%%%%%%%%');
                        List<String> leadSourceValues = new List<String>();
                          
                          
                        //  list<string> r=temp.split('::');
                      //    system.debug('tttttt'+r);
                         leadSourceValues=leadRec.LeadSource.split('::');   
                        //leadSourceValues = leadRec.LeadSource.split('::');
                        
                        //  system.debug('^^^^^^^'+leadSourceValues.size()+leadSourceValues);
                        if(leadSourceValues.size() == 2)
                        {
                            leadRec.LeadSource = leadSourceValues[0];
                            leadRec.Lead_Source_Detail__c = leadSourceValues[1];
                            System.debug(' leadRec.Lead_Source_Detail__c'+ leadRec.Lead_Source_Detail__c);
                        }
                     }
                 
             
            }  
        }
     }

}