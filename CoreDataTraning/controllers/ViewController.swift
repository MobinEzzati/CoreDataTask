//
//  ViewController.swift
//  CoreDataTraning
//
//  Created by mobin on 1/6/23.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var noDataLable: UILabel!
    var segmentNumber:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTableView.reloadData()
        noteTableView.dataSource = self
        noteTableView.delegate = self
//        noteTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: Constant.noteTableViewCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.shared.sortData(segmentIndex: 0)
   
        reloadTableView()
    }
    
    func reloadTableView() {
        if (CoreDataManager.shared.getItems()!.isEmpty) {
            noDataLable.text = "No data is here"
        }else {
            noDataLable.text = " "
        }
        noteTableView.reloadData()
    }
    
    @IBAction func garmentAdder(_ sender: Any) {
        moveNoteController()
    }
    
    func moveNoteController(item:Item? = nil) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: Constant.noteVCID) as! NoteViewController
        controller.delegate = self
        controller.selectedItem = item
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func segmentClick(_ sender: Any) {
        
        if  segment.selectedSegmentIndex == 0 {
            segmentNumber = 0
            CoreDataManager.shared.sortData(segmentIndex: 0)
        }else {
            segmentNumber = 1
            CoreDataManager.shared.sortData(segmentIndex: 1)
        }
        reloadTableView()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataManager.shared.getItems()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell propertis like Label, image,...
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.noteTableViewCell, for: indexPath) as?UITableViewCell
        
        let singleItem:Item = CoreDataManager.shared.getItems()?[indexPath.row] ?? Item()
            
        cell!.textLabel?.text = singleItem.name
        if singleItem.image != nil {
            cell!.imageView?.image = UIImage(data: singleItem.image!)

        }
        
        return cell!
    }
    
    private func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableView.automaticDimension

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem:Item = CoreDataManager.shared.getItems()?[indexPath.row] ?? Item()
        moveNoteController(item: selectedItem)
    }
    // cell swipe on tableViw
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // create alert 
            let alert = UIAlertController(title: "delete note?", message: "You can always access your content by signing back in",         preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: UIAlertAction.Style.default,
                                          handler: { _ in
                alert.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "delete",
                                                  style: UIAlertAction.Style.default,
                                                  handler: {(_: UIAlertAction!) in
                CoreDataManager.shared.deleteData(index: indexPath.row)
                CoreDataManager.shared.sortData(segmentIndex: 1)
                self.reloadTableView()
                    }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension ViewController: SendData {
    func getData(note: String, imageData: Data?) {
        print(imageData?.description)
        CoreDataManager.shared.addData(name: note, date: Date(), imageData: imageData )
        CoreDataManager.shared.sortData(segmentIndex: 1)
        reloadTableView()
    }
    
    func getImageUrl(imageUrl: String) {
    }
    
    func getData(note: String) {

    }
}

