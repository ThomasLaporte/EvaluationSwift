//
//  ViewController.swift
//  EvalLaporte
//
//  Created by stagiaire on 05/05/2017.
//  Copyright © 2017 stagiaire. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var txtFilter: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pictures: UIImageView!
    
    var lstPictures:[Picture] = []
    var lstPicturesFilter:[Picture] = []
    var indexPic:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadJSON()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhoto(urlPicture:String, titlePicture:String){
        
        
        
        let url = URL(string: urlPicture)
        let data = try? Data(contentsOf: url!)
        self.pictures.image = UIImage(data: data!)
        self.lblTitle.text = titlePicture
        self.lblTitle.sizeToFit()
        
    }

    func loadJSON(){
        Alamofire.request("https://jsonplaceholder.typicode.com/photos").responseJSON { response in
            
            if let pictureLst:[[String:Any]] = response.result.value as? [[String:Any]] {
                for pict:[String:Any] in pictureLst {
                    if let titlePic = pict["title"] as? String,
                        let urlPic = pict["url"] as? String {
                        self.lstPictures.append(Picture(title: titlePic, url: urlPic))
                    }
                }
                self.loadPhoto(urlPicture: self.lstPictures[self.indexPic].url, titlePicture: self.lstPictures[self.indexPic].title)
                self.lstPicturesFilter = self.lstPictures
            }
            
        }
    }

    @IBAction func previousPicture(_ sender: Any) {
        
        if(indexPic > 0){
            indexPic -= 1
            if(self.txtFilter.text == ""){
                self.loadPhoto(urlPicture: self.lstPictures[self.indexPic].url, titlePicture: self.lstPictures[self.indexPic].title)
            }
            else{
                self.loadPhoto(urlPicture: self.lstPicturesFilter[self.indexPic].url, titlePicture: self.lstPicturesFilter[self.indexPic].title)
            }
            
        }
    }
    
    @IBAction func nextPicture(_ sender: Any) {
        
        var nbElements:Int = self.lstPictures.count
        if(self.lstPicturesFilter.count < self.lstPictures.count && self.lstPicturesFilter.count > 0){
            nbElements = self.lstPicturesFilter.count
        }
        
        if(indexPic < (nbElements - 1)){
            indexPic += 1
            if(self.txtFilter.text == ""){
                self.loadPhoto(urlPicture: self.lstPictures[self.indexPic].url, titlePicture: self.lstPictures[self.indexPic].title)
            }
            else{
                self.loadPhoto(urlPicture: self.lstPicturesFilter[self.indexPic].url, titlePicture: self.lstPicturesFilter[self.indexPic].title)
            }
        }
    }
    
    @IBAction func clickSearch(_ sender: Any) {
        indexPic = 0
        
        self.lstPicturesFilter = self.lstPictures.filter({$0.title.lowercased().contains(self.txtFilter.text!.lowercased())})
        
        if(self.lstPicturesFilter.count == 0){
            self.lstPicturesFilter = self.lstPictures
        }
        
        self.loadPhoto(urlPicture: self.lstPicturesFilter[self.indexPic].url, titlePicture: self.lstPicturesFilter[self.indexPic].title)
        
        
    }
    

}

