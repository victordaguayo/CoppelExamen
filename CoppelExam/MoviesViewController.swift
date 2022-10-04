//
//  MoviesViewController.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 26/09/22.
//

import UIKit

class MoviesViewController: UIViewController {

    
    //@IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var ScrollView: UIScrollView!
    let validateLoginUrl = "https://api.themoviedb.org/3/trending/all/day?api_key=137b11a240f2116a7e7712d532aa0286"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemPink
        // Do any additional setup after loading the view.
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
                    let myImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
                    
                    myImageView.loadFrom(URLAddress: "https://image.tmdb.org/t/p/w500\(lastString)")
                    myImageView.contentMode = .scaleAspectFit
                    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                    nameLabel.center = CGPoint(x: 10, y: 10)
                    nameLabel.textColor = .green
                    nameLabel.textAlignment = .center
                    nameLabel.text = MyResult.title ?? "no title"
                    let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
                    dateLabel.center = CGPoint(x: 9, y: 9)
                    dateLabel.textColor = .green
                    dateLabel.textAlignment = .left
                    dateLabel.font = UIFont.systemFont(ofSize: 12)
                    dateLabel.text = MyResult.release_date ?? "no date"
                    let puntuacionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
                    puntuacionLabel.textColor = .green
                    puntuacionLabel.textAlignment = .left
                    puntuacionLabel.text = String(MyResult.vote_average ?? 0.0)
                    let overviewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
                    overviewLabel.font = UIFont.systemFont(ofSize: 10)
                    overviewLabel.textColor = .white
                    overviewLabel.textAlignment = .justified
                    overviewLabel.text = MyResult.overview ?? "no overview"
                    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
                      button.backgroundColor = .green
                    button.tintColor = .black
                      button.setTitle("Descripción", for: .normal)
                    button.tag = MyResult.id ?? 0
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    


                    self.StackView.addArrangedSubview(myImageView)
                    self.StackView.addArrangedSubview(nameLabel)
                    self.StackView.addArrangedSubview(dateLabel)
                    self.StackView.addArrangedSubview(puntuacionLabel)
                    self.StackView.addArrangedSubview(overviewLabel)
                    self.StackView.addArrangedSubview(button)
                }
            })
            
            
            DispatchQueue.main.async {
                /*let myImageView = UIImageView()
                myImageView.loadFrom(URLAddress: "https://image.tmdb.org/t/p/w500\(lastString)")
                self.StackView.addArrangedSubview(myImageView)*/
                
                self.ScrollView.addSubview(self.StackView)
                self.view.addSubview(self.ScrollView)
            }
            /*let res : [MyResult]?
            
            if ((json.results as? MyResult?) != nil){
                res = json.results
                res?.forEach({ MyResult
                    in
                    print(MyResult.poster_path ?? "No data")
                    
                })
            }*/
            
        }
        task.resume()
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
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
        
    }
}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
