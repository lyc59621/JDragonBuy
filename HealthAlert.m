//
//  HealthAlert.m
//  Cim120
//
//  Created by CIM CIM on 13-4-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HealthAlert.h"
#import <QuartzCore/QuartzCore.h>

@implementation HealthAlert
@synthesize delegate;
-(id)init
{
    self=[self initWithStyle:Attention];
    
    return self;
}
-(void)dealloc
{
//    [label release];
//    [view release];
    //手势移出
    [view removeGestureRecognizer:_tap];
    [_data release];
    [super dealloc];
}
-(id)initWithStyle:(alertType)_type
{
    self=[super init];
    
    if (self) {
        [self retain];
        
        _tap=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOver:)];
        
        secondsCount=15;
        view=[[UIView alloc] init];
        [view addGestureRecognizer:_tap];
        [_tap release];
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
        label.numberOfLines=0;
        label.lineBreakMode=NSLineBreakByCharWrapping;//   UILineBreakModeCharacterWrap;
        [view addSubview:label];
        [label release];
        label.backgroundColor=[UIColor redColor];
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentCenter;
        view.backgroundColor=[UIColor redColor];
        
        view.layer.cornerRadius=10; 
        view.clipsToBounds=YES;
        view.frame=CGRectMake(0, 0, 200, 60);
        view.alpha=0;
        type=_type;
        switch (_type) {
            case Attention:
                view.frame=label.frame=CGRectMake(0, 0, 200, 60);
        
                break;
            case Alarm:{
                view.frame=CGRectMake(0, 0, 200,120);
                label.frame=CGRectMake(0, 0, 200, 80);
                cancelAlert=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                sendAlert=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                cancelAlert.frame=CGRectMake(20, 120-10-30, 60, 30);
                sendAlert.frame=CGRectMake(200-80, 120-10-30, 60, 30);
                [cancelAlert setTitle:@"取消" forState:UIControlStateNormal];
                [sendAlert setTitle:@"发送" forState:UIControlStateNormal];
                
                [view addSubview:cancelAlert];
                [view addSubview:sendAlert];
                
                [cancelAlert addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
                [sendAlert addTarget:self action:@selector(sendAlert) forControlEvents:UIControlEventTouchUpInside];
                
            }
            default:
                break;
        }
        
    }
   
    return self;
}
-(void)moveOver:(UIPanGestureRecognizer*)tap
{
    
    UIView *tempview=[[UIView alloc] initWithFrame:CGRectZero];
    [view.superview addSubview:tempview];
    [tempview release];
    
    
    UIInterfaceOrientation orientation=[UIApplication sharedApplication].statusBarOrientation;//   [UIDevice currentDevice].orientation;
    CGAffineTransform tran;
    
    if (orientation==UIInterfaceOrientationPortrait) {
        tran=CGAffineTransformIdentity;
        
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft) {
        tran=CGAffineTransformMakeRotation(1.5*M_PI);
    }
    else if (orientation==UIInterfaceOrientationLandscapeRight) {
        tran=CGAffineTransformMakeRotation(M_PI/2);
    }
    else if(orientation==UIInterfaceOrientationPortraitUpsideDown) {
        tran=CGAffineTransformMakeRotation(-M_PI);
    }
    else {
        tran=CGAffineTransformIdentity;
    }
    
    
    tempview.transform=tran;
    
    
    if (tap.state==UIGestureRecognizerStateBegan) {
        oldPoint=[tap locationInView:tempview];
        return;
    }
    CGPoint curPoint=[tap locationInView:tempview];
    
    view.transform=CGAffineTransformTranslate(view.transform,curPoint.x-oldPoint.x , curPoint.y-oldPoint.y);
    oldPoint=curPoint;
//    CGPoint curPoint=[tap locationInView:view];
//    if (tap.state==UIGestureRecognizerStateBegan) {
//        oldPoint= CGPointMake(tap.view.center.x-curPoint.x, tap.view.center.y-curPoint.y);// 
//    }
//    tap.view.center=CGPointMake(curPoint.x+oldPoint.x, curPoint.y+oldPoint.y);
    [tempview removeFromSuperview];



}
-(void)cancelAlert
{


    if ([delegate respondsToSelector:@selector(healthAlertDidClickedCancel)]) {
        [delegate healthAlertDidClickedCancel];
    }
    [timer invalidate];
    //[view removeFromSuperview ];
    view.alpha=0;
    [self release];
    

}
-(void)sendAlert
{
    if ([delegate respondsToSelector:@selector(healthAlertDidClickedSend)]) {
        [delegate healthAlertDidClickedSend];
    }
    [timer invalidate];
    if(view) { 
       // [view removeFromSuperview];
        view.alpha=0;
       // [[ServerManager sharedServerManager] sendData:_data];//原包发送
        [self release];
    }
}
-(void)showWithMessage:(NSString*)string
{

    [self showWithMessage:string andTimeInterval:5];
}
-(void)showWithMessage:(NSString *)string andAc3Data:(NSData *)data
{
    _data=[data retain];
    [self showWithMessage:string andTimeInterval:5];
}
-(void)showWithMessage:(NSString*)string andTimeInterval:(NSTimeInterval)inter
{
  
    text=string;
    UIWindow *win= [[UIApplication sharedApplication] delegate].window;
    //判断方向
    UIInterfaceOrientation orientation=[UIApplication sharedApplication].statusBarOrientation;//   [UIDevice currentDevice].orientation;
    CGAffineTransform tran;
    
    if (orientation==UIInterfaceOrientationPortrait) {
        tran=CGAffineTransformIdentity;
        
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft) {
        tran=CGAffineTransformMakeRotation(1.5*M_PI);
    }
    else if (orientation==UIInterfaceOrientationLandscapeRight) {
        tran=CGAffineTransformMakeRotation(M_PI/2);
    }
     else if(orientation==UIInterfaceOrientationPortraitUpsideDown) {
        tran=CGAffineTransformMakeRotation(-M_PI);
    }
     else {
         tran=CGAffineTransformIdentity;
     }
    view.transform=tran;
    
    [win addSubview:view];
    view.center=win.center;
    label.text=text; 
    

    
    switch (type) {
        case Attention:
            [UIView animateWithDuration:0.5
                             animations:^{
                                 
                                 view.alpha=1;
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:inter
                                                  animations:^{
                                                      view.alpha=0;
                                                      
                                                        [self release];
                                                  }];
                             }];

            break;

        default:
        {
            [UIView animateWithDuration:0.5 animations:^{view.alpha=1;}];
            
            label.text=[text stringByAppendingString:@"\n(15s后系统将自动发送）"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
            
        
        }
            
            
            break;
    }
    
   
}
-(void)refreshView
{
    if(secondsCount<0&&self) [self sendAlert];
    
    else {
       label.text=[text stringByAppendingString:[NSString stringWithFormat:@"\n(%02ds后系统将自动发送）",secondsCount--]];
    }
}
@end
