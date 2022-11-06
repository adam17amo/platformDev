/**
 * @author - Adam Olshansky
 * @description - Custom Controller to be used for a Visualforce page on Store records
 */
public without sharing class StoreCustomController {
    public final Store__c currentStore {get; set;}
    public String name {get; set;}
    public String buzzId {get; set;}
    public String city {get; set;}
    public String stateProvince {get; set;}
    public String country {get; set;}

    /**
     * @description - Constructor for Visualforce controller.
     * Specifies the store record being used by the page based on the id parameter
     */
    public StoreCustomController() {
        Id idFromUrl = ApexPages.currentPage().getParameters().get('id');
        if(idFromUrl != null) {
            this.currentStore = [SELECT Id, Name, Buzz_Id__c, City__c, State_Province__c, Country__c
                                FROM Store__c
                                WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            this.name = this.currentStore.Name;
            this.buzzId = this.currentStore.Buzz_Id__c;
            this.city = this.currentStore.City__c;
            this.stateProvince = this.currentStore.State_Province__c;
            this.country = this.currentStore.Country__c;
        } else {
            this.currentStore = new Store__c();
        }
    }

    /**
     * @description - Custom save action to check a user's access before saving
     * @return - A reference to the Store record detail page to be redirected to
     */
    public PageReference save() {
        // Check if the user has access to create and update stores
        if(Schema.sObjectType.Store__c.isCreateable() &&
            Schema.sObjectType.Store__c.isUpdateable()) {
            this.currentStore.Name = this.name;
            this.currentStore.Buzz_Id__c = this.buzzId;
            this.currentStore.City__c = this.city;
            this.currentStore.State_Province__c = this.stateProvince;
            this.currentStore.Country__c = this.country;
            upsert this.currentStore;
            return new PageReference('/' + this.currentStore.Id);
        }
        // Send an error message to the page
        ApexPages.Message failureMessage = new ApexPages.Message(ApexPages.Severity.ERROR,
                                            'User does not have access to create or edit a store');
        ApexPages.addMessage(failureMessage);
        return null;
    }

    /**
     * @description - Custom cancel action
     * @return - A reference to the Store tab to be redirected to
     */
    public PageReference cancel() {
        return new PageReference('/lightning/o/Store__c/home');
    }
}
