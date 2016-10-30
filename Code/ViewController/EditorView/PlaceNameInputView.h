//
//  PlaceNameInputView.h
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlaceNameInputViewDelegate;
@interface PlaceNameInputView : UIView{
    id <PlaceNameInputViewDelegate> _delegate;
}

@property (nonatomic,assign) id <PlaceNameInputViewDelegate> delegate;




- (instancetype)loadFromNib;

@end

@protocol PlaceNameInputViewDelegate <NSObject>
-(void)buttonTap:(UIButton *)button;
@end
