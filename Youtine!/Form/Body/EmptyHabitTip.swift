//
//  InlineTip.swift
//  Youtine!
//
//  Created by Bobby Guerra on 3/25/26.
//


struct InlineTip: Tip {
    var title: Text {
        Text("Save as a Favorite")
    }
    var message: Text? {
        Text("Your favorite backyards always appear at the top of the list.")
    }
    var image: Image? {
        Image(systemName: "star")
    }
}