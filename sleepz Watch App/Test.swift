//
//  Test.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-02-08.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {

   @IBOutlet weak var label: WKInterfaceLabel!
   @IBOutlet weak var button: WKInterfaceButton!

   @IBAction func buttonTapped() {
      label.setText("Button Tapped!")
   }
}
