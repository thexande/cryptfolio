import UIKit

extension UIViewController {
    func blur() {
        //   Blur out the current view
        let blurView = UIVisualEffectView(frame: self.view.frame)
        self.view.addSubview(blurView)
        UIView.animate(withDuration:0.25) {
            blurView.effect = UIBlurEffect(style: .light)
        }
    }
    
    func unblur() {
        for childView in view.subviews {
            guard let effectView = childView as? UIVisualEffectView else { continue }
            UIView.animate(withDuration: 0.25, animations: {
                effectView.effect = nil
            }) {
                didFinish in
                effectView.removeFromSuperview()
            }
        }
    }
}

