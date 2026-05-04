public class ExtractDataFromImage {

     public class Request {
        @InvocableVariable(required=true)
        public Id cId;
    }

    public class electResponse {
        /*
        @InvocableVariable public String billTo;
        @InvocableVariable public String contact;
        @InvocableVariable public List<Item> items;
        @InvocableVariable public Double subtotal;
        @InvocableVariable public Double tax;
        @InvocableVariable public Double total;
		
        */
        
        @InvocableVariable public String sendDate;
        @InvocableVariable public String companyName;
        @InvocableVariable  public double Amount;
        @InvocableVariable public String transactionId;
        
    }

    public class Item {
        @InvocableVariable public String description;
        @InvocableVariable public String itemNo;
        @InvocableVariable public Integer qty;
        @InvocableVariable public Double cost;
    }

    @InvocableMethod(label='Preview bill PDF' description='Preview bill PDF')
    public static List<electResponse> requestDocumentAI(List<Request> requests) {
        List<electResponse> results = new List<electResponse>();

        Id caseId;
         for (Request req : requests) {
            caseId= req.cId;
            
        }
        
      //cardApplicant__c cardRed=  [Select id,file_id__c from cardApplicant__c where Name =: CardName limit 1];
        
      ContentDocumentLink link = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: caseId limit 1] ;
        
        
        ContentVersion fileToProcess = [
            SELECT VersionData
            FROM ContentVersion
            WHERE ContentDocumentId = :link.ContentDocumentId
            ORDER BY VersionNumber DESC
            LIMIT 1
        ];

        if (fileToProcess == null) {
            System.debug('Error: No file found with ContentDocumentId ' + '069gL000004gHbdQAE');
            return results;
        }

        String fileDataAsBase64 = EncodingUtil.base64Encode(fileToProcess.VersionData);

        HttpRequest req = new HttpRequest();
        String endpoint = System.Url.getOrgDomainUrl().toExternalForm() +
                          '/services/data/v64.0/ssot/document-processing/actions/extract-data';
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        String accessToken = OAuthTokenUtil.getAccessToken();
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Map<String, Object> fileDetails = new Map<String, Object>{
            'mimeType' => 'image/png',
            'data' => fileDataAsBase64
        };

        Map<String, Object> requestBodyMap = new Map<String, Object>{
            'idpConfigurationIdOrName' => 'Bill_Image',
            'files' => new List<Object>{ fileDetails }
        };

        String jsonBody = JSON.serialize(requestBodyMap, true);
        req.setBody(jsonBody);

        try {
            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200 || res.getStatusCode() == 202||res.getStatusCode() == 201) {
                Map<String, Object> outerJson = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> dataList = (List<Object>) outerJson.get('data');
                Map<String, Object> firstData = (Map<String, Object>) dataList[0];
                String encodedJson = (String) firstData.get('data');
                String decodedJson = encodedJson
                    .replace('&quot;', '\u0022')
                    .replace('&amp;', '&')
                    .replace('&lt;', '<')
                    .replace('&gt;', '>')
                    .replace('&apos;', '\'');
                Map<String, Object> finalJson = (Map<String, Object>) JSON.deserializeUntyped(decodedJson);
                system.debug('finalJson'+finalJson);

                electResponse response = new electResponse();
                response.sendDate = (String)((Map<String, Object>)finalJson.get('sending_date')).get('value');
                response.companyName = (String)((Map<String, Object>)finalJson.get('company_name')).get('value');
                response.Amount = (Double)((Map<String, Object>)finalJson.get('total_amount')).get('value');
                response.transactionId = (String)((Map<String, Object>)finalJson.get('transaction_id')).get('value');
                //response.total = (Double)((Map<String, Object>)finalJson.get('total')).get('value');

                // Parse items
              /*  List<Object> itemsList = (List<Object>)((Map<String, Object>)finalJson.get('items')).get('value');
                response.items = new List<Item>();
                for (Object itemObj : itemsList) {
                    Map<String, Object> itemMap = (Map<String, Object>)((Map<String, Object>)itemObj).get('value');
                    Item item = new Item();
                    item.description = (String)((Map<String, Object>)itemMap.get('description')).get('value');
                    item.itemNo = (String)((Map<String, Object>)itemMap.get('itemNo')).get('value');
                    item.qty = ((Map<String, Object>)itemMap.get('qty')).get('value') != null ? Integer.valueOf(String.valueOf(((Map<String, Object>)itemMap.get('qty')).get('value'))) : null;
                    item.cost = ((Map<String, Object>)itemMap.get('cost')).get('value') != null ? Double.valueOf(String.valueOf(((Map<String, Object>)itemMap.get('cost')).get('value'))) : null;
                    
                    
                    response.items.add(item);
                }
            */
                
                system.debug('100 response'+response);

                results.add(response);
            } else {
                System.debug('Error! Status: ' + res.getStatus());
                System.debug('Status Code: ' + res.getStatusCode());
                System.debug('Response Body: ' + res.getBody());
            }
        } catch(System.CalloutException e) {
            System.debug('Callout failed: ' + e.getMessage());
        }
        return results;
    }
}