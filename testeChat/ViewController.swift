//
//  ViewController.swift
//  testeChat
//
//  Created by Admin on 16/02/23.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var mensagem: UITextView!
    
}

struct mensagem {
    var nome: String
    var msg: String
}

class ViewController: UIViewController {
    
    let service: SocketIOManager = SocketIOManager()
    
    @IBOutlet weak var menssageTextField: UITextField!
    
    
    @IBOutlet weak var table: UITableView!
    
    var textos = [mensagem]() {
        didSet {
            table.reloadData()
        }
    }
    
    var player: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        service.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        askNickname()
    }
    
    func askNickname() {
        let alertController = UIAlertController(title: "SocketChat", message: "Please enter a nickname:", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            if textfield.text?.count == 0 {
                self.askNickname()
            }
            else {
                self.player = textfield.text
                self.service.conectaPlayer(player: textfield.text ?? "bundao")
                
            }
        }
        
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func enviaMensagem(_ sender: Any) {
        service.enviaMensagem(player: player, mensagem: menssageTextField.text ?? "nada")
        self.menssageTextField.text?.removeAll()
    }
    
    @IBAction func sair(_ sender: Any) {
        service.exitPlayer(player: player)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse or create a cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        
        // For a standard cell, use the UITableViewCell properties.
        cell.nome.text = textos[indexPath.row].nome
        cell.mensagem.text = textos[indexPath.row].msg
        return cell
        
    }
    
    
}


extension ViewController: Aporradodelegate {
    func didStart() {
        print("Conectado")
    }
    
    func newTurn(_ name: String) {
        print("seu turno")
    }
    
    func playerDidMove(_ name: String, from originIndex: Int, to newIndex: Int) {
        print("1")
        
    }
    
    func receivedMessage(_ name: String, msg: String) {
        print("Recebeu uma mensagem")
        textos.append(mensagem(nome: name, msg: msg))
    }
    
    
}
