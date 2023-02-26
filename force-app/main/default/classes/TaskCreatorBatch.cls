/**
 * @author - Adam Olshansky
 * @description - Batch class to create tasks for open cases that have been open for too long
 */
public with sharing class TaskCreatorBatch implements Database.Batchable<sObject>, Database.Stateful{
    public final String query;
    public final Integer threshold;
    public final Boolean throwNewException;
    // The total number of tasks created across all batches
    public Integer totalTasksCreated = 0;

    public class TaskBatchException extends Exception{}

    /**
     * @description - Constructor to specify a threshold and whether an exception should be thrown 
     * @param thresholdDays The number of days in the past to check for open cases
     * @param throwException Boolean specifying whether or not an exception should be thrown
     */
    public TaskCreatorBatch(Integer thresholdDays, Boolean throwException) {
        threshold = thresholdDays;
        throwNewException = throwException;
        query = 'SELECT Id,' +
                        'CaseNumber,' +
                        'Subject,' +
                        'CreatedDate,' + 
                        'Priority,' + 
                        'Status, ' + 
                        'OwnerId ' +
                'FROM Case ' +
                'WHERE ' +
                    'IsClosed = false ' +
                    'AND CreatedDate < LAST_N_DAYS:' + thresholdDays;
        System.debug('In constructor, query is ' + query);
    }

    /**
     * @description - Start method to run the query
     * @param bc Batchable context that's part of the interface
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('In start method');
        return Database.getQueryLocator(query);
    }

    /**
     * @description - Execute method to create the tasks
     * @param bc Batchable context that's part of the interface
     * @param scope List of open cases that were the result of the query
     */
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        System.debug('In execute method with scope size ' + scope.size());
        try {
            if(throwNewException) {
                throw new TaskBatchException();
            }
            List<Task> tasksToCreate = new List<Task>();
            for(sObject obj : scope) {
                Case openCase = (Case)obj;
                System.debug('Open case is ' + openCase);
                Task newTask = createNewTask(openCase);
                tasksToCreate.add(newTask);
            }
            System.debug('Tasks to insert size ' + tasksToCreate);
            totalTasksCreated += tasksToCreate.size();
            
            System.debug('Total tasks created updated to ' + totalTasksCreated);
            insert tasksToCreate;
        } catch(Exception e) {
            System.debug('Exception was thrown');
        }
    }

    /**
     * @description - Finish method to summarize all executions 
     * @param bc Batchable context that's part of the interface
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('In finish method having created ' + totalTasksCreated + ' tasks');
    }

    /**
     * @description - Method to create a task based on a case
     * @param openCase The case whose details will be used to create the case
     * @return A new task based on the case that has been open for too long
     */
    private Task createNewTask(Case openCase) {
        System.debug('Creating new task for case number ' +
                    openCase.CaseNumber + ';' + openCase.Subject);
        Task newTask = new Task();
        newTask.OwnerId = openCase.OwnerId;
        newTask.WhatId = openCase.Id;
        newTask.Status = 'In Progress';
        newTask.Subject = 'Other';
        newTask.Priority = 'High';
        newTask.Description = 'This case has been open for more than ' + threshold + ' days';
        return newTask;
    }
}