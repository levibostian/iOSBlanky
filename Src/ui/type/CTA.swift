import Foundation

struct CTA: Codable, Equatable {
    let title: String
    let links: [CTALink]?
    let notice: String?
}

struct CTALink: Codable, Equatable {
    let title: String
    let url: URL?
    let action: String?

    var type: LinkType {
        if url != nil {
            return LinkType.url(url!)
        }
        if action != nil {
            return LinkType.action(action!)
        }
        fatalError("Not valid option")
    }

    enum LinkType {
        case url(_ url: URL)
        case action(_ action: String)
    }

    init(title: String, url: URL) {
        self.title = title
        self.url = url
        self.action = nil
    }

    init(title: String, action: String) {
        self.title = title
        self.url = nil
        self.action = action
    }
}
