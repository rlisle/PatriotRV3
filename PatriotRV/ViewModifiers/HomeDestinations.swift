//
//  HomeDestinations.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/15/23.
//
import SwiftUI

struct HomeDestinations: ViewModifier {

    var trip: Trip
    var item: ChecklistItem
    
    init(trip: Trip, item: ChecklistItem) {
        self.trip = trip
        self.item = item
  }

  func body(content: Content) -> some View {
      content
      .navigationDestination(for: String.self) { dest in
          switch dest {
          case "trip":
              TripListView()
          case "addtrip":
              TripView()
          case "edittrip":
              TripView(trip: trip)
          case "itemlist":
              ChecklistView()
          case "additem":
              AddChecklistView()
          case "edititem":
              AddChecklistView(item: item)
          case "power":
              PowerView()
          default:    // Log
              LogRowView()
          }
      }
  }
}
