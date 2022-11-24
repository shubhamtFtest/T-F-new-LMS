import mergeAcc from "@salesforce/apex/MergeAccountController.mergeAcc";
import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import fetchAccountsByIds from "@salesforce/apex/MergeAccountController.fetchAccountsByIds";
import getDataToAnalyze from "@salesforce/apex/MergeAccountController.getDataToAnalyze";

//Column for data table
const columns = [
    {
        label: 'Account name',
        fieldName: 'Name'
    },
    {
        label: 'Ringgold Id',
        fieldName: 'Ringgold_Account_ID__c'
    },
    {
        label: 'Party ID',
        fieldName: 'Customer_Id__c'
    },
    {
        label: 'Address',
        fieldName: 'Mailing_Country_List__c'
    }
];


const columnsChanged = [
    {
        label: 'Account Name',
        fieldName: 'name',
    },
    {
        label: 'Party ID',
        fieldName: 'party_id'
    },
    {
        label: 'Ringold ID',
        fieldName: 'ringgold_id'
    },
    {
        label: 'Contact List',
        fieldName: 'contactList',
    },
    {
        label: 'Active License',
        fieldName: 'activeLicenseCount'
    },
    {
        label: 'Child Accounts',
        fieldName: 'child_accounts'
    }
];


export default class FindAccount extends LightningElement {
    @track winningId = '';
    @track losingId = '';
    @track losingSearchData;
    @track winningSearchData;
    @track loading;
    @track columns = [];
    @track data = [];
    @track newWinning = [];
    @track newLosing = [];
    noDataFoundLosing = false;
    noDataFoundWinning = false;
    mergeVisible = true;
    confirmMerge = false;
    hasMergeData = '';
    hasMessage = '';
    @track accId1;
    @track accId2;
    @track showMe = false;

    constructor() {
        super();
        //this.template.querySelector('[.toastClose]').addEventListener('lightning__showtoast', this.handleToastEvent.bind(this));
     }


    swapRow() {
        this.template.querySelector('[data-accwin]').value = this.losingSearchData[0].Id;
        console.log(this.template.querySelector('[data-accwin]').value);
        this.template.querySelector('[data-acclose]').value = this.winningSearchData[0].Id;
        console.log(this.template.querySelector('[data-acclose]').value);
        
        let tempData = this.losingSearchData;
        this.losingSearchData = this.winningSearchData;
        this.winningSearchData = tempData;
        console.log(this.losingSearchData[0].message);
        this.winningId = this.winningSearchData[0].Id;
        this.losingId = this.losingSearchData[0].Id;

        console.log('check n'+this.winningSearchData[0].name);
        console.log('check N'+this.winningSearchData[0].Name);
        console.log('check done n'+this.losingSearchData[0].name);
        console.log('check N'+this.losingSearchData[0].Name);
        /*if(this.winningSearchData[0].name != undefined || this.winningSearchData[0].Name != undefined){
            this.noDataFoundWinning = false;
            //this.hasMergeData = "ERROR";
            //this.hasMessage = "Winning Account has no data."
        }else{
            this.noDataFoundWinning = true;
        }
        if(this.losingSearchData[0].name != undefined || this.losingSearchData[0].Name != undefined){
            this.noDataFoundLosing = false;
            //this.hasMergeData = "ERROR";
            //this.hasMessage = "Winning Account has no data."
        }else{
            this.noDataFoundLosing = true;
        }*/
    }

    handleSelect(event) {
        this.loading = true;
        this.mergeVisible = true;
        this.selectedAccount = event.target.value;
        console.log(event.target);
        const Id = event.target.value;
        console.log(Id);
        const label = event.target.dataset.name;
        console.log(label);
        this.noDataFoundWinning = false;
        this.noDataFoundLosing = false;
        let response;
        this.showMe = true;
        fetchAccountsByIds({ id: Id }).then(result => {
            this.columns = columns;
            console.log('Result---> ');
            console.log(result);
            if (label == 'winning') {
                this.winningSearchData = result;
                this.winningId = this.winningSearchData[0].Id;
                this.noDataFoundWinning = false;
            }
            else if (label == 'losing') {
                this.losingSearchData = result;
                this.losingId = this.losingSearchData[0].Id;
                this.noDataFoundLosing = false;
            }
            this.loading = false;
        }).catch(error => {
            console.log(error);
            this.loading = false;
        });
    }
    handleReset(){
        this.loading = true;
        this.losingSearchData = [];
        this.winningSearchData = [];
        this.losingId = '';
        this.winningId = '';
        this.newWinning = [];
        this.newLosing = [];
        this.template.querySelector('[data-accwin]').value = null;
        console.log(this.template.querySelector('[data-accwin]').value);
        this.template.querySelector('[data-acclose]').value = null;
        console.log(this.template.querySelector('[data-acclose]').value);
        this.loading = false;
        this.noDataFoundLosing = true;
        this.noDataFoundWinning = true;
        this.showMe = false;
        this.mergeVisible = true;
    }

    //To Handle Submit Button Action and find accounts
    handleSubmit() {
        this.loading = true;
        this.hasMergeData = this.losingSearchData[0].status;
        this.hasMessage = this.losingSearchData[0].message;
        console.log('In this');
        console.log(JSON.stringify(this.losingSearchData));
        //let message = 'Losing Account can not contain data';
        /*if(this.hasMessage != ''){
            message = this.hasMessage;
        }else{
            message = 'Losing Account can not contain data';
        }*/
        //alert('Merge Done')
        if( (this.losingSearchData[0].activeLicenseCount != 0 || this.losingSearchData[0].child_accounts != 0 || this.losingSearchData[0].contactList != 0) && (this.losingSearchData[0].activeLicenseCount != null || this.losingSearchData[0].child_accounts != null || this.losingSearchData[0].contactList != null)){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Merging record',
                    message: 'Losing Account cannot contain data.',
                    variant: 'error',
                    mode: 'sticky'
                }),
            );
            this.loading = false;
            return;
        }
        if(this.hasMergeData == 'ERROR'){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Merging record',
                    message: this.hasMessage,
                    variant: 'error',
                    mode: 'sticky'
                }),
            );
            this.loading = false;
            return;
        }
        

        mergeAcc({ masterId: this.winningId, dupesId: this.losingId }).then(result => {
            console.log('result is ' + result);
            let response = JSON.parse(result);
            //alert('Your merge is successfully completed');
            this.loading = false;
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Success! Your account has been merged',
                variant: 'Success',
                mode: 'sticky'
            });
            if(response.status != "ERROR"){
                this.dispatchEvent(evt);
                this.winningSearchData = [];
                this.losingSearchData = [];
                this.newWinning = [];
                this.newLosing = [];
                this.mergeVisible = true;
                this.columns = [];
                this.showMe = false;
                this.noDataFoundLosing = false;
                this.noDataFoundWinning = false;
                this.template.querySelector('[data-accwin]').value = '';
                console.log(this.template.querySelector('[data-accwin]').value);
                this.template.querySelector('[data-acclose]').value = '';
                console.log(this.template.querySelector('[data-acclose]').value);
            }
            else{
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: response.message,
                    variant: 'Error',
                    mode: 'sticky'
                });
                this.dispatchEvent(evt);
            }
        }).catch(error => {
            //alert('These Ids cannot be merged!');
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Oops! Something went wrong. Please try again later.',
                variant: 'Error',
                mode: 'sticky'
            });
            this.dispatchEvent(evt);
            //console.log(error);
            this.loading = false;
        })
    }


    handleSearchedData() {
        this.loading = true;

        if (this.winningSearchData[0].Id === this.losingSearchData[0].Id) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Merging record',
                    message: 'Same Ids Cannot be Merged',
                    variant: 'error',
                    mode: 'sticky'
                }),
            );
            this.loading = false;
            this.refreshComponent();
            return;
        }
        else {
            this.newWinning = [];
            this.newLosing = [];
            getDataToAnalyze({ id: this.winningSearchData[0].Id, partyId: this.winningSearchData[0].Customer_Id__c, ringgoldId: this.winningSearchData[0].Ringgold_Account_ID__c,status:'1' }).then(result => {
                console.log('result---  '+result);
                if (result) {
                    this.newWinning.push(JSON.parse(result));
                    if(this.newWinning[0].status == "SERVER ERROR"){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title:'Error',
                                message: "Sorry, We Screwed Up. API is not working",
                                variant: 'error',
                                mode: 'sticky'
                            }),
                        );
                        return;
                    }
                    else{
                        this.noDataFoundWinning = false;
                        this.columns = columnsChanged;
                        
                        console.log('new winning');
                        console.log(this.newWinning.length);
                        this.mergeVisible = false;
                        if (this.newWinning.length > 0) {
                            if(this.newWinning[0].status == "BLANK"){
                                this.newWinning[0].Name = undefined;
                                this.newWinning[0].status = "SUCCESS";
                                this.winningSearchData[0].Name = undefined;
                                this.newWinning[0].name = '';
                                this.newWinning[0].party_id = '';
                                //this.noDataFoundWinning = true;
                                //this.hasMergeData = "ERROR";
                                
                                this.winningSearchData = this.newWinning;
                                //this.hasMessage = "Winning Account has no data."
                            }else{
                                this.noDataFoundWinning = false;
                                console.log(JSON.parse(result));
                                this.winningSearchData = this.newWinning;
                            }
                            
                            console.log('Winning Length');
                            console.log(this.winningSearchData.length);
                            
                        }
                        else {
                            this.noDataFoundWinning = true;
                        }

                
                    }
                }
            }).catch(error => {
                //alert('These Ids cannot be merged!');
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Please try again later',
                    variant: 'Error',
                    mode: 'sticky'
                });
                this.dispatchEvent(evt);

            });

            getDataToAnalyze({ id: this.losingSearchData[0].Id, partyId: this.losingSearchData[0].Customer_Id__c, ringgoldId: this.losingSearchData[0].Ringgold_Account_ID__c,status:'2' }).then(result => {
                console.log(result);
                console.log(JSON.parse(result));
                if (result) {
                    this.newLosing.push(JSON.parse(result));
                    if(this.newLosing[0].status == "SERVER ERROR"){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title:'Error',
                                message: "Sorry, We Screwed Up. API is not working",
                                variant: 'error',
                                mode: 'sticky'
                            }),
                        );
                        this.loading = false;
                        return;
                    }
                    else{
                        this.columns = columnsChanged;
                        var data = JSON.parse(result);
                        this.hasMergeData = data.status;
                        this.hasMessage = data.message;
                        console.log(this.hasMergeData);
                        console.log(data);
                        console.log('new losing data');
                        console.log(this.newLosing);
                        this.loading = false;
                        this.mergeVisible = false;
                        if (this.newLosing.length > 0) {
                            if(this.newLosing[0].status == "BLANK"){
                                this.losingSearchData[0].Name = undefined;
                                this.newLosing[0].Name = undefined;
                                this.newLosing[0].name = '';
                                this.newLosing[0].party_id = '';
                                this.newLosing[0].status = "SUCCESS";
                                this.losingSearchData = this.newLosing;
                                //this.hasMergeData = "ERROR";
                                //this.hasMessage = "Losing Account has no data."
                                console.log(this.hasMergeData);
                                //this.noDataFoundLosing = true;
                            }else{
                                this.noDataFoundLosing = false;
                                this.losingSearchData = this.newLosing;
                            }
                            console.log(this.losingSearchData.length);
                        }
                        else {
                            this.noDataFoundLosing = true;
                        }
                    }
                }
            }).catch(error => {
                //alert('These Ids cannot be merged!');
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Please Try Again Later',
                    variant: 'Error',
                    mode: 'sticky'
                });
                this.dispatchEvent(evt);
                this.loading = false;
            });

        }

    }



    refreshComponent(){
        console.log(this.template.querySelector('lightning-primitive-icon'));
        console.log(this.template.querySelector('.toastClose'));
        console.log(document.querySelector('.toastClose'));

        /*document.querySelector('.toastClose').addEventListener('click',function(){
            alert('Hell');
        })
        this.template.querySelector('.toastClose').addEventListener('click',function(){
            alert('Hi');
        })*/
    }



    






}