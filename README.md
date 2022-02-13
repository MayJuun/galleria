# galleria

## [Setup for sending emails via a service account](https://stackoverflow.com/questions/55062040/flutter-googleapis-gmail-api-send-email-returns-400-bad-request)

- Requires a service account credentials, just as you would for anything else, but with an impersonated user
```dart
  final clientCredentials = ServiceAccountCredentials.fromJson(credentials,
      impersonatedUser: 'impersonated.user@mayjuun.com');
```
- This service account can have access to the FHIR server, but it will need to be setup as a [domain-wide delegation for a client](https://support.google.com/a/answer/162106?product_name=UnuFlow&hl=en&visit_id=637803216817936373-460879578&rd=1&src=supportwidget0&hl=en#zippy=%2Cset-up-domain-wide-delegation-for-a-client)
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
