//
//  main.swift
//  NeatoTest
//
//  Created by Tara Tandel on 21/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass = isRunningTests ? nil : NSStringFromClass(AppDelegate.self)
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
