@main
public struct Abuse_Helper {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(Abuse_Helper().text)
    }
}

export TWILIO_ACCOUNT_SID='AC83fe2c07cccad5672e10fcc6c4e3fee1'
export TWILIO_AUTH_TOKEN='a0eb1b983cf36043ad43200b0046fff4'

import Foundation
import Alamofire

if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
   let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {

  let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
  let parameters = ["From": "YOUR_TWILIO_NUMBER", "To": "YOUR_PERSONAL_NUMBER", "Body": "Hello from Swift!"]

  Alamofire.request(url, method: .post, parameters: parameters)
    .authenticate(user: accountSID, password: authToken)
    .responseJSON { response in
      debugPrint(response)
  }

  RunLoop.main.run()
}
