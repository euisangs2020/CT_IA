import UIKit
 
class ImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    // selected is the UILabel for the Cell where the UIImagePicker is
    @IBOutlet var selected: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    let input:[String] = ["name", "contact", "loc", "bio", "industry"]
    
    var image:UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        tableView.dataSource = self
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    @IBAction func pressedSelectedImageB(_ sender: UIButton)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        selected.text = "Selected"
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableViewController Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return input.count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath.row)
        switch indexPath.row
        {
        case 0:
            let cell:SelectImageCell = tableView.dequeueReusableCell(withIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell
            cell.label.text = "Photo"
            return cell
            
        case input.count+1:
            let cell:SubmitCell = tableView.dequeueReusableCell(withIdentifier: "SubmitCell", for: indexPath) as! SubmitCell
            return cell
            
        default:
            let cell:InsertInfoCell = tableView.dequeueReusableCell(withIdentifier: "InsertInfoCell", for: indexPath) as! InsertInfoCell
            cell.label.text = input[indexPath.row-1]
            return cell
        }
    }
    
    @IBAction func submitB(_ sender: UIButton)
    {
        
    }
    
}
