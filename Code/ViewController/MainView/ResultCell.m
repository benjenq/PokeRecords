//
//  ResultCell.m
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import "ResultCell.h"


@interface ResultCell(){
    IBOutlet UILabel *_pkPlaceNameRemark;
    IBOutlet UILabel *_pkDataTime;
    IBOutlet UILabel *_pkIV;
    IBOutlet UIImageView *_pkIconView;
    IBOutlet UILabel *_pkweekDay;
    IBOutlet UILabel *_pktimePeriod;

    IBOutlet UILabel *_pktimeInterval;
    
    
    
}

@end

@implementation ResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //[self setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResultCellBG"]] autorelease]];
    UIImageView *bgv = [[[UIImageView alloc] initWithImage:[UIImage imageFromColor:[UIColor iOS7tintColor]]] autorelease];
    
    [self setSelectedBackgroundView:bgv];
    
}

- (void)bindValueWithRecord:(PKMRecord *)objRec
{
    if ([objRec.remark isEqualToString:@""]) {
        _pkPlaceNameRemark.text = [NSString stringWithFormat:@"%@ %@",objRec.placeName, objRec.note];
    }
    else
    {
        _pkPlaceNameRemark.text = [NSString stringWithFormat:@"%@ %@(%@)",objRec.placeName,objRec.note,objRec.remark];
    }
    _pkDataTime.text = [NSString stringWithFormat:@"%@",objRec.dateTime];
    
    _pktimePeriod.text = [NSString stringWithFormat:@"[%@]",objRec.timePeriod];
    if ([objRec.timePeriod isEqualToString:NSLocalizedString(@"PERIOD_D", @"PERIOD_D")])  {

        [self setBackgroundColor:[UIColor cellDarkColor:0.075]];
    }
    else
    {

        [self setBackgroundColor:[UIColor cellLightColor:0.25]];

    }
    
    
    _pkweekDay.text = [NSString stringWithFormat:NSLocalizedString(@"WEEKNUM", @"WEEKNUM"),objRec.weekDay];
    
    if ([objRec.weekDayType isEqualToString:NSLocalizedString(@"DAYISHOLIDAY", @"DAYISHOLIDAY")]) {
        _pkweekDay.textColor = [UIColor redColor];
        _pkDataTime.textColor = [UIColor redColor];
    }
    else
    {
        _pkweekDay.textColor = [UIColor darkGrayColor];
        _pkDataTime.textColor = [UIColor darkGreenColor];
    }
    
    _pkIV.text = [NSString stringWithFormat:@"IV: %@", objRec.iv ];
    
    _pkIconView.image = [UIImage imageNamed:objRec.pkIconName];
        
    _pktimeInterval.text = [NSString stringWithFormat:@"%@",objRec.intervalString];
    
    /*
    NSDate *d1 = [appHelper stringToDate:@"2016-10-01 12:00"];
    NSDate *d2 = [appHelper stringToDate:@"2016-12-01 13:00"];
    
    NSString *rr = [appHelper intervalStringFromStartDate:d1 toDate:d2];
    NSLog(@"%@",rr); */
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    //NSLog(@"<%p>%@ dealloc",self,[self class].description);

    [super dealloc];
}

@end
