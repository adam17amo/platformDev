/**
 * @description - Class to be used for demonstrating how to use conditional statements
 */
public with sharing class Conditionals {
    /**
     * @description - Examples of isolated if statements
     */
    public static void ifStatements() {
        Boolean trueVariable = true;
        if(trueVariable == true) {
            System.debug('This should print but 2 equal signs are needed');
        }
        if(trueVariable) {
            System.debug('This should also print as equal signs are implied');
        }
        if(!trueVariable) {
            System.debug('This should not print since ! is the NOT operator');
        }
    }

    /**
     * @description - Examples of if/else statements
     */
    public static void ifElseStatements() {
        Integer orderAmount = 100000;
        Account supplier = new Account(Name='San Francisco Hub');

        // If/else with multiple conditions
        if(orderAmount > 500000) {
            supplier.Rating = 'Hot';
            System.debug('This should not be reached');
        } else if(orderAmount >= 100000) {
            supplier.Rating = 'Medium';
            System.debug('This should be the only block that runs');
        } else {
            supplier.Rating = 'Low';
            System.debug('Will only execute if all conditions fail');
        }
        System.debug('Supplier is ' + supplier);

        // If/else with only one condition
        if(supplier.Name == 'San Francisco Hub') {
            System.debug('SF Hub has its own logic');
        } else {
            System.debug('All other stores will follow this logic');
        }
    }

    /**
     * @description - Examples of switch statements
     */
    public static void switchStatements() {
        // Change the value of the coin flip to see the different results
        String coinFlip = 'heads';
        switch on coinFlip {
            when 'tails' {
                System.debug('Tails never fails');
            } when 'heads' {
                System.debug('Except when it does, your coinflip was heads!');
            } when else {
                System.debug('What kind of coin are you flipping???');
            }
        }

        // Pick a number 1-10 to see the output
        Integer pickedNumber = 7;
        switch on pickedNumber {
            when 1, 3, 5, 7, 9 {
                System.debug('You chose an odd number');
            } when 2, 4, 6, 8, 10 {
                System.debug('You chose an even number');
            } when else {
                System.debug('Please guess a valid number');
            }
        }
    }
}
