//
//  Maintenance.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/7/23.
//

import Foundation

struct MaintenanceSeed {
    static let initialMaintenance = [
        
        // MAINTENANCE 0
        ChecklistItem(
            key: "genRun",
            name: "Run Generator",
            category: .maintenance,
            description: "<p>Periodically run the generator</p><ul><li>Run under load for 20-30 minutes</li></ul>",
            sortOrder: 0,
            isDone: true),
        
        ChecklistItem(
            key: "genChangeOil",
            name: "Change Generator Oil",
            category: .maintenance,
            description: "<p>Change the generator oil every 150 hours or annually</p></ul><li>SAE 15W40 (OnaMax) 10°-100°F </li><li>SAE 30 above 32°F</li><li>SJ, SH, or SG Performance class</li><li>May be combined with CH-4, CG-4, or CF-4</li><li>eg. SJ/CH-4</li></ul>",
            sortOrder: 0,
            isDone: true),
        ChecklistItem(
            key: "genAirFilter",
            name: "Replace Generator Air Filter",
            category: .maintenance,
            description: "<p>Change generator air filter every 150 hours</p><p>Change more frequently if dusty environment</p>",
            sortOrder: 0,
            isDone: true),
        ChecklistItem(
            key: "genSparkPlugs",
            name: "Replace Generator Spark Plugs",
            category: .maintenance,
            description: "<p>Change generator spark plugs every 500 hours or 3 years</p>",
            sortOrder: 0,
            isDone: true),
        ChecklistItem(
            key: "genSparkArrestor",
            name: "Clean Generator Spark Arrestor",
            category: .maintenance,
            description: "<p>Clean generator spark arrestor every 50 hours</p>",
            sortOrder: 0,
            isDone: true),
        ChecklistItem(
            key: "genFuelFilter",
            name: "Replace Generator Fuel Filter",
            category: .maintenance,
            description: "<p>Change generator fuel filter every 500 hours</p><p>Change sooner if performance deteriorates or every 3 years</p>",
            sortOrder: 0,
            isDone: true)
    ]
}
