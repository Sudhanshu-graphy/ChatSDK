//  NextView.swift
//  Created by Sudhanshu Dwivedi on 12/12/20.
//  Copyright © 2020 Puneet Gupta. All rights reserved.
//

import UIKit

protocol NextViewDelegate: AnyObject {
    func nextView(_ view: NextView, nextButtonTapped button: UIButton)
}

class NextView: UIView {
    
    enum NextViewDirection {
        case right, left
    }
    
    public weak var delegate: NextViewDelegate?
    
    public var enableAutomaticFadeOut = true
    
    private var timer = Timer()
    private var counter = Int.zero {
        didSet {
            UIView.animate(withDuration: 0.6) { [weak self] in
                guard let self = self else { return }
                self.alpha = (self.counter == 0) ? 0.5 : 1
            }
        }
    }
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [startColor, endColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "round_arrow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.imageView?.tintColor = .white
        button.blink()
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let startColor = UIColor.clear.cgColor
    private let endColor = UIColor(white: 0.0, alpha: 0.3).cgColor
    
    public var buttonShouldTap: ((_ shouldTap: Bool) -> Void)?

    init(direction: NextViewDirection, addTo parentView: UIView) {
        super.init(frame: CGRect.zero)
        commitInit()
        // Add to parent view with constraints
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.12).isActive = true
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        switch direction {
        case .left:
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        case .right:
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        }
        // start the timer
        if enableAutomaticFadeOut {
            resetTimer()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commitInit() {
        // Add gradient layer
        self.layer.insertSublayer(gradient, at: 0)
        // Add button with constraints
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.nextView(self, nextButtonTapped: sender)
        sender.bounce()
        if enableAutomaticFadeOut {
            resetTimer()
        }
    }
    
    // MARK: Timer Methods
    private func resetTimer() {
        counter = 5
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        if counter == 0 {
            timer.invalidate()
        } else {
            counter -= 1
        }
    }
    
}
