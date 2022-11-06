import { LightningElement, api } from 'lwc';

export default class StoreOrder extends LightningElement {
    // Store Supply Order to display
    @api orderItem;

    // Whether the component has unsaved changes
    isModified = false;

    // Current changed order values
    form = {};

    // Handles changes to the record values
    handleFormChange(evt) {
        this.isModified = true;
        const field = evt.target.dataset.fieldName;
        let value = parseInt(evt.detail.value.trim(), 10);
        if (!Number.isInteger(value)) {
            value = 0;
        }
        this.form[field] = value;
    }

    // Fire custom event to the parent component that the record has changed
    saveOrderItem() {
        const event = new CustomEvent('orderitemchange', {
            detail: Object.assign({}, { Id: this.orderItem.Id }, this.form)
        });
        this.dispatchEvent(event);
        this.isModified = false;
    }

    // Cancel additional changes to the record
    cancelChanges() {
        this.isModified = false;
    }
}