public with sharing class RecipeController {

    static Integer PAGE_SIZE = 9;

    public class Filters {
        public String searchKey { get;set; }
        public String[] categories { get;set; }
    }

    @AuraEnabled(Cacheable=true)
    public static PagedResult getRecipes(String filters, Integer pageNumber) {
        String key, whereClause = '';
        String[] categories, criteria = new String[]{};
        if (!String.isEmpty(filters)) {
            Filters coctailFilters = (Filters) JSON.deserializeStrict(filters, RecipeController.Filters.class);
            if (!String.isEmpty(coctailFilters.searchKey)) {
                key = '%' + coctailFilters.searchKey + '%';
                criteria.add('Name LIKE :key');
            }
            if (coctailFilters.categories != null) {
                categories = coctailFilters.categories;
                criteria.add('Coctail_type__c IN :categories');
            }                      
            if (criteria.size() > 0) {
                whereClause = 'WHERE ' + String.join( criteria, ' AND ' );
            }                      
        }
        Integer pageSize = RecipeController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        PagedResult result =  new PagedResult();
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;
        result.totalItemCount = Database.countQuery('SELECT count() FROM Recipe__c ' + whereClause);
        result.records = Database.query('SELECT Id, Name, Recipe_description__c, Coctail_type__c, Recipe_URL__c, (SELECT Id, Name , Ingridient_amount__c, Unit_of_measurement__c FROM Recipe_amounts__r) FROM Recipe__c ' + whereClause + ' ORDER BY Name LIMIT :pageSize OFFSET :offset');
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static Recipe__c[] getAllRecipes() {
        return [SELECT Id, Name, Recipe_description__c, Coctail_type__c, Recipe_URL__c FROM Recipe__c];
    }

    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] getSimilarProducts(Id productId, Id familyId) {
        return [SELECT Id, Name, Recipe_description__c, Coctail_type__c, Recipe_URL__c FROM Recipe__c WHERE Coctail_type__c =:familyId AND Id!=:productId];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Recipe_amount__c> getRecipeAmounts(String recipeId){
        List<Recipe_amount__c> qr = null;
        String[] criteria = new String[]{};
        String whereClause = '';
        if (!String.isEmpty(recipeId)){
            criteria.add('Recipe__c = :recipeId');
            whereClause = 'WHERE ' + criteria;
            qr = Database.query('SELECT Id, Name , Ingridient_amount__c, Unit_of_measurement__c FROM Recipe_amount__c ' + whereClause);           
        }
        return qr;
    }
}