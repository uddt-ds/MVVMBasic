//
//  MBTIViewController.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import UIKit
import SnapKit

final class MBTIViewController: UIViewController {

    private var selectedIndexDictionary: [Int:Int] = [:]

    let imageManager = ImageManager.shared

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 70
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.layer.borderWidth = 5
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        let imageName = self.imageManager.imageNames[Int.random(in: 0...11)]
        imageView.image = UIImage(named: imageName)
        return imageView
    }()

    private let cameraImageButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
        let image = UIImage(systemName: "camera.fill", withConfiguration: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.backgroundColor = .main
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()

//    let cameraImageView: UIImageView = {
//        let imageView = UIImageView()
//        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
//        imageView.contentMode = .center
//        imageView.layer.cornerRadius = 18
//        imageView.image = UIImage(systemName: "camera.fill", withConfiguration: symbolConfiguration)
//        imageView.backgroundColor = .blue   // 블루 색상 변경 필요
//        imageView.tintColor = .white
//        return imageView
//    }()

    private let nicknametextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        textField.borderStyle = .none
        textField.textColor = .darkGray
        return textField
    }()
    
    private let underLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .darkGray
        return lineView
    }()

    private let mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let completeButon: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 20
        button.isEnabled = false
        return button
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeMBTICollectionViewLayout())

    private let buttonTitleArr = ButtonTitle.e.horizontalArray

//    private var selectedArr: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        setupNav()
        setupGesture()
        addButtonTarget()

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(MBTICell.self, forCellWithReuseIdentifier: MBTICell.identifier)
    }

    private func makeMBTICollectionViewLayout() -> UICollectionViewFlowLayout {
        let deviceWidth = UIScreen.main.bounds.width 
        let cellWidth = (deviceWidth * 0.6 - 36) / 4
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .zero
        layout.itemSize = .init(width: cellWidth, height: cellWidth)
        return layout
    }

    private func configureHierarchy() {
        [imageView, cameraImageButton, nicknametextField, underLine, mbtiLabel, collectionView, completeButon].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(140)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }

        cameraImageButton.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.top.equalTo(imageView.snp.bottom).offset(-40)
            make.trailing.equalTo(imageView).offset(-8)
        }

        nicknametextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        underLine.snp.makeConstraints { make in
            make.top.equalTo(nicknametextField.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.centerX.equalTo(nicknametextField)
        }

        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknametextField.snp.bottom).offset(60)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel.snp.top)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.132)     // iphone16pro 기준 874에서 셀 2개의 높이와 인셋을 포함한 비율
        }

        completeButon.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }

    private func configureView() {
        view.backgroundColor = .white
    }

    private func addButtonTarget() {
        completeButon.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    private func updateButton() {
        completeButon.backgroundColor = completeButon.isEnabled ? .main : .darkGray
    }


    private func setupNav() {
        navigationItem.title = "PROFILE SETTING"
    }

    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(gesture)
    }

    private func checkButtonState() {
        if selectedIndexDictionary.count == 4 {
            completeButon.isEnabled = true
        } else {
            completeButon.isEnabled = false
        }
        updateButton()
    }

    @objc private func completeButtonTapped(_ sender: UIButton) {
        print(#function)
    }

    @objc private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MBTIViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonTitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICell.identifier, for: indexPath) as? MBTICell else { return .init() }
        cell.configureButton(title: buttonTitleArr[indexPath.item].rawValue, tag: indexPath.item)

        cell.buttonTapClosure = { btn in
            let tappedIndex = btn.tag
            let groupKey = self.buttonTitleArr[tappedIndex].groupKey
            let selectedIndex = self.selectedIndexDictionary[groupKey]
            if selectedIndex == nil {
                self.selectedIndexDictionary[groupKey] = tappedIndex
                self.collectionView.reloadItems(at: [IndexPath(item: tappedIndex, section: 0)])
            } else if selectedIndex == tappedIndex {
                self.selectedIndexDictionary[groupKey] = nil
                self.collectionView.reloadItems(at: [IndexPath(item: tappedIndex, section: 0)])
            } else {
                if let selectedIndex {
                    let reloadIndexes = [
                        IndexPath(item: selectedIndex, section: 0),
                        IndexPath(item: tappedIndex, section: 0)
                    ]
                    self.selectedIndexDictionary[groupKey] = tappedIndex
                    self.collectionView.reloadItems(at: reloadIndexes)
                }
            }
        }

        let groupKey = self.buttonTitleArr[indexPath.item].groupKey
        cell.changeButtonColor(isSelected: selectedIndexDictionary[groupKey] == indexPath.item)

        checkButtonState()

        return cell
    }
}

enum ButtonTitle: String, CaseIterable {
    case e = "E"
    case s = "S"
    case t = "T"
    case j = "J"
    case i = "I"
    case n = "N"
    case f = "F"
    case p = "P"

    var verticalArray: [ButtonTitle] {
        return ButtonTitle.allCases
    }
    
    var horizontalArray: [ButtonTitle] {
        // TODO: 시간되면 로직 풀어보기. 0, 4, 1, 5, 2, 6, 3, 7 순으로 데이터가 있어야 함
        return [ButtonTitle.e, ButtonTitle.i, ButtonTitle.s, ButtonTitle.n, ButtonTitle.t, ButtonTitle.f, ButtonTitle.j, ButtonTitle.p]
    }

    var groupKey: Int {
        switch self {
        case .e, .i: return 0
        case .n, .s: return 1
        case .t, .f: return 2
        case .j, .p: return 3
        }
    }
}
