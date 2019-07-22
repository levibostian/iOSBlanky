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
import SnapKit

class MainViewController: UIViewController {

    fileprivate var didSetupConstraints = false

    let usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString("github_username", comment: "")
        view.keyboardType = .default
        view.spellCheckingType = .no
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.borderStyle = .roundedRect
        return view
    }()

    let goButton: UIButton = {
        let view = UIButton()
        view.setTitle(NSLocalizedString("how_many_repos_button_text", comment: ""), for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        return view
    }()

    let stateOfDataLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.darkText
        view.font = view.font.withSize(17)
        return view
    }()

    let fetchingDataStatusLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.darkText
        view.font = view.font.withSize(17)
        return view
    }()

    let rootView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 18
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let reposViewModel = Di.inject.reposViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        rootView.addArrangedSubviews([
            usernameTextField,
            goButton,
            stateOfDataLabel,
            fetchingDataStatusLabel])

        view.addSubview(rootView)
        view.setNeedsUpdateConstraints()

        setupViews()
    }

    private func setupViews() {
        stateOfDataLabel.text = ""
        fetchingDataStatusLabel.text = ""
        goButton.isEnabled = false

        goButton.addTarget(self, action: #selector(howManyReposButtonPressed), for: .touchUpInside)

        reposViewModel.observeGitHubUsername()
            .subscribe(onNext: { (stateData: StateLocalData<GitHubUsername>) in
                switch stateData.state() {
                case .isEmpty?: break
                case .data(let username)?:
                    self.usernameTextField.text = username
                case .none: break
                }
            }).disposed(by: disposeBag)

        reposViewModel.observeRepos()
            .subscribe(onNext: { (stateData: StateOnlineData<[Repo]>) in
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

    override func updateViewConstraints() {
        if !didSetupConstraints {
            rootView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.equalToSuperview().offset(40)
                make.trailing.equalToSuperview().inset(40)
            }
            usernameTextField.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
            }

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }
    
    @objc func howManyReposButtonPressed(_ sender: UIButton) {
        reposViewModel.setGitHubUsernameForRepos(usernameTextField.text!)
    }
    
}
