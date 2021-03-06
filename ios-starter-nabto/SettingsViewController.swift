//
//  SettingsViewController.swift
//  ios-starter-nabto
//
//  Created by Tiago Lira on 31/01/2017.
//  Copyright © 2017 Nabto. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var fingerprintLabel : UILabel!
    @IBOutlet weak var keypairButton    : UIButton!
    @IBOutlet weak var clearButton      : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keypairButton.clipsToBounds = true
        clearButton.clipsToBounds   = true
        keypairButton.layer.cornerRadius = 6
        clearButton.layer.cornerRadius   = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fingerprintLabel.text = getFormattedFingerprint()
    }
    
    func resetKeypair() {
        ProfileTools.clearProfile() //remove from saved data
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    func getFormattedFingerprint() -> String? {
        guard let string = ProfileTools.getSavedCertificate() else { return nil }
        return UserInfo.format(fingerprint: string)
    }
    
    //MARK: - IBActions
    
    @IBAction func goToHome(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    //shows an alert
    @IBAction func recreateKeyPair(_ sender: Any) {
        
        let title = "Re-create profile"
        let message = "Are you sure you want to remove the currently active keypair? You must factory reset devices that you are owner of to be owner again with the new key."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
            self.resetKeypair()
            alert.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func clearBookmarks(_ sender: Any) {
        
        let title = "Clear device list"
        let message = "Are you sure you want to clear the list of known devices?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
            BookmarkManager.shared.clearBookmarks()
            alert.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProfileCreateViewController {
            destination.isReset = true
        }
    }
    

}
