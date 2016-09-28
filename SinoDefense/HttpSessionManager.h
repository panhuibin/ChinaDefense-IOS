//
//  HttpSessionManager.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-08-11.
//  Copyright © 2016 Sarah Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSessionManager : NSObject
+ (id)sharedInstance;
-(void)sendPost:(NSURLRequest*) request completionHandler:(void (^)(bool isSuccessful))completionHandler;
@end
