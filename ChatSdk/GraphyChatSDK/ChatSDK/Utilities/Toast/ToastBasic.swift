//
//  ToastBasic.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 09/07/21.
//

import UIKit

public class ToastBasic: UIView, ToastView {
    private (set) lazy var toastLabel: UILabel = {
        let toastLabel = UILabel()
        toastLabel.font = AppFont.fontOf(type: .SemiBold, size: 12)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        return toastLabel
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = AppColors.barry03.withAlphaComponent(0.85)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            toastLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            toastLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            toastLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        toastLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 64
    }
    
    // This class function to make an Object is inspired from Android.
    public class func make(text: String) -> ToastBasic {
        let content = ToastBasic(frame: CGRect.zero)
        content.toastLabel.text = text
        return content
    }
}


public class ToastError: ToastBasic {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.barry03
    }
    
    public class func make(error text: String) -> ToastError {
        let content = ToastError(frame: CGRect.zero)
        content.toastLabel.text = text
        return content
    }
}
