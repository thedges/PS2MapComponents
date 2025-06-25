import { LightningElement, api } from 'lwc';
import { RefreshEvent } from "lightning/refresh";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import loadRecordLocation from '@salesforce/apex/PS2MapUtils.loadRecordLocation';
import saveRecordLocation from '@salesforce/apex/PS2MapUtils.saveRecordLocation';

export default class Ps2RecordLocator extends LightningElement {
    @api recordId;
    @api latField;
    @api lngField;
    @api fullAddressField;
    @api streetField;
    @api cityField;
    @api stateField;
    @api postalField;
    @api mapCenterLat;
    @api mapCenterLng;
    @api mapZoomLevel;
    @api mapHeight;
    @api centerOnLocation;
    @api addressAutocomplete;

    recLat;
    recLng;

    connectedCallback() {
    }

    setRecordLocation(recLat, recLng, locAddr) {
        const child = this.template.querySelector('c-ps2-base-map');
        if (child) {
            child.setRecordLocation(recLat, recLng, locAddr);
        }
    }

    setCrosshair(event) {
        console.log('setCrosshair() invoked...');
        console.log('event=' + JSON.stringify(event.detail));

        saveRecordLocation({
            recordId: this.recordId,
            latField: this.latField,
            lngField: this.lngField,
            fullAddressField: this.fullAddressField,
            streetField: this.streetField,
            cityField: this.cityField,
            stateField: this.stateField,
            postalField: this.postalField,
            lat: event.detail.latitude,
            lng: event.detail.longitude,
            fullAddress: event.detail.fullAddress,
            street: event.detail.street,
            city: event.detail.city,
            state: event.detail.state,
            postal: event.detail.postal
        }).then((result) => {
            this.dispatchEvent(new RefreshEvent());    // refresh record screen to show updated values
        }).catch((err) => {
            console.log(err);
            const message = this.getErrorMessage(err);
            this.showToast('Error', message, 'error', 'sticky');
        });

    }

    mapInit(event) {
        console.log('mapInit called...');

        loadRecordLocation({
            recordId: this.recordId,
            latField: this.latField,
            lngField: this.lngField,
            fullAddressField: this.fullAddressField,
            streetField: this.streetField,
            cityField: this.cityField,
            stateField: this.stateField,
            postalField: this.postalField
        }).then(result => {
            console.log('currLoc=' + result);
            var data = JSON.parse(result);

            if (data?.latitude && data?.longitude) {
                this.recLat = data.latitude;
                this.recLng = data.longitude;

                this.setRecordLocation(this.recLat, this.recLng, data.fullAddress);
            }
        }).catch((err) => {
            console.log(err);
            const message = this.getErrorMessage(err);
            this.showToast('Error', message, 'error', 'sticky');
        });
    }

    getErrorMessage(error) {
        if (Array.isArray(error.body)) {
            return error.body.map(e => e.message).join(', ');
        } else if (error?.body?.message) {
            return error.body.message;
        }
        return 'An unexpected error occurred';
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant,
                mode
            })
        );
    }

}