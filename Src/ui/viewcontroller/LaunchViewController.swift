import RxCocoa
import RxSwift
import SnapKit
import UIKit

class LaunchViewController: UIViewController {
    fileprivate var didSetupConstraints = false

    enum AccessibilityId: String {
        case usernameTextField
        case goButton
        case stateOfDataLabel
        case fetchingDataStatusLabel
    }

    internal let themeManager = DI.shared.themeManager

    let usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = Strings.githubUsername.localized
        view.keyboardType = .default
        view.spellCheckingType = .no
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.borderStyle = .roundedRect
        view.accessibilityIdentifier = AccessibilityId.usernameTextField.rawValue
        return view
    }()

    let goButton: UIButton = {
        let view = UIButton()
        view.setTitle(Strings.howManyReposButtonText.localized, for: .normal)
        view.accessibilityIdentifier = AccessibilityId.goButton.rawValue
        return view
    }()

    lazy var stateOfDataLabel: UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(17)
        view.accessibilityIdentifier = AccessibilityId.stateOfDataLabel.rawValue
        return view
    }()

    let fetchingDataStatusLabel: UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(17)
        view.accessibilityIdentifier = AccessibilityId.fetchingDataStatusLabel.rawValue
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
            .subscribe(onNext: { (dataState: CacheState<[Repo]>) in
                switch dataState.state {
                case .noCache:
                    self.stateOfDataLabel.text = "User does not have any repos."
                case .cache(let cache, _):
                    if let repos = cache {
                        self.stateOfDataLabel.text = "Num of repos for user: \(String(repos.count))"
                    } else {
                        self.stateOfDataLabel.text = "User does not have any repos."
                    }
                }
                
                if dataState.isRefreshing {
                    self.stateOfDataLabel.text = "Loading repos for user..."
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
        doneEditing()

        reposViewModel.gitHubUsername = usernameTextField.text!
    }
}

extension LaunchViewController: ThemableViewController {
    var navigationBarTitle: String? {
        "Repos"
    }

    var navigationBarBackButtonText: String? {
        nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentTheme.statusBarStyle
    }
}
