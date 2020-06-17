import Foundation
import Kingfisher
import UIKit

protocol PickerViewDelegate: AnyObject {
    func pickerView(_ pickerView: PickerView, didSelect rows: [Int]) // Unlike UIPickerViewDelegate where this function is called when you scroll to that position, this is called when it's chosen by the user. Rows is an array of zero indexed rows in each component, in order.
    func pickerViewDidCancel(_ pickerView: PickerView)
}

/**
 Like `UIPickerView`, however, includes buttons to accept the chosen row and a method to cancel as well.
 */
class PickerView: UIView {
    fileprivate var didSetupConstraints = false

    weak var delegateDataSource: (UIPickerViewDataSource & UIPickerViewDelegate & PickerViewDelegate)? {
        didSet {
            picker.dataSource = delegateDataSource
            picker.delegate = delegateDataSource
        }
    }

    let picker: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = Colors.pickerViewBackground.color
        return view
    }()

    let cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle(Strings.cancel.localized, for: .normal)
        return view
    }()

    let acceptButton: UIButton = {
        let view = UIButton()
        view.setTitle(Strings.accept.localized, for: .normal)
        return view
    }()

    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.pickerViewBackground.color
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        build()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func build() {
        buttonsView.addSubview(cancelButton)
        buttonsView.addSubview(acceptButton)

        addSubview(buttonsView)
        addSubview(picker)

        cancelButton.setTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        acceptButton.setTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            let buttonsPadding = 12

            acceptButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(buttonsPadding)
                make.top.bottom.equalToSuperview().inset(buttonsPadding)
            }
            cancelButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(buttonsPadding)
                make.top.bottom.equalToSuperview().inset(buttonsPadding)
            }
            buttonsView.snp.makeConstraints { make in
                make.bottom.equalTo(picker.snp.top)
                make.width.equalToSuperview()
            }
            buttonsView.resistGrowing(for: .vertical)

            picker.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            picker.resistShrinking(for: .vertical)

            snp.makeConstraints { make in
                make.top.equalTo(buttonsView.snp.top)
            }

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    @objc func cancelButtonPressed() {
        delegateDataSource?.pickerViewDidCancel(self)
    }

    @objc func acceptButtonPressed() {
        var rowIndexes: [Int] = []

        for componentIndex in 0..<picker.numberOfComponents {
            rowIndexes.append(picker.selectedRow(inComponent: componentIndex))
        }

        delegateDataSource?.pickerView(self, didSelect: rowIndexes)
    }
}

// Handy functions for using this view more like a UIPickerView
extension PickerView {
    var numberOfComponents: Int {
        picker.numberOfComponents
    }

    func numberOfRows(inComponent componentIndex: Int) -> Int {
        picker.numberOfRows(inComponent: componentIndex)
    }

    func title(forRow row: Int, forComponent: Int) -> String? {
        picker.delegate?.pickerView?(picker, titleForRow: row, forComponent: forComponent)
    }
}
