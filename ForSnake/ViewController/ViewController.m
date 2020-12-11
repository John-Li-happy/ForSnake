//
//  ViewController.m
//  ForSnake
//
//  Created by Zhaoyang Li on 12/9/20.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) ViewModel *viewModel;
@property (nonatomic) BOOL finishFlag;
@property (nonatomic) BOOL turnFlag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicUISettings];
    [self delegateLoading];
    self.viewModel = [[ViewModel alloc] init];
    [self startPlaying];
}

- (void)startPlaying {
    [self.viewModel initialMatrixSettings:^(bool success) {
        self.finishFlag = NO;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(refreshing) userInfo:Nil repeats:YES];
    }];
}

- (void)refreshing {
    if (!self.finishFlag) {
        [self.viewModel refreshing:^(bool success){
            if (success) {
                [self.collectionView reloadData];
                self.title = [NSString stringWithFormat:@"Score: %ld", (long)self.viewModel.snakeArray.count];
                self.turnFlag = YES;
            } else {
                self.finishFlag = YES;
                NSString *message = [NSString stringWithFormat:@"Your highest score is  %ld", (long)self.viewModel.snakeArray.count];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Game OVer" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Restart" style:UIAlertActionStyleDefault handler:Nil];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:Nil];
            }
        }];
    }
}

- (void)delegateLoading {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)basicUISettings {
    // flag settings
    self.collectionView.scrollEnabled = NO;
    self.turnFlag = NO;
    // background set
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"woodBackGround"];
    imageView.layer.zPosition = -99;
    [self.view addSubview:imageView];
    
    self.view.layer.borderWidth = 10;
    self.view.layer.borderColor = UIColor.blackColor.CGColor;
    self.view.layer.cornerRadius = 10;
    
    // recognizers
    UISwipeGestureRecognizer *top = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(topHandler)];
    top.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:top];
    UISwipeGestureRecognizer *bot = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(botHandler)];
    bot.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:bot];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandler)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandler)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
}

- (void)topHandler{
    bool correctDirection = self.viewModel.direction == 2 || self.viewModel.direction == 3;
    if (correctDirection && self.turnFlag) {
        self.viewModel.direction = 0;
        self.turnFlag = NO;
    }
}

- (void)botHandler{
    bool correctDirection = self.viewModel.direction == 2 || self.viewModel.direction == 3;
    if (correctDirection && self.turnFlag) {
        self.viewModel.direction = 1;
        self.turnFlag = NO;
    }
}

- (void)leftHandler{
    bool correctDirection = self.viewModel.direction == 0 || self.viewModel.direction == 1;
    if (correctDirection && self.turnFlag) {
        self.viewModel.direction = 2;
        self.turnFlag = NO;
    }
}

- (void)rightHandler{
    bool correctDirection = self.viewModel.direction == 0 || self.viewModel.direction == 1;
    if (correctDirection && self.turnFlag) {
        self.viewModel.direction = 3;
        self.turnFlag = NO;
    }
}

- (UIColor *)randomColor {
    UIColor *color = [[UIColor alloc] initWithRed:((double)arc4random() / UINT32_MAX) green:((double)arc4random() / UINT32_MAX) blue:((double)arc4random() / UINT32_MAX) alpha:1];
    return color;
}

// MARK: - collection View
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    if ([self.viewModel.matrix[indexPath.row / 20][indexPath.row % 20]  isEqual: @0]) {
        cell.backgroundColor = UIColor.clearColor;
    } else if ([self.viewModel.matrix[indexPath.row / 20][indexPath.row % 20]  isEqual: @1]) {
        cell.layer.cornerRadius = 5;
        cell.backgroundColor = UIColor.blueColor;
    } else if ([self.viewModel.matrix[indexPath.row / 20][indexPath.row % 20]  isEqual: @2]){
        cell.backgroundColor = UIColor.redColor;
        cell.layer.cornerRadius = 5;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 740;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(collectionView.frame.size.width / 20, collectionView.frame.size.width / 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
