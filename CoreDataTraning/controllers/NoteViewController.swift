//
//  NoteViewController.swift
//  CoreDataTraning
//
//  Created by mobin on 1/6/23.
//

import UIKit

protocol SendData {
    
    func getData(note:String , imageData:Data?)
}

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var noteTextEditor: UITextView!
    @IBOutlet var saveButton: UIButton?
    
    @IBOutlet weak var deleteNoteButton: UIButton!
    var delegate : SendData? = nil
    var selectedItem:Item? = nil
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        noteTextEditor.delegate = self
        deleteNoteButton?.isHidden = true
        if selectedItem != .none {
            print(selectedItem?.image)
            print(selectedItem?.itemID)
            print(selectedItem?.name)
            noteTextEditor?.text = selectedItem?.name
            saveButton?.setTitle("Update Item", for: .normal)
            deleteNoteButton?.isHidden = false

        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
         noteImage.isUserInteractionEnabled = true
         noteImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    @IBAction func saveAndUpdateNote (_ sender: UIButton) {
      
        CoreDataManager.shared.updateItem(itemId: (selectedItem?.itemID)!, newStr:self.noteTextEditor.text)
        let data = (self.noteTextEditor?.text)!
        if let imageData = noteImage.image?.pngData() {
            self.delegate?.getData(note: data, imageData: imageData)
        }

        navigationController?.popViewController(animated: true)
//        if sender.titleLabel?.text == "Update Item"{
//            CoreDataManager.shared.updateItem(itemId: (selectedItem?.itemID)!, newStr:self.noteTextEditor.text)
//            let data = (self.noteTextEditor?.text)!
//            if let imageData = noteImage.image?.pngData() {
//                self.delegate?.getData(note: data, imageData: imageData)
//            }
//
//            navigationController?.popViewController(animated: true)
//
//
//        }else {
//            let data = (self.noteTextEditor?.text)!
//            if let imageData = noteImage.image?.pngData() {
//                self.delegate?.getData(note: data, imageData: imageData)
//            }
//            navigationController?.popViewController(animated: true)
//        }
//
        
 

    }
    
    @IBAction func deleteNote(_ sender: Any) {
        CoreDataManager.shared.deleteDataById(itemId: (selectedItem?.itemID)!)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: Any) {
    
        
    }
    

    
  // click on Image and pick photo from gallery
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)

    }
    
}
// Image Picker delegate

extension NoteViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        noteImage.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension NoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil {
            noteTextEditor.resignFirstResponder()
            return false
        }
        return true
    }
    
    
}




