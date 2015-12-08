//
//  NDQAOnlineVC+Grid.m
//  newdoc
//
//  Created by zzc on 15/11/12.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDQAOnlineVC+Grid.h"
#import "ActionSheet.h"

#define MAX_IMAGE_COUNT 6

static ActionSheet *_sheet;

@implementation NDQAOnlineVC(Grid)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NDPhotoGridCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NDPhotoGridCell"
                                                                                 forIndexPath:indexPath];
    
    if(indexPath.item < self.imgs.count){
        
        UIImage *tempImg = [self.imgs[indexPath.item] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [cell.photoBtn setImage:tempImg forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.item < self.imgs.count - 1 && self.imgs.count > 1)
    {
        ActionSheet * sheet = [[ActionSheet alloc] initWithTitle:@"移除此图片？"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"移除"
                                               otherButtonTitles:nil];
        sheet.callback = ^(ActionSheet * sheet,int buttonIndex)
        {
            if(buttonIndex != sheet.cancelButtonIndex)
            {
                [self.imgs removeObjectAtIndex:indexPath.item];
                [self.collectionView reloadData];
            }
        };
        _sheet = sheet;
        [sheet showInView:self.view];
    }
    else
    {
        [self.photoActionSheet showAnimation];
    }
}

- (void)actionSheetDidFinished:(NSArray *)obj{
    
    WEAK_SELF;
    
    if((obj.count + self.imgs.count) >= MAX_IMAGE_COUNT || self.imgs.count > 1){
        id lastObj = self.imgs.lastObject;
        [self.imgs removeLastObject];
        [self.imgs addObjectsFromArray:obj];
        if(self.imgs.count + 2 > MAX_IMAGE_COUNT){
            [self.imgs removeObjectsInRange:NSMakeRange(0, self.imgs.count + 1 - MAX_IMAGE_COUNT)];
        }
        [self.imgs addObject:lastObj];
    }else{
        [self.imgs addObjectsFromArray:obj];
        [self.imgs exchangeObjectAtIndex:0 withObjectAtIndex:self.imgs.count - 1];
    }
    
    [self.collectionView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _sheet.callback(_sheet, (int)buttonIndex);
}

@end
