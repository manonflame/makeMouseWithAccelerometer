//
//  ViewController.h
//  accelerometer_test
//
//  Created by 민경준 on 2017. 3. 17..
//  Copyright © 2017년 민경준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController{
    CMMotionManager *manager;
    float x_accel;
    float x_velo;
    float x_dist;
    
    
    //시간 계산에 사용될 변수
    float times;
    
    //적분에 사용될 속도 변수들
    float velo;
    float acc0;
    float acc1;
    
    
    //적분에 사용될 거리 변수들
    float dist;
    float velo0;
    float velo1;
    
    //속도 오차 조정(momentCheck)에 사용될 변수
    int check;
    int at;
    int vt;
    
    float errorV;
    float checking;
    float checking2;
    float maxavg;
    float minavg;
    
    //심슨 방법에 사용될 변수
    float ai, aj, ak; // 가속도
    float vi, vj, vk; // 속도
    float velocity;//속도값 유지를 위한 변수
    
    
    
    //노이즈의 최소 최대
    float noisemax;
    float noisemin;
    
    
    
    //칼만변수
    
    float q1;
    float r1;
    float kx1;
    float p1;
    float k1;
    
    float q2;
    float r2;
    float kx2;
    float p2;
    float k2;
    
    float q3;
    float r3;
    float kx3;
    float p3;
    float k3;
    
    float q4;
    float r4;
    float kx4;
    float p4;
    float k4;
    
    
    
    
    
    
    
    

    float nsum;
    float ksum1;
    float ksum2;
    float ksum3;
    float ksum4;
    
    float avg;
    float div;
    
    
    int kindex;
    int nindex;
    
    
    
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(nonnull UIAcceleration *)acceleration;

- (void)myCalibration;

- (float)CalIntegrationWithbase:(float) velo: (float)base:(float)diff0:(float)diff1:(float)time;


//심슨 적분법 인자 파악 : 측정값 3개 + 기존값  --> 파악 필수
- (float)simpson:(float)t0: (float) t1: (float) t3;



@property (strong, nonatomic) IBOutlet UIButton *testButton;
@end

