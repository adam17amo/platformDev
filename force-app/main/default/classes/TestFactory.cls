/**
 * @author - Adam Olshansky
 * @description - Test Factory to create commonly used data for tests
 */
@isTest
public with sharing class TestFactory {

    /**
     * @description - Create test accounts
     * @param accountsToCreate The number of test accounts to create
     * @param performDml Determines whether or not DML should fire here
     * @return List of accounts for testing
     */
    public static List<Account> createAccounts(Integer accountsToCreate, Boolean performDml) {
        List<Account> newAccounts = new List<Account>();
        for(Integer i = 0; i < accountsToCreate; i++) {
            Account acct = new Account();
            acct.Name = 'Account ' + i;
            acct.AnnualRevenue = 10000;
            acct.Customer_Priority__c = 'High';
            newAccounts.add(acct);
        }
        if(performDml) {
            insert newAccounts;
        }
        return newAccounts;
    }
    
    /**
     * @description - Create a test user
     * @param profileName The number of the profile the test user should have
     * @param performDml Determines whether or not DML should fire here
     * @return New user for testing
     */
    public static User createUser(String profileName) {
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = :profileName];
        User u = new User(
            FirstName = 'Tom',
            LastName = 'Snape',
            ProfileId = userProfile.Id,
            Email = 'tsnape@wiredbrain.com',
            Username = 'tsnape@wiredbrain.com',
            CompanyName = 'Wired Brain Coffee',
            Title = 'Retail Employee',
            Alias = 'tsnape',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        return u;
    }

    /**
     * @description - Create test stores
     * @param storesToCreate The number of test stores to create
     * @param performDml Determines whether or not DML should fire here
     * @return List of stores for testing
     */
    public static List<Store__c> createStores(Integer storesToCreate, Boolean performDml) {
        List<Store__c> newStores = new List<Store__c>();
        for(Integer i = 0; i < storesToCreate; i++) {
            Store__c store = new Store__c();
            store.Name = 'San Francisco Hub ' + i;
            store.Latest_Health_Score__c = 100;
            store.Customer_Satisfaction_Score__c = 90.00;
            store.Date_of_Establishment__c = Date.today().addYears(-1);
            store.Street__c = '123 Sesame St.';
            store.City__c = 'San Francisco';
            store.State_Province__c = 'CA';
            store.Zip_Postal_Code__c = '95102';
            store.Country__c = 'United States';
            store.Buzz_Id__c = 'WBC00' + (i+1);
            newStores.add(store);
        }
        if(performDml) {
            insert newStores;
        }
        return newStores;
    }

    /**
     * @description - Create test cases
     * @param casesToCreate The number of test cases to create
     * @param performDml Determines whether or not DML should fire here
     * @return List of cases for testing
     */
    public static List<Case> createCases(Integer casesToCreate, Boolean performDml) {
        List<Case> newCases = new List<Case>();
        for(Integer i = 0; i < casesToCreate; i++) {
            Case newCase = new Case();
            newCase.Subject = 'Issue Identified';
            newCase.Status = 'New';
            newCase.Priority = 'High';
            newCases.add(newCase);
        }
        if(performDml) {
            insert newCases;
        }
        return newCases;
    }
}
