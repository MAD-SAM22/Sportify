//
//  OnboardingViewController.swift
//  Sportify
//
//  Created by Mina_Wagdy on 24/05/2026.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    var presenter: OnboardingPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = OnboardingPresenter(view: self)

        collectionView.delegate = self
        collectionView.dataSource = self
        // --- ADDED: Force the strict layout rules programmatically ---
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout

        // Prevent iOS from adding invisible padding for the notch/dynamic island
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        presenter.viewDidLoad()
    }

    @IBAction func nextBtnClicked(_ sender: Any) {
        presenter.nextButtonClicked(currentIndex: pageControl.currentPage)
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        presenter.skipButtonClicked()
    }
}
// MARK: - OnboardingViewProtocol Implementation
extension OnboardingViewController: OnboardingViewProtocol {
    func reloadData() {
        collectionView.reloadData()
        pageControl.numberOfPages = presenter.slides.count
    }

    func updatePageIndicator(to index: Int) {
        pageControl.currentPage = index
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(
            at: indexPath, at: .centeredHorizontally, animated: true)

        if index == presenter.slides.count - 1 {
            nextBtn.setTitle("Get Started", for: .normal)
        } else {
            nextBtn.setTitle("Next", for: .normal)
        }
    }

    func navigateToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let mainTabBarVC = storyboard.instantiateViewController(
                withIdentifier: "MainTabBarController") as? UITabBarController
        else {
            fatalError("MainTabBarController not found in Storyboard")
        }

        // Access the current window via the SceneDelegate
        guard
            let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else {
            return
        }

        // Swap the root view controller with a smooth cross-dissolve animation
        UIView.transition(
            with: window, duration: 0.4, options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = mainTabBarVC
            }, completion: nil)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension OnboardingViewController: UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return presenter.slides.count
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "OnboardingCell", for: indexPath)
            as! OnboardingCollectionViewCell

        let slide = presenter.slides[indexPath.row]
        cell.titleLabel.text = slide.title
        cell.descriptionLabel.text = slide.description
        cell.slideImageView.image = UIImage(named: slide.imageName)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    // Update page control when user swipes manually
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / width)
        updatePageIndicator(to: currentPage)
    }
}
