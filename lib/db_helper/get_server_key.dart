import 'package:googleapis_auth/auth_io.dart';

class GetServerKey{
  Future<String> getServerKeyToken()async{
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "campauslink",
              "private_key_id": "5d9241068357a00eb447a976e34f6201b0a64367",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCn3+eRQCMzD+PP\nn7xx/eMC7z1DiNDtRhVOMAlt+MtIvcHbV4F4cePyE2pgL9a6okAykMwjTSXPf8sp\nBqc8v4kpV+n6fxITtLciWOMpJpDx43jL6NWnTI3KJ4x7QMmev4ANhvDyIR3Yyni/\nFrn1if0T8CedAHDCCLZSG7BpsKeJFcceK93St9AT+F0Z7tLo/Cwo1LVWuuQ+8mY2\n2Tgjr2u+4HdOO0akIR2MiThzfiqIMoSEr5VBQacuiqJO72TXRSnzTGNDS7tR9p0+\n4dJgr7zt0gslBTQwPgQCz4cEQLfgWNz/BFC7ge8Hiw7L9Cqt40mTDxa1Di3uxyY2\nlDssph15AgMBAAECggEACDuG1Gdyt8rAHLA5clX695ZKaOuxIpWvg/T/SA1C+4H8\nxgLW+/8Kfeuy/t0RuMzYp5zUuf11oiT4TlPVHeRJt8U9LvY41CO7tbuUsPGt0C2c\nK1Rzgn+9VgGAVjyxi9oEelqt/xMd2YISZP1FE37CcmNyWd90ktC7ui/r7pRFybHl\n5Ks0k0PLryUTHj++GvEUm2bVTAaIm0pZtwc8co0PFunSSCpuHf6OJx46eG84Cq+v\nSZeOc9bux4x6mQ3HvG+s4mgqq8ZNQD3RlvQhzkGJWojhCLDXeVD5mS7/CAaUiG7P\nKwA4urnuJbz1XhfXFTLBVlYw44WuTC2SuzMu+qrwlQKBgQDhFBaOBtK1omspgTdP\nifJgf6QSEtj6oLNnk6Lu7zM9m+U97+c6YEjjBvvQRd084diEDc8qPn6xJnDNr0oY\nctSR8oHPbZ61TNbUaQeTYFZWSG8pW88rRUZknBkG6NDzgA+Kk4//Pfti/PY817F3\n4C0OWCEfhMBhIOrPlGJKimUGxQKBgQC+7/tx1mSXyjSPMTs7Y7kYj6wjWk4f7eqW\nhtUtSJIPfElokHJcMKyZkw51aF1dMu3C5YqKj9gGzozufQ8npDq/uvvxdytHcE/7\nU8syjRb7JdlVrSgHfBml7vdSQhYUQR1WqBD3Hu//oAyrovvrOnp7UUUnr/hEM+1a\nB8DpGTXHJQKBgDQRipo2l94vAa1rWBlNZ0XNoW4Q8CMis/4dGE9ABNGW0/R9IDfP\n+GyUvAJVdzXTZVw/OZKjPHnM08GxcGmxft14hXEwAcwdR4GB/p+oZLC3NwgRVh7D\neuJhfiSsDVKXaID9XA2HEDW5IVm36DU8JhAwcREyi7Ksg8WbpRVraK2lAoGAR63Z\n7Ft6+gzb/GGUBfCi/Rh6m+774zqy1X2aq9xRkOSsvkdz1y4iraiqReM/IYzL+12m\ny+vCQpPqDmH+fXhG4dF1YanGIpSEQiqr3rdeyDvmQia2H1E0Y7m5OTU8CrCDLhP8\nAnmnyYQxHYIbJqyWbJMO7h4+ioQf96tvfVKMgM0CgYEAlxJqZSHXDmNGhbwXb6q1\nhxswT4KwR/Iw1z/BtbZIPItzuMOGKac2ZTwwmfjMbPgJERfWQXK4eF5kjwcXD3Ss\nn8bAIM1xnfcJsD/2MM6Q/mFq5P9UiCM191n+5ZrOoGIsosragM9SqF6XYNRKwSGO\ngW+HnaGycSzO6qH3JMgV76s=\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-2eg6k@campauslink.iam.gserviceaccount.com",
              "client_id": "101625729375660443424",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-2eg6k%40campauslink.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
        ),
        scopes
    );

    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}