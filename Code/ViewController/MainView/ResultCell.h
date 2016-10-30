//
//  ResultCell.h
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ResultCell : UITableViewCell

- (void)bindValueWithRecord:(PKMRecord *)objRec;

@end
