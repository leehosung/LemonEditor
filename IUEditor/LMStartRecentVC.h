//
//  LMStartRecentVC.h
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMStartRecentVC : NSViewController

@property   NSMutableArray *recentDocs;
@property (strong) IBOutlet NSArrayController *recentAC;
@property (weak) IBOutlet NSCollectionView *recentCollectV;
@property (nonatomic) NSIndexSet   *selectedIndexes;

@end