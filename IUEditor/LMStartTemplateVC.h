//
//  LMStartTemplateVC.h
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUProject.h"


@interface LMStartTemplateVC : NSViewController

@property (strong) IBOutlet NSArrayController *templateAC;
@property (weak) IBOutlet NSCollectionView *templateCollectionV;
@property (nonatomic) NSIndexSet   *selectedIndexes;

@end
