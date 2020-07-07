import UIKit
import RxDataSources
import RxSwift
import RxCocoa

extension MySection : SectionModelType {
    typealias Item = Int
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}

class ViewController: UIViewController,UICollectionViewDelegateFlowLayout{
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
    let disposeBag = DisposeBag()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ImageDisplay.self , forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    let sections = [
        MySection(items: [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9
        ])
    ]
    
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
    
    func determinePlayerNumber(index : Int){
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
        if noTie{
            filled = player1 + player2
            filled.sort()
            if filled.elementsEqual(allPositions){
                self.gameOver()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setFunctionalityOfSelectedItem()
        setDataSource()
    }
    
    func setFunctionalityOfSelectedItem(){
        collectionView.rx.itemSelected
            .subscribe(onNext:{ indexPath in
                let index = Int(indexPath.row + 1)
                self.determinePlayerNumber(index: index)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? ImageDisplay {
                    cell.setCrossOrCircle(playerNumber: self.playerNumber)
                }
            }).disposed(by: disposeBag)
    }
    
    func setDataSource(){
        let dataSource = RxCollectionViewSectionedReloadDataSource<MySection>(
            configureCell: { dataSource, cv, indexPath, item in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageDisplay
                cell.backgroundColor = .white
                return cell
        })
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.5 + 10, height: collectionView.frame.height/3)
    }
}



























