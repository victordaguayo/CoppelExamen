//
//  itemCellDetail.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 10/10/22.
//

import UIKit

class itemCellDetail: UICollectionViewCell {
//presupuesto budget
    @IBOutlet weak var tituloMovie: UILabel!
    @IBOutlet weak var imagenMovie: UIImageView!
    //duracion runtime
    @IBOutlet weak var descripcionMovie: UITextView!
    @IBOutlet weak var duracionMovie: UILabel!
    @IBOutlet weak var presupuestoMovie: UILabel!
 
    @IBOutlet weak var puntuacionMovie: UILabel!
    //vendio revenue
    @IBOutlet weak var vendioMovie: UILabel!
    @IBOutlet weak var fechaMovie: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(titulo: String, fecha: String, puntuacion: String, descripcion: String, imagen: String, presupuesto: String, duracion : String, vendio: String){
        self.tituloMovie.text = "Titulo: \(titulo)"
        self.fechaMovie.text = "Fecha: \(fecha)"
        self.puntuacionMovie.text = "Puntuación: \(puntuacion)"
        self.descripcionMovie.text = descripcion
        self.presupuestoMovie.text = "Presupuesto: \(presupuesto)"
        self.duracionMovie.text = "Duración: \(duracion)"
        self.vendioMovie.text = "Recaudó: \(vendio)"
        
        self.imagenMovie.loadFrom3(URLAddress: "https://image.tmdb.org/t/p/w500\(imagen)")
    }

}
extension UIImageView {
    func loadFrom3(URLAddress: String) {
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
