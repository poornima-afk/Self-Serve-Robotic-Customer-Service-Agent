public class OAuthTokenUtil {
    public static String getAccessToken() {
        // Replace with your actual values or retrieve from Named Credential/Custom Setting
        String clientId = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        String clientSecret = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
       // String username = 'harshfsc@astreait.com';
        //String password = '%%%%%%';

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://orgfarm-e7f9892e9d.my.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'grant_type=client_credentials'
            + '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8')
            + '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8');
        req.setBody(body);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            system.debug('result'+result);
           // Account acc = new Account();
            //acc.Name=(String)result.get('access_token');
            //insert acc;
            return (String)result.get('access_token');
        } else {
            System.debug('OAuth error: ' + res.getBody());
            return null;
        }
    }
}