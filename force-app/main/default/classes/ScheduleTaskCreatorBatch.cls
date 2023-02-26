/**
 * @author - Adam Olshansky
 * @description - Schedulable job for calling the TaskCreatorBatch class
 * Use this string to run daily at 12:30pm
 * String sch = '0 30 12 * * ?';
 * Values represent seconds minutes hours day_of_month month day_of_week
 */
public with sharing class ScheduleTaskCreatorBatch implements Schedulable{
    public final Integer openCaseThreshold;
    
    /**
     * @description - Constructor to specify a threshold for the batch class 
     * @param threshold The number of days in the past to check for open cases
     */
    public ScheduleTaskCreatorBatch(Integer threshold) {
        System.debug('In scheduler constructor');
        openCaseThreshold = threshold;
    }

    /**
     * @description - Method to execute the batch class
     * @param sc Schedulable context that's part of the interface implementation
     */
    public void execute(SchedulableContext sc) {
        System.debug('Executing scheduleable job with threshold ' + openCaseThreshold);
        TaskCreatorBatch tcb = new TaskCreatorBatch(openCaseThreshold, false); 
        Database.executeBatch(tcb, 5);
    }
}