public String[] loginSalesforce(String[] salesforceLogin) {
 
  // split array into strings to pass to httpclient
  String username = salesforceLogin[0];
  String password = salesforceLogin[1];
  String url = salesforceLogin[2];
  String grantService = salesforceLogin[3];
  String clientId = salesforceLogin[4];
  String clientSecret = salesforceLogin[5];
  
  //string for output of token and url
  String[] accessDetails = new String[2];

  // build new httpclient
  HttpClient httpclient = HttpClientBuilder.create().build();
  
  //build login url string
  String loginURL = url + grantService + "&client_id=" + clientId + "&client_secret=" + clientSecret + "&username=" + username + "&password=" + password;
  
  // setup post request
  HttpPost httpPost = new HttpPost(loginURL);
  HttpResponse response = null;
  
  try { // do salesforce login
  response = httpclient.execute(httpPost);
  } 
  
  catch (ClientProtocolException cpException) {
    // put error handling code here
  } 
  
  catch (IOException ioException) {
    // put error handling code here
  }
  
  // get http status code, output to console
  int statusCode = response.getStatusLine().getStatusCode();
  //System.out.println("HTTP Status: " + statusCode);  
  
         
  try { // take JSON response from sfdc login, store access token and url to vars
      String jsonString = EntityUtils.toString(response.getEntity());
      JSONObject json;
      json = JSONObject.parse(jsonString);      
      //System.out.println(json);
      accessDetails[0] = json.getString("access_token");
      accessDetails[1] = json.getString("instance_url");
      //System.out.println(accessToken);  
  } 
  
  catch (IOException ioException) {
    // put error handling code here
  }
   // return access token and url to class
   return accessDetails;
}


Boolean insertSlide( String[] accessDetails, JSONObject rideDetails) {
  
  Boolean isSuccess = false;
  
  HttpClient httpclient = HttpClientBuilder.create().build();
   
  HttpPost post = new HttpPost(accessDetails[1] + "/services/data/v29.0/sobjects/Slide_Run__c/");
  post.setHeader("Authorization", "OAuth " + accessDetails[0]);
  post.addHeader("Content-Type", "application/json");

  try {
  StringEntity params = new StringEntity(rideDetails.toString());
    post.setEntity( params );
  }
  
  catch(Exception uee) {
    uee.printStackTrace();
  }
 
  try {
    HttpResponse response = httpclient.execute(post);
    if ( response.getStatusLine().getStatusCode() == 201 ) {
      isSuccess = true;
    }
    else {
      isSuccess = false;
    }
    
  }
  
  catch (IOException ie) {
   isSuccess = false; 
  }
   
  return isSuccess;
  
}

void salesForceLogin() {
  
    String[] salesforceLoginDetails = new String[6];

    salesforceLoginDetails[0] = "mick.wheelz@gmail.com"; //username
    salesforceLoginDetails[1] = "InItial89ULi8HaMXOIx418iTkHK6gmTPT"; //password and token
    salesforceLoginDetails[2] = "https://login.salesforce.com"; //login url
    salesforceLoginDetails[3] ="/services/oauth2/token?grant_type=password"; // grant type
    salesforceLoginDetails[4] = "3MVG9Y6d_Btp4xp5LLJdvxJXv2qYyLbJtrC13AyKJVy1l9h9xq2eQzIGhC5IaQiCOnt0Btssf1NUL1BckOZad"; //client id
    salesforceLoginDetails[5] = "3875746611375330421"; //client secret 

    accessDetails = loginSalesforce(salesforceLoginDetails);
    
}

void salesForceSendData() {
  
      JSONObject rideTest;    

      rideTest = new JSONObject();

      rideTest.setString("Barcode__c", postData[0]);
      rideTest.setFloat("Reaction_Time__c", float(postData[1]));
      rideTest.setFloat("Speed__c", float(postData[2]));
      rideTest.setFloat("ET__c", float(postData[3]));
      rideTest.setFloat("Sector_1__c", float(postData[4]));
      rideTest.setFloat("Sector_2__c", float(postData[5] ));
      rideTest.setFloat("Sector_3__c", float(postData[6] ));
      rideTest.setFloat("Sector_4__c", float(postData[7]));
      rideTest.setFloat("Total_Time__c", float(postData[8]));
      rideTest.setBoolean("False_Start__c", boolean(postData[9]));

      int t = millis();
      Boolean insertSlideResult = insertSlide(accessDetails, rideTest);
      int r = millis() - t;
      data[index - 1][9] = r;
      
}

/* String readProducts( String[] accessDetails ) {
  
  HttpClient httpclient = HttpClientBuilder.create().build();

  HttpGet httpgeter = new HttpGet(accessDetails[1] + "/services/data/v29.0/query?q=SELECT+name+FROM+Product2" );
  httpgeter.setHeader("Authorization", "OAuth " + accessDetails[0]);
  HttpResponse getresponse = null;
          
  try {          
    getresponse = httpclient.execute(httpgeter);
  } 
  catch (ClientProtocolException cpException) {
    // put error handling code here
  }
  catch (IOException ioException) {
    // put error handling code here
  }  
  
  String getResult2 = null;
  
  try {
    getResult2 = EntityUtils.toString(getresponse.getEntity());
   } 
  catch (IOException ioException) {
    // put error handling code here
  }
  
  return getResult2;

} */
