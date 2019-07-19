//
//  ViewController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class MainViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var stateOfDataLabel: UILabel!
    @IBOutlet weak var fetchingDataStatusLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private let reposViewModel: ReposViewModel = ReposViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stateOfDataLabel.text = ""
        self.fetchingDataStatusLabel.text = ""
        self.goButton.isEnabled = false
        
        reposViewModel.observeGitHubUsername()
            .subscribe(onNext: { (stateData: StateLocalData<GitHubUsername>) in
                switch stateData.state() {
                case .isEmpty?:
                    self.goButton.isEnabled = false
                case .data(let username)?:
                    self.goButton.isEnabled = true
                    self.usernameTextField.text = username
                case .none: break
                }
            }).disposed(by: disposeBag)
        
        reposViewModel.observeRepos()            
            .subscribe(onNext: { (stateData: StateOnlineData<[RepoModel]>) in
                switch stateData.cacheState() {
                case .cacheEmpty?:
                    self.stateOfDataLabel.text = "User does not have any repos."
                case .cacheData(let repos, _)?:
                    self.stateOfDataLabel.text = "Num of repos for user: \(String(repos.count))"
                case .none: break
                }
                switch stateData.noCacheState() {
                case .noCache?:
                    self.stateOfDataLabel.text = "User does not have any repos."
                case .firstFetchOfData?:
                    self.stateOfDataLabel.text = "Loading repos for user..."
                default: break
                }
                switch stateData.fetchingFreshDataState() {
                case .fetchingFreshCacheData?:
                    self.fetchingDataStatusLabel.text = "Fetching fresh data."
                case .finishedFetchingFreshCacheData(let errorDuringFetch)?:
                    self.fetchingDataStatusLabel.text = "Done fetching data."
                    if errorDuringFetch != nil { self.fetchingDataStatusLabel.text = "Done fetching data because of an error." }
                case .none: break
                }
            }).disposed(by: disposeBag)
        
        usernameTextField.rx.text.asObservable()
            .map { (text: String?) -> String? in
                self.goButton.isEnabled = text != nil && !text!.isEmpty
                return text
            }
            .subscribe()
            .disposed(by: disposeBag)
    }    
    
    @IBAction func howManyReposButtonPressed(_ sender: UIButton) {
        reposViewModel.setGitHubUsernameForRepos(usernameTextField.text!)
    }
    
}
