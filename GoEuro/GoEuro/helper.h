//
//  helper.h
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#ifndef helper_h
#define helper_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

typedef void (^ ErrorBlock)(NSError* error);

#endif /* helper_h */
