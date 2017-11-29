# FINE 452 Assignment 3 Smart Beta
Author: Deon, Pegah, Jaskrit
Last Modified: 2017-11-29
Course: Applied Quantitative Finance Fall 2017 Section 1
Project: Smart Beta (Assignment 3)
Team name: Dexter

## Prerequisites for running the code:
- You need to create `marketIndex.mat` inside
- You need to create `thisCrsps.mat`
- You need to create `crsp.mat`
- You need to create `ff3.mat`
- You need to create `dateList.mat`
These things will be automatically created if you run 'make.m' script.
Type the following in the Matlab Command Window.
```
>> make
```
You only need to run this code once. After that, 'mat' files are created and you do not need to run this again in that computer, as long as those mat files exist.

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
Or, you can use 'loadResult.m' script to create 'results' variable which contains all the performance results from each strategy.

## What is 'thisCrsps'? Why does it look so different from Evan's example code?
Since we had a considerable number of strategies to test on, and it took too much time for them to run, we needed to automate the process and optimize the speed of code as possible as we can.

We managed to improve on a significant amount of running time by creating a special wrapper table variable, 'thisCrsps', which is a table containing a set of 'thisCrsp's for each dates between 2010-2014 as structs.

It takes a lot of time and memory space to create this variable at first, but once we save it as a 'thisCrsps.mat' file and reuse it as a function argument for our custom strategies, the performance has boosted up significantly. It took about 3 minutes to run a single strategy before. Now it takes approximately 35 seconds.

## What is 'marketIndex'? Why is it needed?
Our strategy involves dynamic weighting based on market volatility. So we created a market index portfolio with around 4000 firms in 'crsp', 


## Why does the for loop iteration starts from 295 instead of 1?
We are using 42-day EWMA Market Index volatility, which is derived from 252-day EWMA Market Index return, as a signal for our dynamic weight adjustment in our strategies, and those are available only after 295 days from the beginning of the dataset. In order to avoid unnecessary looping and waste of running time, we starts the for loop from i=295. The result is checked and proved to be the same as what it starts from i=1. Starting from i=1 takes more computer-time while generating NaNs.

