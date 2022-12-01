@isTest
public with sharing class LeadTests {
    @testSetup
    static void createData() {
        List<Lead> newLeads = new List<Lead>();

        Lead newLead = new Lead();
        newLead.FirstName = 'Taylor';
        newLead.LastName = 'Fast';
        newLead.Company = 'Midnight Records';
        newLead.Email = 'tfast13@midnight.com';
        newLead.Status = 'Working - Contacted';
        newLeads.add(newLead);

        for(Integer i = 0; i < 5; i++) {
            Lead extraLead = new Lead();
            extraLead.FirstName = 'Lead ' + i;
            extraLead.LastName = 'Vader';
            extraLead.Company = 'Astro Stars Inc';
            extraLead.Email = 'vader' + i + '@stars.com';
            extraLead.Status = 'Open - Not Contacted';
            newLeads.add(extraLead);
        }

        insert newLeads;
    }

    // Create an Account and a Contact
    private static void createSupplementalData() {
        Account newAccount = new Account(Name = 'Midnight Records');
        insert newAccount;
        Contact newContact = new Contact();
        newContact.FirstName = 'Taylor';
        newContact.LastName = 'Quick';
        newContact.Email = 'tfast13@midnight.com';
        newContact.AccountId = newAccount.Id;
        insert newContact;
    }

    @isTest
    static void customControllerTest() {
        Lead currentLead = [SELECT Id FROM Lead WHERE FirstName = 'Taylor' LIMIT 1];
        PageReference pageRef = Page.LeadCreateCustom;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', currentLead.Id);
      
        Test.startTest();
        LeadCustomController controller = new LeadCustomController();
        Assert.areEqual(currentLead.Id, controller.currentLead.Id,
                    'The controller should have the right lead record');

        Assert.areEqual('Custom Controller', controller.getPageType(), 
                        'The controller should have the page type Custom Controller');

        List<Lead> existingLeads = [SELECT Id FROM Lead
                                    WHERE Status IN ('Open - Not Contacted', 'Working - Contacted')];
        Assert.areEqual(existingLeads.size(), controller.getLeads().size(),
                        'The controller should return all the leads in the given statuses');

        PageReference saveRedirect = controller.save();
        Assert.areEqual('/' + currentLead.Id, saveRedirect.getUrl(),
                        'The controller should return the record page of the current Lead');

        PageReference cancelRedirect = controller.cancel();
        Assert.areEqual('/lightning/o/Lead/home', cancelRedirect.getUrl(),
                        'The controller should return the Lead home page');

        
        Test.stopTest();
    }

    @isTest
    static void testValidateLeadInfoCustomController() {
        createSupplementalData();
        
        Lead currentLead = [SELECT Id FROM Lead WHERE FirstName = 'Taylor' LIMIT 1];
        PageReference pageRef = Page.LeadCreateCustom;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', currentLead.Id);
        Assert.isFalse(ApexPages.hasMessages(), 'There should be no messages');
      
        Test.startTest();
        LeadCustomController controller = new LeadCustomController();
        // Make the Lead's last name match an existing Contact
        controller.currentLead.LastName = 'Quick';
        PageReference saveWithDupe = controller.save();
        Assert.isNull(saveWithDupe, 'The controller should return null with a duplicate');
        Assert.isTrue(ApexPages.hasMessages(ApexPages.Severity.ERROR), 'There should be an error message on the page');
        Test.stopTest();
    }

    @isTest
    static void controllerExtensionTest() {
        Lead currentLead = [SELECT FirstName, LastName, Company, Email FROM Lead
                            WHERE FirstName = 'Taylor' LIMIT 1];
        PageReference pageRef = Page.LeadCreateExtension;
        Test.setCurrentPage(pageRef);
      
        Test.startTest();
        LeadControllerExtension extension = new LeadControllerExtension(new ApexPages.StandardController(currentLead));

        Assert.isTrue(extension.greetingToggle, 'Toggle should be true to start');
        Assert.areEqual(0, extension.sampleCount, 'Sample count should be 0 to start');
        Assert.areEqual('Controller Extension', extension.getPageType(),
                    'The extension should have the page type Controller Extension');
        List<Lead> existingLeads = [SELECT Id FROM Lead
                                    WHERE Status IN ('Open - Not Contacted', 'Working - Contacted')];
        Assert.areEqual(existingLeads.size(), extension.getLeads().size(),
                        'The extension should return all the leads in the given statuses');
        extension.toggleGreeting();
        Assert.isFalse(extension.greetingToggle, 'Toggle should be false after the method call');
        extension.incrementSampleCounter();
        Assert.areEqual(1, extension.sampleCount, 'Sample count should be increased to 1');
        Test.stopTest();
    }

    @isTest
    static void testValidateLeadInfoControllerExtension() {
        createSupplementalData();
        
        Lead currentLead = [SELECT FirstName, LastName, Company, Email
                            FROM Lead WHERE FirstName = 'Taylor' LIMIT 1];
        PageReference pageRef = Page.LeadCreateExtension;
        Test.setCurrentPage(pageRef);
        Assert.isFalse(ApexPages.hasMessages(), 'There should be no messages');
      
        Test.startTest();
        LeadControllerExtension extension = new LeadControllerExtension(new ApexPages.StandardController(currentLead));

        // Make the Lead's last name match an existing Contact
        extension.currentLead.LastName = 'Quick';
        extension.validateLeadInfo();
        Assert.isTrue(ApexPages.hasMessages(ApexPages.Severity.ERROR), 'There should be an error message on the page');
        Test.stopTest();
    }
}
