struct Repo: Codable, Equatable {
    let fullName: String
    let repoDescription: String?
}

extension Repo {
    enum CodingKeys: String, CodingKey {
        case fullName
        case repoDescription = "description"
    }
}
