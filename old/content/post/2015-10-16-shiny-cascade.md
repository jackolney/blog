---
title:  "Interactive Dynamic Models in R"
date:   2015-10-16 09:41:00
description: An experiment with 'shiny'
categories: [shiny, programming]
tags: [shiny,R]
---

As part of a new work package I am part of, we needed to develop a dynamic transmission model of HIV care that has a relatively user-friendly interface and that can be run on almost any device.

The initial choice was to go with an Excel spreadsheet, and have a tab hidden in the background with the model running and a whole bunch of simple stuff at the front for the user to interact with. We then wanted this to develop further into something that had parameter 'sliders' so the model was perhaps a little more intuitive.

Eventually, I decided that the best course of action was to jump into developing a ['shiny'](http://shiny.rstudio.com/) app again. I initially messed around with this package in 2013 when I had first started developing models of infectious diseases. Back then, I had this idea of publishing a paper and then saying "instead of some boring static figure, check out this interactive version so you can get a better feel for the model". Those days soon passed, luckily.

But now, with this impending project, I felt like now was an opportunity to check it out again. But first, I needed to verify a few things could be done with shiny running either locally or an RStudio server:

- Run a reactive dynamic model that can be manipulated in real-time using data input through a series of boxes and sliders.
- Interact with a GoogleSheet to import data and export results.
- Run some form of optimisation algorithm that would allow us to simulate a set of interventions to understand, for a given cost, how we can maximise health gains over a period of say five years.

Luckily, none of these issues presented much of a problem and after a day or so of playing around, I had a working (albeit basic) version of the model up and running.

The latest version can be found [here](https://jackolney.shinyapps.io/ShinyCascade). I would embed the model in an iframe here but, there are limits on the up-time I can use on RStudio's servers given that I only have a free account, and also I think the text width on this site would screw it all up. So head over there to check out my latest toy!
