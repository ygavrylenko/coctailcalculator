/* eslint-disable no-console */
import { LightningElement, wire, track} from 'lwc';

/** getProducts() method in ProductController Apex class */
import getAllRecipes from '@salesforce/apex/RecipeController.getAllRecipes';

export default class CoctailCalculator extends LightningElement {
    @track
    bottlelist = []

    newbottlelist = [
        { id: 1, description: 'Rum Carta Blanca Rum 0.7 l', numbottles: '15 btl'},
        { id: 2, description: 'London Dry Gin, 1 l', numbottles: '22 btl'},
        { id: 3, description: 'Mint leaves', numbottles: '3.500 gr' },
        { id: 4, description: 'Brown sugar', numbottles: '7 kg' },
        { id: 5, description: 'Fresh lime juice', numbottles: '4,7 l' },
        { id: 6, description: 'Cinnamon', numbottles: '50 pcs' },
        { id: 7, description: 'Apple cider', numbottles: '15 l' },
    ];
    
    @wire(getAllRecipes) recipes;

    handleSave() {
        console.log('Calculating')
        this.bottlelist.length = 0
        this.bottlelist.push.apply(this.bottlelist, this.newbottlelist)
    }
}