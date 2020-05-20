//
//  ContentTableView.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
import UIKit
#if !COCOAPODS
@_exported import Boomerang
#endif


public protocol ContentTableViewCellType: NSObjectProtocol, WithViewModel {
    var internalView: UIView? { get set }
    ///Constraints between cell and inner view.
    var insetConstraints: [NSLayoutConstraint] { get set }
}

public class ContentTableViewCell: UITableViewCell, ContentTableViewCellType {

    public func configure(with viewModel: ViewModel) {
        (self.internalView as? WithViewModel)?.configure(with: viewModel)
    }

    public weak var internalView: UIView? {
        didSet {
            guard let view = internalView else { return }
            self.backgroundColor = .clear
            self.contentView.addSubview(view)
            self.insetConstraints = view.fitInSuperview(with: .zero)
        }
    }
    ///Constraints between cell and inner view.
    public var insetConstraints: [NSLayoutConstraint] = []

    open override var canBecomeFocused: Bool {
        return internalView?.canBecomeFocused ?? super.canBecomeFocused
    }
    open override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return internalView?.preferredFocusEnvironments ?? super.preferredFocusEnvironments
    }
    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        return internalView?.didUpdateFocus(in: context, with: coordinator) ?? super.didUpdateFocus(in: context, with: coordinator)
    }

}
