//
//  ViewModel.h
//  ForSnake
//
//  Created by Zhaoyang Li on 12/9/20.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ViewModel : NSObject

@property (strong, nonatomic, nullable) NSMutableArray<NSMutableArray *> *matrix;

@property (nonatomic) SwipeDirection direction;
@property (nonatomic) NSInteger rowStarter;
@property (nonatomic) NSInteger columeStarter;
@property (nonatomic) NSInteger snakeLength;
@property (nonatomic) NSInteger foodRowIndex;
@property (nonatomic) NSInteger foodColumeIndex;
@property (nonatomic) NSMutableArray * _Nullable snakeArray;

- (void)initialMatrixSettings: (void (^_Nullable)(bool))handler;

- (void)refreshing: (void (^_Nullable)(bool))handler;

@end
