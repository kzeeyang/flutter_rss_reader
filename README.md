# Flutter RSS Reader

这是一个RSS订阅器，请配合RSSHub食用。

## 预览

<p align="center">
    <img width="380" src="https://kzeeyang.github.io/images/rssreader_home.jpg" />
    <img width="380" src="https://kzeeyang.github.io/images/rssreader_rsspage.jpg" />
    <img width="380" src="https://kzeeyang.github.io/images/rssreader_detail.jpg" />
    <img width="380" src="https://kzeeyang.github.io/images/rssreader_setting.jpg" />
</p>

## 使用介绍

展示的控件比较少，但是有一些隐藏功能。左侧手机边缘往右拖会出现浮动的控件。在不同的页面有不同的效果，例如：主页能退出，WebViewer页面会根据浏览记录前进后退页面。其他隐藏功能请自行摸索😉

导入是通过URL导入JSON内容，以下为JSON示例：
```
{
  "category": [
    {
      "iconName": "home",
      "cateName": "主页",
      "rssSettings": [
        {
          "rssName": "好奇心日报",
          "url": "http://www.qdaily.com/feed.xml",
          "opened": false
        },
        {
          "rssName": "知乎每日精选",
          "url": "https://www.zhihu.com/rss",
          "opened": true
        },
      ]
    },
    {
      "iconName": "developer_board",
      "cateName": "开发",
      "rssSettings": [
        {
          "rssName": "HelloGitHub 月刊",
          "url": "https://hellogithub.com/rss",
          "opened": true
        },
        {
          "rssName": "LibHunt's Top Open-Source Projects",
          "url": "https://www.libhunt.com/feed",
          "opened": true
        }
      ]
    }
  ]
}
```
分类上限为12个，分类下所添加的RSS没有限制。但是因为需要从不同的网站解析RSS内容，添加太多会影响体验。
如果可以，会写一个后端提供用户注册添加存储用户关注的RSS内容。
