@RestResource(urlMapping='/Contact/*')
Global class Infoware {
   
    @HttpPost
    global static ID createContact (String Customer_Number, 
                                    String Title, 
                                    String First_Name, 
                                    String Middle_Name, 
                                    String Last_Name, 
                                    String A_Name,
                                    String Client_Number,
                                    String Client_Type,
                                    String Nationality,
                                    String Contact_Person,
                                    String Gender,
                                    String Address, String City, String State, String Country, String Phone_Number, String Email, String Birthday, String MeansofIDexpiration, String MeansofID, String Mothers_Maiden_Name, String Occupation, String Employer_Name) {
       
        Current_Product_Holding__c CPH_object = new Current_Product_Holding__c();
         Current_Product_Holding__c[] toCheck = [SELECT Id, Account_Number__c, Client__c, Name FROM Current_Product_Holding__c where Account_Number__c =: Customer_Number];
                
                                        
        if (toCheck.size() > 0 ) {
                        return 'record already exists';
                              }
                                          
        
             
        Account newAccount = new Account(Name = A_Name, 
                                          AccountNumber = Client_Number, Contact_Person__c = Contact_Person, RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Client_Type).getRecordTypeId()
                                        );
         insert newAccount;
        ID acct_ID = newAccount.ID;
        //new input
         Current_Product_Holding__c CPH = new Current_Product_Holding__c(Account_Number__c = Customer_Number, Client__c = acct_ID);                               
         insert CPH;
                                        
        Contact thisContact = new Contact(FirstName=First_Name, Middle_Name__c=Middle_Name, LastName=Last_Name, Title=Title, AccountId = acct_ID, Primary_Nationality__c = Nationality, Gender__c = Gender, Phone = Phone_Number, Email = Email, Means_of_ID_Document_Type__c = MeansofID, Mother_Maiden_Name__c = Mothers_Maiden_Name, Occupation__c = Occupation, Birthdate = Date.parse(Birthday), Expiry_Date__c = date.parse(MeansofIDexpiration), MailingCity = City, MailingState = State, MailingCountry = Country, Employer_Name__c = Employer_Name);
         insert thisContact;
         return thisContact.Id;   
                                        
        
         
    }
    
    @HttpPatch
    global static ID updateContactFields() {
        RestRequest request = RestContext.request;
        String ContactID = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = : contactID];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }
    
      
}