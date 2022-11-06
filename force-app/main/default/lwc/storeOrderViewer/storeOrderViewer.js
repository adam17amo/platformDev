import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Record DML operations
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';

// Use Apex to fetch related records
import { getSObjectValue } from '@salesforce/apex';
import getStoreSupplyOrders from '@salesforce/apex/StoreSupplyOrderController.getStoreSupplyOrders';

// Get fields from objects
import TOTAL_SUPPLY_SPEND_FIELD from '@salesforce/schema/Store__c.Total_Supply_Spend__c';
import NAME_FIELD from '@salesforce/schema/Store_Supply_Order__c.Name';
import ORDER_AMOUNT_FIELD from '@salesforce/schema/Store_Supply_Order__c.Order_Amount__c';
import ORDER_STATUS_FIELD from '@salesforce/schema/Store_Supply_Order__c.Order_Status__c';
import PRODUCT_ORDERED_FIELD from '@salesforce/schema/Store_Supply_Order__c.Product_Ordered__c';
import QUANTITY_FIELD from '@salesforce/schema/Store_Supply_Order__c.Quantity__c';

// Get static resources for product images
import COFFEE_IMAGE from '@salesforce/resourceUrl/Coffee_Image';
import CUPS_IMAGE from '@salesforce/resourceUrl/Cup_Image';
import PASTRIES_IMAGE from '@salesforce/resourceUrl/Pastries_Image';
import UTENSILS_IMAGE from '@salesforce/resourceUrl/Utensils_Image';

// Map products to images
const imageMap = new Map([
    ['Coffee', COFFEE_IMAGE],
    ['Cups', CUPS_IMAGE],
    ['Pastries', PASTRIES_IMAGE],
    ['Utensils', UTENSILS_IMAGE],
]);

export default class StoreOrderViewer extends LightningElement {
    // Id of the Store to display records on
    @api recordId;

    // The Store Supply Orders to display
    storeSupplyOrders;

    error;

    // Wired Apex result so it may be programmatically refreshed
    wiredSupplyOrders;

    // Count of the total number of items ordered
    orderQuantity = 0;

    @wire(getRecord, { recordId: '$recordId', fields: [TOTAL_SUPPLY_SPEND_FIELD] })
    storeRecord;

    get totalSupplySpend() {
        return getFieldValue(this.storeRecord.data, TOTAL_SUPPLY_SPEND_FIELD);
    }

    get hasStoreSupplyOrders() {
        return this.storeSupplyOrders != null && this.storeSupplyOrders.length > 0;
    }

    // Load the Store's Store Supply Orders
    @wire(getStoreSupplyOrders, { storeId: '$recordId' })
    wiredGetStoreSupplyOrders(value) {
        this.wiredSupplyOrders = value;
        if (value.error) {
            this.error = value.error;
        } else if (value.data) {
            this.setStoreSupplyOrders(value.data);
        }
    }

    // Set the Store Supply Order variable along with images and calculate orderQuantity
    setStoreSupplyOrders(orders) {
        this.storeSupplyOrders = [];
        this.orderQuantity = 0;
        orders.forEach((order) => {
            let supplyOrder = {};
            supplyOrder.Id = order.Id;
            supplyOrder[NAME_FIELD.fieldApiName] = getSObjectValue(order, NAME_FIELD);
            supplyOrder[ORDER_AMOUNT_FIELD.fieldApiName] = getSObjectValue(order, ORDER_AMOUNT_FIELD);
            supplyOrder[ORDER_STATUS_FIELD.fieldApiName] = getSObjectValue(order, ORDER_STATUS_FIELD);
            supplyOrder[PRODUCT_ORDERED_FIELD.fieldApiName] = getSObjectValue(order, PRODUCT_ORDERED_FIELD);
            supplyOrder.ImageUrl = this.getStaticResourceUrl(getSObjectValue(order, PRODUCT_ORDERED_FIELD));
            supplyOrder[QUANTITY_FIELD.fieldApiName] = getSObjectValue(order, QUANTITY_FIELD);
            this.orderQuantity += getSObjectValue(order, QUANTITY_FIELD);
            this.storeSupplyOrders.push(supplyOrder);
        });
    }

    getStaticResourceUrl(productOrdered) {
        return imageMap.get(productOrdered);
    }

    // Handles event to change Store Supply Order details
    handleOrderItemChange(event) {
        const changedOrder = event.detail;

        const previousSupplyOrders = this.storeSupplyOrders;
        // Update Store Supply Order on the client
        const supplyOrders = this.storeSupplyOrders.map((order) => {
            if (order.Id === changedOrder.Id) {
                // Set a new Store Supply Order sObject
                return Object.assign({}, order, changedOrder);
            }
            return order;
        });
        this.setStoreSupplyOrders(supplyOrders);

        // Update Store Supply Order on the server
        const recordInput = { fields: changedOrder };
        updateRecord(recordInput)
            .then(() => {
                // If successful, display a toast
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Updated Store Supply Order',
                        message: 'Record has been updated',
                        variant: 'success'
                    })
                );
            })
            .catch((e) => {
                // If an error updating server, rollback data
                this.setOrderItems(previousSupplyOrders);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating order item',
                        message: reduceErrors(e).join(', '),
                        variant: 'error'
                    })
                );
            });
    }
}