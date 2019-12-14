import RxCocoa
import RxSwift
import SnapKit
import UIKit

class LaunchViewController: UIViewController {
    fileprivate var didSetupConstraints = false

    internal let themeManager = DI.shared.themeManager

    let usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = Strings.githubUsername.localized
        view.keyboardType = .default
        view.spellCheckingType = .no
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.borderStyle = .roundedRect
        return view
    }()

    let goButton: UIButton = {
        let view = UIButton()
        view.setTitle(Strings.howManyReposButtonText.localized, for: .normal)
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
    private let reposViewModel = DI.shared.reposViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        rootView.addArrangedSubviews([
            usernameTextField,
            goButton,
            stateOfDataLabel,
            fetchingDataStatusLabel
        ])

        view.addSubview(rootView)
        view.setNeedsUpdateConstraints()

        setupViews()
    }

    private func setupViews() {
        stateOfDataLabel.text = ""
        fetchingDataStatusLabel.text = ""
        goButton.isEnabled = false

        goButton.addTarget(self, action: #selector(howManyReposButtonPressed), for: .touchUpInside)

        usernameTextField.text = nil
        reposViewModel.observeGitHubUsername()
            .subscribe(onNext: { username in
                self.usernameTextField.text = username
            }).disposed(by: disposeBag)

        reposViewModel.observeRepos()
            .subscribe(onNext: { (dataState: DataState<[Repo]>) in
                switch dataState.state() {
                case .none: break
                case .noCache:
                    self.stateOfDataLabel.text = "User does not have any repos."
                case .cache(let cache, _, _, _, _, _):
                    if let repos = cache {
                        self.stateOfDataLabel.text = "Num of repos for user: \(String(repos.count))"
                    } else {
                        self.stateOfDataLabel.text = "User does not have any repos."
                    }
                }

                switch dataState.fetchingState() {
                case .fetching(let fetching, _, _, _):
                    if fetching {
                        self.stateOfDataLabel.text = "Loading repos for user..."
                    }
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
            usernameTextField.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }

    @objc func howManyReposButtonPressed(_ sender: UIButton) {
        reposViewModel.gitHubUsername = usernameTextField.text!
    }
}

extension LaunchViewController: ThemableViewController {
    var navigationBarTitle: String? {
        return "Repos"
    }

    var navigationBarBackButtonText: String? {
        return nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentTheme.statusBarStyle
    }
}
