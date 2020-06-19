import Foundation

struct RepoFakes {
    var random: Repo {
        Repo(fullName: "\("".random(length: 4)) \("".random(length: 8))", repoDescription: "".random(length: 18))
    }

    func repoForUser(username: GitHubUsername) -> Repo {
        Repo(fullName: username, repoDescription: "".random(length: 18))
    }
}

extension Repo {
    static var fake: RepoFakes {
        RepoFakes()
    }
}
