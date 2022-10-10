//
//  MoviesViewController.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 26/09/22.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let validateLoginUrl = "https://api.themoviedb.org/3/trending/all/day?api_key=137b11a240f2116a7e7712d532aa0286"
    
    var tituloArray : [String] = []
    var fechaArray : [String] = []
    var puntuacionArray : [String] = []
    var descripcionArray : [String] = []
    var imagenArray : [String] = []
    var idMovieArray : [Int] = []
    var estimateWidth=160.0
    var cellMarginSize=16.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        //view.backgroundColor = .systemPink
        // Do any additional setup after loading the view.
        
        //self.collectionView.delegate = self
        
        let url = URL(string: validateLoginUrl)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                
                let dataString = String(data: data, encoding: .utf8)
                print("dataString = \(dataString)")
                
                return
            }
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from : data)
                    
                
            } catch {
                print(error)
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
            guard let json = result?.results else{
                return
            }
            print("RESULTADO TRENDING")
            //print(json)
            var lastString = "no"
            json.forEach({ MyResult
                in
                print(MyResult.poster_path ?? "No data")
                DispatchQueue.main.async {
                    lastString = MyResult.poster_path ?? "no"
                    
                    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
                      button.backgroundColor = .green
                    button.tintColor = .black
                      button.setTitle("Descripción", for: .normal)
                    button.tag = MyResult.id ?? 0
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    
                    self.tituloArray.append(MyResult.title ?? "no title")
                    self.fechaArray.append(MyResult.release_date ?? "no date")
                    self.puntuacionArray.append(String(MyResult.vote_average ?? 0.0))
                    self.descripcionArray.append(MyResult.overview ?? "no overview")
                    self.imagenArray.append(lastString)
                    self.idMovieArray.append(MyResult.id ?? 0)
                    
                }
            })
            
            DispatchQueue.main.async {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                
                self.collectionView.register(UINib(nibName: "itemCell", bundle: nil), forCellWithReuseIdentifier: "itemCell")
                
                self.setupGridView()
                
                
            }
        }
        task.resume()
        
    }
    func setupGridView(){
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
    }
    //https://image.tmdb.org/t/p/w500/ prefijo para imagenes
    struct Response: Codable{
        let page: Int?
        let results : [MyResult]?
        let total_pages: Int?
        let total_results: Int?
    }
    struct MyResult: Codable{
        let poster_path : String?
        let adult : Bool?
        let overview : String?
        let release_date: String?
        let genre_ids : [Int]?
        let id: Int?
        let original_title: String?
        let original_language: String?
        let title: String?
        let backdrop_path: String?
        let popularity: Float?
        let vote_count: Int?
        let video: Bool?
        let vote_average: Float?
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        print(sender.tag)
        DispatchQueue.main.async {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "movie_details") as? MovieDetails
            homeViewController?.IdMovie=String(sender.tag)
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
        
    }
}
extension MoviesViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tituloArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! itemCell
        cell.setData(titulo: self.tituloArray[indexPath.row], fecha: self.fechaArray[indexPath.row], puntuacion: self.puntuacionArray[indexPath.row], descripcion: self.descripcionArray[indexPath.row], imagen: self.imagenArray[indexPath.row])
        return cell
        
    }
    
    
}
extension MoviesViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculatewidth()
        return CGSize(width: width, height: width*2)
    }
    func calculatewidth() -> CGFloat{
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width/estimatedWidth))
        let margin = CGFloat(cellMarginSize*2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize)*(cellCount - 1) - margin)/cellCount
        return width
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "movie_details") as? MovieDetails
        vc?.IdMovie = String(self.idMovieArray[indexPath.row])
        vc?.title = "Details: \(self.tituloArray[indexPath.row])"
        
        //self.navigationController?.pushViewController(vc!, animated: true)
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
}
