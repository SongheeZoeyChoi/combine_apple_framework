//
//  FrameworkDetailViewController.swift
//  AppleFramework
//
//  Created by joonwon lee on 2022/05/01.
//

import UIKit
import SafariServices
import Combine

class FrameworkDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    @Published var framework: AppleFramework = AppleFramework(name: "Unknown", imageName: "", urlString: "", description: "")
    var framework = CurrentValueSubject<AppleFramework, Never>(AppleFramework(name: "Unknown", imageName: "", urlString: "", description: ""))
    let buttonTapped = PassthroughSubject<AppleFramework, Never>()
    var subscription = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateUI()
        
        bind()
    }
    
    private func bind() {
        //input//
        // - 버튼 클릭했을 때 : framework -> url -> safari -> present
        buttonTapped
            .receive(on: RunLoop.main)
            .compactMap{ URL(string: $0.urlString) }
            .sink { [unowned self] url in
                let safari = SFSafariViewController(url: url)
                self.present(safari, animated: true)
            }.store(in: &subscription)
        
        //output//
        // - 전달 받은 데이터 넘어와서 UI업데이트 할 때
        framework
            .receive(on: RunLoop.main)
            .sink { [unowned self] framework in
                imageView.image = UIImage(named: framework.imageName)
                titleLabel.text = framework.name
                descriptionLabel.text = framework.description
            }.store(in: &subscription)
        
    }
    
//    func updateUI() {
//        imageView.image = UIImage(named: framework.imageName)
//        titleLabel.text = framework.name
//        descriptionLabel.text = framework.description
//    }
    
    
    @IBAction func learnMoreTapped(_ sender: Any) {
        
        buttonTapped.send(framework.value)
//        guard let url = URL(string: framework.urlString) else {
//            return
//        }
//
//        let safari = SFSafariViewController(url: url)
//
//        present(safari, animated: true)
    }
}
