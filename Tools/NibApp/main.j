//
// main.j
// Editor
//
// Created by Francisco Tolmasky on May 21, 2008.
// Copyright 2005 - 2008, 280 North, Inc. All rights reserved.
//

import <Foundation/Foundation.j>
import <AppKit/AppKit.j>

import "MyDocument.j"


function main(args, namedArgs)
{
    CPApplicationMain(args, namedArgs);
}

window.setTimeout(main, 0);