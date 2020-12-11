//
//  ViewModel.m
//  ForSnake
//
//  Created by Zhaoyang Li on 12/9/20.
//

#import "ViewModel.h"

@implementation ViewModel

- (void)initialMatrixSettings: (void (^_Nullable)(bool))handler {
    // initial zero matrix settings
    self.matrix = [[NSMutableArray<NSMutableArray *> alloc] init];
    self.snakeArray = [[NSMutableArray alloc] init];
        
    for (int row = 0; row < 37; row ++) {
        NSMutableArray *onerow = [[NSMutableArray alloc] init];
        for (int counter = 0; counter < 20; counter ++) {
            [onerow addObject:@0];
        }
        [self.matrix addObject:onerow];
    }
    
    // snake is 1, food is 2
    // random direction
    self.direction = 0;//arc4random_uniform(4);
    // random position
    int lowerColumeBound = 4;
    int upperColumeBound = 15;
    int lowerRowBound = 4;
    int upperRowBound = 32;
    int randomColumeStarter = lowerColumeBound + arc4random_uniform(upperColumeBound - lowerColumeBound + 1);
    int randomRowStarter = lowerRowBound + arc4random_uniform(upperRowBound - lowerRowBound + 1);
    self.matrix[randomRowStarter][randomColumeStarter] = @1;
    
    NSArray *oneJoint = @[[NSNumber numberWithInt:randomRowStarter], [NSNumber numberWithInt:randomColumeStarter]];
    [self.snakeArray addObject:oneJoint];
    self.rowStarter = randomRowStarter;
    self.columeStarter = randomColumeStarter;
    // populate snake
    self.snakeLength = 4;
    for (int counter = 0; counter < self.snakeLength - 1; counter++) {
        switch (self.direction) {
            case 0:
                randomRowStarter += 1;
                self.matrix[randomRowStarter][randomColumeStarter] = @1;
                break;
            case 1:
                randomRowStarter -= 1;
                self.matrix[randomRowStarter][randomColumeStarter] = @1;
                break;
            case 2:
                randomColumeStarter += 1;
                self.matrix[randomRowStarter][randomColumeStarter] = @1;
                break;
            case 3:
                randomColumeStarter -= 1;
                self.matrix[randomRowStarter][randomColumeStarter] = @1;
                break;
            default:
                break;
        }
        oneJoint = @[[NSNumber numberWithInt:randomRowStarter], [NSNumber numberWithInt:randomColumeStarter]];
        [self.snakeArray addObject:oneJoint];
    }
        
    // populate food
    [self generateRandomFood];
    handler(YES);
}

- (void)refreshing: (void (^_Nullable)(bool))handler {
    switch (self.direction) {
        case 0:
            if ([[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] <= 0) {
                handler(NO);
                return;
            }
            if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] - 1][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] isEqual: @0]) {
                self.matrix[[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:1] intValue]] = @0;

                [self.snakeArray removeLastObject];
                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] - 1;
                NSArray *newPlace = @[[NSNumber numberWithInt:newRowCounter], self.snakeArray[0][1]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] = @1;
                handler(YES);
                return;
            } else if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] - 1][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] isEqual: @1]) {
                handler(NO);
                return;
            } else {
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] - 1][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] = @1;

                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] - 1;
                NSArray *newPlace = @[[NSNumber numberWithInt:newRowCounter], self.snakeArray[0][1]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                [self generateRandomFood];
                handler(YES);
                return;
            }
            break;
            
        case 1:
            if ([[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] >= 36) {
                handler(NO);
                return;
            }
            if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] + 1][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] isEqual: @0]) {
                self.matrix[[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:1] intValue]] = @0;

                [self.snakeArray removeLastObject];
                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] + 1;
                NSArray *newPlace = @[[NSNumber numberWithInt:newRowCounter], self.snakeArray[0][1]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] = @1;
                handler(YES);
                return;
            } else if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] + 1][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] isEqual: @1]) {
                handler(NO);
                return;
            } else {
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] + 1][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] = @1;

                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue] + 1;
                NSArray *newPlace = @[[NSNumber numberWithInt:newRowCounter], self.snakeArray[0][1]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                [self generateRandomFood];
                handler(YES);
                return;
            }
            break;

        case 2:
            if ([[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] <= 0) {
                handler(NO);
                return;
            }
            if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] - 1] isEqual: @0]) {
                self.matrix[[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:1] intValue]] = @0;

                [self.snakeArray removeLastObject];
                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] - 1;
                NSArray *newPlace = @[self.snakeArray[0][0], [NSNumber numberWithInt:newRowCounter]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] = @1;
                handler(YES);
                return;
            } else if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] - 1] isEqual: @1]) {
                handler(NO);
                return;
            } else {
                
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] - 1] = @1;

                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] - 1;
                NSArray *newPlace = @[self.snakeArray[0][0], [NSNumber numberWithInt:newRowCounter]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                [self generateRandomFood];
                handler(YES);
                return;
            }
            break;
            
        case 3:
            if ([[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] >= 19) {
                handler(NO);
                return;
            }
            if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] + 1] isEqual: @0]) {
                self.matrix[[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:self.snakeArray.count - 1] objectAtIndex:1] intValue]] = @0;

                [self.snakeArray removeLastObject];
                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] + 1;
                NSArray *newPlace = @[self.snakeArray[0][0], [NSNumber numberWithInt:newRowCounter]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue]] = @1;
                handler(YES);
                return;
            } else if ([self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] + 1] isEqual: @1]) {
                handler(NO);
                return;
            } else {
                
                self.matrix[[[[self.snakeArray objectAtIndex:0] objectAtIndex:0] intValue]][[[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] + 1] = @1;

                int newRowCounter = [[[self.snakeArray objectAtIndex:0] objectAtIndex:1] intValue] + 1;
                NSArray *newPlace = @[self.snakeArray[0][0], [NSNumber numberWithInt:newRowCounter]];
                [self.snakeArray insertObject:newPlace atIndex:0];
                
                [self generateRandomFood];
                handler(YES);
                return;
            }
            break;
        default:
            break;
    }
}

- (void)generateRandomFood {
    bool chosen = NO;
    do {
        self.foodColumeIndex = 1 + arc4random_uniform(18);
        self.foodRowIndex = 1 + arc4random_uniform(35);
        if ([self.matrix[self.foodRowIndex][self.foodColumeIndex] isEqual: @0]) {
            chosen = YES;
            self.matrix[self.foodRowIndex][self.foodColumeIndex] = @2;
        }
    } while (!chosen);
}

@end
