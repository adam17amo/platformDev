/**
 * @author - Adam Olshansky
 * @description - Controller Extension to be used for a Visualforce page on Lead records
 */
public with sharing class LeadControllerExtension {
    
    public final Lead currentLead {get; set;}
    private final String pageType = 'Controller Extension';
    public Boolean greetingToggle {get; set;}
    public Integer sampleCount {get; set;}

    /**
     * @description - Constructor for Visualforce controller extension.
     * Retrieves the record being used for the page
     */
    public LeadControllerExtension(ApexPages.StandardController leadController) {
        this.currentLead = (Lead)leadController.getRecord();
        this.greetingToggle = true;
        this.sampleCount = 0;
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
        return [SELECT Id, FirstName, LastName, Email, Company, LeadSource, Rating FROM Lead
                WHERE Status IN ('Open - Not Contacted', 'Working - Contacted')
                ORDER BY FirstName];
    }

    /**
     * @description - Checks whether or not the details of a Lead match an existing Contact
     */
    public void validateLeadInfo() {
        Integer dupeContactsCount = [SELECT count() FROM Contact
                                    WHERE FirstName = :this.currentLead.FirstName
                                    AND LastName = :this.currentLead.LastName
                                    AND Account.Name = :this.currentLead.Company
                                    AND Email = :this.currentLead.Email];
        if(dupeContactsCount > 0) {
            // Send an error message to the page
            ApexPages.Message failureMessage =
                        new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate contact found');
            ApexPages.addMessage(failureMessage);
        }
    }

    /**
     * @description - Toogle the greeting flipping it from true to false or back to true
     */
    public void toggleGreeting() {
        this.greetingToggle = !this.greetingToggle;
    }

    /**
     * @description - Increment the sample counter
     */
    public PageReference incrementSampleCounter() {
        this.sampleCount++;
        return null;
    }
}
