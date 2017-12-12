import UIKit
import Lottie
import Anchorage

class BlurLoadingViewController: UIViewController {
    let animationView = LOTAnimationView(name: "gears")
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissFade() {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            UIView.animate(withDuration: 0.5, animations: {
                self?.animationView.alpha = 0
            }, completion: { (_) in
                self?.unblur()
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when, execute: { [weak self] in
                    self?.dismiss(animated: false)
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            guard let `self` = self else { return }
            self.blur()
            self.view.addSubview(self.animationView)
            self.animationView.play()
            self.animationView.loopAnimation = true
            self.animationView.centerAnchors == self.view.centerAnchors
            
            UIView.animate(withDuration: 0.5, animations: {
                self.animationView.alpha = 1
            })
            
            //Create Activity Indicator
//            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//
//            // Position Activity Indicator in the center of the main view
//            myActivityIndicator.center = self?.view.center ?? CGPoint()
//
//            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
//            myActivityIndicator.hidesWhenStopped = false
//
//            // Start Activity Indicator
//            myActivityIndicator.startAnimating()
//
//            // Call stopAnimating() when need to stop activity indicator
//            //myActivityIndicator.stopAnimating()
            
            
//            self?.view.addSubview(myActivityIndicator)
        }
    }
}
