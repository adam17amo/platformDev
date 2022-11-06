/**
 * @author - Adam Olshansky
 * @description - Custom Controller to be used for a Visualforce page on Lead records
 */
public with sharing class LeadCustomController {
    public final Lead currentLead {get; set;}
    private final String pageType = 'Custom Controller';
    List<Lead> leads;

    /**
     * @description - Constructor for Visualforce controller.
     * Specifies the lead record being used by the page based on the id parameter
     */
    public LeadCustomController() {
        Id idFromUrl = ApexPages.currentPage().getParameters().get('id');
        if(idFromUrl != null) {
            this.currentLead = [SELECT Id, FirstName, LastName, Email, Company, LeadSource, Rating FROM Lead 
                    WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        } else {
            this.currentLead = new Lead();
        }
    }

    /**
     * @description - Getter for pageType
     * @return - Gets the value of the page type variable
     */
    public String getPageType() {
        return this.pageType;
    }

    /**
     * @description - Get all open Leads in the org
     * @return - List of open leads in the org sorted by first name
     */
    public List<Lead> getLeads() {
        leads = [SELECT Id, FirstName, LastName, Email, Company, LeadSource, Rating FROM Lead
                WHERE Status IN ('Open - Not Contacted', 'Working - Contacted')
                ORDER BY FirstName];
        return leads;
    }

    /**
     * @description - Custom save action to perform a validation check before saving
     * @return - A reference to the Lead record detail page to be redirected to
     */
    public PageReference save() {
        if(validateLeadInfo()) {
            upsert this.currentLead;
            return new PageReference('/' + this.currentLead.Id);
        }
        return null;
    }

    /**
     * @description - Custom cancel action
     * @return - A reference to the Lead tab to be redirected to
     */
    public PageReference cancel() {
        return new PageReference('/lightning/o/Lead/home');
    }

    /**
     * @description - Checks whether or not the details of a Lead match an existing Contact
     * @return - Boolean specifying whether or not there is a duplicate Contact for the Lead
     */
    private Boolean validateLeadInfo() {
        Integer dupeContactsCount = [SELECT count() FROM Contact
                                    WHERE FirstName = :this.currentLead.FirstName
                                    AND LastName = :this.currentLead.LastName
                                    AND Account.Name = :this.currentLead.Company
                                    AND Email = :this.currentLead.Email];
        if(dupeContactsCount == 0) {
            return true;
        }
        // Send an error message to the page
        ApexPages.Message failureMessage =
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate contact found');
        ApexPages.addMessage(failureMessage);
        return false;
    }
}
