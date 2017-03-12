---
title:  "Calling R from a Python instance"
date:   2015-07-01 09:41:00
description: R and Python play nice
categories: [programming]
tags: [R,python]
---

After spending several hours today trying to figure out how to call R from an instance of Python running on the departmental cluster, I figured that I better document this.

### Why bother?

Some background on my problem. I have an individual-based model written in C++ that describes the HIV epidemic in Kenya over time from 1970 to 2036/2056. This model is called through R which supplies a whole bunch of arguments allowing me to simulate a whole bunch of different scenarios. For some time now I have been using Python as a high-level manager for these simulations. I simple stick some python script in a directory, it creates all the directories, writes the R scripts, writes the .bat files and submits the jobs to the cluster.

Recently, I have been running a set of scenarios that involve learning from experience. I run some simulations and depending on the results, make some changes to the next set of simulations. A simple method for doing this was by running an R script across all the results and computing the changes that needed to be made. This was okay but if you want to run several hundred scenarios at once, it quickly becomes boring, and rather tedious.

I figured that I would write some python code that would deploy the simulations, wait for them to complete then run some analysis in R and then deploy the next set of simulations. Actually, rather than have my instance of Python sleep for a while and take up resources I kill it off and allow each simulation to check if the others are done, create a lock-file if they have finished and run some analysis.

This actually turned out better than my original plan, but I was still keen to know how to call R directly from my instance of python. The way I was submitting jobs and generally accessing the command line was by using the os module and calling:

{% highlight python %}
import os
os.system("job submit /scheduler:somewhere /numcores:lots \\somecomputer\somewhere\")
{% endhighlight %}

Yet, interestingly if I tried:

{% highlight python %}
os.system("Rscript \\somescript\somewhere")
{% endhighlight %}

I got nowhere. I then tried the absolute path to Rscript.exe (windows cluster), but to no avail. The solution turned out to be clunky.

{% highlight python %}
# Two methods:
import subprocess

# Either with \\ double backslash.
subprocess.call(["C:\\Program Files\\R\\R-3.0.1\\bin\\Rscript.exe","\\\\somecomputer\\someplace\\mydir\\Test\\Python\\test.R"]);

# or using the ignore escape character 'r'
subprocess.call([r"C:\Program Files\R\R-3.0.1\bin\Rscript.exe",r"\\somecomputer\someplace\mydir\Test\Python\test.R"]);

# It turns out that using os.system is odd.
# It needs to be in double-quotes then wrapped in single-quotes
# Then where to arguments go? Within the single-quotes but not the double-quotes. WTF!?
os.system('"C:\\Program Files\\R\R-3.0.1\\bin\Rscript.exe" --version')
{% endhighlight %}

Anyway, now we have the solution.
