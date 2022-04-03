import { LightningElement, track, api, wire } from 'lwc';
import getOpenCases from '@salesforce/apex/StoreControllerExt.getOpenCasesWithId';
import { getRecord } from 'lightning/uiRecordApi';
import STORE_NAME_FIELD from '@salesforce/schema/Store__c.Name';
import USER_ID from '@salesforce/user/Id';
import USER_FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';
import { refreshApex } from '@salesforce/apex';
import { subscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Subject', fieldName: 'Subject' },
    { label: 'Status', fieldName: 'Status', type: 'string'},
    { label: 'Priority', fieldName: 'Priority', type: 'string'},
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
];

export default class StoreCaseDetails extends LightningElement {
    @track greeting;
    @track currentStatus;
    @track caseList;
    @track caseListForRefresh;
    columns = columns;
    @api recordId;
    @track record;
    firstName;
    error;
    subscription = {};
    CHANNEL_NAME = '/event/Customer_Satisfaction_Update__e';

    connectedCallback() {
        // Listen for Customer Satisfaction Update Platform Events
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            console.error('Server Error in callback ' + error);
        });
    }

    refreshList = ()=> {
        // Update list of store cases
        refreshApex(this.caseListForRefresh);
    }

    // Get the user's details and update the greeting
    @wire(getRecord, {recordId: USER_ID, fields: [USER_FIRST_NAME_FIELD]}) 
    wireUser({ error,data}) {
        if (data) {
            this.firstName = data.fields.FirstName.value;
            this.greeting = 'Hello ' + this.firstName + '!';
        } else if (error) {
            this.error = error;
        }
    }

    // Get the store details and update the current status message
    @wire(getRecord, { recordId: '$recordId', fields: [STORE_NAME_FIELD] })
    store({ error, data }) {
        if (data) {
            this.record = data;
            this.error = undefined;
            this.currentStatus = 'You are viewing the ' + this.name + ' Store Case List in a Lightning Web Component.';
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

    get name() {
        return this.record.fields.Name.value;
    }

    // Retreive the store's cases from Apex
    @wire(getOpenCases, { storeId: '$recordId' })
    wiredCases(value) {
        // Hold on to the provisioned value so we can refresh it later
        this.caseListForRefresh = value;
        // Show a toast for any new cases
        if(this.caseList) {
            this.showToast();
        }
        // Destructure the provisioned value 
        const { data, error } = value;
        if (data) {
            // Map the data in the datatable
            let caseData = [];
            data.forEach(element => {
                let tableRow = {};
                tableRow.Subject = element.Subject;
                tableRow.Status = element.Status;
                tableRow.Priority = element.Priority;
                tableRow.CreatedDate =  element.CreatedDate;
                caseData.push(tableRow);
            });
            this.caseList = caseData;
        } else if (error) {
            this.error = error;
        }
    }
    
    // Show a success toast for new cases
    showToast() {
        const toast = new ShowToastEvent({
            title: 'New Case',
            message: 'Cases have been updated!',
            variant: 'success',
        });
        this.dispatchEvent(toast);
    }
}