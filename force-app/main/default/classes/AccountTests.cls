@isTest
public with sharing class AccountTests {
    @isTest
    static void testPlatinumAccount() {
        Account acct = new Account(Name='Test Account', Quality_Rating__c=100);
        insert acct;

        Account acctAfterInsert = [SELECT Service_Level_Agreement__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Platinum', acctAfterInsert.Service_Level_Agreement__c, 'The SLA should be Platinum');
    
        update acctAfterInsert;
    }

    @isTest
    static void testGoldAccount() {
        Account acct = new Account(Name='Test Account', Quality_Rating__c=81);
        insert acct;

        Account acctAfterInsert = [SELECT Service_Level_Agreement__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Gold', acctAfterInsert.Service_Level_Agreement__c, 'The SLA should be Gold');
    }

    @isTest
    static void testSilverAccount() {
        Account acct = new Account(Name='Test Account', Quality_Rating__c=51);
        insert acct;

        Account acctAfterInsert = [SELECT Service_Level_Agreement__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Silver', acctAfterInsert.Service_Level_Agreement__c, 'The SLA should be Silver');
    }

    @isTest
    static void testBronzeAccount() {
        Account acct = new Account(Name='Test Account', Quality_Rating__c=31);
        insert acct;

        Account acctAfterInsert = [SELECT Service_Level_Agreement__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Bronze', acctAfterInsert.Service_Level_Agreement__c, 'The SLA should be Bronze');
    }
}
