//
//  itemCell.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 09/10/22.
//

import UIKit

class itemCell: UICollectionViewCell {

    @IBOutlet weak var puntuacionMovie: UILabel!
    @IBOutlet weak var descripcionMovie: UITextView!

    @IBOutlet weak var fechaMovie: UILabel!
    @IBOutlet weak var tituloMovie: UILabel!
    @IBOutlet weak var imagenMovie: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(titulo: String, fecha: String, puntuacion: String, descripcion: String, imagen: String){
        self.tituloMovie.text = titulo
        self.fechaMovie.text = fecha
        self.puntuacionMovie.text = puntuacion
        self.descripcionMovie.text = descripcion
        
        self.imagenMovie.loadFrom2(URLAddress: "https://image.tmdb.org/t/p/w500\(imagen)")
    }

}
extension UIImageView {
    func loadFrom2(URLAddress: String) {
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
