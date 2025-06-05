//
//  ViewController.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/5/25.
//

import UIKit

class MainViewController: UIViewController {
    
    private struct Constants {
        static let regularFontSize: CGFloat = 16.0
        static let underlineHeight: CGFloat = 2.0
        static let backgroundUnderlineHeight: CGFloat = 4.0 / UIScreen.main.scale
        static let animationDuration: TimeInterval = 0.3
        static let normalSegmentAlpha: CGFloat = 0.6
        
        static let allTabTitle = "All"
        static let politicsTabTitle = "Politics"
        static let technologyTabTitle = "Technology"
        static let educationTabTitle = "Education"
        
        static let allViewControllerID = "AllViewController"
        static let politicsViewControllerID = "PoliticsViewController"
        static let technologyViewControllerID = "TechnologyViewController"
        static let educationViewControllerID = "EducationViewController"
        
        static let mainStoryboardName = "Main"
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var pageViewController: UIPageViewController!
    var orderedViewControllers: [UIViewController] = []
    let segmentTitles = [
        Constants.allTabTitle,
        Constants.politicsTabTitle,
        Constants.technologyTabTitle,
        Constants.educationTabTitle
    ]
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .indicator
        return view
    }()
    
    private lazy var backgroundUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundUnderline
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundUnderlineView)
        self.view.addSubview(underlineView)
        
        setupPageViewController()
        setupSegmentedControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutBackgroundUnderlineView()
        updateUnderlinePosition(animated: false)
    }
    
    
    private func setupSegmentedControl() {
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: Constants.regularFontSize)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: Constants.regularFontSize, weight: .medium)
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupPageViewController() {
        guard let pageVC = children.first(where: { $0 is UIPageViewController }) as? UIPageViewController else {
            fatalError("Failed to find UIPageViewController in children. Ensure it's embedded in the Storyboard.")
        }
        pageViewController = pageVC
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let storyboard = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil)
        
        let allVC = storyboard.instantiateViewController(withIdentifier: Constants.allViewControllerID)
        let politicsVC = storyboard.instantiateViewController(withIdentifier: Constants.politicsViewControllerID)
        let techVC = storyboard.instantiateViewController(withIdentifier: Constants.technologyViewControllerID)
        let eduVC = storyboard.instantiateViewController(withIdentifier: Constants.educationViewControllerID)
        
        orderedViewControllers = [allVC, politicsVC, techVC, eduVC]
        
        if let firstViewController = orderedViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            logCurrentPageTitle(for: firstViewController)
        }
    }

   
    private func getIdentifiedSegmentViews() -> [UIView] {
        let controlHeight = segmentedControl.bounds.height
        guard controlHeight > 0 else { return [] }

        let candidateViews = segmentedControl.subviews.filter { view in
            !view.isHidden &&
            abs(view.bounds.height - controlHeight) < 1.0 &&
            view.bounds.width > 0
        }.sorted { $0.frame.origin.x < $1.frame.origin.x }

        var actualSegmentViews: [UIView] = []
        let numberOfActualSegments = segmentedControl.numberOfSegments
        
        guard numberOfActualSegments > 0 else { return [] }

        if candidateViews.count >= numberOfActualSegments * 2 {
            for i in 0..<numberOfActualSegments {
                let viewIndex = i * 2
                if viewIndex < candidateViews.count {
                    actualSegmentViews.append(candidateViews[viewIndex])
                }
            }
        } else if candidateViews.count == numberOfActualSegments {
            actualSegmentViews = candidateViews
        } else {
            print("Warning: Number of identified segment views (\(candidateViews.count)) is unexpected for \(numberOfActualSegments) segments. Underline positioning might be based on fallback.")
        }
        return actualSegmentViews
    }
    
    private func layoutBackgroundUnderlineView() {
        var bgUnderlineX = segmentedControl.frame.minX
        var bgUnderlineWidth = segmentedControl.frame.width
        
        let actualSegmentViews = getIdentifiedSegmentViews()
        
        if segmentedControl.numberOfSegments > 0,
           actualSegmentViews.count == segmentedControl.numberOfSegments,
           let firstSegmentView = actualSegmentViews.first,
           let firstSegmentTitle = segmentedControl.titleForSegment(at: 0) {
            
            let firstSegmentAttributes: [NSAttributedString.Key: Any]
            if segmentedControl.selectedSegmentIndex == 0, let attrs = segmentedControl.titleTextAttributes(for: .selected) {
                firstSegmentAttributes = attrs
            } else if let attrs = segmentedControl.titleTextAttributes(for: .normal) {
                firstSegmentAttributes = attrs
            } else {
                firstSegmentAttributes = [.font: UIFont.systemFont(ofSize: Constants.regularFontSize)]
            }
            
            let firstSegmentTextWidth = firstSegmentTitle.size(withAttributes: firstSegmentAttributes).width
            let firstSegmentFrameInSelfView = firstSegmentView.convert(firstSegmentView.bounds, to: self.view)
            
            bgUnderlineX = firstSegmentFrameInSelfView.origin.x + (firstSegmentFrameInSelfView.width - firstSegmentTextWidth) / 2
            bgUnderlineWidth = segmentedControl.frame.maxX - bgUnderlineX
        }
        
        backgroundUnderlineView.frame = CGRect(
            x: bgUnderlineX,
            y: segmentedControl.frame.maxY - Constants.backgroundUnderlineHeight,
            width: bgUnderlineWidth,
            height: Constants.backgroundUnderlineHeight
        )
    }
    
    private func updateUnderlinePosition(animated: Bool) {
        guard segmentedControl.numberOfSegments > 0,
              segmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment,
              let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else {
            underlineView.isHidden = true
            return
        }
        underlineView.isHidden = false
        
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let numberOfSegments = segmentedControl.numberOfSegments
        
        let attributes = segmentedControl.titleTextAttributes(for: .selected) ?? [
            .font: UIFont.systemFont(ofSize: Constants.regularFontSize, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        let textWidth = title.size(withAttributes: attributes).width
        
        let identifiedSegmentViews = getIdentifiedSegmentViews()
        
        let underlineFrame: CGRect
        
        if identifiedSegmentViews.count == numberOfSegments, selectedIndex < identifiedSegmentViews.count {
            let targetSegmentView = identifiedSegmentViews[selectedIndex]
            let segmentFrameInSelfView = targetSegmentView.convert(targetSegmentView.bounds, to: self.view)
            
            let underlineXPosition = segmentFrameInSelfView.origin.x + (segmentFrameInSelfView.width - textWidth) / 2
            let underlineYPosition = segmentedControl.frame.maxY - Constants.underlineHeight
            
            underlineFrame = CGRect(x: underlineXPosition, y: underlineYPosition, width: textWidth, height: Constants.underlineHeight)
        } else {
            print("Fallback: Using approximate underline position for segment \(selectedIndex).")
            let segmentTotalWidth = segmentedControl.bounds.width / CGFloat(max(1, numberOfSegments))
            let fallbackX = segmentedControl.frame.minX + (segmentTotalWidth * CGFloat(selectedIndex)) + (segmentTotalWidth - textWidth) / 2
            underlineFrame = CGRect(x: fallbackX, y: segmentedControl.frame.maxY - Constants.underlineHeight, width: textWidth, height: Constants.underlineHeight)
        }
        
        if animated {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.underlineView.frame = underlineFrame
            }
        } else {
            underlineView.frame = underlineFrame
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard selectedIndex < orderedViewControllers.count else { return }
        
        let targetViewController = orderedViewControllers[selectedIndex]
        
        let currentIndex = orderedViewControllers.firstIndex(of: pageViewController.viewControllers?.first ?? UIViewController()) ?? 0
        let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ? .forward : .reverse
        
        pageViewController.setViewControllers([targetViewController], direction: direction, animated: true) { [weak self] finished in
            if finished {
                self?.logCurrentPageTitle(for: targetViewController)
                self?.updateUnderlinePosition(animated: true)
            }
        }
    }
    
    private func logCurrentPageTitle(for viewController: UIViewController) {
        if let index = orderedViewControllers.firstIndex(of: viewController), index < segmentTitles.count {
            let title = segmentTitles[index]
            print("Current Page: \(title)")
        }
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, previousIndex < orderedViewControllers.count else { return nil }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < orderedViewControllers.count else { return nil }
        return orderedViewControllers[nextIndex]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = orderedViewControllers.firstIndex(of: visibleViewController) {
            segmentedControl.selectedSegmentIndex = index
            logCurrentPageTitle(for: visibleViewController)
            updateUnderlinePosition(animated: true)
        }
    }
}
