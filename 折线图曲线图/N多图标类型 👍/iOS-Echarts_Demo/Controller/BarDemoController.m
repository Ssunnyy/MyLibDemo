//
//  BarDemoControllerViewController.m
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/9/27.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarDemoController.h"

typedef enum {
    BarDemoTypeTagBasicColumn = 20000,
    BarDemoTypeTagStackedColumn = 20001,
    BarDemoTypeTagTermometer = 20002,
    BarDemoTypeTagCompositiveWaterfall = 20003,
    BarDemoTypeTagChangeWaterfall = 20004,
    BarDemoTypeTagStackedAndClusteredColumn = 20005,
    BarDemoTypeTagBasicBar = 20006,
    BarDemoTypeTagStackedBar = 20007,
    BarDemoTypeTagStackedFloatingBar = 20008,
    BarDemoTypeTagTornado = 20009,
    BarDemoTypeTagTornado2 = 20010,
    BarDemoTypeTagIrrgularBar = 20011,
    BarDemoTypeTagTimeline = 20012,
    BarDemoTypeTagRainbowBar = 20013,
    BarDemoTypeTagMultipleSreiesRainbowBar = 20014,
    BarDemoTypeTagColumn = 20015
}BarDemoTypeTag;

@interface BarDemoController ()

@end

@implementation BarDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

#pragma mark - custom functions
-(void)initAll {
    self.title = @"柱状图";
    [self showBasicColumnDemo];
    [_kEchartView loadEcharts];
}


- (IBAction)kDemosClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case BarDemoTypeTagBasicColumn:
            [self showBasicColumnDemo];
            break;
        case BarDemoTypeTagStackedColumn:
            [self showStackedColumnDemo];
            break;
        case BarDemoTypeTagTermometer:
            [self showTermometerDemo];
            break;
        case BarDemoTypeTagCompositiveWaterfall:
            [self showCompositiveWaterfallDemo];
            break;
        case BarDemoTypeTagChangeWaterfall:
            [self showChangeWaterfallDemo];
            break;
        case BarDemoTypeTagStackedAndClusteredColumn:
            [self showStackedAndClusteredColumnDemo];
            break;
        case BarDemoTypeTagBasicBar:
            [self showBasicBarDemo];
            break;
        case BarDemoTypeTagStackedBar:
            [self showStackedBarDemo];
            break;
        case BarDemoTypeTagStackedFloatingBar:
            [self showStackedFloatingBarDemo];
            break;
        case BarDemoTypeTagTornado:
            [self showTornadoDemo];
            break;
        case BarDemoTypeTagTornado2:
            [self showTornado2Demo];
            break;
        case BarDemoTypeTagIrrgularBar:
            [self showIrrgularBarDemo];
            break;
        case BarDemoTypeTagTimeline:
            break;
        case BarDemoTypeTagRainbowBar:
            break;
        case BarDemoTypeTagMultipleSreiesRainbowBar:
            break;
        case BarDemoTypeTagColumn:
            break;
        default:
            break;
    }
    [_kEchartView loadEcharts];
}

/**
 *  标准柱状图
 */
-(void)showBasicColumnDemo {
    NSString *basicColumnJson = @"{\"grid\":{\"x\":30,\"x2\":45},\"title\":{\"text\":\"某地区蒸发量和降水量\",\"subtext\":\"纯属虚构\"},\"tooltip\":{\"trigger\":\"axis\"},\"legend\":{\"data\":[\"蒸发量\",\"降水量\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"category\",\"data\":[\"1月\",\"2月\",\"3月\",\"4月\",\"5月\",\"6月\",\"7月\",\"8月\",\"9月\",\"10月\",\"11月\",\"12月\"]}],\"yAxis\":[{\"type\":\"value\"}],\"series\":[{\"name\":\"蒸发量\",\"type\":\"bar\",\"data\":[2,4.9,7,23.2,25.6,76.7,135.6,162.2,32.6,20,6.4,3.3],\"markPoint\":{\"data\":[{\"type\":\"max\",\"name\":\"最大值\"},{\"type\":\"min\",\"name\":\"最小值\"}]},\"markLine\":{\"data\":[{\"type\":\"average\",\"name\":\"平均值\"}]}},{\"name\":\"降水量\",\"type\":\"bar\",\"data\":[2.6,5.9,9,26.4,28.7,70.7,175.6,182.2,48.7,18.8,6,2.3],\"markPoint\":{\"data\":[{\"name\":\"年最高\",\"value\":182.2,\"xAxis\":7,\"yAxis\":183,\"symbolSize\":18},{\"name\":\"年最低\",\"value\":2.3,\"xAxis\":11,\"yAxis\":3}]},\"markLine\":{\"data\":[{\"type\":\"average\",\"name\":\"平均值\"}]}}]}";
    NSData *jsonData = [basicColumnJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  堆积柱状图
 */
-(void)showStackedColumnDemo {
    NSString *stackedColumnJson = @"{\"grid\":{\"x\":40,\"x2\":55},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"legend\":{\"data\":[\"直接访问\",\"邮件营销\",\"联盟广告\",\"视频广告\",\"搜索引擎\",\"百度\",\"谷歌\",\"必应\",\"其他\"]},\"toolbox\":{\"show\":true,\"orient\":\"vertical\",\"x\":\"right\",\"y\":\"center\",\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\",\"stack\",\"tiled\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"category\",\"data\":[\"周一\",\"周二\",\"周三\",\"周四\",\"周五\",\"周六\",\"周日\"]}],\"yAxis\":[{\"type\":\"value\"}],\"series\":[{\"name\":\"直接访问\",\"type\":\"bar\",\"data\":[320,332,301,334,390,330,320]},{\"name\":\"邮件营销\",\"type\":\"bar\",\"stack\":\"广告\",\"data\":[120,132,101,134,90,230,210]},{\"name\":\"联盟广告\",\"type\":\"bar\",\"stack\":\"广告\",\"data\":[220,182,191,234,290,330,310]},{\"name\":\"视频广告\",\"type\":\"bar\",\"stack\":\"广告\",\"data\":[150,232,201,154,190,330,410]},{\"name\":\"搜索引擎\",\"type\":\"bar\",\"data\":[862,1018,964,1026,1679,1600,1570],\"markLine\":{\"itemStyle\":{\"normal\":{\"lineStyle\":{\"type\":\"dashed\"}}},\"data\":[[{\"type\":\"min\"},{\"type\":\"max\"}]]}},{\"name\":\"百度\",\"type\":\"bar\",\"barWidth\":5,\"stack\":\"搜索引擎\",\"data\":[620,732,701,734,1090,1130,1120]},{\"name\":\"谷歌\",\"type\":\"bar\",\"stack\":\"搜索引擎\",\"data\":[120,132,101,134,290,230,220]},{\"name\":\"必应\",\"type\":\"bar\",\"stack\":\"搜索引擎\",\"data\":[60,72,71,74,190,130,110]},{\"name\":\"其他\",\"type\":\"bar\",\"stack\":\"搜索引擎\",\"data\":[62,82,91,84,109,110,120]}]}";
    NSData *jsonData = [stackedColumnJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  温度计式图表
 */
-(void)showTermometerDemo {
    NSString *termometerDemo = @"{\"grid\":{\"x\":30,\"x2\":45},\"title\":{\"text\":\"温度计式图表\",\"subtext\":\"From ExcelHome\",\"sublink\":\"http://e.weibo.com/1341556070/AizJXrAEa\"},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"},\"formatter\":\"(function (params){return params[0].name + \'<br/>\' + params[0].seriesName + \' : \' + params[0].value + \'<br/>\' + params[1].seriesName + \' : \' + (params[1].value + params[0].value);})\"},\"legend\":{\"selectedMode\":false,\"data\":[\"Acutal\",\"Forecast\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"category\",\"data\":[\"Cosco\",\"CMA\",\"APL\",\"OOCL\",\"Wanhai\",\"Zim\"]}],\"yAxis\":[{\"type\":\"value\",\"boundaryGap\":[0,0.1]}],\"series\":[{\"name\":\"Acutal\",\"type\":\"bar\",\"stack\":\"sum\",\"barCategoryGap\":\"50%\",\"itemStyle\":{\"normal\":{\"color\":\"tomato\",\"barBorderColor\":\"tomato\",\"barBorderWidth\":6,\"barBorderRadius\":0,\"label\":{\"show\":true,\"position\":\"insideTop\"}}},\"data\":[260,200,220,120,100,80]},{\"name\":\"Forecast\",\"type\":\"bar\",\"stack\":\"sum\",\"itemStyle\":{\"normal\":{\"color\":\"#fff\",\"barBorderColor\":\"tomato\",\"barBorderWidth\":6,\"barBorderRadius\":0,\"label\":{\"show\":true,\"position\":\"top\",\"formatter\" : \"(function (params) {for (var i = 0, l = option.xAxis[0].data.length; i < l; i++) {if (option.xAxis[0].data[i] == params.name) {return option.series[0].data[i] + params.value;}}})\",\"textStyle\":{\"color\":\"tomato\"}}}},\"data\":[40,80,50,80,80,70]}]}\n";
    NSData *jsonData = [termometerDemo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  组成瀑布图
 */
-(void)showCompositiveWaterfallDemo {
    NSString *compositiveWaterfallJson = @"{\"grid\":{\"x\":40,\"x2\":30},\"title\":{\"text\":\"深圳月最低生活费组成（单位:元）\",\"subtext\":\"From ExcelHome\",\"sublink\":\"http://e.weibo.com/1341556070/AjQH99che\"},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"},\"formatter\" : \"(function (params) {var tar = params[0];return tar.name + '<br/>' + tar.seriesName + ' : ' + tar.value;})\"},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"xAxis\":[{\"type\":\"category\",\"splitLine\":{\"show\":false},\"data\":[\"总费用\",\"房租\",\"水电费\",\"交通费\",\"伙食费\",\"日用品数\"]}],\"yAxis\":[{\"type\":\"value\"}],\"series\":[{\"name\":\"辅助\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"barBorderColor\":\"rgba(0,0,0,0)\",\"color\":\"rgba(0,0,0,0)\"},\"emphasis\":{\"barBorderColor\":\"rgba(0,0,0,0)\",\"color\":\"rgba(0,0,0,0)\"}},\"data\":[0,1700,1400,1200,300,0]},{\"name\":\"生活费\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"inside\"}}},\"data\":[2900,1200,300,200,900,300]}]}";
    NSData *jsonData = [compositiveWaterfallJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  变化瀑布图
 */
-(void)showChangeWaterfallDemo {
    NSString *changeWaterfallJson = @"{\"grid\":{\"x\":40,\"x2\":30},\"title\":{\"text\":\"阶梯瀑布图\",\"subtext\":\"From ExcelHome\",\"sublink\":\"http://e.weibo.com/1341556070/Aj1J2x5a5\"},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"},\"formatter\": \"(function (params) {var tar;if (params[1].value != '-') {tar = params[1];}else {tar = params[0];}return tar.name + '<br/>' + tar.seriesName + ' : ' + tar.value;})\"},\"legend\":{\"data\":[\"支出\",\"收入\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"xAxis\":[{\"type\":\"category\",\"splitLine\":{\"show\":false},\"data\": \"(function (){var list = [];for (var i = 1; i <= 11; i++) {list.push('11月' + i + '日');}return list;}())\"}],\"yAxis\":[{\"type\":\"value\"}],\"series\":[{\"name\":\"辅助\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"barBorderColor\":\"rgba(0,0,0,0)\",\"color\":\"rgba(0,0,0,0)\"},\"emphasis\":{\"barBorderColor\":\"rgba(0,0,0,0)\",\"color\":\"rgba(0,0,0,0)\"}},\"data\":[0,900,1245,1530,1376,1376,1511,1689,1856,1495,1292]},{\"name\":\"收入\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"top\"}}},\"data\":[900,345,393,\"-\",\"-\",135,178,286,\"-\",\"-\",\"-\"]},{\"name\":\"支出\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"bottom\"}}},\"data\":[\"-\",\"-\",\"-\",108,154,\"-\",\"-\",\"-\",119,361,203]}]}";
    NSData *jsonData = [changeWaterfallJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  多系列层叠
 */
-(void)showStackedAndClusteredColumnDemo {
    NSString *stackedAndClusteredColumnJson = @"{\"title\":{\"text\":\"ECharts2 vs ECharts1\",\"subtext\":\"Chrome下测试数据\"},\"tooltip\":{\"trigger\":\"axis\"},\"legend\":{\"data\":[\"ECharts1 - 2k数据\",\"ECharts1 - 2w数据\",\"ECharts1 - 20w数据\",\"\",\"ECharts2 - 2k数据\",\"ECharts2 - 2w数据\",\"ECharts2 - 20w数据\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"grid\":{\"y\":45,\"y2\":30,\"x2\":20},\"xAxis\":[{\"type\":\"category\",\"data\":[\"Line\",\"Bar\",\"Scatter\",\"K\",\"Map\"]},{\"type\":\"category\",\"axisLine\":{\"show\":false},\"axisTick\":{\"show\":false},\"axisLabel\":{\"show\":false},\"splitArea\":{\"show\":false},\"splitLine\":{\"show\":false},\"data\":[\"Line\",\"Bar\",\"Scatter\",\"K\",\"Map\"]}],\"yAxis\":[{\"type\":\"value\",\"axisLabel\":{\"formatter\":\"{value} ms\"}}],\"series\":[{\"name\":\"ECharts2 - 2k数据\",\"type\":\"bar\",\"itemStyle\":{\"normal\":{\"color\":\"rgba(193,35,43,1)\",\"label\":{\"show\":true}}},\"data\":[40,155,95,75,0]},{\"name\":\"ECharts2 - 2w数据\",\"type\":\"bar\",\"itemStyle\":{\"normal\":{\"color\":\"rgba(181,195,52,1)\",\"label\":{\"show\":true,\"textStyle\":{\"color\":\"#27727B\"}}}},\"data\":[100,200,105,100,156]},{\"name\":\"ECharts2 - 20w数据\",\"type\":\"bar\",\"itemStyle\":{\"normal\":{\"color\":\"rgba(252,206,16,1)\",\"label\":{\"show\":true,\"textStyle\":{\"color\":\"#E87C25\"}}}},\"data\":[906,911,908,778,0]},{\"name\":\"ECharts1 - 2k数据\",\"type\":\"bar\",\"xAxisIndex\":1,\"itemStyle\":{\"normal\":{\"color\":\"rgba(193,35,43,0.5)\",\"label\":{\"show\":true, \"formatter\":\"(function(p){return p.value > 0 ? (p.value +' '):' ';})\"}}},\"data\":[96,224,164,124,0]},{\"name\":\"ECharts1 - 2w数据\",\"type\":\"bar\",\"xAxisIndex\":1,\"itemStyle\":{\"normal\":{\"color\":\"rgba(181,195,52,0.5)\",\"label\":{\"show\":true}}},\"data\":[491,2035,389,955,347]},{\"name\":\"ECharts1 - 20w数据\",\"type\":\"bar\",\"xAxisIndex\":1,\"itemStyle\":{\"normal\":{\"color\":\"rgba(252,206,16,0.5)\",\"label\":{\"show\":true,\"formatter\":\"(function(p){return p.value > 0 ? (p.value +'+'):'';})\"}}},\"data\":[3000,3000,2817,3000,0]}]}";
    NSData *jsonData = [stackedAndClusteredColumnJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  标准条形图
 */
-(void)showBasicBarDemo {
    NSString *basicBarJson = @"{\"grid\":{\"x\":30,\"x2\":45},\"title\":{\"text\":\"世界人口总量\",\"subtext\":\"数据来自网络\"},\"tooltip\":{\"trigger\":\"axis\"},\"legend\":{\"data\":[\"2011年\",\"2012年\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\",\"boundaryGap\":[0,0.01]}],\"yAxis\":[{\"type\":\"category\",\"data\":[\"巴西\",\"印尼\",\"美国\",\"印度\",\"中国\",\"世界人口(万)\"]}],\"series\":[{\"name\":\"2011年\",\"type\":\"bar\",\"data\":[18203,23489,29034,104970,131744,630230]},{\"name\":\"2012年\",\"type\":\"bar\",\"data\":[19325,23438,31000,121594,134141,681807]}]}";
    NSData *jsonData = [basicBarJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  堆积条形图
 */
-(void)showStackedBarDemo {
    NSString *stackedBarJson = @"{\"grid\":{\"x\":50,\"x2\":30},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"legend\":{\"data\":[\"直接访问\",\"邮件营销\",\"联盟广告\",\"视频广告\",\"搜索引擎\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\",\"stack\",\"tiled\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\"}],\"yAxis\":[{\"type\":\"category\",\"data\":[\"周一\",\"周二\",\"周三\",\"周四\",\"周五\",\"周六\",\"周日\"]}],\"series\":[{\"name\":\"直接访问\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"insideRight\"}}},\"data\":[320,302,301,334,390,330,320]},{\"name\":\"邮件营销\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"insideRight\"}}},\"data\":[120,132,101,134,90,230,210]},{\"name\":\"联盟广告\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"insideRight\"}}},\"data\":[220,182,191,234,290,330,310]},{\"name\":\"视频广告\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"insideRight\"}}},\"data\":[150,212,201,154,190,330,410]},{\"name\":\"搜索引擎\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"insideRight\"}}},\"data\":[820,832,901,934,1290,1330,1320]}]}";
    NSData *jsonData = [stackedBarJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  多维条形图
 */
-(void)showStackedFloatingBarDemo {
    NSString *placeHoldStyleJson = @"{\"normal\":{\"barBorderColor\":\"rgba(0,0,0,0)\",\"color\":\"rgba(0,0,0,0)\"},\"emphasis\":{\"barBorderColor\":\"rgba(0,0,0,0)\",\"color\":\"rgba(0,0,0,0)\"}}";
    NSData *placeHoldStyleJsonData = [placeHoldStyleJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *placeHoldStyleJsonDic = [NSJSONSerialization JSONObjectWithData:placeHoldStyleJsonData options:NSJSONReadingAllowFragments error:nil];
    PYItemStyle *placeHoldStyle = [RMMapper objectWithClass:[PYItemStyle class] fromDictionary:placeHoldStyleJsonDic];
    NSString *dataStyleJson = @"{\"normal\":{\"label\":{\"show\":true,\"position\":\"insideLeft\",\"formatter\":\"{c}%\"}}}";
    NSData *dataStyleJsonData = [dataStyleJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataStyleJsonDic = [NSJSONSerialization JSONObjectWithData:dataStyleJsonData options:NSJSONReadingAllowFragments error:nil];
    PYItemStyle *dataStyle = [RMMapper objectWithClass:[PYItemStyle class] fromDictionary:dataStyleJsonDic];
    NSString *stackedFloatingBarJson = @"{\"title\":{\"text\":\"多维条形图\",\"subtext\":\"From ExcelHome\",\"sublink\":\"http://e.weibo.com/1341556070/AiEscco0H\"},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"},\"formatter\":\"{b}<br/>{a0}:{c0}%<br/>{a2}:{c2}%<br/>{a4}:{c4}%<br/>{a6}:{c6}%\"},\"legend\":{\"y\":55,\"itemGap\":\"(funtion(){return document.getElementById(\'main\').offsetWidth / 8;})()\",\"data\":[\"GML\",\"PYP\",\"WTC\",\"ZTW\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"grid\":{\"x\":30,\"x2\":30,\"y\":80,\"y2\":30},\"xAxis\":[{\"type\":\"value\",\"position\":\"top\",\"splitLine\":{\"show\":false},\"axisLabel\":{\"show\":false}}],\"yAxis\":[{\"type\":\"category\",\"splitLine\":{\"show\":false},\"data\":[\"重庆\",\"天津\",\"上海\",\"北京\"]}],\"series\":[{\"name\":\"GML\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[38,50,33,72]},{\"name\":\"GML\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[62,50,67,28]},{\"name\":\"PYP\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[61,41,42,30]},{\"name\":\"PYP\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[39,59,58,70]},{\"name\":\"WTC\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[37,35,44,60]},{\"name\":\"WTC\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[63,65,56,40]},{\"name\":\"ZTW\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[71,50,31,39]},{\"name\":\"ZTW\",\"type\":\"bar\",\"stack\":\"总量\",\"data\":[29,50,69,61]}]}\n";
    NSData *jsonData = [stackedFloatingBarJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    option.series = [RMMapper mutableArrayOfClass:[PYCartesianSeries class] fromArrayOfDictionary:option.series];
    int i = 1;
    NSMutableArray *serieses = [[NSMutableArray alloc] init];
    for (PYSeries *series in option.series) {
        if (i++ % 2 == 1) {
            series.itemStyle = dataStyle;
        } else {
            series.itemStyle = placeHoldStyle;
        }
        [serieses addObject:series];
    }
    option.series = serieses;
    [_kEchartView setOption:option];
}

/**
 *  旋风条形图
 */
-(void)showTornadoDemo {
    NSString *tornadoJson = @"{\"grid\":{\"x\":30,\"x2\":45},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"legend\":{\"data\":[\"利润\",\"支出\",\"收入\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\"}],\"yAxis\":[{\"type\":\"category\",\"axisTick\":{\"show\":false},\"data\":[\"周一\",\"周二\",\"周三\",\"周四\",\"周五\",\"周六\",\"周日\"]}],\"series\":[{\"name\":\"利润\",\"type\":\"bar\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"inside\"}}},\"data\":[200,170,240,244,200,220,210]},{\"name\":\"收入\",\"type\":\"bar\",\"stack\":\"总量\",\"barWidth\":5,\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}}},\"data\":[320,302,341,374,390,450,420]},{\"name\":\"支出\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"left\"}}},\"data\":[-120,-132,-101,-134,-190,-230,-210]}]}";
    NSData *jsonData = [tornadoJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  旋风条形图2
 */
-(void)showTornado2Demo {
    NSString *tornadoJson = @"{\"title\":{\"text\":\"交错正负轴标签\",\"subtext\":\"From ExcelHome\",\"sublink\":\"http://e.weibo.com/1341556070/AjwF2AgQm\"},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"grid\":{\"x\":30,\"x2\":30,\"y\":80,\"y2\":30},\"xAxis\":[{\"type\":\"value\",\"position\":\"top\",\"splitLine\":{\"lineStyle\":{\"type\":\"dashed\"}}}],\"yAxis\":[{\"type\":\"category\",\"axisLine\":{\"show\":false},\"axisLabel\":{\"show\":false},\"axisTick\":{\"show\":false},\"splitLine\":{\"show\":false},\"data\":[\"ten\",\"nine\",\"eight\",\"seven\",\"six\",\"five\",\"four\",\"three\",\"two\",\"one\"]}],\"series\":[{\"name\":\"生活费\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"color\":\"orange\",\"borderRadius\":5,\"label\":{\"show\":true,\"position\":\"left\",\"formatter\":\"{b}\"}}},\"data\":[{\"value\":-0.07,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"right\"}}}},{\"value\":-0.09,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"right\"}}}},0.2,0.44,{\"value\":-0.23,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"right\"}}}},0.08,{\"value\":-0.17,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"right\"}}}},0.47,{\"value\":-0.36,\"itemStyle\":{\"normal\":{\"label\":{\"position\":\"right\"}}}},0.18]}]}";
    NSData *jsonData = [tornadoJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

/**
 *  不等距柱形图
 */
-(void)showIrrgularBarDemo {
    NSString *irrgularBarJson = @"{\"grid\":{\"x\":30,\"x2\":45},\"title\":{\"text\":\"双数值柱形图\",\"subtext\":\"纯属虚构\"},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"show\":true,\"type\":\"cross\",\"lineStyle\":{\"type\":\"dashed\",\"width\":1}}, \"formatter\" : \"(function (params) {return params.seriesName + ' : [ '+ params.value[0] + ', ' + params.value[1] + ' ]';})\"},\"legend\":{\"data\":[\"数据1\",\"数据2\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\"}],\"yAxis\":[{\"type\":\"value\",\"axisLine\":{\"lineStyle\":{\"color\":\"#dc143c\"}}}],\"series\":[{\"name\":\"数据1\",\"type\":\"bar\",\"data\":[[1.5,10],[5,7],[8,8],[12,6],[11,12],[16,9],[14,6],[17,4],[19,9]],\"markPoint\":{\"data\":[{\"type\":\"max\",\"name\":\"最大值\",\"symbol\":\"emptyCircle\",\"itemStyle\":{\"normal\":{\"color\":\"#dc143c\",\"label\":{\"position\":\"top\"}}}},{\"type\":\"min\",\"name\":\"最小值\",\"symbol\":\"emptyCircle\",\"itemStyle\":{\"normal\":{\"color\":\"#dc143c\",\"label\":{\"position\":\"bottom\"}}}},{\"type\":\"max\",\"name\":\"最大值\",\"valueIndex\":0,\"symbol\":\"emptyCircle\",\"itemStyle\":{\"normal\":{\"color\":\"#1e90ff\",\"label\":{\"position\":\"right\"}}}},{\"type\":\"min\",\"name\":\"最小值\",\"valueIndex\":0,\"symbol\":\"emptyCircle\",\"itemStyle\":{\"normal\":{\"color\":\"#1e90ff\",\"label\":{\"position\":\"left\"}}}}]},\"markLine\":{\"data\":[{\"type\":\"max\",\"name\":\"最大值\",\"itemStyle\":{\"normal\":{\"color\":\"#dc143c\"}}},{\"type\":\"min\",\"name\":\"最小值\",\"itemStyle\":{\"normal\":{\"color\":\"#dc143c\"}}},{\"type\":\"average\",\"name\":\"平均值\",\"itemStyle\":{\"normal\":{\"color\":\"#dc143c\"}}},{\"type\":\"max\",\"name\":\"最大值\",\"valueIndex\":0,\"itemStyle\":{\"normal\":{\"color\":\"#1e90ff\"}}},{\"type\":\"min\",\"name\":\"最小值\",\"valueIndex\":0,\"itemStyle\":{\"normal\":{\"color\":\"#1e90ff\"}}},{\"type\":\"average\",\"name\":\"平均值\",\"valueIndex\":0,\"itemStyle\":{\"normal\":{\"color\":\"#1e90ff\"}}}]}},{\"name\":\"数据2\",\"type\":\"bar\",\"barHeight\":10,\"data\":[[1,2],[2,3],[4,4],[7,5],[11,11],[18,15]]}]}";
    NSData *jsonData = [irrgularBarJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
}

// 缺少搭配时间轴的测试
//-(void)showDemo {
//    NSString *Json = @"";
//}

// 缺少彩色柱形图
//-(void)showDemo {
//    NSString *Json = @"";
//}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com