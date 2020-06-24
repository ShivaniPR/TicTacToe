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
    var noTie = true
    var result:UILabel!
    var tie:UILabel!
    let localizedTie = NSLocalizedString("tie", comment: "")
    let resultString = NSLocalizedString("winner", comment: "")
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ImageDisplay.self , forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    func winDisplay(playerNumber : Int){
        result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textAlignment = .center
        result.textColor = UIColor.white
        result.backgroundColor = UIColor.darkGray
        result.text = String.localizedStringWithFormat(resultString, playerNumber)
        view.addSubview(result)
        
        NSLayoutConstraint.activate([
            result.topAnchor.constraint(equalTo:view.topAnchor,constant: 80),
            result.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            result.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            result.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -450)
        ])
    }
    
    func gameOver(){
        tie = UILabel()
        tie.translatesAutoresizingMaskIntoConstraints = false
        tie.textAlignment = .center
        tie.textColor = UIColor.white
        tie.backgroundColor = UIColor.darkGray
        tie.text = String.localizedStringWithFormat(localizedTie)
        view.addSubview(tie)
        
        NSLayoutConstraint.activate([
            tie.topAnchor.constraint(equalTo:view.topAnchor,constant: 80),
            tie.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tie.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tie.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -450)
        ])
    }
    
    func handlePlayer(playerNumber : Int, playerArray : [Int]){
        for x in 0 ..< win.count {
            position = 0
            for y in 0 ..< win[x].count {
                for k in 0 ..< playerArray.count{
                    if( win[x][y] == playerArray[k]){
                        position += 1
                    }
                }
            }
            if(position == positionMatch){
                noTie = false
                winDisplay(playerNumber: playerNumber)
                break
            }
        }
    }
    
    func determine(index : Int){
        if playerNumber == 2 {
            player2.append(index)
            handlePlayer(playerNumber : playerNumber, playerArray : player2)
            playerNumber = 1
        }
        else{
            player1.append(index)
            handlePlayer(playerNumber : playerNumber, playerArray : player1)
            playerNumber = 2
        }
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
        return 9 // It represents the number of cells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageDisplay
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageDisplay {
            let index = indexPath.row
            self.determine(index : index)
            cell.onTapImage(playerNumber: playerNumber)
            if noTie{
                filled = player1 + player2
                filled.sort()
                if filled.elementsEqual(allPositions){
                    self.gameOver()
                }
            }
            
        }
    }
}

