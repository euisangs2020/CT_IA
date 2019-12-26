import UIKit
 
class ImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var selectImageB: UIButton!
    @IBOutlet var header: UILabel!
    @IBOutlet weak var imageTitle: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var imageViewWidth:CGFloat?
    
    var image:UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        header.text = "Choose Image"
        header.textColor = .black
        header.isHidden = false
        
        imageView.contentMode = .scaleAspectFill
        imageViewWidth = imageView.frame.width
        let placeholder = UIImage(named: "placeholder.png")
        imageView.image = resizeImage(placeholder!, imageViewWidth!)
        
        selectImageB.isEnabled = false
        
        imagePicker.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    /// Presents the image picking view when selectImageB is prsesed
    /// - Parameter sender: UIButton
    @IBAction func pressedSelectedImageB(_ sender: UIButton)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// When image is chosen by user after the above function, the image is saved to variable "image"
    /// - Parameters:
    ///   - picker: Picker
    ///   - info: Information of the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        imageView.image = resizeImage(image!, imageViewWidth!)
        imageView.image = image!
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "UploadImage", sender: self)
    }
    
    /// If the user cancels the image choosing process
    /// - Parameter picker: Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { dismiss(animated: true, completion: nil) }
    
    @IBAction func imageTitleEdited(_ sender: UITextField)
    {
        if imageTitle.text != ""
        {
            selectImageB.isEnabled = true
        }
    }
    
    
    /// Preparing for segue, sends image variable to UploadImage for uploading to Firebase storage
    /// - Parameters:
    ///   - segue: the segue
    ///   - sender: nextViewB
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let receiverVC = segue.destination as! UploadImage
        receiverVC.image = image
        receiverVC.imageTitle = imageTitle.text!
    }
   /*
    /// Determining whether the segue should be done based on whether an image has been chosen
    /// - Parameters:
    ///   - identifier: Segue identifier
    ///   - sender: nextViewB
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if image == nil
        {
            let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//            NSLog("The \"OK\" alert occured.")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }*/
    
    /// Function that gets an image and resizes it to a certain dimension, reducing size to fit screen but maintaining clarity
    /// - Parameters:
    ///   - image: image
    ///   - newWidth: the desired width of the image, usually the width of UITableViewCell
    func resizeImage(_ image: UIImage, _ newWidth: CGFloat) -> UIImage
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
