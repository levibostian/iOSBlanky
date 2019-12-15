import Foundation

enum RepoFake {
    case repoForUser(username: GitHubUsername)
    case randomRepo

    var fake: Repo {
        switch self {
        case .repoForUser(let username):
            return Repo(fullName: username, repoDescription: "".randomName(length: 18))
        case .randomRepo:
            return Repo(fullName: "\("".randomName(length: 4)) \("".randomName(length: 8))", repoDescription: "".randomName(length: 18))
        }
    }
}
