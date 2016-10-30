//
//  EditorViewController.m
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import "EditorViewController.h"

#import "PlaceNameInputView.h"

@interface EditorViewController () {
    
    IBOutlet UIButton *_pkIcon;
    
    IBOutlet UITextField *_YYYY;
    IBOutlet UITextField *_MM;
    IBOutlet UITextField *_DD;
    IBOutlet UITextField *_HH;
    IBOutlet UITextField *_MI;
    
    IBOutlet UITextField *_IV;
    IBOutlet UITextField *_remark;
    IBOutlet UITextField *_placename;
    IBOutlet UITextField *_note;
    
    IBOutlet UITextField *_PKID;
    
    //Input View
    
    IBOutlet UIView *_remarkInputView;
    IBOutlet UIView *_pkmInputView;
    
    PlaceNameInputView *_placeChooser;

    
    IBOutlet UIScrollView *formScroll;
    CGRect formScrollOriginalFrame;

    
}

@property (nonatomic,assign) PKMRecord *pkmRec;

@end


@implementation EditorViewController


#pragma mark -
#pragma mark View lifecycle

- (instancetype)initWithPKMRecord:(PKMRecord *)obj{
    self = [super initWithNibName:[self class].description bundle:nil];
    
    if (self) {
        self.pkmRec = obj;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"EditorViewBG"]];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    if (self.pkmRec == nil) {
        self.title = NSLocalizedString(@"EDITVIEWTITLE1", @"EDITVIEWTITLE1");
    }
    else
    {
        self.title = NSLocalizedString(@"EDITVIEWTITLE2", @"EDITVIEWTITLE2");
    }

    if (!_placeChooser) {
        _placeChooser = [[PlaceNameInputView alloc] loadFromNib];
    }
    [_placeChooser setDelegate:(id<PlaceNameInputViewDelegate>)self];
    
    [self bindValueFromKMRec];
    [self resignTextFieldDelegate:self];
    [self addTargetTextFieldNotification];
    [self addObserverKeyboardEvent];
    
    UIBarButtonItem *saveBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePKMRecord:)] autorelease];
    
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    _pkIcon.layer.cornerRadius = 10;
    _pkIcon.layer.borderWidth = 1;
    _pkIcon.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)savePKMRecord:(id)sender{
    [self resignAllFirstResponder];
    if (self.pkmRec == nil) {
        PKMRecord *obj = [[[PKMRecord alloc] init] autorelease];
        obj.identifier = [appHelper newUUID];
        [self bindTopKMRec:obj];
        [obj writetoDB];
    }
    else
    {
        [self bindTopKMRec:self.pkmRec];
        [self.pkmRec writetoDB];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)bindValueFromKMRec{
    if (self.pkmRec == nil) {
        _YYYY.text = [[appHelper dateToString:[NSDate date]] substringToIndex:4];
        return;
    }
    
    [_pkIcon setImage:[UIImage imageNamed:self.pkmRec.pkIconName] forState:UIControlStateNormal]  ;

    _PKID.text = self.pkmRec.pkID;
    
    _YYYY.text = self.pkmRec.YYYY;
    _MM.text = self.pkmRec.MM;
    _DD.text = self.pkmRec.DD;
    _HH.text = self.pkmRec.HH;
    _MI.text = self.pkmRec.mi;

    _remark.text = self.pkmRec.remark;
    _placename.text = self.pkmRec.placeName;
    _note.text = self.pkmRec.note;
    
    _IV.text = self.pkmRec.iv;
    
    
}

- (void)bindTopKMRec:(PKMRecord *)pkmObj{
    
    //self.pkmRec.pkIconName
    
    
    //[_pkIcon setImage:[UIImage imageNamed:self.pkmRec.pkIconName] forState:UIControlStateNormal]  ;
    
    pkmObj.pkID = _PKID.text ;
    
    pkmObj.YYYY = _YYYY.text ;
    pkmObj.MM = _MM.text ;
    pkmObj.DD = _DD.text ;
    pkmObj.HH = _HH.text  ;
    pkmObj.mi =  _MI.text  ;
    
    pkmObj.remark = _remark.text ;
    pkmObj.placeName = _placename.text ;
    pkmObj.note = _note.text ;
    if (![_IV.text isEqualToString:@""]) {
        pkmObj.iv = _IV.text ;
    }
    
    
}


- (void)addTargetTextFieldNotification{
    
    [_YYYY addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    
    [_MM addTarget:self
              action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
    
    [_DD addTarget:self
              action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
  
    [_HH addTarget:self
              action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
    
    [_MI addTarget:self
            action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
    
    [_IV addTarget:self
            action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
    
    [_remark addTarget:self
            action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
    
    [_placename addTarget:self
            action:@selector(textFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
}

- (void)resignTextFieldDelegate:(id)object{
    [_YYYY setDelegate:(id<UITextFieldDelegate>)object];
    [_MM setDelegate:(id<UITextFieldDelegate>)object];
    [_DD setDelegate:(id<UITextFieldDelegate>)object];
    [_HH setDelegate:(id<UITextFieldDelegate>)object];
    [_MI setDelegate:(id<UITextFieldDelegate>)object];
    [_IV setDelegate:(id<UITextFieldDelegate>)object];
    [_remark setDelegate:(id<UITextFieldDelegate>)object];
    [_placename setDelegate:(id<UITextFieldDelegate>)object];
    [_note setDelegate:(id<UITextFieldDelegate>)object];
    
    _remark.inputView = _remarkInputView;
    _placename.inputAccessoryView = _placeChooser;
    _PKID.inputView = _pkmInputView;
    
    //InputViewBG
    _remarkInputView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"InputViewBG"]];
    _pkmInputView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"InputViewBG"]];
}


 - (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     formScrollOriginalFrame = formScroll.frame; //iOS9 / XCode 7 Fix
     formScroll.contentSize = formScroll.frame.size;
     if (self.pkmRec == nil) {
         [_MM becomeFirstResponder];
     }
 }


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    formScrollOriginalFrame = formScroll.frame; //iOS9 / XCode 7 Fix
    formScroll.contentSize = formScroll.frame.size;
    
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [self resignAllFirstResponder];
    [super viewWillDisappear:animated];
}

/*
 - (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
 }
 */


#pragma mark 鍵盤
- (void)addObserverKeyboardEvent{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification *)n{
    
    // get the size of the keyboard
    //CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSLog(@"keyboardWillShow:%@",[n userInfo]);
    NSDictionary* userInfo = [n userInfo];
    
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //計算 formScroll frame 的變量，將下緣與KeyBoard上端切齊
    
    CGPoint ScrollLowBoundPoint = [self.view convertPoint:CGPointMake(formScrollOriginalFrame.origin.x, formScrollOriginalFrame.origin.y + formScrollOriginalFrame.size.height) //selv.view 上的 frame
                                                   toView:self.view.window];
    CGFloat scrollcuthigh = ScrollLowBoundPoint.y - keyboardFrame.origin.y;
    if (scrollcuthigh >0) {
        [formScroll setFrame:CGRectMake(formScrollOriginalFrame.origin.x, formScrollOriginalFrame.origin.y,
                                        formScrollOriginalFrame.size.width, formScrollOriginalFrame.size.height - scrollcuthigh)];
        
    }
    else
    {
        
        //if (self.pkmRec != nil) {
            [formScroll setFrame:formScrollOriginalFrame];
            [formScroll setContentOffset:CGPointZero animated:YES];
        //}
        //NSLog(@"formScrollOriginalFrame=%@",NSStringFromCGRect(formScrollOriginalFrame));
    }
    
}
-(void)keyboardDidShow:(NSNotification *)n{
    //NSLog(@"keyboardDidShow:%@",[n userInfo]);
}

-(void)keyboardWillHide:(NSNotification *)n{
    
    [formScroll setFrame:formScrollOriginalFrame];
    [formScroll setContentOffset:CGPointZero animated:YES];
    //[formScroll setContentSize:formScrollOriginalContentSize];
    
    //NSLog(@"keyboardWillHide:%@",[n userInfo]);
}
-(void)keyboardDidHide:(NSNotification *)n{
    //NSLog(@"keyboardDidHide:%@",[n userInfo]);
    
}


/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -

- (IBAction)pkIconTab:(UIButton *)sender{
    [_PKID becomeFirstResponder];
}

- (IBAction)resignAllFirstResponder{
    [_YYYY resignFirstResponder];
    [_MM resignFirstResponder];
    [_DD resignFirstResponder];
    [_HH resignFirstResponder];
    [_MI resignFirstResponder];
    [_IV resignFirstResponder];
    [_remark resignFirstResponder];
    [_placename resignFirstResponder];
    [_note resignFirstResponder];
    
    [_PKID resignFirstResponder];

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //NSLog(@"%@",textField.text);
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"%@",textField.text);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //NSLog(@"%@",textField.text);
    
    if (textField == _YYYY) {
        if ([textField.text integerValue] > 2030 || [textField.text integerValue] < 2000) {
            return NO;
        }
    }
    else if (textField == _MM) {
        if ([textField.text integerValue] > 12 || [textField.text isEqualToString:@""] || [textField.text integerValue] <= 0) {
            textField.text = @"01";
            return YES;
        }
        if ([textField.text integerValue] < 10 && textField.text.length == 1) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    else if (textField == _DD ) {
        if ([textField.text integerValue] > 31 || [textField.text isEqualToString:@""] || [textField.text integerValue] <= 0) {
            textField.text = @"01";
            return YES;
        }
        if ([textField.text integerValue] < 10 && textField.text.length == 1) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    else if (textField == _HH) {
        if ([textField.text integerValue] > 23 || [textField.text isEqualToString:@""]) {
            textField.text = @"00";
            return YES;
        }
        if ([textField.text integerValue] < 10 && textField.text.length == 1) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    else if (textField == _MI) {
        if ([textField.text integerValue] > 59 || [textField.text isEqualToString:@""]) {
            textField.text = @"00";
            return YES;
        }
        if ([textField.text integerValue] < 10 && textField.text.length == 1) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    else if (textField == _IV){
        if ([textField.text floatValue] > 100.0) {
            textField.text = @"0.0";
            return YES;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //NSLog(@"%@",textField.text);
}



- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //NSLog(@"textFieldShouldClear:%@",textField.text);
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //NSLog(@"textFieldShouldReturn:%@",textField.text);
    if (textField == _IV) {
        [_remark becomeFirstResponder];
    }
    else if (textField == _remark) {
        [_placename becomeFirstResponder];
    }
    else if (textField == _placename) {
        [_note becomeFirstResponder];
    }
    else if (textField == _note) {
        [self resignAllFirstResponder];
    }
    return YES;
}
#pragma mark 欄位內容
- (void)textFieldDidChange:(UITextField *)textField{
    //NSLog(@"textFieldDidChange:%@",textField.text);
    
    if (textField == _YYYY) {
        if (textField.text.length >=4) {
            [_MM becomeFirstResponder];
        }
    }
    else if (textField == _MM) {
        if (textField.text.length >=2) {
            [_DD becomeFirstResponder];
        }
    }
    else if (textField == _DD) {
        if (textField.text.length >=2) {
            [_HH becomeFirstResponder];
        }
    }
    else if (textField == _HH) {
        if (textField.text.length >=2) {
            [_MI becomeFirstResponder];
        }
    }
    else if (textField == _MI) {
        if (textField.text.length >=2) {
            [_IV becomeFirstResponder];
        }
    }
    else if (textField == _IV) {
        if (textField.text.length >=5) {
            [_remark becomeFirstResponder];
        }
    }
    
    
}

#pragma mark - Input View

- (IBAction)remarkTap:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"無"]) {
        _remark.text = @"";
    }
    else
    {
        _remark.text = sender.titleLabel.text;
        
    }
    [_placename becomeFirstResponder];
}

- (IBAction)pkmButtonTap:(UIButton *)sender{
    NSString *filenm = [NSString stringWithFormat:@"%li",(long)sender.tag];
    _PKID.text = filenm;
    [_pkIcon setImage:[UIImage imageNamed:filenm] forState:UIControlStateNormal];
    [_PKID resignFirstResponder];
}

#pragma mark @protocol PlaceNameInputViewDelegate <NSObject>
-(void)buttonTap:(UIButton *)button{
    _placename.text = button.titleLabel.text;
}


#pragma mark Memory management




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    self.pkmRec = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_placeChooser setDelegate:nil];
    _placename.inputAccessoryView = nil;
    
    //NSLog(@"<%p>%@ dealloc",self,[self class].description);
    [super dealloc];
}


@end

