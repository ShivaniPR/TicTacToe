import UIKit

class ImageDisplay: UICollectionViewCell{
    var noOfTimesTap:String!
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    @objc func onTapImage(playerNumber : Int){
        let imageView = UIImageView()
        if playerNumber == 1 {
            imageView.image = #imageLiteral(resourceName: "circle")
        }
        if playerNumber == 2 {
            imageView.image = #imageLiteral(resourceName: "cross")
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo:contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo:contentView.topAnchor),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("Init is not implemented")
    }
}

