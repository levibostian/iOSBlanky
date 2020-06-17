import Foundation

enum DynamicLinkAction {
    case tokenExchange(token: String)
}

class DynamicLinksProcessor {
    static func getActionFromDynamicLink(_ link: URL) -> DynamicLinkAction? {
        var link = link
        // If the app is opened through a iOS Universal link, the URL may look like this: "https://preview.page.link/?link=https%3A%2F%2Fapp.foo.com%2F%3Ftoken%3D123" If we want to try and get the query param "3Ftoken" out for example, we can't because it's inside of the query param "link=". So, we need to get the value of link first before we can do anything.
        if let appLink = link.getQueryParamValue("link") {
            link = URL(string: appLink)! // Should make the URL encoded value `https%3A%2F%2Fapp.foo.com%2F%3Ftoken%3D123` and make it human readable, `https://app.foo.com/?token=123`
        }

        if let token = link.getQueryParamValue("token") {
            return .tokenExchange(token: token)
        }

        return nil
    }
}
