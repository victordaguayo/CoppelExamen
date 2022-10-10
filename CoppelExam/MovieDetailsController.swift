//
//  MovieDetailsController.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 04/10/22.
//


import UIKit

class MovieDetails : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func buttonBack(_ sender: Any) {
        print("Button tapped")
          DispatchQueue.main.async {
              let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "movies_view") as? MoviesViewController
              self.view.window?.rootViewController = homeViewController
              self.view.window?.makeKeyAndVisible()
          }
    }
    var IdMovie : String = ""
    
    var tituloArray : [String] = []
    var fechaArray : [String] = []
    var puntuacionArray : [String] = []
    var descripcionArray : [String] = []
    var imagenArray : [String] = []
    var idMovieArray = [0]
    var estimateWidth=300.0
    var cellMarginSize=16.0
    var presupuestoArray : [String] = []
    var duracionArray : [String] = []
    var vendioArray : [String] = []
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title:"Detalles Movie", style: .plain, target: nil, action: nil)
        */
        /*let button = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
        button.backgroundColor = .systemGreen
        button.tintColor = .black
          button.setTitle("Regresar", for: .normal)
        button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        self.view.addSubview(button)*/
        print(IdMovie)
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(IdMovie)?api_key=137b11a240f2116a7e7712d532aa0286&language=en-US")!
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
            var result: MyResult?
            do {
                result = try JSONDecoder().decode(MyResult.self, from : data)
                    
                
            } catch {
                print(error)
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
            guard let json = result else{
                return
            }
            print("RESULTADO DETAILS")
                    
            let lastStringBackDrop = json.backdrop_path ?? "no"
                                
            self.tituloArray.append(json.title ?? "no title")
            self.fechaArray.append(json.release_date ?? "no date")
            self.puntuacionArray.append(String(json.vote_average ?? 0.0))
            self.descripcionArray.append(json.overview ?? "no overview")
            self.imagenArray.append(lastStringBackDrop)
            self.idMovieArray.append(json.id ?? 0)
            self.duracionArray.append(String(json.runtime ?? 0))
            self.vendioArray.append(String(json.revenue ?? 0))
            self.presupuestoArray.append(String(json.budget ?? 0))
            
            DispatchQueue.main.async {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                
                self.collectionView.register(UINib(nibName: "itemCellDetail", bundle: nil), forCellWithReuseIdentifier: "itemCellDetail")
                
                self.setupGridView2()
                
                
            }
            print(lastStringBackDrop)
        }
        task.resume()
        
    }
    func setupGridView2(){
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
    }
    
    /*@objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        print(sender.tag)
        DispatchQueue.main.async {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "movies_view") as? MoviesViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
    }*/
    struct MyResult: Codable{
        let poster_path : String?
        let adult : Bool?
        let overview : String?
        let release_date: String?
        let id: Int?
        let original_title: String?
        let original_language: String?
        let title: String?
        let backdrop_path: String?
        let popularity: Float?
        let vote_count: Int?
        let video: Bool?
        let vote_average: Float?
        let budget : Int?
        let revenue : Int?
        let runtime : Int?
        
    }
}
extension MovieDetails:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tituloArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellDetail", for: indexPath) as! itemCellDetail
        cell.setData(titulo: self.tituloArray[indexPath.row], fecha: self.fechaArray[indexPath.row], puntuacion: self.puntuacionArray[indexPath.row], descripcion: self.descripcionArray[indexPath.row], imagen: self.imagenArray[indexPath.row], presupuesto: self.presupuestoArray[indexPath.row], duracion: self.duracionArray[indexPath.row], vendio: self.vendioArray[indexPath.row])
        
        return cell
        
    }
}
extension MovieDetails:UICollectionViewDelegateFlowLayout{
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
}
