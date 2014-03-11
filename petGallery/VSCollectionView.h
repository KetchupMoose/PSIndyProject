//
// PSCollectionView.h
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

#import <UIKit/UIKit.h>
#import "VSCollectionViewCell.h"


#define kVSCollectionViewDidRelayoutNotification @"kVSCollectionViewDidRelayoutNotification"

@class VSCollectionViewCell;

@protocol VSCollectionViewDelegate, VSCollectionViewDataSource;

@interface VSCollectionView : UIScrollView <UIScrollViewDelegate>

#pragma mark - Public Properties

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign, readonly) CGFloat colWidth;
@property (nonatomic, assign, readonly) NSInteger numCols;
@property (nonatomic, assign) NSInteger numColsLandscape;
@property (nonatomic, assign) NSInteger numColsPortrait;
//changing these from unsafe_unretained to nonatomic,strong
@property (nonatomic, strong) id <VSCollectionViewDelegate> collectionViewDelegate;
@property (nonatomic, strong) id <VSCollectionViewDataSource> collectionViewDataSource;

#pragma mark - Public Methods

/**
 Reloads the collection view
 This is similar to UITableView reloadData)
 */
- (void)reloadData:(VSCollectionView *) senderview;

/**
 Dequeues a reusable view that was previously initialized
 This is similar to UITableView dequeueReusableCellWithIdentifier
 */
- (VSCollectionViewCell *)dequeueReusableViewForClass:(Class)viewClass;

@end

#pragma mark - Delegate

@protocol VSCollectionViewDelegate <NSObject>

@optional
- (void)collectionView:(VSCollectionView *)collectionView didSelectCell:(VSCollectionViewCell *)cell atIndex:(NSInteger)index;
- (Class)collectionView:(VSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index;

@end

#pragma mark - DataSource

@protocol VSCollectionViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInCollectionView:(VSCollectionView *)collectionView;
- (VSCollectionViewCell *)collectionView:(VSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index withRect:(CGRect) expectedRect;
- (CGFloat)collectionView:(VSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index;
@optional
- (void) queryForMore:(NSInteger)index WithDirection:(NSInteger) direction;


@end
