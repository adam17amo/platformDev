trigger AccountTrigger on Account (before insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        for(Account acct : Trigger.new) {
            // Set the Service Level Agreement based on the Quality Rating
            if(acct.Quality_Rating__c == 100) {
                acct.Service_Level_Agreement__c = 'Platinum';
            } else if(acct.Quality_Rating__c > 80) {
                acct.Service_Level_Agreement__c = 'Gold';
            } else if(acct.Quality_Rating__c > 50) {
                acct.Service_Level_Agreement__c = 'Silver';
            } else if(acct.Quality_Rating__c > 0) {
                acct.Service_Level_Agreement__c = 'Bronze';
            } else if(acct.Quality_Rating__c == 0) {
                acct.Service_Level_Agreement__c = 'Blue';
            } else {
                acct.Service_Level_Agreement__c = null;
            }
            System.debug('Set SLA to ' + acct.Service_Level_Agreement__c);
        }
    } else if(Trigger.isAfter & Trigger.isUpdate) {
        // SOQL query needed to get record since records can't be directly updated in an after trigger
        List<Account> newAccounts = [SELECT Name, Quality_Rating__c, Service_Level_Agreement__c
                                    FROM Account
                                    WHERE Id IN :Trigger.new];
        List<Account> accountsToUpdate = new List<Account>();
        for(Account acct : newAccounts) {
            // Confirm the Quality Rating has been changed to 100 and set the SLA
            if(acct.Quality_Rating__c == 100 &&
                Trigger.oldMap.get(acct.Id).Quality_Rating__c != 100) {
                acct.Service_Level_Agreement__c = 'Platinum';
                accountsToUpdate.add(acct);
                System.debug('Setting Account ' + acct.Name + ' to Platinum');
            }
        }
        update accountsToUpdate;
    }
}