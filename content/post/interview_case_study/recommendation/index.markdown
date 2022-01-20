---
title: Recommendation to Leadership
author: Spencer Schien
date: '2020-03-14'
slug: recommendation
categories:
  - Interview Case Study
tags:
 - RStats
 - Nonprofit
subtitle: ''
summary: 'Third of three posts on a case study I completed as part of a Data Scientist interview process.'
authors: [admin]
lastmod: '2020-03-14T17:54:00-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: yes
projects: []
---



# Recommendation

The optimal distribution of development staff is to **maximize focus on *Giving Society* giving, especially in startup years** (i.e. first years of implementation for *both* types of giving).

# The Problem

The purpose of this report is to provide a recommendation regarding the optimal distribution of Shocjin Nonprofit development staff between corporate giving and *Giving Society* giving.

To make this recommendation, the Data Science team conducted a survey to collect giving data from Shocjin Nonprofit sites  With this data, we have been able to run simulations that recreate giving ranges we can expect from the two giving categories.  

Our recommendation is based on these ranges and the probability of a site not meeting a benchmark amount of total giving in a year, which we are considering a loss.

<img src="/post/interview_case_study/recommendation/index_files/figure-html/unnamed-chunk-1-1.png" width="672" />

**These ranges represent the giving that Shocjin Nonprofit sites can expect to receive on an annual basis once both giving programs are more than a few years old.**

# The Analysis

We have made the assumption that the sum of the averages (represented by the dotted lines above) for both categories would be a break-even point, where Shocjin Nonprofit sites are receiving as much money as they need to operate, and everything below that would be considered a loss.  



The figures below represent the risk of experiencing a loss for both startup years and for stable years.  


<div class="figure" style="text-align: center">
<img src="/post/interview_case_study/recommendation/index_files/figure-html/unnamed-chunk-2-1.png" alt="Risk of Loss During Startup Years" width="90%" />
<p class="caption">Figure 1: Risk of Loss During Startup Years</p>
</div><div class="figure" style="text-align: center">
<img src="/post/interview_case_study/recommendation/index_files/figure-html/unnamed-chunk-2-2.png" alt="Risk of Loss During Stable Years" width="90%" />
<p class="caption">Figure 2: Risk of Loss During Stable Years</p>
</div>

In both cases, the risk is minimized as more focus if given to *Giving Society* giving.  This is because corporate giving is much more volatile, with a larger range of gift sizes and a smaller number of gifts received each year.

# The Recommendation

The optimal distribution of development staff is to **maximize focus on *Giving Society* giving, especially in startup years** (i.e. first years of implementation for *both* types of giving).  

The level to which it is maximized should be determined by the non-monetary value of the corporate engagements.

## Caveats

The simulations upon which this recommendation is based assume that there are no diminishing returns, either over time (i.e. supply doesn't dwindle as the site cycles through new individuals and corporations every year) or in a single year (i.e. a second development manager would experience the same number of engagements and rate of success).

If these assumptions do not remain true, the accuracy of this model will falter.  The distribution of gift sizes and number of gifts should therefore be monitored on an ongoing basis so the model and recommendation can be adjusted if necessary.

Also, as mentioned above, we assume there are non-monetary returns for both types of engagement.  Quantifying these returns and gathering data on these values should be done in the future to enhance the model and recommendations.
