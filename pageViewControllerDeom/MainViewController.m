//
//  MainViewController.m
//  pageViewControllerDeom
//
//  Created by Bhargava, Rajat on 7/12/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "MainViewController.h"
#import "FirstViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *pageViewContainer;
@property (nonatomic, strong) NSArray *pumpViewControllers;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *bottomPanGestureRecognizer;
@property (nonatomic, assign) CGPoint bottomContainerCenter;

- (UIViewController *)pumpViewControllerAtIndex:(int)index;
- (IBAction)onBottomPan:(UIPanGestureRecognizer *)sender;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FirstViewController *firstPumpViewController = [[FirstViewController alloc] init];
//        firstPumpViewController.pump = //;
        firstPumpViewController.view.backgroundColor = [UIColor redColor];
        
        FirstViewController *secondPumpViewController = [[FirstViewController alloc] init];
        secondPumpViewController.view.backgroundColor = [UIColor blueColor];
        
        // TODO: Only if there are performance issues with 20 view controllers, then switch to using a dictionary and lazy create the view controllers. The key of the dictionary is the index of the pump.
        self.pumpViewControllers = @[firstPumpViewController, secondPumpViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bottomPanGestureRecognizer.delegate = self;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController:self.pageViewController];
    
    // Do any additional setup after loading the view from its nib.
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.pageViewController.view.frame = self.pageViewContainer.bounds;
    [self.pageViewContainer addSubview:self.pageViewController.view];
    
    [self.pageViewController setViewControllers:@[self.pumpViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    int index = [self.pumpViewControllers indexOfObject:viewController];

    if (index > 0) {
        return [self pumpViewControllerAtIndex:index - 1];
    } else {
        return nil;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = [self.pumpViewControllers indexOfObject:viewController];
    
    if (index < self.pumpViewControllers.count - 1) {
        return [self pumpViewControllerAtIndex:index + 1];
    } else {
        return nil;
    }
}

- (UIViewController *)pumpViewControllerAtIndex:(int)index {
    return self.pumpViewControllers[index];
}

- (IBAction)onBottomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    NSLog(@"self view y %f",self.view.frame.origin.y);
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touch = [panGestureRecognizer locationInView:self.pageViewContainer];
        if (touch.y > 50) {
            // Cancel current gesture
        }
        self.bottomContainerCenter = self.pageViewContainer.center;
        // Disable Page View Controller

        if (fabs(velocity.y) > fabs(velocity.x)) {
            [self disablePageViewController];
        }
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.pageViewContainer.center = CGPointMake(self.bottomContainerCenter.x, self.bottomContainerCenter.y + translation.y);
       
        if (fabs(velocity.y) > fabs(velocity.x)) {
            [self disablePageViewController];
        } else {
            [self enablePageViewController];
        }

        
        
        if (velocity.y > 0) {
            self.pageViewContainer.alpha = 0.5;
            
        }

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Enable Page View Controller
        [UIView animateWithDuration:1 animations:^{
            if (velocity.y < 0) {
                self.pageViewContainer.center = self.view.center;
            } else if (velocity.y > 0) { //going down
                self.pageViewContainer.frame = CGRectMake(0, 500, self.view.frame.size.width, self.view.frame.size.height);
                self.pageViewContainer.alpha = 1;
            }
        }];
        
        [self enablePageViewController];
    }
}
- (void) disablePageViewController{
    for (UIScrollView *view  in self.pageViewController.view.subviews) {
        if([view isKindOfClass:[UIScrollView class]]){
            view.scrollEnabled = NO;
        }
    }
}
- (void) enablePageViewController{
    for (UIScrollView *view  in self.pageViewController.view.subviews) {
        if([view isKindOfClass:[UIScrollView class]]){
            view.scrollEnabled = YES;
        }
    }
}
@end
