import Foundation

enum RepoFake {
    case randomRepo

    var fake: Repo {
        switch self {
        case .randomRepo:
            return Repo(fullName: "\("".randomName(length: 4)) \("".randomName(length: 8))", repoDescription: "".randomName(length: 18))
        }
    }
}
