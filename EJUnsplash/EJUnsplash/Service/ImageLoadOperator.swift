//
//  ImageLoadOperator.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import UIKit

class ImageLoadOperator: Operation {
    var photoImage: UIImage?
    var url: URL?
    var completionHandler: ( (UIImage)->() )?
    
    init(url: URL?, completionHandler: @escaping (UIImage)->()) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    override func main() {
    }
}
