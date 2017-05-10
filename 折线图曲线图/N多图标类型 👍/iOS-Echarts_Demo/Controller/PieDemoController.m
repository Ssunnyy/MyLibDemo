//
//  PieDemoController.m
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/10/3.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "PieDemoController.h"
#import "PYEchartsView.h"
#import "PYPieSeries.h"

typedef enum {
    PieDemoTypeBtnTagBasicPie = 30000,
    PieDemoTypeBtnTagDoughnut = 30001,
    PieDemoTypeBtnTagNestedPie = 30002,
    PieDemoTypeBtnTagNightingalesRoseDiagram = 30003,
    PieDemoTypeBtnTagDoughnut2 = 30004,
    PieDemoTypeBtnTagDoughnut3 = 30005,
    PieDemoTypeBtnTagTimeline = 30006,
    PieDemoTypeBtnTagLasagna = 30007,
    PieDemoTypeBtnTagPie = 30008
} PieDemoTypeBtnTag;

@interface PieDemoController ()

@property (weak, nonatomic) IBOutlet PYEchartsView *kEchartView;

@end

@implementation PieDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

#pragma mark - custom function
/**
 *  初始化
 */
-(void)initAll {
    self.title = @"饼图";
    [self showBasicPieDemo];
    [_kEchartView loadEcharts];
}

/**
 *  按钮的点击事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)kDemosClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case PieDemoTypeBtnTagBasicPie:
            [self showBasicPieDemo];
            break;
        case PieDemoTypeBtnTagDoughnut:
            [self showDoughnutDemo];
            break;
        case PieDemoTypeBtnTagNestedPie:
            [self showNestedPie];
            break;
        case PieDemoTypeBtnTagNightingalesRoseDiagram:
            [self showNightingalesRoseDiagramDemo];
            break;
        case PieDemoTypeBtnTagDoughnut2:
            break;
        case PieDemoTypeBtnTagDoughnut3:
            [self showDoughnut3Demo];
            break;
        case PieDemoTypeBtnTagTimeline:
            [self showTimelineDemo];
            break;
        case PieDemoTypeBtnTagLasagna:
            break;
        case PieDemoTypeBtnTagPie:
            [self showPieDemo];
            break;
    }
    [_kEchartView loadEcharts];
}

/**
 *  标准饼图
 */
-(void)showBasicPieDemo {
    NSString *basicPieJson = @"{\"title\":{\"text\":\"某站点用户访问来源\",\"subtext\":\"纯属虚构\",\"x\":\"center\"},\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[\"直接访问\",\"邮件营销\",\"联盟广告\",\"视频广告\",\"搜索引擎\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"pie\",\"funnel\"],\"option\":{\"funnel\":{\"x\":\"25%\",\"width\":\"50%\",\"funnelAlign\":\"left\",\"max\":1548}}},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"series\":[{\"name\":\"访问来源\",\"type\":\"pie\",\"radius\":\"55%\",\"center\":[\"50%\",\"60%\"],\"data\":[{\"value\":335,\"name\":\"直接访问\"},{\"value\":310,\"name\":\"邮件营销\"},{\"value\":234,\"name\":\"联盟广告\"},{\"value\":135,\"name\":\"视频广告\"},{\"value\":1548,\"name\":\"搜索引擎\"}]}]}";
    NSData *jsonData = [basicPieJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  标准环形图
 */
-(void)showDoughnutDemo {
    NSString *doughnutJson = @"{\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[\"直接访问\",\"邮件营销\",\"联盟广告\",\"视频广告\",\"搜索引擎\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"pie\",\"funnel\"],\"option\":{\"funnel\":{\"x\":\"25%\",\"width\":\"50%\",\"funnelAlign\":\"center\",\"max\":1548}}},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"series\":[{\"name\":\"访问来源\",\"type\":\"pie\",\"radius\":[\"50%\",\"70%\"],\"itemStyle\":{\"normal\":{\"label\":{\"show\":false},\"labelLine\":{\"show\":false}},\"emphasis\":{\"label\":{\"show\":true,\"position\":\"center\",\"textStyle\":{\"fontSize\":\"15\",\"fontWeight\":\"bold\"}}}},\"data\":[{\"value\":335,\"name\":\"直接访问\"},{\"value\":310,\"name\":\"邮件营销\"},{\"value\":234,\"name\":\"联盟广告\"},{\"value\":135,\"name\":\"视频广告\"},{\"value\":1548,\"name\":\"搜索引擎\"}]}]}";
    NSData *jsonData = [doughnutJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    
}

/**
 *  嵌套饼图
 */
-(void)showNestedPie {
    NSString *nestedPieJson = @"{\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[\"直达\",\"营销广告\",\"搜索引擎\",\"邮件营销\",\"联盟广告\",\"视频广告\",\"百度\",\"谷歌\",\"必应\",\"其他\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"pie\",\"funnel\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":false,\"series\":[{\"name\":\"访问来源\",\"type\":\"pie\",\"selectedMode\":\"single\",\"radius\":[0, 30],\"x\":\"20%\",\"width\":\"40%\",\"funnelAlign\":\"right\",\"max\":1548,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"inner\"},\"labelLine\":{\"show\":false}}},\"data\":[{\"value\":335,\"name\":\"直达\"},{\"value\":679,\"name\":\"营销广告\"},{\"value\":1548,\"name\":\"搜索引擎\",\"selected\":true}]},{\"name\":\"访问来源\",\"type\":\"pie\",\"radius\":[40,60],\"x\":\"60%\",\"width\":\"35%\",\"funnelAlign\":\"left\",\"max\":1048,\"data\":[{\"value\":335,\"name\":\"直达\"},{\"value\":310,\"name\":\"邮件营销\"},{\"value\":234,\"name\":\"联盟广告\"},{\"value\":135,\"name\":\"视频广告\"},{\"value\":1048,\"name\":\"百度\"},{\"value\":251,\"name\":\"谷歌\"},{\"value\":147,\"name\":\"必应\"},{\"value\":102,\"name\":\"其他\"}]}]}";
    NSData *jsonData = [nestedPieJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  南丁格尔玫瑰图
 */
-(void)showNightingalesRoseDiagramDemo {
    NSString *nightingalesRoseDiagramJson = @"{\"title\":{\"text\":\"南丁格尔玫瑰图\",\"subtext\":\"纯属虚构\",\"x\":\"center\"},\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"x\":\"center\",\"y\":\"bottom\",\"data\":[\"rose1\",\"rose2\",\"rose3\",\"rose4\",\"rose5\",\"rose6\",\"rose7\",\"rose8\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"pie\",\"funnel\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"series\":[{\"name\":\"半径模式\",\"type\":\"pie\",\"radius\":[10,40],\"center\":[\"25%\",100],\"roseType\":\"radius\",\"width\":\"40%\",\"max\":40,\"itemStyle\":{\"normal\":{\"label\":{\"show\":false},\"labelLine\":{\"show\":false}},\"emphasis\":{\"label\":{\"show\":true},\"labelLine\":{\"show\":true}}},\"data\":[{\"value\":10,\"name\":\"rose1\"},{\"value\":5,\"name\":\"rose2\"},{\"value\":15,\"name\":\"rose3\"},{\"value\":25,\"name\":\"rose4\"},{\"value\":20,\"name\":\"rose5\"},{\"value\":35,\"name\":\"rose6\"},{\"value\":30,\"name\":\"rose7\"},{\"value\":40,\"name\":\"rose8\"}]},{\"name\":\"面积模式\",\"type\":\"pie\",\"radius\":[10,40],\"center\":[\"75%\",100],\"roseType\":\"area\",\"x\":\"50%\",\"max\":40,\"sort\":\"ascending\",\"data\":[{\"value\":10,\"name\":\"rose1\"},{\"value\":5,\"name\":\"rose2\"},{\"value\":15,\"name\":\"rose3\"},{\"value\":25,\"name\":\"rose4\"},{\"value\":20,\"name\":\"rose5\"},{\"value\":35,\"name\":\"rose6\"},{\"value\":30,\"name\":\"rose7\"},{\"value\":40,\"name\":\"rose8\"}]}]}";
    NSData *jsonData = [nightingalesRoseDiagramJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  环形图2
 */
-(void)showDoughnut3Demo {
    NSString *dataStyleJson = @"{\"normal\":{\"label\":{\"show\":false},\"labelLine\":{\"show\":false}}}";
    NSData *dataStyleJsonData = [dataStyleJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataSytyleJsonDic = [NSJSONSerialization JSONObjectWithData:dataStyleJsonData options:NSJSONReadingAllowFragments error:nil];
    PYItemStyle *dataStyle = [RMMapper objectWithClass:[PYItemStyle class] fromDictionary:dataSytyleJsonDic];
    NSString *placeHolderStyleJson = @"{\"normal\":{\"color\":\"rgba(0,0,0,0)\",\"label\":{\"show\":false},\"labelLine\":{\"show\":false}},\"emphasis\":{\"color\":\"rgba(0,0,0,0)\"}}";
    NSData *placeHolderStyleJsonData = [placeHolderStyleJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *placeHolderStyleJsonDic = [NSJSONSerialization JSONObjectWithData:placeHolderStyleJsonData options:NSJSONReadingAllowFragments error:nil];
    PYItemStyle *placeHolderStyle = [RMMapper objectWithClass:[PYItemStyle class] fromDictionary:placeHolderStyleJsonDic];
    NSString *doughnut3Json = @"{\"title\":{\"text\":\"你幸福吗？\",\"x\":\"center\",\"y\":\"center\",\"itemGap\":20,\"textStyle\":{\"color\":\"rgba(30,144,255,0.8)\",\"fontFamily\":\"微软雅黑\",\"fontSize\":10,\"fontWeight\":\"bolder\"}},\"tooltip\":{\"show\":true,\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"orient\":\"vertical\",\"x\":190,\"y\":65,\"itemGap\":1,\"textStyle\" : {\"fontSize\": 7},\"data\":[\"68%的人表示过的不错\",\"29%的人表示生活压力很大\",\"3%的人表示“我姓曾”\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"series\":[{\"name\":\"1\",\"type\":\"pie\",\"clockWise\":false,\"radius\":[50,62.5],\"data\":[{\"value\":68,\"name\":\"68%的人表示过的不错\"},{\"value\":32,\"name\":\"invisible\"}]},{\"name\":\"2\",\"type\":\"pie\",\"clockWise\":false,\"radius\":[37.5,50],\"data\":[{\"value\":29,\"name\":\"29%的人表示生活压力很大\"},{\"value\":71,\"name\":\"invisible\"}]},{\"name\":\"3\",\"type\":\"pie\",\"clockWise\":false,\"radius\":[25,37.5],\"data\":[{\"value\":3,\"name\":\"3%的人表示“我姓曾”\"},{\"value\":97,\"name\":\"invisible\"}]}]}";
    NSData *jsonData = [doughnut3Json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    option.series = [RMMapper mutableArrayOfClass:[PYPieSeries class] fromArrayOfDictionary:option.series];
    NSMutableArray *serieses = [[NSMutableArray alloc] init];
    for (PYPieSeries *series in option.series) {
        series.itemStyle = dataStyle;
        NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:series.data];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:series.data[1]];
        [dic setObject:placeHolderStyle forKey:@"itemStyle"];
        [datas replaceObjectAtIndex:1 withObject:dic];
        series.data = datas;
        [serieses addObject:series];
    }
    option.series = serieses;
    [_kEchartView setOption:option];
}

/**
 *  搭配时间轴
 */
-(void)showTimelineDemo {
    NSString *timelineJson = @"{\"timeline\":{\"data\":[\"2013-01-01\",\"2013-02-01\",\"2013-03-01\",\"2013-04-01\",\"2013-05-01\",{\"name\":\"2013-06-01\",\"symbol\":\"emptyStar6\",\"symbolSize\":8},\"2013-07-01\",\"2013-08-01\",\"2013-09-01\",\"2013-10-01\",\"2013-11-01\",{\"name\":\"2013-12-01\",\"symbol\":\"star6\",\"symbolSize\":8}],\"label\":{\"formatter\":\"(function(s) {return s.slice(0, 7);})\"}},\"options\":[{\"title\":{\"text\":\"浏览器占比变化\",\"subtext\":\"纯属虚构\"},\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"data\":[\"Chrome\",\"Firefox\",\"Safari\",\"IE9+\",\"IE8-\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"pie\",\"funnel\"],\"option\":{\"funnel\":{\"x\":\"25%\",\"width\":\"50%\",\"funnelAlign\":\"left\",\"max\":1700}}},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"center\":[\"50%\",\"45%\"],\"radius\":\"50%\",\"data\":[{\"value\":208,\"name\":\"Chrome\"},{\"value\":224,\"name\":\"Firefox\"},{\"value\":352,\"name\":\"Safari\"},{\"value\":656,\"name\":\"IE9+\"},{\"value\":1288,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":336,\"name\":\"Chrome\"},{\"value\":288,\"name\":\"Firefox\"},{\"value\":384,\"name\":\"Safari\"},{\"value\":672,\"name\":\"IE9+\"},{\"value\":1296,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":464,\"name\":\"Chrome\"},{\"value\":352,\"name\":\"Firefox\"},{\"value\":416,\"name\":\"Safari\"},{\"value\":688,\"name\":\"IE9+\"},{\"value\":1304,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":592,\"name\":\"Chrome\"},{\"value\":416,\"name\":\"Firefox\"},{\"value\":448,\"name\":\"Safari\"},{\"value\":704,\"name\":\"IE9+\"},{\"value\":1312,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":720,\"name\":\"Chrome\"},{\"value\":480,\"name\":\"Firefox\"},{\"value\":480,\"name\":\"Safari\"},{\"value\":720,\"name\":\"IE9+\"},{\"value\":1320,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":848,\"name\":\"Chrome\"},{\"value\":544,\"name\":\"Firefox\"},{\"value\":512,\"name\":\"Safari\"},{\"value\":736,\"name\":\"IE9+\"},{\"value\":1328,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":976,\"name\":\"Chrome\"},{\"value\":608,\"name\":\"Firefox\"},{\"value\":544,\"name\":\"Safari\"},{\"value\":752,\"name\":\"IE9+\"},{\"value\":1336,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1104,\"name\":\"Chrome\"},{\"value\":672,\"name\":\"Firefox\"},{\"value\":576,\"name\":\"Safari\"},{\"value\":768,\"name\":\"IE9+\"},{\"value\":1344,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1232,\"name\":\"Chrome\"},{\"value\":736,\"name\":\"Firefox\"},{\"value\":608,\"name\":\"Safari\"},{\"value\":784,\"name\":\"IE9+\"},{\"value\":1352,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1360,\"name\":\"Chrome\"},{\"value\":800,\"name\":\"Firefox\"},{\"value\":640,\"name\":\"Safari\"},{\"value\":800,\"name\":\"IE9+\"},{\"value\":1360,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1488,\"name\":\"Chrome\"},{\"value\":864,\"name\":\"Firefox\"},{\"value\":672,\"name\":\"Safari\"},{\"value\":816,\"name\":\"IE9+\"},{\"value\":1368,\"name\":\"IE8-\"}]}]},{\"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1616,\"name\":\"Chrome\"},{\"value\":928,\"name\":\"Firefox\"},{\"value\":704,\"name\":\"Safari\"},{\"value\":832,\"name\":\"IE9+\"},{\"value\":1376,\"name\":\"IE8-\"}]}]}]}";
    NSData *jsonData = [timelineJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

//缺少千层饼的Demo

/**
 *  饼图
 */
-(void)showPieDemo {
    NSString *pieJson = @"{\"tooltip\":{\"show\":true,\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[\"直达\",\"营销广告\",\"搜索引擎\",\"邮件营销\",\"联盟广告\",\"视频广告\",\"百度\",\"谷歌\",\"必应\",\"其他\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"series\":[{\"name\":\"访问来源\",\"type\":\"pie\",\"center\":[\"35%\",100],\"radius\":15,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"inner\",\"formatter\":\"(function (params) {return (params.percent - 0).toFixed(0) + \'%\'})\"},\"labelLine\":{\"show\":false}},\"emphasis\":{\"label\":{\"show\":true,\"formatter\":\"{b}\\n{d}%\"}}},\"data\":[{\"value\":335,\"name\":\"直达\"},{\"value\":679,\"name\":\"营销广告\"},{\"value\":1548,\"name\":\"搜索引擎\"}]},{\"name\":\"访问来源\",\"type\":\"pie\",\"center\":[\"35%\",100],\"radius\":[30,50],\"data\":[{\"value\":335,\"name\":\"直达\"},{\"value\":310,\"name\":\"邮件营销\"},{\"value\":234,\"name\":\"联盟广告\"},{\"value\":135,\"name\":\"视频广告\"},{\"value\":1048,\"name\":\"百度\",\"itemStyle\":{\"normal\":{\"color\":\"(function (){var zrColor = require(\'zrender/tool/color\');return zrColor.getRadialGradient(300, 200, 110, 300, 200, 140,[[0, \'rgba(255,255,0,1)\'],[1, \'rgba(30,144,250,1)\']])})()\",\"label\":{\"textStyle\":{\"color\":\"rgba(30,144,255,0.8)\",\"align\":\"center\",\"baseline\":\"middle\",\"fontFamily\":\"微软雅黑\",\"fontSize\":30,\"fontWeight\":\"bolder\"}},\"labelLine\":{\"length\":40,\"lineStyle\":{\"color\":\"#f0f\",\"width\":3,\"type\":\"dotted\"}}}}},{\"value\":251,\"name\":\"谷歌\"},{\"value\":102,\"name\":\"必应\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":false},\"labelLine\":{\"show\":false}},\"emphasis\":{\"label\":{\"show\":true},\"labelLine\":{\"show\":true,\"length\":50}}}},{\"value\":147,\"name\":\"其他\"}]},{\"name\":\"访问来源\",\"type\":\"pie\",\"clockWise\":true,\"startAngle\":135,\"center\":[\"75%\",100],\"radius\":[30,50],\"itemStyle\":{\"normal\":{\"label\":{\"show\":false},\"labelLine\":{\"show\":false}},\"emphasis\":{\"color\":\"(function (){var zrColor = require(\'zrender/tool/color\');return zrColor.getRadialGradient(650, 200, 80, 650, 200, 120,[[0, \'rgba(255,255,0,1)\'],[1, \'rgba(255,0,0,1)\']])})()\",\"label\":{\"show\":true,\"position\":\"center\",\"formatter\":\"{d}%\",\"textStyle\":{\"color\":\"red\",\"fontSize\":\"30\",\"fontFamily\":\"微软雅黑\",\"fontWeight\":\"bold\"}}}},\"data\":[{\"value\":335,\"name\":\"直达\"},{\"value\":310,\"name\":\"邮件营销\"},{\"value\":234,\"name\":\"联盟广告\"},{\"value\":135,\"name\":\"视频广告\"},{\"value\":1548,\"name\":\"搜索引擎\"}],\"markPoint\":{\"symbol\":\"star\",\"data\":[{\"name\":\"最大\",\"value\":1548,\"x\":\"80%\",\"y\":40,\"symbolSize\":14}]}}]}";
    NSData *jsonData = [pieJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com