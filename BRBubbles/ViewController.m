//
//  ViewController.m
//  BRBubbles
//
//  Created by Aaron Stephenson on 11/09/2014.
//  Copyright (c) 2014 Bronron Apps. All rights reserved.
//  Website: http://www.bronron.com
//  Twitter: @BronronApps

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define notAnimating 0
#define isAnimating 1

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) UIView *viewBarrier;
@property (nonatomic, assign) CGSize bigSize;
@property (nonatomic, assign) CGSize smallSize;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageNameArray = [[NSMutableArray alloc]init];
    [self.imageNameArray addObject:@"icon_one.png"];
    [self.imageNameArray addObject:@"icon_two.png"];
    [self.imageNameArray addObject:@"icon_three.png"];
    [self.imageNameArray addObject:@"icon_four.png"];
    [self.imageNameArray addObject:@"icon_five.png"];
    [self.imageNameArray addObject:@"icon_six.png"];
    [self.imageNameArray addObject:@"icon_seven.png"];
    [self.imageNameArray addObject:@"icon_eight.png"];
    [self.imageNameArray addObject:@"icon_nine.png"];
    [self.imageNameArray addObject:@"icon_ten.png"];
    
    self.bigSize = CGSizeMake(60, 60);
    self.smallSize = CGSizeMake(30, 30);
    int gutter = 20;
    
    self.imagesArray = [[NSMutableArray alloc]init];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width*2+(gutter*2), self.view.frame.size.height*2+(gutter*3))];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width/2-self.view.frame.size.width/2, self.scrollView.contentSize.height/2-self.view.frame.size.height/2)];
    
    int gap = 5;
    int xValue = gutter;
    int yValue = gutter;
    int rowNumber = 1;
    
    for (int zz = 0; zz < 162; zz++)
    {
        UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(xValue, yValue, 60, 60)];
        [self addImageToScrollView:imageOne];
        
        xValue += (60+gap+gap);
        
        if (xValue > (self.scrollView.contentSize.width-(gutter*3)))
        {
            if (rowNumber % 2)
            {
                xValue = 30 + gutter;
            }else{
                xValue = 0 + gutter;
            }
            yValue += (60+gap);
            rowNumber += 1;
        }
    }
    
    self.viewBarrier = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8,self.view.frame.size.height/8, self.view.frame.size.width-self.view.frame.size.width/4, self.view.frame.size.height-self.view.frame.size.height/4)];
    self.viewBarrier.backgroundColor = [UIColor redColor];
    self.viewBarrier.alpha = 0.3;
    self.viewBarrier.hidden = YES;
    [self.viewBarrier setUserInteractionEnabled:NO];
    [self.view addSubview:self.viewBarrier];
}

- (void)addImageToScrollView:(UIImageView *)image
{
    [image setImage:[UIImage imageNamed:[self.imageNameArray objectAtIndex:arc4random()%9]]];
    [image.layer setCornerRadius:12];
    [image.layer setMasksToBounds:YES];
    image.layer.anchorPoint = CGPointMake(0.5,0.5);
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:image];
    [self.imagesArray addObject:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect container = CGRectMake(scrollView.contentOffset.x+(scrollView.frame.size.width/8), scrollView.contentOffset.y+(scrollView.frame.size.height/8), self.view.frame.size.width-self.view.frame.size.width/4, self.view.frame.size.height-self.view.frame.size.height/4);
    dispatch_queue_t fetchQ = dispatch_queue_create("BubbleQueue", NULL);
    dispatch_async(fetchQ, ^{
        for (UIImageView *imageView in self.imagesArray)
        {
            CGRect thePosition =  imageView.frame;
            if(CGRectIntersectsRect(container, thePosition))
            {
                if (imageView.tag == notAnimating)
                {
                    imageView.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5
                                         animations:^{
                                             imageView.transform = CGAffineTransformMakeScale(1.0,1.0);
                                         }
                                         completion:^(BOOL finished) {
                                             imageView.tag = notAnimating;
                                         }
                         ];
                    });
                }
            }else{
                if (imageView.tag == notAnimating)
                {
                    imageView.tag = isAnimating;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5
                                         animations:^{
                                             imageView.transform = CGAffineTransformMakeScale(0.5,0.5);
                                         }
                                         completion:^(BOOL finished) {
                                             imageView.tag = notAnimating;
                                         }
                         ];
                    });
                }
            }
        }
    });
}

@end
