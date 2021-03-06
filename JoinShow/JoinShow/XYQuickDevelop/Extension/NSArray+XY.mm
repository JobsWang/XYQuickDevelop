//
//  NSArray+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-14.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
//  Copy from bee Framework http://www.bee-framework.com

#import "NSArray+XY.h"
#import "XYPrecompile.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DUMMY_CLASS(NSArray_XY);

@implementation NSArray(XY)

@dynamic APPEND;
@dynamic mutableArray;

- (NSArrayAppendBlock)APPEND
{
	NSArrayAppendBlock block = ^ NSMutableArray * ( id obj )
	{
		NSMutableArray * array = [NSMutableArray arrayWithArray:self];
		[array addObject:obj];
		return array;
	};
	
	return [block copy];
}

- (NSArray *)head:(NSUInteger)count
{
	if ( [self count] < count )
	{
		return self;
	}
	else
	{
		NSMutableArray * tempFeeds = [NSMutableArray array];
		for ( NSObject * elem in self )
		{
			[tempFeeds addObject:elem];
			if ( [tempFeeds count] >= count )
				break;
		}
		return tempFeeds;
	}
}

- (NSArray *)tail:(NSUInteger)count
{	
//	if ( [self count] < count )
//	{
//		return self;
//	}
//	else
//	{
//        NSMutableArray * tempFeeds = [NSMutableArray array];
//		
//        for ( NSUInteger i = 0; i < count; i++ )
//		{
//            [tempFeeds insertObject:[self objectAtIndex:[self count] - i] atIndex:0];
//        }
//
//		return tempFeeds;
//	}

// thansk @lancy, changed: NSArray tail: count

	NSRange range = NSMakeRange( self.count - count, count );
	return [self subarrayWithRange:range];
}

- (id)safeObjectAtIndex:(NSInteger)index
{
	if ( index < 0 )
		return nil;
	
	if ( index >= self.count )
		return nil;

	return [self objectAtIndex:index];
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
	if ( 0 == self.count )
		return nil;

	if ( range.location >= self.count )
		return nil;

	if ( range.location + range.length >= self.count )
		return nil;
	
	return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSMutableArray *)mutableArray
{
	return [NSMutableArray arrayWithArray:self];
}

@end

#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

#pragma mark -

@implementation NSMutableArray(XY)

@dynamic APPEND;

- (NSMutableArrayAppendBlock)APPEND
{
	NSMutableArrayAppendBlock block = ^ NSMutableArray * ( id obj )
	{
		[self addObject:obj];
		return self;
	};
	
	return [block copy];
}
/*
+ (NSMutableArray *)nonRetainingArray	// copy from Three20
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = __TTRetainNoOp;
	callbacks.release = __TTReleaseNoOp;
    
    CFMutableArrayRef cfArray = CFArrayCreateMutable( nil, 0, &callbacks );
    NSMutableArray *array = CFBridgingRelease(cfArray);
    CFRelease(cfArray);
    
	return array;
}
*/
- (NSMutableArray *)pushHead:(NSObject *)obj
{
	if ( obj )
	{
		[self insertObject:obj atIndex:0];
	}
	
	return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
	if ( [all count] )
	{	
		for ( NSUInteger i = [all count]; i > 0; --i )
		{
			[self insertObject:[all objectAtIndex:i - 1] atIndex:0];
		}
	}
	
	return self;
}

- (NSMutableArray *)popTail
{
	if ( [self count] > 0 )
	{
		[self removeObjectAtIndex:[self count] - 1];
	}
	
	return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = n;
			range.length = [self count] - n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
	if ( obj )
	{
		[self addObject:obj];		
	}
	
	return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
	if ( [all count] )
	{
		[self addObjectsFromArray:all];		
	}
	
	return self;
}

- (NSMutableArray *)popHead
{
	if ( [self count] )
	{
		[self removeLastObject];
	}
	
	return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = 0;
			range.length = n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = n;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = 0;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (void)insertObjectNoRetain:(id)object atIndex:(NSUInteger)index
{
	[self insertObject:object atIndex:index];
}

- (void)addObjectNoRetain:(NSObject *)object
{
	[self addObject:object];
	//[object release];
}

- (void)removeObjectNoRelease:(NSObject *)object
{
	//[object retain];
	[self removeObject:object];
}

- (void)removeAllObjectsNoRelease
{
	for ( NSObject * object in self )
	{
		//[object retain];
	}	
	
	[self removeAllObjects];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSArray_XY )
{
	TIMES( 3 )
	{
		NSArray * arr = [NSArray array];
		EXPECTED( arr );
		EXPECTED( 0 == arr.count );
		
		NSString * temp = [arr safeObjectAtIndex:100];
		EXPECTED( nil == temp );
		
		arr = arr.APPEND( @"1" );
		EXPECTED( 1 == arr.count );
		
		arr = arr.APPEND( @"2" ).APPEND( @"3" );
		EXPECTED( 3 == arr.count );
		
		NSArray * head2 = [arr head:2];
		EXPECTED( head2 );
		EXPECTED( 2 == head2.count );
		EXPECTED( [[head2 objectAtIndex:0] isEqualToString:@"1"] );
		EXPECTED( [[head2 objectAtIndex:1] isEqualToString:@"2"] );
		
		NSArray * tail2 = [arr tail:2];
		EXPECTED( tail2 );
		EXPECTED( 2 == tail2.count );
		EXPECTED( [[tail2 objectAtIndex:0] isEqualToString:@"2"] );
		EXPECTED( [[tail2 objectAtIndex:1] isEqualToString:@"3"] );
	}
}
TEST_CASE_END

TEST_CASE( NSMutableArray_XY )
{
	//	+ (NSMutableArray *)nonRetainingArray;	// copy from Three20
	//
	//	- (NSMutableArray *)pushHead:(NSObject *)obj;
	//	- (NSMutableArray *)pushHeadN:(NSArray *)all;
	//	- (NSMutableArray *)popTail;
	//	- (NSMutableArray *)popTailN:(NSUInteger)n;
	//
	//	- (NSMutableArray *)pushTail:(NSObject *)obj;
	//	- (NSMutableArray *)pushTailN:(NSArray *)all;
	//	- (NSMutableArray *)popHead;
	//	- (NSMutableArray *)popHeadN:(NSUInteger)n;
	//
	//	- (NSMutableArray *)keepHead:(NSUInteger)n;
	//	- (NSMutableArray *)keepTail:(NSUInteger)n;
	//
	//	- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
	//	- (void)addObjectNoRetain:(NSObject *)obj;
	//	- (void)removeObjectNoRelease:(NSObject *)obj;
	//	- (void)removeAllObjectsNoRelease;
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
