//
//  IUEventVariable.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUEventVariable.h"
#import "IUDocument.h"

@interface IUEventVariable()

@property NSMutableDictionary* variablesDict;

@end

@implementation IUEventVariable

- (id)init{
    self = [super init];
    if(self){
        _variablesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)hasVariableDict:(NSString *)variable{
    if([_variablesDict objectForKey:variable]==nil){
        return NO;
    }
    return YES;
}

- (NSMutableDictionary *)eventCollectionDictOfVariable:(NSString *)variable{
    NSMutableDictionary *oneDict;
    
    if([self hasVariableDict:variable]){
        oneDict = [_variablesDict objectForKey:variable];
    }
    else{
        oneDict = [NSMutableDictionary dictionary];
        NSMutableArray *array = [NSMutableArray array];
        [oneDict setObject:array forKey:IUEventTagReceiverArray];
        [_variablesDict setObject:oneDict forKey:variable];
    }
    return oneDict;
}

- (NSMutableArray *)receiverArrayOfVariable:(NSString *)variable{
    NSMutableDictionary *dict = [self eventCollectionDictOfVariable:variable];
    return [dict objectForKey:IUEventTagReceiverArray];
}

- (void)makeEventDictionary:(IUDocument *)document{
    for (IUBox *obj in document.allChildren) {
        NSString *variable =  obj.event.variable;
        if(variable){
            NSMutableDictionary *oneDict = [self eventCollectionDictOfVariable:variable];
            [oneDict setObject:variable forKey:IUEventTagVariable];
            [oneDict setObject:obj.htmlID forKey:IUEventTagIUID];
            [oneDict setObject:@(obj.event.initialValue) forKey:IUEventTagInitialValue];
            [oneDict setObject:@(obj.event.maxValue) forKey:IUEventTagMaxValue];
            [oneDict setObject:@(obj.event.actionType) forKey:IUEventTagActionType];
        }
        NSString *visibleVariable = obj.event.eqVisibleVariable;
        if(visibleVariable){
            NSMutableDictionary *visibleDict = [NSMutableDictionary dictionary];
            [visibleDict setObject:obj.htmlID forKey:IUEventTagVisibleID];
            [visibleDict setObject:obj.event.eqVisible forKey:IUEventTagVisibleEquation];
            [visibleDict setObject:@(obj.event.eqVisibleDuration) forKey:IUEventTagVisibleDuration];
            [visibleDict setObject:@(obj.event.directionType) forKey:IUEventTagVisibleDirection];
            
            NSMutableArray *receiverArray = [self receiverArrayOfVariable:visibleVariable];
            [receiverArray addObject:visibleDict];
        }
        
        NSString *frameVariable = obj.event.eqFrameVariable;
        if(frameVariable){
            NSMutableDictionary *frameDict = [NSMutableDictionary dictionary];
            [frameDict setObject:obj.htmlID forKey:IUEventTagFrameID];
            [frameDict setObject:obj.event.eqFrame forKey:IUEventTagFrameEquation];
            [frameDict setObject:@(obj.event.eqFrameDuration) forKey:IUEventTagFrameDuration];
            [frameDict setObject:@(obj.event.eqFrameWidth) forKey:IUEventTagFrameWidth];
            [frameDict setObject:@(obj.event.eqFrameHeight) forKey:IUEventTagFrameHeight];
            
            NSMutableArray *receiverArray = [self receiverArrayOfVariable:frameVariable];
            [receiverArray addObject:frameDict];
            
        }
    }
}


- (NSString *)outputEventJSSource{
    NSArray *variableArray = _variablesDict.allKeys;
    
    NSMutableString *header = [NSMutableString string];
    NSMutableString *bodyHeader = [NSMutableString string];
    NSMutableString *body = [NSMutableString string];
    
    for(NSString *variable in variableArray){
        NSDictionary *oneDict = [_variablesDict objectForKey:variable];
        if(oneDict){
            [header appendFormat:@"var %@=0;", variable];
            [header appendNewline];
            
            id value;
#pragma mark initialize variable
            value = [oneDict objectForKey:IUEventTagInitialValue];
            if(value){
                NSInteger initial = [value integerValue];
                [header appendFormat:@"var INIT_IU_%@=%ld;", variable, initial];
                [header appendNewline];
                [bodyHeader appendFormat:@"%@ = INIT_IU_%@;", variable, variable];
            }
            
            value = [oneDict objectForKey:IUEventTagMaxValue];
            if(value){
                NSInteger max = [value integerValue];
                [header appendFormat:@"var MAX_IU_%@=%ld;", variable, max];
                [header appendNewline];
                
            }
            
#pragma mark make body;
            NSMutableString *eventString = [NSMutableString string];
            
            value = [oneDict objectForKey:IUEventTagIUID];
            if(value){
                [eventString appendFormat:@"$(\"#%@\").", value];
                
                IUEventActionType type = [[oneDict objectForKey:IUEventTagActionType] intValue];
                if(type == IUEventActionTypeClick){
                    [eventString appendString:@"click(function(){"];
                }
                else if(type == IUEventActionTypeHover){
                    [eventString appendString:@"hover(function(){"];
                }
                else{
                    JDFatalLog(@"no action type");
                }
                [eventString appendNewline];
                
                [eventString appendFormat:@"%@++;",variable];
                [eventString appendNewline];
                [eventString appendFormat:@"if( %@ > MAX_IU_%@ ){ %@ = INIT_IU_%@ }",variable, variable, variable, variable];
                [eventString appendNewline];
                
                
#pragma mark make event innerJS
                NSArray *receiverArray = [oneDict objectForKey:IUEventTagReceiverArray];
                NSMutableString *innerfunctionStr = [NSMutableString string];

                for(NSDictionary *receiverDict in receiverArray){
#pragma mark Visible Src
                    value = [receiverDict objectForKey:IUEventTagVisibleEquation];
                    if(value){
                        
                        NSString *visibleID = [receiverDict objectForKey:IUEventTagVisibleID];
                        NSInteger duration = [[receiverDict objectForKey:IUEventTagVisibleDuration] integerValue];
                        
                        
                        [innerfunctionStr appendFormat:@"if( %@%@ ){", variable, value];
                        
                        NSMutableString *innerJS = [NSMutableString string];
                        [innerJS appendFormat:@"$(\"#%@\").show(", visibleID];
                        [innerJS appendFormat:@"%ld);", duration];
                        
                        [innerfunctionStr appendString:[innerJS stringByAddingTab]];
                        [innerfunctionStr appendString:@"}"];
                        [innerfunctionStr appendNewline];
                        
                        [innerfunctionStr appendString:@"else{\n"];
                        [innerfunctionStr appendFormat:@"\t$(\"#%@\").hide(%ld)\n", visibleID, duration];
                        [innerfunctionStr appendString:@"}"];
                        [innerfunctionStr appendNewline];
                    }
#pragma mark Frame Src
                    value = [receiverDict objectForKey:IUEventTagFrameEquation];
                    if(value){
                        
                        NSString *frameID = [receiverDict objectForKey:IUEventTagFrameID];
                        
                        [innerfunctionStr appendFormat:@"if( %@ ){", value];
                        [innerfunctionStr appendNewline];
                        
                        NSMutableString *innerJS = [NSMutableString string];
                        [innerJS appendFormat:@"$(\"#%@\").animate({", frameID];
                        
                        CGFloat width = [[receiverDict objectForKey:IUEventTagFrameWidth] floatValue];
                        CGFloat height = [[receiverDict objectForKey:IUEventTagFrameHeight] floatValue];
                        [innerJS appendFormat:@"width:\"%.2fpx\", height:\"%.2fpx\"}", width, height];
                        
                        NSInteger duration = [[receiverDict objectForKey:IUEventTagFrameDuration] integerValue];
                        [innerJS appendFormat:@", %ld);", duration];
                        
                        [innerfunctionStr appendString:[innerJS stringByAddingTab]];
                        [innerfunctionStr appendString:@"}"];
                        [innerfunctionStr appendNewline];
                        [innerfunctionStr appendString:@"else{\n"];
                        [innerfunctionStr appendFormat:@"\t$(\"#%@\").removeAttr('style')\n", frameID];
                        [innerfunctionStr appendString:@"}"];
                        
                        [innerfunctionStr appendNewline];
                    }
                }//End of receiverArray
                [eventString appendString:[innerfunctionStr stringByAddingTab]];
                [eventString appendString:@"});"];
                [eventString appendNewline];
                [eventString appendNewline];
                [body appendString:eventString];

            }
            
        }
        
    }
    
    JDTraceLog(@"header=====\n%@", header);
    JDTraceLog(@"body-header=====\n%@", bodyHeader);
    JDTraceLog(@"body======\n%@", body);
    
    NSMutableString *eventJSStr = [NSMutableString string];
    [eventJSStr appendString:header];
    [eventJSStr appendNewline];
    [eventJSStr appendString:@"$(document).ready(function(){"];
    [eventJSStr appendNewline];
    [eventJSStr appendString:[bodyHeader stringByAddingTab]];
    [eventJSStr appendNewline];
    [eventJSStr appendString:[body stringByAddingTab]];
    [eventJSStr appendNewline];
    [eventJSStr appendString:@"});"];
    
    JDTraceLog(@"total======\n%@", eventJSStr);
    
    return eventJSStr;
}

@end
