//This class is created for scheduling batch class : TF_LicenseEmailBatch //CHG0048117

global class TF_LicenseEmailBatch_Schedule implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
       TF_LicenseEmailBatch b = new TF_LicenseEmailBatch();
       Database.executebatch(b);
   }   
}