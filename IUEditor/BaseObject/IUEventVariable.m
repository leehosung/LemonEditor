//
//  IUEventVariable.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUEventVariable.h"
#import "IUSheet.h"

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

- (void)makeEventDictionary:(IUSheet *)sheet{
    for (IUBox *obj in sheet.allChildren) {
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
            [visibleDict setObject:@(obj.event.directionType) forKey:IUEventTagVisibleType];
            
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
    NSMutableString *visibleFnStr = [NSMutableString string];
    NSMutableString *frameFnStr = [NSMutableString string];
    NSMutableString *initializeFn = [NSMutableString string];
    
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
                [bodyHeader appendNewline];
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
                [eventString appendFormat:@"/* [IU:%@] Event Declaration */\n", value];
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
                [eventString appendTabAndString:[NSString stringWithFormat:@"%@++;",variable]];
                [eventString appendNewline];
                [eventString appendTabAndString:[NSString stringWithFormat:@"if( %@ > MAX_IU_%@ ){ %@ = INIT_IU_%@ }\n",variable, variable, variable, variable]];
                [eventString appendNewline];
                
                
#pragma mark make event innerJS
                NSArray *receiverArray = [oneDict objectForKey:IUEventTagReceiverArray];
                NSMutableString *innerfunctionStr = [NSMutableString string];

                for(NSDictionary *receiverDict in receiverArray){
#pragma mark Visible Src
                    value = [receiverDict objectForKey:IUEventTagVisibleEquation];
                    if(value){
                        NSString *visibleID = [receiverDict objectForKey:IUEventTagVisibleID];

                        NSString *fnName;
                        if(type == IUEventActionTypeClick){
                            fnName =  [NSString stringWithFormat:@"%@ClickVisible%@Fn", variable, visibleID];
                        }
                        else if(type == IUEventActionTypeHover){
                            fnName =  [NSString stringWithFormat:@"%@HoverVisible%@Fn", variable, visibleID];
                        }
                        [innerfunctionStr appendFormat:@"%@();\n", fnName];

                        NSMutableString *fnStr = [NSMutableString string];
                        NSInteger duration = [[receiverDict objectForKey:IUEventTagVisibleDuration] integerValue];
                        IUEventVisibleType type = [[receiverDict objectForKey:IUEventTagVisibleType] intValue];
                        NSString *typeStr = [self visibleType:type];
                        
                        [fnStr appendFormat:@"if( %@ ){\n", value];
                        
                        NSMutableString *innerJS = [NSMutableString string];
                        [innerJS appendFormat:@"$(\"#%@\").show(", visibleID];
                        [innerJS appendFormat:@"\"%@\", %ld);\n", typeStr, duration*100];
                        [innerJS appendFormat:@"$(\"#%@\").data(\"run%@\", 1);\n", visibleID, fnName];
                        
                        [fnStr appendString:[innerJS stringByAddingTab]];
                        [fnStr appendString:@"}"];
                        [fnStr appendNewline];
                        
                        [fnStr appendString:@"else{\n"];
                        innerJS = [NSMutableString string];
                        [innerJS appendFormat:@"var clicked =$(\"#%@\").data(\"run%@\");\n", visibleID,fnName];
                        [innerJS appendString:@"if(clicked == undefined){\n"];
                        [innerJS appendFormat:@"\t$(\"#%@\").hide();\n", visibleID];
                        [innerJS appendString:@"}\n"];
                        [innerJS appendString:@"else{\n"];
                        [innerJS appendFormat:@"\t$(\"#%@\").hide(\"%@\",%ld);\n", visibleID, typeStr, duration*100];
                        [innerJS appendString:@"}"];
                        [fnStr appendString:[innerJS stringByAddingTab]];
                        [fnStr appendString:@"}"];
                        [fnStr appendNewline];
                        
                        [visibleFnStr appendFormat:@"function %@(){\n", fnName ];
                        [visibleFnStr appendString:[fnStr stringByAddingTab]];
                        [visibleFnStr appendString:@"}\n"];

                        
                        
                    }
#pragma mark Frame Src
                    value = [receiverDict objectForKey:IUEventTagFrameEquation];
                    if(value){
                        
                        NSString *frameID = [receiverDict objectForKey:IUEventTagFrameID];
                        
                        NSString *fnName;
                        if(type == IUEventActionTypeClick){
                            fnName =  [NSString stringWithFormat:@"%@ClickVisible%@Fn", variable, frameID];
                        }
                        else if(type == IUEventActionTypeHover){
                            fnName =  [NSString stringWithFormat:@"%@HoverVisible%@Fn", variable, frameID];
                        }
                        
                        [innerfunctionStr appendFormat:@"%@();\n", fnName];

                        NSMutableString *fnStr = [NSMutableString string];
                        [fnStr appendFormat:@"if( %@ ){", value];
                        [fnStr appendNewline];
                        
                        NSMutableString *innerJS = [NSMutableString string];
                        
                        [innerJS appendFormat:@"$(\"#%@\").data(\"run%@\", 1);\n", frameID, fnName];
                        [innerJS appendFormat:@"$(\"#%@\").data(\"width\", $(\"#%@\").css('width'));\n", frameID, frameID];
                        [innerJS appendFormat:@"$(\"#%@\").data(\"height\", $(\"#%@\").css('height'));\n", frameID, frameID];
                        [innerJS appendFormat:@"$(\"#%@\").animate({", frameID];
                        
                        CGFloat width = [[receiverDict objectForKey:IUEventTagFrameWidth] floatValue];
                        CGFloat height = [[receiverDict objectForKey:IUEventTagFrameHeight] floatValue];
                        [innerJS appendFormat:@"width:\"%.2fpx\", height:\"%.2fpx\"}", width, height];
                        
                        NSInteger duration = [[receiverDict objectForKey:IUEventTagFrameDuration] integerValue];
                        [innerJS appendFormat:@", %ld);", duration*100];
                        
                        [fnStr appendString:[innerJS stringByAddingTab]];
                        [fnStr appendString:@"}"];
                        [fnStr appendNewline];
                        [fnStr appendString:@"else{\n"];
                        
                        innerJS = [NSMutableString string];
                        [innerJS appendFormat:@"var clicked =$(\"#%@\").data(\"run%@\");\n", frameID, fnName];
                        [innerJS appendFormat:@"var d_width =$(\"#%@\").data(\"width\");\n", frameID];
                        [innerJS appendFormat:@"var d_height =$(\"#%@\").data(\"height\");\n", frameID];
                        [innerJS appendString:@"if(clicked == undefined){\n"];
                        [innerJS appendFormat:@"\t$(\"#%@\").animate({width:d_width, height:d_height}, %ld);\n", frameID, duration*100];
                        [innerJS appendString:@"}\n"];
                        [innerJS appendString:@"else{\n"];
                        [innerJS appendFormat:@"\t$(\"#%@\").animate({width:d_width, height:d_height}, %ld);\n", frameID, duration*100];
                        [innerJS appendString:@"}"];
                        
                        [fnStr appendString:[innerJS stringByAddingTab]];
                        [fnStr appendString:@"}"];
                        
                        [fnStr appendNewline];
                        
                        [frameFnStr appendFormat:@"function %@(){\n", fnName ];
                        [frameFnStr appendString:[fnStr stringByAddingTab]];
                        [frameFnStr appendString:@"}\n"];
                    }
                }//End of receiverArray
                [initializeFn appendString:innerfunctionStr];
                
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
    
    [eventJSStr appendString:@" /* Decleare Visible Fn */ \n"];
    [eventJSStr appendString:visibleFnStr];
    [eventJSStr appendNewline];

    [eventJSStr appendString:@" /* Decleare Frame Fn */ \n"];
    [eventJSStr appendString:frameFnStr];
    [eventJSStr appendNewline];
    
    [eventJSStr appendString:@"$(document).ready(function(){"];
    [eventJSStr appendNewline];
    [eventJSStr appendString:@"console.log('ready : iuevent.js');\n"];
    [eventJSStr appendNewline];
    [eventJSStr appendString:[bodyHeader stringByAddingTab]];
    [eventJSStr appendNewline];
    [eventJSStr appendString:[body stringByAddingTab]];
    [eventJSStr appendNewline];
    
    [eventJSStr appendString:@" /* initialize fn */ \n"];
    [eventJSStr appendString:[initializeFn stringByAddingTab]];
    [eventJSStr appendNewline];
    [eventJSStr appendString:@"});"];
    
    JDTraceLog(@"total======\n%@", eventJSStr);
    
    return eventJSStr;
}

#pragma mark visible event 
- (NSString *)visibleType:(IUEventVisibleType)type{
    NSString *typeStr;
    switch (type) {
        case IUEventVisibleTypeBlind:
            typeStr = @"blind";
            break;
        case IUEventVisibleTypeBounce:
            typeStr = @"bounce";
            break;
        case IUEventVisibleTypeClip:
            typeStr = @"clip";
            break;
        case IUEventVisibleTypeDrop:
            typeStr = @"drop";
            break;
        case IUEventVisibleTypeExplode:
            typeStr = @"explode";
            break;
        case IUEventVisibleTypeFold:
            typeStr = @"fold";
            break;
        case IUEventVisibleTypeHide:
            typeStr = @"hide";
            break;
        case IUEventVisibleTypeHighlight:
            typeStr = @"highlight";
            break;
        case IUEventVisibleTypePuff:
            typeStr = @"puff";
            break;
        case IUEventVisibleTypePulsate:
            typeStr = @"pulsate";
            break;
        case IUEventVisibleTypeScale:
            typeStr = @"scale";
            break;
        case IUEventVisibleTypeShake:
            typeStr = @"shake";
            break;
        case IUEventVisibleTypeSize:
            typeStr = @"size";
            break;
        case IUEventVisibleTypeSlide:
            typeStr = @"slide";
            break;
        default:
            typeStr = nil;
            break;
    }
    
    return typeStr;
}

@end
