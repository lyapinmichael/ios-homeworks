//
//  ActionsViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.01.2024.
//

import UIKit

// MARK: - ActionsProviderProtocol

protocol ActionsProviderProtocol: AnyObject {

    var actions: [ActionItem] { get }
    
}

// MARK: - ActionsPopupViewControllerProtocol

protocol ActionsPopupViewControllerProtocol: UIViewController {
    init (sourceView: UIView,
          sourceRect: CGRect?,
          actionsProvider: ActionsProviderProtocol) throws
    
    init(sourceView: UIView,
         sourceRect: CGRect?,
         actions: [ActionItem]) throws
}


// MARK: - ActionsViewController

///
/// `ActionsViewController` is modally presented as a popover. Accepts an array of actions,
/// that will be offered for user take.
///
class ActionsPopupViewController: UITableViewController, ActionsPopupViewControllerProtocol {
    
    // MARK: Private properties
    
    private var actions: [ActionItem]
    
    // MARK: Init
    
    required convenience init(sourceView: UIView,
                              sourceRect: CGRect? = nil,
                     actionsProvider: ActionsProviderProtocol) throws {
        try self.init(sourceView: sourceView,
                      sourceRect: sourceRect,
                  actions: actionsProvider.actions)
    }
    
    required init(sourceView: UIView,
                  sourceRect: CGRect? = nil,
         actions: [ActionItem] = []) throws {
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        guard let popoverPresentationController else {
            throw ActionsViewControllerError.mustBePresentedAsPopover
        }
        popoverPresentationController.delegate = self
        popoverPresentationController.sourceView = sourceView
        popoverPresentationController.sourceRect = sourceRect ?? sourceView.frame
        popoverPresentationController.permittedArrowDirections = .up
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = Palette.dynamicSecondaryBackground
    }
    
    // MARK: TableView override methods
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 300,
                                      height: tableView.contentSize.height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actionForCell = actions[indexPath.row]
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = actionForCell.title
        configuration.textProperties.color = {
            switch actionForCell.type {
            case .normal:
                Palette.dynamicText
            case .destructive:
                    .red
            }
        }()
        configuration.textProperties.alignment = .center
        cell.contentConfiguration = configuration
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        40.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionForCell = actions[indexPath.row]
        actionForCell.action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
    }

    
}

extension ActionsPopupViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    
}

// MARK: - ActionItem

struct ActionItem {
    enum `Type` {
        case normal
        case destructive
    }
    
    let title: String
    let type: `Type`
    let action: () -> Void
    
    
}

// MARK: - ActionsViewControllerError

enum ActionsViewControllerError: Error {
    case mustBePresentedAsPopover
    

}

extension ActionsViewControllerError: CustomStringConvertible {
    var description: String {
        switch self {
        case .mustBePresentedAsPopover:
            return "ActionsViewController must be presended sriclty in `popover` modal presentation style."
        }
    }
    
    
}
