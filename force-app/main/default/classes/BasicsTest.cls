/**
 * @description - Test class to run through basic apex classes for coverage
 */
@isTest
public with sharing class BasicsTest {
    @isTest static void testVariables() {
        Variables.primitiveVariables();
        Variables.sObjectVariables();
        Variables.collectionVariables();
        Variables.variablesWithConstants();
    }

    @isTest static void testConditionals() {
        Conditionals.ifStatements();
        Conditionals.ifElseStatements();
        Conditionals.switchStatements();
    }

    @isTest static void testLoops() {
        Loops.forLoopsBasics();
        Loops.soqlForLoops();
        Loops.whileLoops();
    }

    @isTest static void testQueries() {
        Queries.basicSOQL();
        Queries.relationshipSOQL();
        Queries.dynamicSOQL('Store__c', 97, 10);
        Queries.dynamicSOQL('Store_Supply_Order__c', 100, null);
        Queries.SOSL();
    }
}
