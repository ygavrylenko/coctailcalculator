import { LightningElement, api } from 'lwc';

export default class IngredientsList extends LightningElement {
    _bottlelist = [];

    @api
    get bottlelist() {
        return this._bottleList;
    }
    set bottlelist(value) {
        this._bottleList = value;
    }
}