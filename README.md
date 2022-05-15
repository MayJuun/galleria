# galleria

- Ensure that you have setup PubSub in your FHIR Datastore first

## [Setup for FHIR Pub/Sub](https://cloud.google.com/healthcare-api/docs/how-tos/pubsub)

- Enable API
- Create Pub/Sub Topic 
    - ID for topic in stage: ```projects/demos-322021/topics/stage```
    - Only select ```Add a default subscription``` from the checkboxes
- Create Subscription
    - ID for subscription in stage: ```projects/demos-322021/subscriptions/stage```
    - Select the above Topic
    - Delivery Type = push
    - Endpoint URL: the app url that will be receiving the updates
    - Click Enable Authentication -> Service Account
        - Google APIs Service Agent
        - App Engine default service account
    - Acknowledgement deadline - 10 seconds 
    - Retry policy - Retry after exponential backoff delay 
        - Minimum backoff (seconds) - 10
        - Maximum backoff (seconds) - 600
    - Both of the above effect how long the PubSub service waits for confirmation before sending the message again. Ensure to increase this from the baseline (I go with 10 seconds), or else you can get a LOT of updates (like 83) that get sent before you can shut the service down which results in a lot of text messages
    - Press Create

## Google Cloud Run
- While uploading the app, select that we should only allow authenticated traffic
- Once uploaded, go to the service
- Go to heading ```Triggers```
- ```Ingress``` = Allow internal traffic only
- ```Authentication``` = Require authentication
- Because we're transferring secure information without a lot of inherent security, this only allows incoming traffic from within our google cloud, so it keeps everything safe

## [Setup for sending emails via a service account](https://stackoverflow.com/questions/55062040/flutter-googleapis-gmail-api-send-email-returns-400-bad-request)

- Requires a service account credentials, just as you would for anything else, but with an impersonated user
```dart
  final clientCredentials = ServiceAccountCredentials.fromJson(credentials,
      impersonatedUser: 'impersonated.user@mayjuun.com');
```
- Ensure the service account is an Editor of the FHIR Server
- It will also need to be setup as a [domain-wide delegation for a client](https://support.google.com/a/answer/162106?product_name=UnuFlow&hl=en&visit_id=637803216817936373-460879578&rd=1&src=supportwidget0&hl=en#zippy=%2Cset-up-domain-wide-delegation-for-a-client)
- The only necessary scope: ```https://www.googleapis.com/auth/gmail.send```    
- Example function to send email (remember content need to be base64)
```dart
sendEmail({
    String from: 'me',
    String to: 'someemail@gmail.com',
    String subject: 'Some subject',
    String contentType: 'text/html',
    String charset: 'utf-8',
    String contentTransferEncoding: 'base64',
    String emailContent: '<table></table>',
}) async {
(await getGMailApi()).users.messages.send(
    gMail.Message.fromJson({
        'raw': getBase64Email(
        source: 'From: $from\r\n'
                'To: $to\r\n'
                'Subject: $subject\r\n'
                'Content-Type: $contentType; charset=$charset\r\n'
                'Content-Transfer-Encoding: $contentTransferEncoding\r\n\r\n'
                '$emailContent'), // emailContent is HTML table.
    }),
    from);
}
```

## Example Message

```json
{
    "message": {
        "attributes": {
            "action": "CreateResource",
            "payloadType": "NameOnly",
            "resourceType": "ServiceRequest"
        },
        "data": "cHJvamVjdHMvZGVtb3MtMzIyMDIxL2xvY2F0aW9ucy91cy1jZW50cmFsMS9kYXRhc2V0cy9zdGFnZS9maGlyU3RvcmVzL3N0YWdlL2ZoaXIvU2VydmljZVJlcXVlc3QvZWUzMzQ1ZGYtYzRmMy00ZGEzLWFiYzQtNzE1Zjk2NTBhMzIw",
        "messageId": "3765948479204379",
        "message_id": "3765948479204379",
        "publishTime": "2022-01-25T22:39:23.602Z",
        "publish_time": "2022-01-25T22:39:23.602Z"
    },
    "subscription": "projects/demos-322021/subscriptions/stage"
}
```
