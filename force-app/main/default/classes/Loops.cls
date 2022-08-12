/**
 * @description - Class to be used for demonstrating how to use loops
 */
public with sharing class Loops {
    /**
     * @description - Examples of how to use for loops
     */
    public static void forLoopsBasics() {
        List<Integer> numberList = new List<Integer>{1,2,3,4,5};
        Integer total = 0;
        /* i is a placeholder variable in this traditional for loop
          i = 0 is the starting point,
          the loop will keep going until i < 5 is not true,
          i++ means increase i by 1 each round
        */
        for(Integer i = 0; i < 5; i++) {
            // Total will add the new value of i for each loop execution
            total = total + numberList[i];
            System.debug('Total has been updated to ' + total);
        }
        System.debug('Final total is ' + total); // Should be 15

        Store_Supply_Order__c orderOne = new Store_Supply_Order__c(Order_Amount__c=10000);
        Store_Supply_Order__c orderTwo = new Store_Supply_Order__c(Order_Amount__c=20000);
        Store_Supply_Order__c orderThree = new Store_Supply_Order__c(Order_Amount__c=30000);
        List<Store_Supply_Order__c> orderList = new List<Store_Supply_Order__c>();
        orderList.add(orderOne);
        orderList.add(orderTwo);
        orderList.add(orderThree); 

        Decimal orderTotal = 0.00;

        /* Collection syntax for loop, using a temporary placeholder and a collection to loop through
          Loop will exit when list has been exhausted
        */
        for(Store_Supply_Order__c order : orderList) {
            // Update the orderTotal with each new order's orderAmount
            orderTotal += order.Order_Amount__c;
            System.debug('Updated order total is ' + orderTotal);
        }
        System.debug('Total order amount is ' + orderTotal); // Should be 60,000
    }

    /**
     * @description - Examples of how to use SOQL for loops
     */
    public static void soqlForLoops() {
        Decimal orderTotal = 0.00;
        // SOQL in a for loop is ok if it's in the signature so it will only execute once
        for(Store_Supply_Order__c order : [SELECT Id, Name, Order_Amount__c FROM Store_Supply_Order__c]){
            // Update the orderTotal with each new order's orderAmount
            orderTotal += order.Order_Amount__c;
            System.debug('This order is ' + order.Name + ' with an amount of ' + order.Order_Amount__c);
            System.debug('Updated order total is ' + orderTotal);
        }
        System.debug('Total order amount is ' + orderTotal); // Will differ depending on orders in your org
    }

    /**
     * @description - Examples of how to use while loops
     */
    public static void whileLoops() {
        List<Integer> budgetExpenses = new List<Integer>{100000, 75000, 25000, 50000, 50000, 100000};
        Integer totalBudget = 300000;
        Integer expenseCounter = 0;

        // While statement will execute as long as condition is true
        while(totalBudget > 0 && expenseCounter < budgetExpenses.size()) {
            // Updated total budget subtracts the next expense in the list
            totalBudget = totalBudget - budgetExpenses[expenseCounter];
            System.debug('Expense counter is ' + expenseCounter);
            System.debug('After subtracting ' + budgetExpenses[expenseCounter]
                        + ', updated budget is ' + totalBudget);
            // Remember to increase expenseCounter each time
            expenseCounter++;
        }
        System.debug('After exhausting budget, ' + expenseCounter + ' expenses were made'); // Should be 5
        System.debug('Total budget is now ' + totalBudget); // Should be 0

        Integer counter = 10;
        while(counter < 10) {
            counter++;
            // This should not run if counter >= 10
            System.debug('Counter in while loop is ' +  counter);
        }

        do {
            counter++;
            // This will run once if counter >= 10
            System.debug('Counter in do while loop is ' + counter);
        } while(counter < 10);
    }
}
