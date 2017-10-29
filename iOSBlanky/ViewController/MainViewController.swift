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
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (stateData: StateData<GitHubUsername>) in
                switch stateData.localDataState() {
                case .isEmpty:
                    self.goButton.isEnabled = false
                case .dataExists(let data):
                    self.goButton.isEnabled = true
                    self.usernameTextField.text = data
                case .errorFound(let error):
                    self.goButton.isEnabled = true
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in })
                    self.present(alert, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        reposViewModel.observeRepos()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (stateData: StateData<[RepoModel]>) in
                switch stateData.onlineDataState() {
                case .isEmpty:
                    self.stateOfDataLabel.text = "User does not have any repos."
                case .isLoading:
                    self.stateOfDataLabel.text = "Loading repos for user..."
                case .isFetchingFreshData:
                    self.fetchingDataStatusLabel.text = "Fetching fresh data."
                case .doneFetchingFreshData(let errorCausedDoneFetching):
                    self.fetchingDataStatusLabel.text = "Done fetching data."
                    if errorCausedDoneFetching { self.fetchingDataStatusLabel.text = "Done fetching data because of an error." }
                case .dataExists(let data):
                    self.stateOfDataLabel.text = "Num of repos for user: \(String(data.count))"
                case .errorFound(let error):
                    self.stateOfDataLabel.text = ""
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in })
                    self.present(alert, animated: true, completion: nil)
                case .noState:
                    break
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
