import { LightningElement,api, track } from 'lwc';
import getCaseRecord from '@salesforce/apex/CaseController.getCaseRecord';
import getContactList from '@salesforce/apex/CaseController.getContactList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from "lightning/actions";
import { updateRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/schema/Case.Id';
import ContactId from '@salesforce/schema/Case.ContactId';
import getAccount from '@salesforce/apex/CaseController.getAccount';
export default class CaseAction extends LightningElement {
    @api recordId;
        SuppliedName;
        SuppliedEmail;
        SuppliedPhone;
        AccountId;
 @track caseRecord;
       renderedCallback() {         
        getCaseRecord({recordId:this.recordId})
        .then(res=>{
            this.caseRecord= res[0];
            this.SuppliedName = res[0].Contact.Name;
            this.SuppliedEmail = res[0].ContactEmail;
            this.SuppliedPhone=res[0].ContactPhone;

        }).catch(error=>{
            console.log(error);
        })
        getAccount()
        .then(result=>{
            console.log(result);
            console.log(result[0].Id);
            console.log('renderdCallBack');

            this.AccountId=result[0].Id;
        })
        .catch(error=>{
            console.log('error');
          console.log(error);
      })
    }

       handleChangeEmail(event) {
           this.SuppliedEmail= event.target.value;
                  
      }
       handleChangeName(event) {
           this.SuppliedName= event.target.value;
      }
      
   
       createContact(event){
        if (this.SuppliedName === undefined) {
            this.SuppliedName=this.caseRecord.SuppliedName;         
        }
          if (this.SuppliedEmail === undefined) {
            this.SuppliedEmail=this.caseRecord.SuppliedEmail;         
        }
          if (this.SuppliedPhone === undefined) {
            this.SuppliedPhone=this.caseRecord.SuppliedPhone;         
        } 
        getContactList({
                conName : this.SuppliedName, 
                conEmail : this.SuppliedEmail,
                conPhone : this.SuppliedPhone,
                conAccountId : this.AccountId})
                
                .then(result => {
                    const eventSuccess = new ShowToastEvent({
                        title: 'Contact created',
                        message: 'New Contact '+ this.SuppliedName +' '+ this.SuppliedEmail +' created.',
                        variant: 'success'
                    });
                    const eventError = new ShowToastEvent({
                        title: 'Error',
                        message: 'Error creating contact. Please use a Unique Email',
                        variant: 'error'
                    });
                    if (result != null) {
                        const fields = {};
                        fields[Id.fieldApiName] = this.recordId;
                        fields[ContactId.fieldApiName] = result;
                        const recordInput = { fields };

                       updateRecord(recordInput)
                       .then(() => {
                       })
                       
                        this.dispatchEvent(eventSuccess);
            this.dispatchEvent(new CloseActionScreenEvent());
                    } 
                     else {
                        this.dispatchEvent(eventError);
                    }
                 })
                .catch(error => {
                    const event = new ShowToastEvent({
                        title : 'Error',
                        message : 'Error creating contact. Please Contact System Admin',
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                });
        }
       closeModal()
        {
            this.dispatchEvent(new CloseActionScreenEvent());
       }
}