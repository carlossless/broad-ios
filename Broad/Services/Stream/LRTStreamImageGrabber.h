//
//  BroadStreamImageGrabber.h
//  Broad
//
//  Created by Karolis Stasaitis on 26/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface LRTStreamImageGrabber : NSObject

- (nullable UIImage *)generateImageForUrl:(NSURL *_Nonnull)url size:(CGSize)size error:(NSError *_Nullable*_Nonnull)error;

@end
