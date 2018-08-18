//
//  Created by Akshit Bum
//

#import "ResultCell.h"

@interface ResultCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ResultCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self commonInit];
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self commonInit];
    }
    return self;
}

-(void) commonInit
{
    self.title = self.subtitle = nil;
    self.renditionImage = nil;
    [self stopActivity];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)startActivity
{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

-(void)stopActivity
{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}

#pragma mark PROPERTY SETTERS/GETTERS

-(void) setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(NSString*) title
{
    return [self.titleLabel.text copy];
}

-(void) setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

-(NSString*) subtitle
{
    return [self.subtitleLabel.text copy];
}

-(void) setRenditionImage:(UIImage *)image
{
    self.thumbImageView.image = image;
    
    if(self.thumbImageView.image != nil)
        [self stopActivity];
}

-(UIImage*) renditionImage
{
    return self.thumbImageView.image;
}

@end
