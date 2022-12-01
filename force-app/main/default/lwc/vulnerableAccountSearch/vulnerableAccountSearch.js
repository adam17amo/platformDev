import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountUtility.getAccountsForSearch';

const cols = [
    { label: 'Name', fieldName: 'Name', type: 'string' },
    { label: 'Annual Revenue', fieldName: 'AnnualRevenue', type: 'string' },
    { label: 'Priority', fieldName: 'Customer_Priority__c', type: 'string' }
];

export default class VulnerableAccountSearch extends LightningElement {
    searchTerm = '';
    columns = cols;
    error;

    @wire(getAccounts, { searchTerm: '$searchTerm' })
    newAccountList = [];

    // Update the change in search term
    handleSearchTermChange(event) {
        /* Debouncer to wait 300ms in between updating searchTerm to allow the user 
        to finish typing their input and avoid making unnecessary calls to Apex */
        window.clearTimeout(this.delayTimeout);
        const userInput = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = userInput;
        }, 300);
    }
}