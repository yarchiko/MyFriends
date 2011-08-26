//
//  MainVC.m
//  MyFriends
//
//  Created by Yaroslav Obodov on 8/25/11.
//  Copyright 2011 Mouzone. All rights reserved.
//

#import "MainVC.h"
#import "FBConnect.h"

static NSString* kAppId = @"145062165564860";

@implementation MainVC

@synthesize facebook = _facebook;

- (id)init
{ 
    if (self = [super init])
    {
        _permissions =  [[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil] retain];
        _facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (_responseText)
		[_responseText release];
	_responseText = [[NSMutableData alloc] initWithLength:0];
    
    return self;
}

- (void)dealloc {
    
    if(imgArray)
        [imgArray release], imgArray = nil;
    
    if(connectionArray)
        [connectionArray release], connectionArray = nil;
    
    if(arrayWithData)
        [arrayWithData release], arrayWithData = nil;
    
    [_facebook release];
    [_permissions release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView * backgroundView = [[[UIView alloc] init] autorelease];
    backgroundView.frame = CGRectMake(0, 0, 320, 480);
    backgroundView.backgroundColor = [UIColor whiteColor];
    [backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:backgroundView];
    
    connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    connectButton.frame = CGRectMake(85, 50, 150, 50);
    [connectButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
	[connectButton setTitle:@"View Friends" forState:UIControlStateNormal];
    [backgroundView addSubview:connectButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)loginAction
{
    [_facebook authorize:_permissions localAppId:kAppId];
}

- (void)fbDidLogin 
{
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];

    [self viewFriendsButtonPressed];
}

-(void)fbDidNotLogin:(BOOL)cancelled 
{

}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
   
}

- (void)request:(FBRequest *)request didReceiveData:(NSData *)data 
{
    [_responseText appendData:data];
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
    if(_data)
        [_data release], _data = nil;
    _data = [result retain];
    
    if(imgArray)
        [imgArray release], imgArray = nil;
    imgArray = [[NSMutableArray alloc] init];
    
    if(connectionArray)
        [connectionArray release], connectionArray = nil;
    connectionArray = [[NSMutableArray alloc] init];
    
    if(arrayWithData)
        [arrayWithData release], arrayWithData = nil;
    arrayWithData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[_data objectForKey:@"data"] count]; ++i) 
    {
        [imgArray addObject:[NSNull null]];
        [connectionArray addObject:[NSNull null]];
        [arrayWithData addObject:[NSNull null]];
    }
    
    [self moveToFriendsListTable];
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{

};

#pragma mark -
#pragma mark Action
#pragma mark -

- (void) viewFriendsButtonPressed
{
    NSString * accessToken = [_facebook.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * tempString = [NSString stringWithFormat:@"me/friends?access_token=%@&fields=name,id,picture",accessToken];
    
    [_facebook requestWithGraphPath:tempString
                          andParams:nil
                        andDelegate:self];
}

- (void) closeButtonPressed
{
    [UIView beginAnimations:@"Advanced" context:nil];
	[UIView setAnimationDuration:0.4];
    mainView.frame = CGRectMake(0.0f, -480.0f, 320.0f, 480.0f);
	mainView.alpha = 0.0;
    [UIView commitAnimations];
    
    [connectButton setHidden:NO];
}

- (void) moveToFriendsListTable
{    
    [connectButton setHidden:YES];
        
    mainView = [[[UIView alloc] init] autorelease];
    mainView.backgroundColor = [UIColor grayColor];
    mainView.frame = CGRectMake(0.0f, -480.0f, 320.0f, 480.0f);
    mainView.alpha = 0.0;
    [self.view addSubview:mainView];
    
    _table = [[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)] autorelease];	
	_table.backgroundColor = [UIColor whiteColor];
	_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	_table.dataSource = self;
	_table.delegate = self;
	[_table setTableFooterView:[[[UIView alloc] initWithFrame:CGRectZero] autorelease]];
	[mainView addSubview:_table];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(0, 00, 60, 40);
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[closeButton setTitle:@"Back" forState:UIControlStateNormal];
    [mainView addSubview:closeButton];
    
    [UIView beginAnimations:@"Advanced" context:nil];
	[UIView setAnimationDuration:0.4];
    mainView.frame = CGRectMake(0.0f, 20.0f, 320.0f, 460.0f);
	mainView.alpha = 1.0;

	[UIView commitAnimations];
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[_data objectForKey:@"data"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *cellId = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    
    NSDictionary * item = [[_data objectForKey:@"data"] objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"name"];
    
    if ([[imgArray objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]])
    {
        if (tableView.dragging == NO && tableView.decelerating == NO)
        {
            [self startIconDownload:[item objectForKey:@"picture"] forIndexPath:indexPath];
        }
        
        CGSize itemSize = CGSizeMake(40.0f, 40.0f);
        UIGraphicsBeginImageContext(itemSize);
        
        CGContextRef curContext = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(curContext, [[UIColor lightGrayColor] CGColor]);
        CGContextFillRect(curContext, CGRectMake(0.0f, 0.0f, itemSize.width, itemSize.height));
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        cell.imageView.image = img;                
    }
    else
    {
        cell.imageView.image = [imgArray objectAtIndex:indexPath.row];
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSString *)urlString forIndexPath:(NSIndexPath *)indexPath
{
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:urlString]] delegate:self]; 
    [connectionArray replaceObjectAtIndex:indexPath.row withObject:conn];
    [conn release];
    
    NSMutableData *data = [NSMutableData data];
    [arrayWithData replaceObjectAtIndex:indexPath.row withObject:data];
}

- (void)loadImagesForOnscreenRows
{
    if ([[_data objectForKey:@"data"] count] > 0)
    {
        NSArray *visiblePaths = [_table indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {            
            if ([[imgArray objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) 
            {
                NSDictionary *item = [[_data objectForKey:@"data"] objectAtIndex:indexPath.row];
                [self startIconDownload:[item objectForKey:@"picture"] forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    int index = [connectionArray indexOfObject:connection];
    
    if (index != NSNotFound)
    {
        NSMutableData *mutData = (NSMutableData *)[arrayWithData objectAtIndex:index];
        [mutData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    int index = [connectionArray indexOfObject:connection];
    if (index != NSNotFound)
    {
        [arrayWithData replaceObjectAtIndex:index withObject:[NSNull null]];
        [connectionArray replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    int index = [connectionArray indexOfObject:connection];
    
    if (index != NSNotFound)
    {
        NSMutableData *mutData = (NSMutableData *)[arrayWithData objectAtIndex:index];
        
        UIImage *image = [[UIImage alloc] initWithData:mutData];
        if (image.size.width != 40.0f && image.size.height != 40.0f)
        {
            CGSize itemSize = CGSizeMake(40.0f, 40.0f);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [image drawInRect:imageRect];
            
            [imgArray replaceObjectAtIndex:index withObject:UIGraphicsGetImageFromCurrentImageContext()];
            UIGraphicsEndImageContext();
        }
        else
        {
            [imgArray replaceObjectAtIndex:index withObject:image];
        }
        
        [image release];
        
        [arrayWithData replaceObjectAtIndex:index withObject:[NSNull null]];
        [connectionArray replaceObjectAtIndex:index withObject:[NSNull null]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [_table cellForRowAtIndexPath:indexPath];
        
        cell.imageView.image = [imgArray objectAtIndex:index];
    }
}

@end