//
//  Theme.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 2/2/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import UIKit

struct Theme {
    enum Colors {
        case NavigationBar
        case NavigationFont
        case PullRefreshBackground
        case PullRefreshLoading
        
        var color: UIColor {
            switch self {
                case .NavigationBar: return UIColor(red:0.2, green:0.2, blue:0.22, alpha:1)
                case .NavigationFont: return UIColor(white: 1, alpha: 1)
                case .PullRefreshBackground: return UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
                case .PullRefreshLoading: return UIColor(white: 1, alpha: 1)
            }
        }
    }
    
}