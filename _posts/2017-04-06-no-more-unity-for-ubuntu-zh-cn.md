---
layout: post
date: 2017-04-06
image: https://sukso96100.github.io/blogimgs/ubuntu-unity.png
title: "不再有Ubuntu用Unity。（简体中文）"
tags: ubuntu linux unity gnome essay
---

因为Canonical决定放弃Unity工程，从Ubuntu 18.04，Unity不是Ubuntu的基本桌面环境。
从明年，GNOME是Ubuntu的新基本桌面环境。
那个企业也又放弃Unity工程（桌面环境到手机用Unity）又放弃了为Unity开发的Mir Display服务器。

从Mark Shuttlewotrh(Canonical和Ubuntu工程的创始人)的帖子，他觉得为Convergence开始的 Unity 8 和 Ubuntu Touch（手机和片剂电脑用Ubuntu）工程是他的错误。
我觉得Canonical和他的工程不是一个错误。但他们的错误是没选择帮组Wayland Display服务器工程，
而是选开发Mir Display服务器是Canonical自己开发的。

他们说，原来Mir的目的是代替Xorg。可是现在Wayland还需要很多改善，也支持它要很多时间。
在这样的情况，为在支持Wayland忙的公司如何支持Mir？

与把编写的GTK放在Unity也是他们的错误。大多GTK程序在Unity工作的时总是有UI问题。
（例如，在GNOME环境Nautilus工作得很好，但是在Unity环境UI问题出现。）

Ubuntu Touch 太迟到了。在Android和iOS已经所有手机市场的情况，真样Ubuntu Touch进入手机市场呢？
Mozila的Firefox OS和Microsoft的Windows Phone已经失败进入。
如果Ubuntu Touch进入成功，卖很多，我已经有的。

Canonical打算放弃Unity8和Ubuntu Touch，反而集中云计算和物联网。
由于Ubuntu在云计算和服务器方面已经非常好，我感觉它这方面保持进步。

很有名的服务器用程序（例如：Openstack, Docker, Kubernetes）文书的标准是Ubuntu。因此，已经说完了。

新消息：Canonical放弃Unity8工程后，希望保持工程的人们出现了。他们分叉了Unity8工程。新工程的名字是“Yunit”。我觉得这样的办法比较好的。

## 参考

- [Ubuntu Insights - Growing Ubuntu for cloud and IoT, rather than phone and convergence](https://insights.ubuntu.com/2017/04/05/growing-ubuntu-for-cloud-and-iot-rather-than-phone-and-convergence/)
- [yunit - A community-driven unity8 fork](https://yunit.io/)
- [Ubuntu 를 위한 Unity 는 이제 없다.(韩语原文)](https://sukso96100.github.io/blog/2017/04/06/no-more-unity-for-ubuntu.html)
