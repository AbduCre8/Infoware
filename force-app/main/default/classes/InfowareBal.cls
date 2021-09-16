public class InfowareBal {
   
    public class DataTable {
        public ColumnDef ColumnDef;
        public List<ColumnDef> Rows;
    }
  
    public class Infoware_response {
        public DataTable DataTable;
        public Integer StatusID;
        public String StatusMessage;
        public String outValue;
    }
  
    public class ColumnDef {
        public String zero = '0';
        public String one = '1';
        public String two = '2';
        public String three = '3';
        public String four = '4';
    }
  
    @AuraEnabled
    Public static String getCustomerBalance (String theRecord_id) {
      
        System.debug('the record id received from lwc: ' + theRecord_id);
        Current_Product_Holding__c testing = [SELECT Id, Account_Number__c, Bank__c, Client__c FROM Current_Product_Holding__c WHERE Id =:theRecord_id LIMIT 1];
        String customer_ID = '1010014354';
        //String customer_ID = testing.Account_Number__c;
        String session_ID = InfowareBal.getSessionId();
      
        if (session_ID.equals('failed')) {
          
            return 'failed from sessionID';
          
        } else {
          
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'http://80.248.0.89/IWAPISvcsEBizTest/api/json/CustInfo/' + session_ID + '/' + customer_ID + '/9';
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            //String responseBody = response.getBody();
          
            String customerBalance;
          
            if (response.getStatusCode() == 200) {
                //The change I made. Debug and let me know the response.
                Map<string , object> data = (Map<string , object>)JSON.deserializeUntyped(response.getBody());
                Map<string , Object> DataTable = (Map<string , Object>)data.get('DataTable');
                List<Object> rows = (List<Object>)DataTable.get('Rows');
                Map<String , object> targetRow = (Map<string , Object>)Json.deserializeUntyped(Json.serialize(rows[0]));
                String requiredValue = targetRow.get('4').toString();
                system.debug('The current balance is ' + requiredValue);
                return requiredValue;                
            } else if (response.getStatusCode() > 0) {
                Infoware_response data_Val = (Infoware_response)JSON.deserialize(response.getBody(), Infoware_response.class);
                customerBalance = 'failed';
                return customerBalance;
            } else {
              
                Infoware_response data_Val = new Infoware_response();
                customerBalance = 'failed';
                return customerBalance;
              
            }
          
        }
      
      
    }
  
  
    @AuraEnabled
    Public static string getSessionId() {
        Http http = new Http();
      
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://80.248.0.89/IWAPISvcsEBizTest/api/json/Login/12345/APISVCS/Buhari@2020');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();
      
        String session_response;
      
        if (response.getStatusCode() == 200) {
            Infoware_response data_Val = (Infoware_response)JSON.deserialize(responseBody, Infoware_response.class);
            system.debug('the list ' + data_Val);
            session_response = data_Val.outValue;
            System.debug('the session id is: ' + session_response);
            return session_response;
        } else if (response.getStatusCode() > 0) {
            Infoware_response data_Val = (Infoware_response)JSON.deserialize(responseBody, Infoware_response.class);
            session_response = 'failed';
            return session_response;
        } else {
          
            Infoware_response data_Val = new Infoware_response();
            session_response = 'failed';
            return session_response;
          
        }
      
    }}
