//
//  Gjkm_AlertView.m
//  Gjkm_AltreView
//
//  Created by Gj k m on 16/4/14.
//  Copyright © 2016年 Gj k m. All rights reserved.
//

#define Spacing 25
#define Font 15

#import "GAlertView.h"

@interface GAlertView  ()<UITextViewDelegate> {
    CGFloat showWidth;
}
@property(nonatomic,weak)UIImageView * bgView;//背景View
@property(nonatomic,weak)UILabel * TitleLab;//标题lable
@property(nonatomic,strong)UILabel * MessageLab;//提示内容lable
@property(nonatomic,strong)UITextView * Messagetext;//提示内容lable
@property(nonatomic,weak)UIView * MessageView;//提示view
@property(nonatomic,weak)UIButton * submiteButton;//确定按钮
@property(nonatomic,weak)UIButton * cancelButton;//取消按钮
@property(nonatomic,assign)GAlertViewStyle  preferredStyle;


@end

@implementation GAlertView


+ (instancetype)AlertView{
    return [[self alloc]init];
}

- (instancetype)initWithStyle:(GAlertViewStyle)Style{
    
    self.preferredStyle = Style;
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        UIImageView * bgView = [[UIImageView alloc]init];
        bgView.userInteractionEnabled = YES;
        UIImage  * image = [UIImage imageNamed:@"bg"];
        bgView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UILabel * titlelab = [[UILabel alloc]init];
        titlelab.text = @"温馨提示";
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:20];
        self.TitleLab = titlelab;
        [self.bgView addSubview:titlelab];
        
        
        UIButton * submitebtn = [[UIButton alloc]init];
        submitebtn.tag = 1;
        [submitebtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        submitebtn.layer.borderWidth = 0.5;
        submitebtn.layer.borderColor = [UIColor grayColor].CGColor;
        [submitebtn addTarget:self action:@selector(alertclick:) forControlEvents:UIControlEventTouchUpInside];
        self.submiteButton = submitebtn;
        [self.bgView addSubview:submitebtn];
        
        
        UIButton * cancelbtn = [[UIButton alloc]init];
        cancelbtn.tag = 2;
        cancelbtn.layer.borderWidth = 0.5;
        cancelbtn.layer.borderColor = [UIColor grayColor].CGColor;
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(alertclick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.cancelButton = cancelbtn;
        [self.bgView addSubview:cancelbtn];
        
        showWidth = (self.frame.size.width/4)*3-Spacing*2;
        switch (self.preferredStyle) {
                
            case GAlertViewStyleText:
            {
                
                UITextView * textView = [[UITextView alloc]init];
                textView.font = [UIFont systemFontOfSize:Font];
                textView.text = _Messagestr;
                textView.scrollEnabled = NO;
                textView.delegate = self;
                self.Messagetext = textView;
                [self.bgView addSubview:textView];
            }
                break;
                
            case GAlertViewStyleDefault:
            {
                UILabel * messagelab = [[UILabel alloc]init];
                messagelab.numberOfLines = 0;
                messagelab.textAlignment = NSTextAlignmentCenter;
                messagelab.font = [UIFont systemFontOfSize:Font];
                self.MessageLab = messagelab;
                [self.bgView addSubview:messagelab];
            }
                break;
                
            case GAlertViewStyleActionSheet:
            {
                
            }
                
                break;
            default:
                break;
        }

        
        //添加一个观测者：检测键盘弹出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
        //添加一个观测者：检测键盘隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.preferredStyle == GAlertViewStyleText) {
        [self endEditing:YES];
    }
}
#pragma mark - 监听键盘
- (void)keyBoardShow:(NSNotification *)note{
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘高度
    CGRect keyboardframe = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardframe.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, -keyboardH*0.5);
    }];
}
- (void)keyBoardHide:(NSNotification *)note{
    
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.bgView.transform = CGAffineTransformIdentity;

    }];}
#pragma mark - 按钮点击
- (void)alertclick:(UIButton *)btn{
    
    if (btn.tag == 2) {
        [self removeFromSuperview];

    }else{
        
        if ([self.deletegate respondsToSelector:@selector(AlertView:ButtonclickIndex:)]) {
            [self.deletegate AlertView:self ButtonclickIndex:btn.tag];
            [self removeFromSuperview];
        }
    }

}

#pragma mark - 重写set
- (void)setMessagestr:(NSString *)Messagestr{
    _Messagestr = Messagestr;
    
    
    CGSize size = [_Messagestr boundingRectWithSize:CGSizeMake(showWidth - Spacing/2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Font]} context:nil].size;
    
    switch (self.preferredStyle) {
            
        case GAlertViewStyleText:
        {
            
            self.Messagetext.text = _Messagestr;
            self.Messagetext.frame = CGRectMake(Spacing, Spacing+25, showWidth, size.height+20);
        }
            break;
            
        case GAlertViewStyleDefault:
        {
            self.MessageLab.text = _Messagestr;
            self.MessageLab.frame = CGRectMake(Spacing, Spacing+25, showWidth, size.height);
        }
            break;
            
        case GAlertViewStyleActionSheet:
        {
            
        }
            
            break;
        default:
            break;
    }
   
    [self setNeedsLayout];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [self setMessagestr:textView.text];
    [self textViewLayout];
}

- (void)setSubmiteButtonTitle:(NSString *)submiteButtonTitle{
    _submiteButtonTitle = submiteButtonTitle;
    [self.submiteButton setTitle:_submiteButtonTitle forState:UIControlStateNormal];
}

#pragma mark - 添加父试图
- (void)show:(UIView *)View{
    
    [View addSubview:self];
}
- (void)textViewLayout{
    self.bgView.frame = CGRectMake(0, 0, self.frame.size.width/4*3, CGRectGetHeight(self.Messagetext.frame)+12+Spacing*2+44);
    
    self.bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
     
    self.TitleLab.frame = CGRectMake(0, Spacing, self.bgView.frame.size.width, 21);
     
    self.submiteButton.frame = CGRectMake(0, self.bgView.frame.size.height - 44, self.bgView.frame.size.width*0.5, 44);
    self.cancelButton.frame = CGRectMake(self.bgView.frame.size.width*0.5, self.bgView.frame.size.height - 44, self.bgView.frame.size.width*0.5, 44);
    
}
#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    static BOOL isfirst = YES;
    
    if (isfirst) {
  
    switch (self.preferredStyle) {
            
        case GAlertViewStyleText:{
            
            self.bgView.frame = CGRectMake(0, 0, self.frame.size.width/4*3, CGRectGetHeight(self.Messagetext.frame)+12+Spacing*2+44);
            
        }
              break;
        case GAlertViewStyleDefault:
        {
            self.bgView.frame = CGRectMake(0, 0, self.frame.size.width/4*3, CGRectGetHeight(self.MessageLab.frame)+12+Spacing*2+44);
        }
            
            break;
        case GAlertViewStyleActionSheet:{
            
        }
            
            break;
        default:
            break;
    }
  
   
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            
            self.TitleLab.frame = CGRectMake(0, Spacing, self.bgView.frame.size.width, 21);
            
            self.submiteButton.frame = CGRectMake(0, self.bgView.frame.size.height - 44, self.bgView.frame.size.width*0.5, 44);
            self.cancelButton.frame = CGRectMake(self.bgView.frame.size.width*0.5, self.bgView.frame.size.height - 44, self.bgView.frame.size.width*0.5, 44);
            
        } completion:^(BOOL finished) {
            isfirst = NO;
        }];
        
    }
}
@end
