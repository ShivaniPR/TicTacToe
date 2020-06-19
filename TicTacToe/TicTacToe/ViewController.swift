import UIKit

class ViewController:UIViewController{
    var player1:[Int] = []
    var player2:[Int] = []
    var position = 0
    let win:[[Int]] = [ [1,2,3], [4,5,6], [7,8,9] , [1,4,7], [2,5,8], [3,6,9] , [1,5,9], [3,5,7]]
    var playerNumber:Int = 1
    var filled:[Int] = []
    let allPositions:[Int] = [1,2,3,4,5,6,7,8,9]
    let positionMatch:Int = 3
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self , forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    func winDisplay(playerNumber : Int){
        let result = UILabel()
        result.text = "Player \(playerNumber) wins"
        result.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 120)
        result.textAlignment = .center
        result.textColor = UIColor.white
        result.backgroundColor = UIColor.darkGray
        view.addSubview(result)
    }
    
    func gameOver(){
        let label = UILabel()
        label.text = "It's a tie!"
        label.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 120)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkGray
        view.addSubview(label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.5 + 10, height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CustomCell
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCell {
            let index = indexPath.row + 1
            if playerNumber == 2 {
                playerNumber = 1
                cell.onTapImage(playerNumber: playerNumber)
                player2.append(index)
                for x in 0 ..< win.count {
                    position = 0
                    for y in 0 ..< win[x].count {
                        for k in 0 ..< player2.count{
                            if( win[x][y] == player2[k]){
                                position += 1
                            }
                        }
                    }
                    if(position == positionMatch){
                        if let viewController = self as? ViewController {
                            viewController.winDisplay(playerNumber : 2)
                        }
                        break
                    }
                }
            }
            else{
                playerNumber = 2
                player1.append(index)
                for x in 0 ..< win.count {
                    position = 0
                    for y in 0 ..< win[x].count {
                        for k in 0 ..< player1.count{
                            if( win[x][y] == player1[k]){
                                position += 1
                            }
                        }
                    }
                    if(position == positionMatch){
                        if let viewController = self as? ViewController {
                            viewController.winDisplay(playerNumber : 1)
                        }
                        break
                    }
                }
                cell.onTapImage(playerNumber : playerNumber)
            }
            filled = player1 + player2
            filled.sort()
            if filled.elementsEqual(allPositions){
                if let viewController = self as? ViewController {
                    viewController.gameOver()
                }
            }
        }
    }
}

class CustomCell: UICollectionViewCell{
    var noOfTimesTap:String!
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    @objc func onTapImage(playerNumber : Int){
        let iv = UIImageView()
        if playerNumber == 1 {
            iv.image = #imageLiteral(resourceName: "circle")
        }
        if playerNumber == 2 {
            iv.image = #imageLiteral(resourceName: "cross")
        }
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        contentView.addSubview(iv)
        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo:contentView.topAnchor),
            iv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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

