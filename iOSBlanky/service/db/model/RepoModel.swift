//
//  RepoModel.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/21/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import CoreData

class RepoModel: NSManagedObject {

    @NSManaged var fullName: String?
    @NSManaged var repoDescription: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<RepoModel> {
        return NSFetchRequest<RepoModel>(entityName: "RepoModel")
    }

}

extension RepoModel {

    class func insertFrom(_ repo: Repo, context: NSManagedObjectContext) -> RepoModel {
        let model = RepoModel(context: context)

        model.fullName = repo.fullName
        model.repoDescription = repo.repoDescription

        return model
    }

    func toRepo() -> Repo {
        return Repo(fullName: self.fullName!,
                    repoDescription: self.repoDescription)
    }

}
