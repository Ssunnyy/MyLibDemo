//
//  NORFilePreselectionDelegate.swift
//  nRF Toolbox
//
//  Created by Mostafa Berg on 12/05/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//
import Foundation

protocol NORFilePreselectionDelegate {
    func onFilePreselected(withURL aFileURL : URL)
}
