struct Repo: Codable {
    let fullName: String
    let repoDescription: String?
}

extension Repo {
    enum CodingKeys: String, CodingKey {
        case fullName
        case repoDescription = "description"
    }
}
