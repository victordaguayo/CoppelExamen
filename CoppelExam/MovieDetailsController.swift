//
//  MovieDetailsController.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 04/10/22.
//


import UIKit

class MovieDetails : UIViewController {
    var IdMovie : String = ""
    
   
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var StackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.backgroundColor = .systemGreen
        button.tintColor = .black
          button.setTitle("Regresar", for: .normal)
        button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
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
            print("RESULTADO TRENDING")
            //print(json)
            var lastString = "no"
            
                print(json.poster_path ?? "No data")
                DispatchQueue.main.async {
                    lastString = json.poster_path ?? "no"
                    let myImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
                    
                    myImageView.loadFrom(URLAddress: "https://image.tmdb.org/t/p/w500\(lastString)")
                    myImageView.contentMode = .scaleAspectFit
                    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                    nameLabel.center = CGPoint(x: 10, y: 10)
                    nameLabel.textColor = .green
                    nameLabel.textAlignment = .center
                    nameLabel.text = json.title ?? "no title"
                    let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
                    dateLabel.center = CGPoint(x: 9, y: 9)
                    dateLabel.textColor = .green
                    dateLabel.textAlignment = .left
                    dateLabel.font = UIFont.systemFont(ofSize: 12)
                    dateLabel.text = json.release_date ?? "no date"
                    let puntuacionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
                    puntuacionLabel.textColor = .green
                    puntuacionLabel.textAlignment = .left
                    puntuacionLabel.text = String(json.vote_average ?? 0.0)
                    let overviewLabel = UITextView (frame: CGRect(x: 0, y: 0, width: 100, height: 50))
                    overviewLabel.font = UIFont.systemFont(ofSize: 10)
                    overviewLabel.textColor = .white
                    overviewLabel.textAlignment = .justified
                    overviewLabel.text = json.overview ?? "no overview"
                    
                    
                    var lastStringBackDrop = json.backdrop_path ?? "no"
                    let myImageView2 = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
                    
                    myImageView2.loadFrom(URLAddress: "https://image.tmdb.org/t/p/w500\(lastStringBackDrop)")
                    myImageView2.contentMode = .scaleAspectFit
                    self.StackView.addArrangedSubview(myImageView2)
                    self.StackView.addArrangedSubview(nameLabel)
                    //self.StackView.addArrangedSubview(myImageView)
                    self.StackView.addArrangedSubview(puntuacionLabel)
                    self.StackView.addArrangedSubview(dateLabel)
                    
                    self.StackView.addArrangedSubview(overviewLabel)
                    
                }
            DispatchQueue.main.async {
                self.ScrollView.addSubview(self.StackView)
                
                self.view.addSubview(self.ScrollView)
            }
            
        }
        task.resume()
        
    }
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        print(sender.tag)
        DispatchQueue.main.async {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "movies_view") as? MoviesViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
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
