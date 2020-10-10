//
//  LBXPermissionPhotos.m
//  LBXKits
//
//  Created by lbxia on 2017/9/10.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionPhotos.h"
#import <Photos/Photos.h>


@implementation LBXPermissionPhotos

+ (BOOL)authorized
{
    return [self authorizationStatus] == 3;
}


/**
 photo permission status

 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 */
+ (NSInteger)authorizationStatus
{
//    PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
    
    if (@available(iOS 14.0, *)) {
        
        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    }
    else
    {
        PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
        
        return status;
    }
}

+ (NSInteger)authorizationStatus_AddOnly
{
    if (@available(iOS 14.0, *)) {
        
        
        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];

        
    }else{
        
        return [self authorizationStatus];
    }

}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 8.0, *)) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined:
            {
//              iOS14 PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
            }
                break;
            default:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
        
    }
}

@end
