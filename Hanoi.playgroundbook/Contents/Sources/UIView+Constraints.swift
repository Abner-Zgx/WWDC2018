import UIKit

extension UIView {
    public func constrainToCenterOfParent(withAspectRatio aspectRatio: CGFloat) {
        let parent = superview!
        
        //中心约束
        let centerX = self.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        centerX.priority = UILayoutPriority.required
        let centerY = self.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
        centerY.priority = UILayoutPriority.required
        
        //宽高约束
        let aspectRatio = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio) //宽高比
        aspectRatio.priority = UILayoutPriority.required
        let lessThanOrEqualWidth = self.widthAnchor.constraint(lessThanOrEqualTo: parent.widthAnchor)
        lessThanOrEqualWidth.priority = UILayoutPriority.required
        let lessThanOrEqualHeight = self.widthAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor)
        lessThanOrEqualHeight.priority = UILayoutPriority.required
        
        let equalWidth = self.widthAnchor.constraint(equalTo: parent.widthAnchor)
        equalWidth.priority = UILayoutPriority.defaultHigh
        let equalHeight = self.heightAnchor.constraint(equalTo: parent.heightAnchor)
        equalHeight.priority = UILayoutPriority.defaultHigh
        
        NSLayoutConstraint.activate([
            centerX,
            centerY,
            aspectRatio,
            lessThanOrEqualWidth,
            lessThanOrEqualHeight,
            equalWidth,
            equalHeight
        ])
    }
}
