// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// Script for the Schema class
// Get all object info
System.debug('Global describe ' + Schema.getGlobalDescribe());

// Get info for specific object
System.debug('Store info ' + Schema.describeSObjects(new List<String>{'Store__c'}));

// Get relationships for specific object
List<Schema.ChildRelationship> relationships = Schema.sObjectType.Store__c.getChildRelationships();
for(Schema.ChildRelationship rel : relationships) {
    System.debug('Relationship is ' + rel);
}

// Get fields for specific objects
System.debug('Fields for Store ' + Schema.sObjectType.Store__c.fields.getMap());

// Get details for specific field
System.debug('Store Country details ' + Store__c.Country__c.getDescribe());

// Get labels and values for Store Country
List<Schema.PicklistEntry> picklistValues = Store__c.Country__c.getDescribe().getPicklistValues();
for(Schema.PicklistEntry pe : picklistValues) {
    System.debug('Label is ' + pe.getLabel() + ' and value is ' + pe.getValue());
}