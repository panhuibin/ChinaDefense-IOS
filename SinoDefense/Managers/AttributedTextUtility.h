//
//  AttributedTextUtility.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-30.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHppleElement.h"

@interface AttributedTextUtility : NSObject

+(id)sharedInstance;

-(NSAttributedString *) htmlIntoAttr:(TFHppleElement *)node withImageFileNames:(NSArray *) imageFileNames;
-(NSMutableDictionary *) htmlIntoImageTextBlocks:(TFHppleElement *)node;
@end
