//
//  AKTPublic.c
//  Pursue
//
//  Created by YaHaoo on 16/3/19.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#include "AKTPublic.h"
/*
 * Safty check whether "a" is equal to "b". Support: int float or double
 */
bool aktValueEqual(double a, double b) {
    double delta = ABS(a-b);
    if (delta>1) {
        return false;
    }else{
        delta *= 1e4;
        if (delta>1) {
            return false;
        }else{
            return true;
        }
    }
}

/*
 * Random color
 */
UIColor *aktRandomColor(CGFloat alpha) {
    int r, g, b;
    while (1) {
        r = arc4random()%255;
        g = arc4random()%255;
        b = arc4random()%255;
        if (ABS(g-r)+ABS(b-r)>40) {
            break;
        }
    }
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
}

