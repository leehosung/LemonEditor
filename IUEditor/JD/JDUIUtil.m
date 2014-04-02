//
//  JDUtil.m
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDUIUtil.h"
#import "NSString+JDExtension.h"

BOOL isValidRect(NSRect aRect){
    if ( isnan(aRect.size.width) || isnan(aRect.size.height) || isnan(aRect.origin.x) || isnan(aRect.origin.y) ) {
        return NO;
    }
    
    return YES;
}

BOOL   isNSRectContainsRect(NSRect rect, NSRect subrect){
    if (rect.origin.x <= subrect.origin.x && rect.origin.y <= subrect.origin.y) {
        if (rect.origin.x + rect.size.width >= subrect.origin.x + subrect.size.width) {
            if (rect.origin.y + rect.size.height >= subrect.origin.y + subrect.size.height) {
                return YES;
            }
        }
    }
    return NO;
}


NSRect NSRectIntersect(NSRect a, NSRect b){
    return CGRectIntersection(a,b);
}


NSPoint NSPointWithInt(NSPoint p){
    NSPoint p2 = {(int)(p.x), (int)(p.y)};
    return p2;
}

NSPoint NSPointMake(CGFloat x, CGFloat y){
    return NSPointFromCGPoint(CGPointMake(x, y));
}


NSRect  NSRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    return NSRectFromCGRect(CGRectMake(x, y, width, height));
}

NSRect NSRectModifyX(NSRect rect, float x){
    return NSRectFromCGRect(CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height));
}

NSRect NSRectModifyXY(NSRect rect, float x, float y){
    return NSRectFromCGRect(CGRectMake(x, y, rect.size.width, rect.size.height));
}


NSRect NSRectExpandLeft(NSRect rect, float x){
    return NSRectFromCGRect(CGRectMake(x, rect.origin.y, rect.size.width - x + rect.origin.x, rect.size.height));
}

NSRect NSRectExpandRight(NSRect rect, float x){
    // x - rect.origin.x
    return NSRectFromCGRect(CGRectMake(rect.origin.x, rect.origin.y, x - rect.origin.x, rect.size.height));
}

NSRect NSRectExpandBottom(NSRect rect, float y){
    return NSRectFromCGRect(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width , y - rect.origin.y));
}


NSRect NSRectExpandTop(NSRect rect, float y){
    return NSRectFromCGRect(CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height-y+rect.origin.y));
}

NSRect NSRectModifyY(NSRect rect, float y){
    return NSRectFromCGRect(CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height));
}

NSRect NSRectModifyWidth(NSRect rect, float width){
    return NSRectFromCGRect(CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height));
}

NSRect NSRectModifyHeight(NSRect rect, float height){
    return NSRectFromCGRect(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height));
}

NSRect NSRectModifyOrigin(NSRect rect, NSPoint origin){
    return NSRectFromCGRect(CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height));
}

BOOL isSameColor(NSColor *color1, NSColor *color2){
    if (color1 == color2) {
        return YES;
    }
    NSInteger numberOfComp1 = [color1 numberOfComponents];
    NSInteger numberOfComp2 = [color2 numberOfComponents];
    if (numberOfComp1 != numberOfComp2) {
        return NO;
    }
    CGFloat *comp1=malloc(sizeof(CGFloat));
    CGFloat *comp2=malloc(sizeof(CGFloat));
    for (int i=0; i<numberOfComp1; i++) {
        [color1 getComponents:comp1];
        [color2 getComponents:comp2];
        if (comp1 != comp2) {
//            free(comp1);
//            free(comp2);
            return NO;
        }
    }
//    free(comp1);
//    free(comp2);
    return YES;
}

@implementation NSImageView(JDExtension)

-(id)addSubviewWithTopLeftFixed:(NSView*)subview{
    [self addSubview:subview];

    CGFloat modifiedX=0;
    CGFloat modifiedY=0;
    
    if (subview.frame.origin.y > 0) {
        modifiedY = subview.frame.origin.y - 0.1;
    }
    if (subview.frame.origin.x > 0) {
        modifiedX =  subview.frame.origin.x - 0.1;
    }

    NSString *stringFormat = [NSString stringWithFormat:@"V:|-(%f@1)-[subview]",modifiedY];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:stringFormat
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];

    NSString *stringFormat2 = [NSString stringWithFormat:@"H:|-(%f@1)-[subview]",modifiedX];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:stringFormat2
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];

    return subview;
}
@end

@implementation NSView(JDExtension)

-(void)removeAllSubview{
    NSArray *subviews = [NSArray arrayWithArray:self.subviews];
    for (NSView *view in subviews) {
        [view removeFromSuperview];
    }
}

-(BOOL)hasSubview:(NSView*)subview{
    if (subview ==self) {
        return YES;
    }
    for (NSView *view in self.subviews) {
        if ([view hasSubview:subview]) {
            return YES;
        }
    }
    return NO;
}

-(id)addSubviewWithFixTopSpace:(NSView*)subview{
    [self addSubview:subview];
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSString *stringFormat = [NSString stringWithFormat:@"H:|-%f-[subview]-(>=0)-|",subview.frame.origin.y];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:stringFormat
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    
    return subview;
}

- (void)addSubviewFullFrame:(NSView *)subview positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView{
    if  (subview == nil){ return;}
    [self addSubview:subview positioned:place relativeTo:otherView];
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[subview]-(0@1000)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[subview]-(0@1000)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
}

-(id)addSubviewFullFrame:(NSView*)subview{
    if (subview == nil) {
        return nil;
    }
    [self addSubview:subview];

    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[subview]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(subview)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[subview]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];

    return subview;
}
-(NSView*)addSubviewFullFrame:(NSView*)subview atPosition:(NSWindowOrderingMode)place{
    [self addSubview:subview positioned:place relativeTo:nil];
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[subview]-(<=0)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[subview]-(<=0)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    
    return subview;
}



- (void)addSubviewMiddleInFrameWithFrame:(NSView *)aView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView{
    [self addSubview:aView positioned:place relativeTo:otherView];
    [aView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[aView]-(0@1000)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(aView)]];
    NSString *widthFormat = [NSString stringWithFormat:@"[aView(%.0f)]", aView.frame.size.width];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:widthFormat
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(aView)]];
    
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:aView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1 constant:0]];
    
    
}

- (void)addSubviewMiddleInFrameWithFrame:(NSView *)aView{
    [self addSubview:aView];
    [aView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[aView]-(0@1000)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(aView)]];
    NSString *widthFormat = [NSString stringWithFormat:@"[aView(%.0f)]", aView.frame.size.width];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:widthFormat
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(aView)]];
    
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:aView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1 constant:0]];
    
    
}

- (void)addSubviewVeriticalCenterInFrameWithFrame:(NSView *)aView height:(CGFloat)height{
    [self addSubview:aView];
    [aView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[aView]-(0@1000)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(aView)]];
    NSString *heightFormat = [NSString stringWithFormat:@"V:[aView(%.0f)]", height];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:heightFormat
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(aView)]];
    
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:aView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1 constant:0]];
    
    
}

-(void)setX:(CGFloat)x{
    self.frame = NSRectModifyX(self.frame, x);
}
-(void)setY:(CGFloat)y{
    self.frame = NSRectModifyY(self.frame, y);
}
-(void)setWidth:(CGFloat)width{
    self.frame = NSRectModifyWidth(self.frame, width);
}
-(void)setHeight:(CGFloat)height{
    self.frame = NSRectModifyHeight(self.frame, height);
}

@end


@implementation JDUIUtil

+(NSRect)frame:(NSRect)frame modify:(CGFloat)modifier{
    return NSRectMake(frame.origin.x * modifier, frame.origin.y * modifier, frame.size.width * modifier, frame.size.height * modifier);
}

+(NSPoint)point:(NSPoint)point modify:(CGFloat)modifier{
    return NSPointMake(point.x * modifier, point.y * modifier);
}

+(void)view:(NSView*)view addSubviewFullFrame:(NSView*)subview{
    [view addSubview:subview];
    [subview setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
}

+(void)view:(NSView*)view setCenterWithView:(NSView*)originView{
    CGFloat x = NSMidX(originView.frame);
    CGFloat y = NSMidY(originView.frame);
    CGRect rect= CGRectMake(x-view.frame.size.width/2, y-view.frame.size.height/2, NSWidth(view.frame), NSHeight(view.frame));
    [view setFrame:NSRectFromCGRect(rect)];
    [view setNeedsDisplay:YES];
}

+(NSRect)rectBetweenTwoPointFrom:(NSPoint)point1 to:(NSPoint)point2{
    return NSRectFromCGRect(CGRectMake(point1.x, point1.y, point2.x - point1.x, point2.y - point1.y));
}


+(void)view:(NSView*)view addSubviewFullFrame:(NSView*)subview atPosition:(NSWindowOrderingMode)place{
    [view addSubview:subview positioned:place relativeTo:nil];
    [subview setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
}


+(void)view:(NSView*)view fillColor:(NSColor*)color{
    [[NSColor redColor] setFill];
    NSRectFill(view.bounds);
}



/*
+(CGColorRef)NSColorToCGColor:(NSColor*)color
{
    NSColor *colorRGB = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat components[4];
    [colorRGB getRed:&components[0]
               green:&components[1]
                blue:&components[2]
               alpha:&components[3]];
    CGColorSpaceRef space = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGColorRef theColor = CGColorCreate(space, components);
    CGColorSpaceRelease(space);
    return theColor;
}
*/

+(NSPoint)pointRound:(NSPoint)point{
    NSPoint retPoint;
    retPoint.x = (int)(point.x);
    retPoint.y = (int)(point.y);
    return retPoint;
}
+(NSPoint)pointRoundf:(NSPoint)point{
    NSPoint retPoint;
    retPoint.x = roundf(point.x);
    retPoint.y = roundf(point.y);
    return retPoint;
}

+(NSPoint)pointDiff:(NSPoint)point1 from:(NSPoint)point2{
    NSPoint retPoint;
    retPoint.x = point2.x - point1.x;
    retPoint.y = point2.y - point1.y;
    return retPoint;
}

+(NSString *)NSColorToHexString:(NSColor*)color
{
    if  (color == nil){
        color = [NSColor blackColor];
    }
    CGFloat redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;
    
    //Convert the NSColor to the RGB color space before we can access its components
    NSColor *convertedColor=[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    if(convertedColor)
    {
        // Get the red, green, and blue components of the color
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
        
        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        redIntValue=redFloatValue*255.99999f;
        greenIntValue=greenFloatValue*255.99999f;
        blueIntValue=blueFloatValue*255.99999f;
        
        // Convert the numbers to hex strings
        redHexValue=[NSString stringWithFormat:@"%02x", redIntValue];
        greenHexValue=[NSString stringWithFormat:@"%02x", greenIntValue];
        blueHexValue=[NSString stringWithFormat:@"%02x", blueIntValue];
        
        // Concatenate the red, green, and blue components' hex strings together with a "#"
        return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
    }
    return nil;
}

+ (NSColor*)hexColorToNSColor:(NSString*)inColorString
{
    if ([inColorString characterAtIndex:0]=='#') {
        inColorString = [inColorString substringFromIndex:1];
    }
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}


@end

@implementation NSColor(JDExtension)
-(NSString*) rgbString{
    CGFloat redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
        
    //Convert the NSColor to the RGB color space before we can access its components
    NSColor *convertedColor=[self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    
    if(convertedColor)
    {
        // Get the red, green, and blue components of the color
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
        
        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        redIntValue=redFloatValue*255.99999f;
        greenIntValue=greenFloatValue*255.99999f;
        blueIntValue=blueFloatValue*255.99999f;
        
        // Concatenate the red, green, and blue components' hex strings together with a "#"
        return [NSString stringWithFormat:@"rgb(%d,%d,%d)", redIntValue, greenIntValue, blueIntValue];
    }
    return nil;
}

+ (NSColor *)randomColor {
    static int seeded;
    if (seeded == 0) {
        srand((unsigned int)time(NULL));
        seeded++;
    }
    
    float c[4];
    c[0] = ((float)(rand()%256))/256;
    c[1] = ((float)(rand()%256))/256;
    c[2] = ((float)(rand()%256))/256;
    c[3] = 1.0;
    
    return [NSColor colorWithCalibratedRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
}



-(NSColor*) complementaryColor{
    CGFloat red = [self redComponent];
    CGFloat green = [self greenComponent];
    CGFloat blue = [self blueComponent];
    return [NSColor colorWithSRGBRed:1-red green:1-green blue:1-blue alpha:1];
}


@end

@implementation NSString(JDExtension2)


-(NSColor*)color{
    NSArray *arr = [self RGXMatchAllStringsWithPatten:@"(\\d+)"];
    
    NSColor *result = [NSColor
              colorWithDeviceRed:(CGFloat)[[arr objectAtIndex:0] intValue] / 0xff
              green:(CGFloat)[[arr objectAtIndex:1] intValue] / 0xff
              blue:(CGFloat)[[arr objectAtIndex:2] intValue] / 0xff
              alpha:1.0];
    return result;
}
@end


@implementation NSBezierPath(JDExtenstion)

-(void)strokeHorizentalLine:(CGFloat)y fromX:(CGFloat)x1 toX:(CGFloat)x2{
    NSPoint p1 = {x1,y};
    NSPoint p2 = {x2,y};
    [self moveToPoint:p1];
    [self lineToPoint:p2];
    [self stroke];
}
-(void)strokeVerticalLine:(CGFloat)x fromY:(CGFloat)y1 toY:(CGFloat)y2{
    NSPoint p1 = {x,y1};
    NSPoint p2 = {x,y2};
    [self moveToPoint:p1];
    [self lineToPoint:p2];
    [self stroke];
}
-(void)drawline:(NSPoint)start end:(NSPoint)end{
    [self moveToPoint:start];
    [self lineToPoint:end];
}

- (CGPathRef)quartzPath
{
    int i, numElements;
    
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = (int)[self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
        
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
        
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);
        
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    
    return immutablePath;
}

@end


@implementation NSUserDefaults(JDColorSupport)

- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey
{
    NSData *theData=[NSArchiver archivedDataWithRootObject:aColor];
    [self setObject:theData forKey:aKey];
}

- (NSColor *)colorForKey:(NSString *)aKey
{
    NSColor *theColor=nil;
    NSData *theData=[[self dataForKey:aKey] copy];
    if (theData != nil)
        theColor=(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
    return theColor;
}

@end

@implementation NSScrollView(JDExtension)

-(void)scrollOnTop{
    NSPoint newScrollOrigin;
    newScrollOrigin=NSMakePoint(0.0,NSMaxY([(NSView*)[self documentView] frame])
                                -NSHeight([[self contentView] bounds]));
    [[self documentView] scrollPoint:newScrollOrigin];

}
-(void)scrollOnBottom{
    NSPoint newScrollOrigin;
    
    // assume that the scrollview is an existing variable
    if ([[self documentView] isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,NSMaxY([(NSView*)[self documentView] frame])
                                    -NSHeight([[self contentView] bounds]));
    } else {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    }
    
    [[self documentView] scrollPoint:newScrollOrigin];
}

@end


@implementation NSButton(JDExtension)

- (void)setTitle:(NSString*)title withColor:(NSColor*)color {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    
    NSFont *font= [NSFont fontWithName:@"Helvetica" size:11];
    
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, font, NSFontAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:title attributes:attrsDictionary];
    
    [self setAttributedTitle:attrString];
}

@end
