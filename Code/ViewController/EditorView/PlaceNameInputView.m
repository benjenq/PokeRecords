//
//  PlaceNameInputView.m
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import "PlaceNameInputView.h"

@interface PlaceNameInputView (){
    
    NSMutableArray *_placeNameArrays;
    
    IBOutlet  UIScrollView *_baseScrollView;


}

@end


@implementation PlaceNameInputView
@synthesize delegate = _delegate;

- (instancetype)loadFromNib{
    //NSLog(@"PlaceNameInputView loadFromNib");
    self = [[[NSBundle mainBundle] loadNibNamed:@"PlaceNameInputView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    _baseScrollView.contentSize = self.frame.size;
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"InputViewBG"]];
    
    [self renewArray];
    
}

- (void)renewArray{
    if (!_placeNameArrays) {
        _placeNameArrays = [[NSMutableArray alloc] init];
    }
    else
    {
        [_placeNameArrays removeAllObjects];
    }
    [FetchDataProc fetchPlaceNamesArray:_placeNameArrays completion:^(BOOL success, NSMutableArray *resultArray) {
        if (!success) {
            return ;
        }
        [self layoutPlaceNameButtons];
        
    }];
}

- (void)layoutPlaceNameButtons{
    
    
    [_placeNameArrays enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(5 + idx*85 , 5, 80, 35)] autorelease];
        
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.minimumFontSize = 7;
        
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.35]];
        
        btn.showsTouchWhenHighlighted = YES;
        
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [_baseScrollView addSubview:btn];
        
        CGSize newcontentSize = CGSizeMake(MAX(_baseScrollView.contentSize.width,btn.frame.size.width + btn.frame.origin.x), _baseScrollView.contentSize.height);
        
        _baseScrollView.contentSize = newcontentSize;
        
    }];
    
}

- (void)buttonTap:(UIButton *)sender{
    
    if ([_delegate respondsToSelector:@selector(buttonTap:)]) {
        [_delegate buttonTap:sender];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    //NSLog(@"<%p>%@ dealloc",self,[self class].description);
    [_placeNameArrays removeAllObjects];
    [_placeNameArrays release];
    for (UIView *v in _baseScrollView.subviews ) {
        [v removeFromSuperview];
    }
    [super dealloc];
}

@end
