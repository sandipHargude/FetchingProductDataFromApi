//
//  ViewController.swift
//  CompanyTask3
//
//  Created by Mac on 17/12/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
    var products : [apiResponceProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        productApi()
        xibRedistration()
        delegateAndDataSource()
    }
    func delegateAndDataSource(){
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
    }
        
    func xibRedistration(){
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        self.productCollectionView.register(nib, forCellWithReuseIdentifier: "productCell")
    }
    
    func productApi(){
        let uriString = "https://fakestoreapi.com/products"
            guard let url = URL(string: uriString) else {
                print("String Not Found")
                return
                
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            
            let session = URLSession(configuration: .default)
          
         let dataTask = session.dataTask(with: request){Data , responce , Error in
                print("The data is \(Data)")
                print("The Error id \(Error)")
                
                
                
                guard let data = Data else
                {
                    print("No Data Found")
                    return
                    
                }
                guard let getJsonObject = try? JSONSerialization.jsonObject(with: Data!) as? [[String: Any]]
                else {
                    print("Json Object Not Found")
                    return
                    
                }
        
                for dictionary in getJsonObject{
                    let eachdictionary = dictionary
                    let pimage = eachdictionary["image"] as! String
                
                    
                    let newPost = apiResponceProduct(image: pimage)
                      
                    self.products.append(newPost)
                    
                }
            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
            }
            }
            dataTask.resume()
        }

    
}
extension ViewController : UICollectionViewDelegate{

    
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        let img = NSURL(string: products[indexPath.row].image)
        cell.productImage.sd_setImage(with: img as? URL)
        return cell
    }
    
    
}

