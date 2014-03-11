//
// PSCollectionView.m
//
// Copyright (c) 2012 Peter Shih (http://petershih.com)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VSCollectionView.h"
#import <QuartzCore/QuartzCore.h>

//@Brian note: to limit the amount that the app refreshes and adds views & help control memory, it might be valuable to try limiting the amount that the app refreshes by skipping some cell refreshes if the user is scrolling with a certain momentum.  Pinterest seems to introduce some bounceback to the scrolling engine also to help control from the user scrolling too much & trying to load too much.
//[view setContentOffset: offset animated: YES]



static inline NSString * VSCollectionKeyForIndex(NSInteger index) {
    return [NSString stringWithFormat:@"%d", index];
}

static inline NSInteger VSCollectionIndexForKey(NSString *key) {
    return [key integerValue];
}

#pragma mark - UIView Category

@interface UIView (VSCollectionView)

@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign, readonly) CGFloat right;
@property(nonatomic, assign, readonly) CGFloat bottom;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@end

@implementation UIView (VSCollectionView)


float vskMargin = 5.0;


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end

#pragma mark - Gesture Recognizer

// This is just so we know that we sent this tap gesture recognizer in the delegate
@interface VSCollectionViewTapGestureRecognizer : UITapGestureRecognizer
@end

@implementation VSCollectionViewTapGestureRecognizer
@end


@interface VSCollectionView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) CGFloat lastOffset;
@property (nonatomic, assign, readwrite) CGFloat offsetThreshold;
@property (nonatomic, assign, readwrite) CGFloat lastWidth;
@property (nonatomic, assign, readwrite) CGFloat colWidth;
@property (nonatomic, assign, readwrite) NSInteger numCols;
@property (nonatomic, assign) UIInterfaceOrientation orientation;

@property (nonatomic, strong) NSMutableDictionary *reuseableViews;
@property (nonatomic, strong) NSMutableDictionary *visibleViews;
@property (nonatomic, strong) NSMutableArray *viewKeysToRemove;
@property (nonatomic, strong) NSMutableDictionary *indexToRectMap;




/**
 Forces a relayout of the collection grid
 */
- (void)relayoutViews;

/**
 Stores a view for later reuse
 TODO: add an identifier like UITableView
 */
- (void)enqueueReusableView:(VSCollectionViewCell *)view;

/**
 Magic!
 */
- (void)removeAndAddCellsIfNecessary;

@end

@implementation VSCollectionView
NSInteger currentScrollIndex;
NSInteger scrollingdir;
NSInteger vstrackmode=0;
NSInteger vsmovingnow=1;

id <UIScrollViewDelegate> ownDelegate;
BOOL vsisStartingDecelerating = TRUE;
#pragma mark - Init/Memory


- (void)setDelegate:(id <UIScrollViewDelegate>)newDel
{
    ownDelegate = newDel;
    [super setDelegate:self];
}




- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        
        self.lastOffset = 0.0;
       self.offsetThreshold = floorf(self.height / 4.0);
       
        
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
         {
                  self.colWidth = 150.0;
         }
        else
        {
            self.colWidth = 350.0;
        }
   
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            vskMargin=20.0;
            
        }
        
        
        self.numCols = 0;
        self.numColsPortrait = 0;
        self.numColsLandscape = 0;
        self.autoresizesSubviews = NO;
        
        self.orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        self.reuseableViews = [NSMutableDictionary dictionary];
        self.visibleViews = [NSMutableDictionary dictionary];
        self.viewKeysToRemove = [NSMutableArray array];
        self.indexToRectMap = [NSMutableDictionary dictionary];
      
        
    }
    return self;
}



- (void)dealloc {
    // clear delegates
   self.delegate = nil;
   self.collectionViewDataSource = nil;
   self.collectionViewDelegate = nil;
}

#pragma mark - DataSource

- (void)reloadData:(VSCollectionView *) senderview {
    NSLog(@"doing the relayout");
    
    
    //remove all views.
    for (UIView * view in self.subviews)
    {
        NSLog(@"this subview: %@", [view.class description]);
        
        [view removeFromSuperview];
    }
    
    [senderview layoutSubviews];
    [senderview relayoutViews];
   
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // [ownDelegate scrollViewDidEndDecelerating:self];
    //isStartingDecelerating = FALSE;
    NSLog(@"celery time!");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //[ownDelegate scrollViewWillBeginDecelerating:self];
   // isStartingDecelerating = TRUE;
    NSLog(@"begindeceler");
}

#pragma mark - View

- (void)layoutSubviews {
    [super layoutSubviews];
    
    

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (self.orientation != orientation) {
        self.orientation = orientation;
        // Recalculates layout
        [self relayoutViews];
    } else if(self.lastWidth != self.width) {
        // Recalculates layout
        [self relayoutViews];
    } else {
        // Recycles cells
        
        CGFloat diff = fabsf(self.lastOffset - self.contentOffset.y);
        CGFloat prevoffset = self.lastOffset;
        
        if (diff > self.offsetThreshold && vsisStartingDecelerating) {
            self.lastOffset = self.contentOffset.y;
            
            //set scroll direction only if it's scrolling
            if (prevoffset-self.contentOffset.y <0)
            {
                scrollingdir=1;
                
            }
            else
            {
                scrollingdir=2;
            }
           
            [self removeAndAddCellsIfNecessary];
        }
    }
    
    self.lastWidth = self.width;
}

- (void)relayoutViews {
    
    NSLog(@"doing a relayout views");
    
    self.numCols = UIInterfaceOrientationIsPortrait(self.orientation) ? self.numColsPortrait : self.numColsLandscape;
    

    
    //brian note--seems like this might be flawed logic, enumerating keys and directly after removing all objects..
    // Reset all state
   [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       VSCollectionViewCell *view = (VSCollectionViewCell *)obj;
      [self enqueueReusableView:view];
    }];
    
    //trying the same for loop up here
    
    
    
    //for (id key in self.visibleViews)
    //{
      //  PSCollectionViewCell *cellview;
       // [cellview setValue:@"blah" forKey:@"obj"];
       // [self enqueueReusableView:cellview];
    //}
    
    
    [self.visibleViews removeAllObjects];
    [self.viewKeysToRemove removeAllObjects];
    [self.indexToRectMap removeAllObjects];
   
   // self.lastOffset = 0.0;
    self.offsetThreshold = floorf(self.height / 4.0);
    
    // This is where we should layout the entire grid first
    NSInteger numViews = [self.collectionViewDataSource numberOfRowsInCollectionView:self];
    
    NSLog(@"this is the num views%i",numViews);
    
    
    CGFloat totalHeight = 0.0;
    CGFloat top = vskMargin/2;
    
    // Add headerView if it exists
    if (self.headerView) {
        top = self.headerView.top;
        self.headerView.width = self.width;
        [self addSubview:self.headerView];
        top += self.headerView.height;
    }
    
    if (numViews > 0) {
        // This array determines the last height offset on a column
        NSMutableArray *colOffsets = [NSMutableArray arrayWithCapacity:self.numCols];
        for (int i = 0; i < self.numCols; i++) {
            [colOffsets addObject:[NSNumber numberWithFloat:top]];
           
        }
        
        // Calculate index to rect mapping
        
       // self.colWidth = floorf((self.width - kMargin * (self.numCols + 1)) / self.numCols);
        
        
       
        
      
        
         //NSLog(@"self width: %ld", (long)self.width);
        
        
        for (NSInteger i = 0; i < numViews; i++) {
            NSString *key = VSCollectionKeyForIndex(i);
            
            // Find the shortest column
            NSInteger col = 0;
            CGFloat minHeight = [[colOffsets objectAtIndex:col] floatValue];
            for (int i = 1; i < [colOffsets count]; i++) {
                CGFloat colHeight = [[colOffsets objectAtIndex:i] floatValue];
                
                if (colHeight < minHeight) {
                    col = i;
                    minHeight = colHeight;
                }
            }
            
           CGFloat left = vskMargin + (col * vskMargin) + (col * self.colWidth);
            //CGFloat left = kMargin + 0 + (col * self.colWidth);
            
            CGFloat top = [[colOffsets objectAtIndex:col] floatValue];
            
            //NSLog(@"calculated top:%f",top);
            
            //calculate height based on retrieved image height factored to max height
            
            
            
            CGFloat colHeight = [self.collectionViewDataSource collectionView:self heightForRowAtIndex:i];
            
            NSLog(@"row index for delegate:%i",i);
            
            CGRect viewRect = CGRectMake(left, top, self.colWidth, colHeight);
            
          //  NSLog(@"top value :%f",top);
             //NSLog(@"height value :%f",colHeight);
            
            // Add to index rect map
            [self.indexToRectMap setObject:NSStringFromCGRect(viewRect) forKey:key];
            
            // Update the last height offset for this column
            CGFloat heightOffset = colHeight > 0 ? top + colHeight + (vskMargin/2) : top;
            
            [colOffsets replaceObjectAtIndex:col withObject:[NSNumber numberWithFloat:heightOffset]];
            
             //NSLog(@"height  offset value :%f",heightOffset);
            
        }
        
        for (NSNumber *colHeight in colOffsets) {
            totalHeight = (totalHeight < [colHeight floatValue]) ? [colHeight floatValue] : totalHeight;
            
           
        }
         //NSLog(@"calculated total height :%f",totalHeight);
    } else {
        totalHeight = self.height;
    }
    
    //NSLog(@"decided on total height :%f",totalHeight);
    
    // Add footerView if exists
    if (self.footerView) {
        self.footerView.top = totalHeight;
        self.footerView.width = self.width;
        [self addSubview:self.footerView];
        totalHeight += self.footerView.height;
    }
    
    self.contentSize = CGSizeMake(self.width, totalHeight);
    //self.contentSize = CGSizeMake(self.width, 8000);
    
    
    [self removeAndAddCellsIfNecessary];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVSCollectionViewDidRelayoutNotification object:self];
}

- (void)removeAndAddCellsIfNecessary {
    static NSInteger bufferViewFactor = 8;
    static NSInteger topIndex = 0;
    static NSInteger bottomIndex = 0;
    
    //@brian note, does this really need to be set every single time?
    NSInteger numViews = [self.collectionViewDataSource numberOfRowsInCollectionView:self];
    
  

    
    if (numViews == 0) return;
    
    //    NSLog(@"diff: %f, lastOffset: %f", diff, self.lastOffset);
    
    // Find out what rows are visible
    CGRect visibleRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.width, self.height);
    
    
    
    //NSLog(@"visiblerect left: %f", visibleRect.origin.x);
    //NSLog(@"visiblerect top: %f", visibleRect.origin.y);
    //NSLog(@"visiblerect width: %f", visibleRect.size.width);
    //NSLog(@"visiblerect height: %f", visibleRect.size.height);
    
    
    
    visibleRect = CGRectInset(visibleRect, 0, -1.0 * self.offsetThreshold);
    
    // Remove all rows that are not inside the visible rect
    
    //this is potentially an area where the app is crashing...writing my own for loop
    //instead of block method
    
   // int j=0;
    //int xit=0;
    
    //for (id key in self.visibleViews)
    //{
      //  PSCollectionViewCell *cellview = [self.visibleViews objectForKey:@"obj"];
        //CGRect viewRect = cellview.frame;
        
        //if(!CGRectIntersectsRect(visibleRect,viewRect))
        //{
           // [self enqueueReusableView:cellview];
        //     [self.viewKeysToRemove addObject:key];
       // }
        
   // }
   
    
    
   [self.visibleViews enumerateKeysAndObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(id key, id obj, BOOL *stop)
    {
       VSCollectionViewCell *view = (VSCollectionViewCell *)obj;
         CGRect viewRect = view.frame;
         
       if (!CGRectIntersectsRect(visibleRect, viewRect)) {
           
           //try limiting what gets placed on remove queue until it's loaded
           
           [self enqueueReusableView:view];
            [self.viewKeysToRemove addObject:key];
           
         }
     }];
    
    // NSLog(@"total numviews :%i",self.visibleViews.count);
       //NSLog(@"total keystoremove :%i",self.viewKeysToRemove.count);
   
    //@Brian note.  this is where you need code to add back a view to visible views and remove it from visible views so the memory usage doesn't explode.
    for (NSObject *viewobj in self.viewKeysToRemove)
    {
        
        
        if([self.visibleViews objectForKey:viewobj])
        {
           
            [self.visibleViews removeObjectForKey:viewobj];
            
            }
    }
    
    //[self.visibleViews removeObjectsForKeys:self.viewKeysToRemove];
    [self.viewKeysToRemove removeAllObjects];
    
    
    
    if ([self.visibleViews count] == 0) {
        topIndex = 0;
        bottomIndex = numViews;
    } else {
        NSArray *sortedKeys = [[self.visibleViews allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
               
                //return (NSComparisonResult)NSOrderedSame;
                return (NSComparisonResult)NSOrderedAscending;
                
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
               //return (NSComparisonResult)NSOrderedSame;
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
        
        //will try to change this to just ordered same
        
        topIndex = [[sortedKeys objectAtIndex:0] integerValue];
        bottomIndex = [[sortedKeys lastObject] integerValue];
        
        topIndex = MAX(0, topIndex - (bufferViewFactor * self.numCols));
        bottomIndex = MIN(numViews, bottomIndex + (bufferViewFactor * self.numCols));
    }
        NSLog(@"topIndex: %d, bottomIndex: %d", topIndex, bottomIndex);
    
    // Add views
    for (NSInteger i = topIndex; i < bottomIndex; i++) {
        NSString *key = VSCollectionKeyForIndex(i);
        CGRect rect = CGRectFromString([self.indexToRectMap objectForKey:key]);
        
        if(vstrackmode==1)
        {
          //  NSLog(@"new cell index: %i", i);
           // NSLog(@"new cell left: %f", rect.origin.x);
           // NSLog(@"new cell top: %f", rect.origin.y);
           // NSLog(@"new cell width: %f", rect.size.width);
           // NSLog(@"new cell height: %f", rect.size.height);
        }
     
        //NSArray *allkeys = [self.indexToRectMap allKeys];
       // NSLog(@"%i",allkeys.count);
        // If view is within visible rect and is not already shown
        if (![self.visibleViews objectForKey:key] && CGRectIntersectsRect(visibleRect, rect)) {
            // Only add views if not visible
           VSCollectionViewCell *newCell;
          
           newCell = [self.collectionViewDataSource collectionView:self cellForRowAtIndex:i withRect:CGRectFromString([self.indexToRectMap objectForKey:key])];
            
            
           newCell.frame = CGRectFromString([self.indexToRectMap objectForKey:key]);
      
           // NSLog(@"new cell index: %i", i);
            
            // NSLog(@"new cell left: %f", newCell.frame.origin.x);
            // NSLog(@"new cell top: %f", newCell.frame.origin.y);
            // NSLog(@"new cell width: %f", newCell.frame.size.width);
            // NSLog(@"new cell height: %f", newCell.frame.size.height);
            
            [self addSubview:newCell];
            
            if(scrollingdir==1)
            {
                currentScrollIndex = currentScrollIndex +1;
                NSLog(@"%i",currentScrollIndex);
            }
            else
            if(scrollingdir==2)
            {
                currentScrollIndex = currentScrollIndex -1;
                NSLog(@"%i",currentScrollIndex);
                
            }
           // NSLog(@"%i",self.reuseableViews.count);
            
            
            //if the scroll hits a multiple of 125, check the length and query for more just if more length is actually needed.
           if(currentScrollIndex>1)
           {
            if ((currentScrollIndex % 100) == 0) {
                // A is divisible by B
                [self.collectionViewDataSource queryForMore:currentScrollIndex WithDirection:scrollingdir];
                vstrackmode=1;
                
                [self killScroll];
            } else {
                // A isn't divisible by B
            }
           }
            
            
            // Setup gesture recognizer
            if ([newCell.gestureRecognizers count] == 0) {
                VSCollectionViewTapGestureRecognizer *gr = [[VSCollectionViewTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectView:)];
                gr.delegate = self;
                [newCell addGestureRecognizer:gr];
                newCell.userInteractionEnabled = YES;
            }
            
            [self.visibleViews setObject:newCell forKey:key];
            
        }
        
    }
}

- (void)killScroll
{
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}

-(void) allowscrolling:(id)sender {
    NSLog(@"allowed scrolling");
    
    self.scrollEnabled = true;
    
}
#pragma mark - Reusing Views

- (VSCollectionViewCell *)dequeueReusableViewForClass:(Class)viewClass {
    NSString *identifier = NSStringFromClass(viewClass);
    
    VSCollectionViewCell *view = nil;
    if ([self.reuseableViews objectForKey:identifier]) {
        view = [[self.reuseableViews objectForKey:identifier] anyObject];
        
        if (view) {
            // Found a reusable view, remove it from the set
            [[self.reuseableViews objectForKey:identifier] removeObject:view];
            
            NSLog(@"successfuldequeue");
            
        }
    }
    
    return view;
}


//check this enqueue reusable view code for a bad thread error potentially
//error here on en enqueuing reusable views.




- (void)enqueueReusableView:(VSCollectionViewCell *)view {
    
   //  NSLog(@"doing an enqueue");
    if ([view respondsToSelector:@selector(prepareForReuse)]) {
        [view performSelector:@selector(prepareForReuse)];
    }
    view.frame = CGRectZero;
    
    
    
    NSString *identifier = NSStringFromClass([view class]);
    if (![self.reuseableViews objectForKey:identifier]) {
        [self.reuseableViews setObject:[NSMutableSet set] forKey:identifier];
    }
    
    
    
    [[self.reuseableViews objectForKey:identifier] addObject:view];
    
    //removefromsuperview might be causing the thread error
    
    //after doing this, I got an error because it was being mutated while being enumerated.  YAY THREAD COLLISIONS!!!
    //[self.visibleViews removeObjectForKey:(view)];
    
    //may want to wrap this with a if view exists statement
    //@Brianchange--moved this to a diff area
     // [view removeFromSuperview];
    for (UIView *mysview in view.subviews)
    {
        mysview.frame = CGRectZero;
        
    }
}

#pragma mark - Gesture Recognizer

- (void)didSelectView:(UITapGestureRecognizer *)gestureRecognizer {
    NSString *rectString = NSStringFromCGRect(gestureRecognizer.view.frame);
    NSArray *matchingKeys = [self.indexToRectMap allKeysForObject:rectString];
    NSString *key = [matchingKeys lastObject];
    if ([gestureRecognizer.view isMemberOfClass:[[self.visibleViews objectForKey:key] class]]) {
        if (self.collectionViewDelegate && [self.collectionViewDelegate respondsToSelector:@selector(collectionView:didSelectCell:atIndex:)]) {
            NSInteger matchingIndex = VSCollectionIndexForKey([matchingKeys lastObject]);
            [self.collectionViewDelegate collectionView:self didSelectCell:(VSCollectionViewCell *)gestureRecognizer.view atIndex:matchingIndex];
            scrollingdir=0;
            
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![gestureRecognizer isMemberOfClass:[VSCollectionViewTapGestureRecognizer class]]) return YES;
    
    NSString *rectString = NSStringFromCGRect(gestureRecognizer.view.frame);
    NSArray *matchingKeys = [self.indexToRectMap allKeysForObject:rectString];
    NSString *key = [matchingKeys lastObject];
    
    if ([touch.view isMemberOfClass:[[self.visibleViews objectForKey:key] class]]) {
        return YES;
    } else {
        return NO;
    }
}



@end
