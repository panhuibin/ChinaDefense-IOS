///
//  HTMLParsingManager.m
//  HTMLParsing
//
//  Created by Sarah Pan on 2016-04-29.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "HTMLParsingManager.h"
#import "TFHpple.h"
#import "SingleCategory.h"
#import "SingleForumEntity.h"
#import "SingleReplyEntity.h"
#import "TopicEntity.h"
#import "ImageManager.h"
#import "AttributedTextUtility.h"
#import "ImageStore.h"

@implementation HTMLParsingManager{
    NSMutableArray *_array;
    NSString *_baseUrl;
}

+(id)sharedInstance
{
    static HTMLParsingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        _array = [[NSMutableArray alloc] init];
        _baseUrl = @"https://www.sinodefenceforum.com/";
    }
    return self;
}

-(NSArray *) parseFrontPageCategories
{
    NSURL *categoryUrl = [NSURL URLWithString:_baseUrl];
    NSData *cateogoryHtmlData = [NSData dataWithContentsOfURL:categoryUrl];
    //NSData *cateogoryHtmlData = [NSData dataWithContentsOfFile: @"category.htm"];
    NSLog(@"downloading front page");
    TFHpple *parser = [TFHpple hppleWithHTMLData:cateogoryHtmlData];
    NSString *queryStringCategory = @"//div[@class='categoryText']";
    NSArray *categoryNodes = [parser searchWithXPathQuery:queryStringCategory];
    NSString *queryStringForums = @"//ol[@class='nodeList']";
    NSArray *forumNodes = [parser searchWithXPathQuery:queryStringForums];
    NSMutableArray *newCategories = [[NSMutableArray alloc] initWithCapacity:0];
    int categoryCount = [categoryNodes count];
    
    //skip the first category and the last category
    for (int i=1;i<categoryCount-1;i++) {
        TFHppleElement *categoryNode = [categoryNodes objectAtIndex:i];
        TFHppleElement *forumListNode = [forumNodes objectAtIndex:i];
        SingleCategory *singleCategory = [[SingleCategory alloc] init];
        TFHppleElement *categoryElement = [[categoryNode searchWithXPathQuery:@"//h3/a"] firstObject];
        singleCategory.title = [categoryElement content];
        

        
        NSArray *forumElements = [forumListNode searchWithXPathQuery:@"//li/div/div[@class='nodeText']/h3/a"];
        singleCategory.forums =[[NSMutableArray alloc] initWithCapacity:0];
        for(TFHppleElement *forumNode in forumElements){
            SingleForumEntity *singleForum = [[SingleForumEntity alloc] init];
            singleForum.title = forumNode.content;
            singleForum.url = [forumNode objectForKey:@"href"];
            [singleCategory.forums addObject:singleForum];
        }
        
        [newCategories addObject:singleCategory];
    }
    
    NSArray *_categories = newCategories;
    return _categories;
}



-(NSArray *) parseTopicPage: (NSString*) topicURLString forPage:(int)pageIndex
{
    topicURLString = [topicURLString stringByReplacingOccurrencesOfString:@"/unread" withString:@"/"];
    NSString *combinedURLString = [NSString stringWithFormat:@"%@%@page-%d", _baseUrl, topicURLString,pageIndex];
    NSURL *topicUrl = [NSURL URLWithString:combinedURLString];
    NSData *topicHtmlData = [NSData dataWithContentsOfURL:topicUrl];
    NSLog(@"downloading topic page");
    TFHpple *parser = [TFHpple hppleWithHTMLData:topicHtmlData];
    NSString *queryStringForReplies = @"//ol[@class='messageList']/li";
    NSArray *replyNodes = [parser searchWithXPathQuery:queryStringForReplies];
    
    NSMutableArray *newReplies = [[NSMutableArray alloc] initWithCapacity:0];

    for (TFHppleElement *node in replyNodes) {
        SingleReplyEntity *singleReply = [[SingleReplyEntity alloc] init];
        singleReply.replyId = [node objectForKey:@"id"];
        TFHppleElement *authorElement = [[node searchWithXPathQuery:@"//div[@class='uix_message ']/div[@class='messageUserInfo']/div/h3/div/a"] firstObject];
        
        singleReply.author = [authorElement content];
        
        NSArray *contentElements = [node searchWithXPathQuery:@"//div[@class='uix_message ']/div[@class='messageInfo primaryContent']/div[@class='messageContent']/article/blockquote" ] ;
        TFHppleElement *contentElement = contentElements[0];
        //NSString *htmlString = contentElement.raw ;
        singleReply.imageTextBlocks =[[[AttributedTextUtility sharedInstance] htmlIntoImageTextBlocks:contentElement] copy];
        [newReplies addObject:singleReply];
    }
    
    NSArray *_replies = newReplies;
    return _replies;
}

-(NSArray *) parseForumPage:(NSString*) forumURLString forPage:(int)pageIndex
{
    NSMutableArray *newTopics = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *combinedURLString = [NSString stringWithFormat:@"%@%@page-%d", _baseUrl, forumURLString,pageIndex];
    NSURL *forumUrl = [NSURL URLWithString:combinedURLString];
    NSData *forumHtmlData = [NSData dataWithContentsOfURL:forumUrl];
    NSLog(@"downloading forum page");
    TFHpple *parser = [TFHpple hppleWithHTMLData:forumHtmlData];
    
    //get sticky entries if first page
    if(pageIndex==1){
        NSString *queryStringForStickyNodes =@"//div[@class='uix_stickyThreads']/li";
        NSArray *StickyNodes = [parser searchWithXPathQuery:queryStringForStickyNodes];
        
        for(TFHppleElement *stickyNode in StickyNodes){
            TopicEntity *singleTopic = [[TopicEntity alloc] init];
            singleTopic.author = [stickyNode objectForKey:@"data-author"];
            TFHppleElement *titleElement = [[stickyNode searchWithXPathQuery:@"//h3[@class='title']/a"] firstObject];
            singleTopic.title = [titleElement content];
            singleTopic.url = [titleElement objectForKey:@"href"];
            TFHppleElement *replyElement = [[stickyNode searchWithXPathQuery:@"//div[@class='listBlock stats pairsJustified']/dl/dd"] firstObject];
            singleTopic.replies = [replyElement content];
            singleTopic.isSticky = YES;
            [newTopics addObject:singleTopic];

        }
    }
    
    NSString *queryStringForNormalNodes =@"//li[@class='discussionListItem visible  ']";
    NSArray *nodes = [parser searchWithXPathQuery:queryStringForNormalNodes];
    
    for(TFHppleElement *node in nodes){
        TopicEntity *singleTopic = [[TopicEntity alloc] init];
        singleTopic.author = [node objectForKey:@"data-author"];
        TFHppleElement *titleElement = [[node searchWithXPathQuery:@"//h3[@class='title']/a"] firstObject];
        singleTopic.title = [titleElement content];
        singleTopic.url = [titleElement objectForKey:@"href"];
        TFHppleElement *replyElement = [[node searchWithXPathQuery:@"//div[@class='listBlock stats pairsJustified']/dl/dd"] firstObject];
        singleTopic.replies = [replyElement content];
        singleTopic.isSticky = NO;
        [newTopics addObject:singleTopic];
        
    }
    
    
    
    /*
    NSString *queryStringForTitle = @"//div[@class='listBlock main']/div[@class='titleText']/h3[@class='title']/a";
    NSArray *titleNodes = [parser searchWithXPathQuery:queryStringForTitle];
    NSString *queryStringForAuthor = @"//div[@class='listBlock main']/div[@class='titleText']/div[@class='secondRow']/div[@class='posterDate muted']/a";
    NSArray *authorNodes = [parser searchWithXPathQuery:queryStringForAuthor];
    NSString *queryStringForReplies = @"//div[@class='listBlock stats pairsJustified']/dl/dd";
    NSArray *replyNodes = [parser searchWithXPathQuery:queryStringForReplies];

    int titleCount = [titleNodes count];
    int authorCount = [authorNodes count];
    for (int i=0; i<MIN(titleCount, authorCount); i++) {
        TFHppleElement *titleElement = [titleNodes objectAtIndex:i];
        TopicEntity *singleTopic = [[TopicEntity alloc] init];
        //NSLog(@"%@", titleElement.attributes);
        singleTopic.title = [titleElement content];
        singleTopic.url = [titleElement objectForKey:@"href"];
        TFHppleElement *authorElement = [authorNodes objectAtIndex:i];
        //NSLog(@"%@", authorElement.attributes);
        singleTopic.author = [authorElement content];
        [newTopics addObject:singleTopic];
        TFHppleElement *replyElement = [replyNodes objectAtIndex:i];
        //NSLog(@"%@", replyElement.attributes);
        singleTopic.replies = [replyElement content];
    }
    */

    NSArray *_topics = newTopics;
    return _topics;
}

-(NSArray *) parseTopicPage2: (NSString*) topicURLString
{
    NSString *combinedURLString = [NSString stringWithFormat:@"%@%@", _baseUrl, topicURLString];
    NSURL *topicUrl = [NSURL URLWithString:combinedURLString];
    NSData *topicHtmlData = [NSData dataWithContentsOfURL:topicUrl];
    NSLog(@"downloading topic page");
    TFHpple *parser = [TFHpple hppleWithHTMLData:topicHtmlData];
    NSString *queryStringForReplies = @"//ol[@class='messageList']/li/div[@class='uix_message ']";
    NSArray *replyNodes = [parser searchWithXPathQuery:queryStringForReplies];
    
    NSMutableArray *newReplies = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *node in replyNodes) {
        
        SingleReplyEntity *singleReply = [[SingleReplyEntity alloc] init];
        TFHppleElement *authorElement = [[node searchWithXPathQuery:@"//div[@class='messageUserInfo']/div/h3/div/a"] firstObject];
        
        singleReply.author = [authorElement content];
        
        NSArray *contentElements = [node searchWithXPathQuery:@"//div[@class='messageInfo primaryContent']/div[@class='messageContent']/article/blockquote" ] ;
        TFHppleElement *contentElement = contentElements[0];
        NSString *htmlString = contentElement.raw ;
        singleReply.imageTextBlocks =[[AttributedTextUtility sharedInstance] htmlIntoImageTextBlocks:contentElement];
        [newReplies addObject:singleReply];
    }
    
    NSArray *_replies = newReplies;
    return _replies;
}




@end
