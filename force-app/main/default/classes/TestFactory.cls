@isTest
public with sharing class TestFactory {

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
}
