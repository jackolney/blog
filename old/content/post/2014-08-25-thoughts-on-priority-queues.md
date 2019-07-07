---
title:  "Thoughts on priority queues in C++"
date:   2014-08-25 09:41:00
description: Late night thoughts on individual-based modelling practices
categories: [programming]
tags: [C++]
---

Taking comfort in the fact that I am sure that nobody will read this site except me, I have decided to procrastinate by writing something about a problem, or perhaps I should say challange that I am currently facing. To add some background, I have written an individual-based time-to-event model that describes a series of events that make up HIV care. I have written this model purely in C++, but as it was my first "big" model and I was still learning C++ at the time, I have since thought about revisiting the source code and changing the fundamentals of the model.

### Original plan for the model.
The model starts by creating an "individual". This individual has a set of basic characteristics: gender, age, natural death date etc. The individual is then exposed to an annual hazard of developing HIV. If the individual is unfortunate enough to contract HIV, they have the opportunity to enter HIV care and eventually receive treatment. The way the model handles events occurring through time is by a clever little thing called a priority queue. A priority queue can be thought of as an ordered list that as reshuffles as objects are inserted depending on a set of rules. This can be as basic as the priority queue shown below:

```C++
  priority_queue<int, vector<int>, greater<int> > testQ;
```

A priority queue can have objects "pushed" into it that are then ordered according to the compare parameter, which in this case is shown by <code> greater&lt;int&gt; </code>. This means that every object that enters the priority queue, called "testQ" in this instance, is evaluated and placed in order. The current setup shown above orders the integers in the queue from largest to smallest. The "top" of the queue contains the smallest value. There are some cool member functions associated with priority queues. For instance, <code>testQ.push()</code> takes an arguement of the integer that we wish to push into the queue. While, <code>testQ.top()</code> will show us the value at the top of the queue (smallest). <code> testQ.pop()</code> is another useful function that has the effect of "popping" off the top of the queue and removing it. This is particular useful for me as I want to setup a priority queue that I can pass a list of dates to. I want the queue to order the dates with the smallest date, or date closest to the current date, being at the top of the queue. That will allow me to feed my model dates of any size and for it to quickly order them chronologically so I can effectively walk through them "popping" them off as I go.


### Old setup.
I currently use something similar to above, in that I pass dates to the queue and then "pop" them off. The slight problem with this approach is that when the date of an event comes to the top of the priority queue, I need to be able to call a specific function that is due to occur on that specific date. For example, if I wanted to perform an HIV-test on an individual in 2010, I pass the date 2010 to the priority queue and when <code>testQ.top() == 2010</code> I compare an HIV-test "flag" (which holds the date 2010) to the top of the queue. If the two agree, then we proceed and call the HIV-test function.

### Future setup.
Looking back at this, while it is simple, it is slightly crude to be checking the top of the priority queue against a "flag". What would be much neater would be to create a <code>class event</code> which has the attributes of <code>time</code> and a function pointer. This would allow me to "push" a time and function into the queue. When an event comes to the top of the queue, I will be able to access a time and a pointer to the appropriate function.

```C++
class eventClass {
  double time;
  void (*ptr_fun)();
};

priority_queue<eventClass, vector<eventClass>, timeComparison > testQ;
```
