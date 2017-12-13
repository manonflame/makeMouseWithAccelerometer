//
//  ViewController.m
//  accelerometer_test
//
//  Created by 민경준 on 2017. 3. 17..
//  Copyright © 2017년 민경준. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#include <math.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize testButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //초당 센서 측정 간격 (초)
    times = 0.01;
    
    
    //
    errorV=0;
    checking = 0;
    checking2 = 0;
    
    //CMMotionManager 생성
    manager = [[CMMotionManager alloc] init];
    x_accel = 0;
    x_velo = 0;
    x_dist = 0;
    
    NSLog(@"이 부분은 한번만 호출되어야 해요1");
    
    
    //속도를 위한 적분에 활용할 가속도 데이터의 초기값.
    velo = 0;
    acc0 = 0;
    acc1 = 0;
    
    
    //적분에 사용될
    dist = 0;
    velo0 = 0;
    velo1 = 0;
    
    maxavg= -10;
    minavg= 10;
    
    
    
    //심슨메소드에 사용될 변수
    
    //가속도 변수
    ai, aj, ak = 0;
    //속도 변수
    velocity, vi, vj, vk = 0;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    r1 = 0.8;
    p1 = 0;
    
    q1 = 0.001;
    kx1 = 0;
    
    ////////////////////////////////////////////////////////////
    
    r2 = 0.0000024;
    p2 = 0;
    
    q2 = 0.00000001;
    kx2 = 0;
    
    ////////////////////////////////////////////////////////////
    
    
    r3 = 2.4; //새로들어오는 값의 정확한 정도 작을수록 정확
    p3 = 0;
    
    q3 = 0.00000001; //
    kx3 = 0;
    
    ////////////////////////////////////////////////////////////
    
    r4 = 0.0000024;
    p4 = 1;
    
    q4 = 0.01;
    kx4 = 0;
    
    
    
    ksum1=0;
    ksum2=0;
    ksum3=0;
    ksum4=0;
    
    
    
    
    nsum=0;
    kindex=0;
    nindex=0;
    
    
    
    
    
    
    
    float rett = 0;
    float tdiff0 = 0;
    float tdiff1 = 1;
    float tt = 2;
    
    
    avg = 0;
    div = 0;
    
    
    noisemax = 0;
    
    noisemin = 0;
    
    
    //가속도 - 속도변환
    rett = [self CalIntegration:rett :tdiff0 :tdiff1 :tt];
    NSLog(@"first :: %f",rett);
    
    tdiff0 = tdiff1;
    tdiff1 = 1.5;
    
    //속도 - 거리변환
    rett = [self CalIntegration:rett :tdiff0 :tdiff1 :tt];
    NSLog(@"second :: %f",rett);
    
    //속도 오차 조정(momentCheck)에 사용될 변수 초기값 설정.
    check = 0;
    
    
    //혹시 이 상위파트가 계속 호출되는지 확인해보장
    NSLog(@"이 부분은 한번만 호출되어야 해요2");
    
    
    
    
    //CMMotionManager 설정 - 측정 간격
    manager.deviceMotionUpdateInterval = times;
    
    
    //CMMotionManager 에서 가속도를 검출
    if(manager.deviceMotionAvailable){
        [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion* motion, NSError* error){
            
            //가속도계에 할당 - 시간은 상부에서 설정함.
            CMAcceleration g = motion.userAcceleration;
            
            
            
            //초기 노이즈 잡음 : 아직 미구현 : 노이스 설정은 어떤 변수를 사용해서 한번만 호춛하는 것으로 수정하자.
            [self myCalibration];
            
            //칼만필터의 구현
            //칼만 게인//공분산 업데이트
            acc1 = g.x;
            
            
            k1 = (p1+q1)/(p1+q1+r1);
            p1 = r1*(p1+q1)/(p1+q1+r1);
            kx1 = kx1 + (acc1 - kx1)*k1;
            
            
            k2 = (p2+q2)/(p2+q2+r2);
            p2 = r2*(p2+q2)/(p2+q2+r2);
            kx2 = kx2 + (acc1 - kx2)*k2;
            
            k3 = (p3+q3)/(p3+q3+r3);
            p3 = r3*(p3+q3)/(p3+q3+r3);
            kx3 = kx3 + (acc1 - kx3)*k3;
            
            k4 = (p4+q4)/(p4+q4+r4);
            p4 = r4*(p4+q4)/(p4+q4+r4);
            kx4 = kx4 + (acc1 - kx4)*k4;

            

            
            
            velo = [self CalIntegration : velo :ksum1 : kx1:times];

            //속도를 velo1에 저장
            velo1 = velo;
            
            //거리를 trapezoidal method를 이용해서 정밀 적분
            dist = [self CalIntegration: dist :velo0 :velo1 :times];
            
            //속도를 다음 적분을 위에 저장
            velo0 = velo1;
            

            
            
            
            
            
            //필터링 된 값들에 가중을 두고 그중 첫번째 필터링 값을 적분
            NSLog(@"|%+4.6f|%+4.6f|%+4.6f|%+4.6f|%+4.6f|%+4.6f",kx1, kx2,kx3,kx4,acc1,roundf(velo*1000)/100);
            //NSLog(@"|%+4.6f|%+4.6f|%+4.6f",kx1,acc1,roundf(velo*1000)/100);
            
            
            
            
            ksum1=kx1;
            ksum2=kx2;
            ksum3=kx3;
            ksum4=kx4;


            
        }];
    }
    else{
        NSLog(@"deviceMotionUpdateInterval is NO;");
    }
    
    
}
//초기 가속도 노이즈 조정
- (void)myCalibration{
    //NSLog(@"노이즈 설정");
    
}


- (IBAction)testButtonClicked:(id)sender {
    dist= 0;
    kx2 = 0;
    checking = 0;
    velo=0;
    
    
    
    
    
    NSLog(@"위치 제자리로");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//trapezoidal 적분
- (float) CalIntegration:(float) base:(float) diff0 : (float) diff1 :(float) time{
    float ret = 0;
    ret = base + ( diff0 + diff1 )/2 *time;
    return ret;
}

- (void) momentCheck:(float)acc{
    if(acc == 0){
        check++;
    }
    
    if(check >=5)
    {
        velo = 0;
    }
    else{
        
    }
}

- (float) simpson:(float)t0 :(float)t1 :(float)t2{
    float ret = 0;
    ret  = (2*times/6)*(t0 + 4*t1 + t2);
    return ret;
}


@end































