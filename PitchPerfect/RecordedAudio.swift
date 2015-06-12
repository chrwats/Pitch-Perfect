//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by CHRISTOPHER WATSON on 06/5/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl:NSURL!
    var title:String!
    
    init (filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}