import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/CSVFileReadLWCCntrl.csvFileRead';

const columns = [
    { label: 'Email', fieldName: 'Email' }, 
    { label: 'Status', fieldName: 'Status' },
    { label: 'Reason', fieldName: 'Reason'},
    { label: 'SuccessOrFailure', fieldName: 'SuccessOrFailure'}
];

export default class gDPRUpload extends LightningElement {
    casesSpinner = false;
   
    @api recordId;
    @track error;
    @track columns = columns;
    @track data;

    // accepted parameters
 // change isLoaded to the opposite of its current value
    handleClick() {
   // this.isLoaded = !this.isLoaded;
    }
    get acceptedCSVFormats() {
        console.log('hi');
        return ['.csv'];
    }
    
    uploadFileHandler(event) {
        this.casesSpinner = true;
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;
         
          console.log('uploadedFiles[0].documentId',uploadedFiles[0].documentId);
          console.log('uploadedFiles',uploadedFiles);
        // calling apex class csvFileread method
        csvFileRead({contentDocumentId : uploadedFiles[0].documentId})
        .then(result => {
            window.console.log('result ===> '+JSON.stringify(result));
            this.data = result;
            this.casesSpinner = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'All records inserted successfully.',
                    variant: 'Success',
                }),
            );
        })
        .catch(error => {
            this.error = error;
            this.casesSpinner = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}