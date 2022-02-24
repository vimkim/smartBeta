
> :warning: **This code was written when I was a Non-CS Major.**
> 
> Inspired by the limitations and the growth opportunities I experienced during this project, I started persuing my second degree as a CS major from March 2019 after finishing my ECON degree. Please be aware that the code might include some inefficient codes and amateur mistakes. After taking OS & DB courses I figured this code can be way more optimized. 😄 

# FINE 452 Assignment 3 Smart Beta
Author: Daehyun, Pegah, Jaskrit
Last Modified: 2017-11-29
Course: Applied Quantitative Finance Fall 2017 Section 1
Project: Smart Beta (Assignment 3)
Team name: Dexter

** This code is also uploaded on github. If you think reading long comments in MATLAB editor being too obnoxious, try typing the following url in your browser: **

https://github.com/dqgthb/smartBeta

## Prerequisite step for running this code (required only for once):
- You need to create `marketIndex.mat` inside `matFolder` directory.
- You need to create `thisCrsps.mat` inside `matFolder` directory.
- You need to create `crsp.mat` inside `matFolder` directory.
- You need to create `ff3.mat` inside `matFolder` directory.
- You need to create `dateList.mat` inside `matFolder` directory.
These mat-files will be automatically created if you run 'make.m' script.
In order to run 'make.m' script, you need to first create a folder named 'csvFolder' inside this smartBeta project directory. Place all your relevant 'crsp.csv' and 'ff3.csv' inside 'csvFolder'.
Type the following in the Matlab Command Window.
```
>> make
```
Again, you only need to run this code once. 'make.m' script will create multiple 'mat' files in 'matFolder' directory, and you do not need to run 'make.m' again, as long as you do not delete the contents in 'matFolder'.

## How to run the code:
After you run 'make.m' script, type the following in the Matlab Command Window.
```
>> main
```

## How to check the results without running the code again:
For example, if you want to check the results of Strategy No. 2,
type the following in the Matlab Command Window.
```
>> load('strategy2Performance');
```
Or, you can use 'loadResult.m' script to create 'loaded' and 'results' variable which contain all the performance results from each strategy.

## What is 'thisCrsps'? Why does it look so different from Evan's example code?
Since we had a considerable number of strategies to test on, and it took too much time for them to run, we needed to automate the process and optimize the speed of code as possible as we can.

We managed to improve on a significant amount of running time by creating a special wrapper table variable, 'thisCrsps', which is a table containing a set of 'thisCrsp's for each dates between 2010-2014 as structs.

It takes a lot of time and memory space to create this variable at first, but once we save it as a 'thisCrsps.mat' file and reuse it as a function argument for our custom strategies, the performance has boosted up significantly. It took about 3 minutes to run a single strategy before. Now it takes approximately 35 seconds.

We know it is a horrible naming sense, but it is intuitively a collection of 'thisCrsp' variables. So we think calling it 'thisCrsp's actually makes sense.

## What is 'marketIndex'? Why is it needed?
Our strategy involves dynamic weighting based on market volatility. So we created a market index portfolio with around 4000 firms in 'crsp', weighted by relative market capitalization. This is like S&P500, expect for that it includes all the firms in 'crsp' data pool. This is just a recap of Assignment 1. Once we create the market index portfolio and get returns, we can also compute the volatility of this index.

## Why does the for loop iteration starts from 295 instead of 1 in 'runStrategy.m'?
We are using 42-day EWMA Market Index volatility, which is derived from 252-day EWMA Market Index return, as a signal for our dynamic weight adjustment in our strategies, and those are available only after 295 days from the beginning of the dataset. In order to avoid unnecessary looping and waste of running time, we starts the for loop from i=295. The result is checked and proven to be the same as what it starts from i=1. Starting from i=1 takes more computer-time while generating NaNs.

