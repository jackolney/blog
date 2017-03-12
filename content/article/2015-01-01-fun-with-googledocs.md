---
title:  "Fun with GoogleDocs API"
date:   2015-01-01 09:41:00
description: Reading a GoogleDoc into R
categories: [Google]
tags: [Google]
---

I wanted to document some code for accessing documents (only spreadsheets at the moment) through GoogleDocs using the DIDE cluster and R.

### Getting started.
The R code is fairly self explanatory but involves two little tricks to get it to work: (1) manipulating the GoogleDocs URL to export the document as a csv and (2) changes the privilages on the document such that anyone with the link can edit (done under sharing).

{% highlight r %}
# Set working directory.
setwd("[yourWorkingDirectory]")

# Install RCurl on cluster.
install.packages("RCurl",repos="http://cran.ma.imperial.ac.uk",lib="[yourLibraryDirectory]")

# Now, with the desired GoogleSpreadsheet open in your browser copy the "Key" (the series of numbers and letters after /d/...) from the URL and insert it where [yourDocumentKey] is.
url <- "https://docs.google.com/spreadsheets/d/[yourDocumentKey]/export?format=csv"

# In your browser, go to "Share" and alter the document privilages so "anyone with a link can view".

# Load up RCurl (bitops is required by RCurl so best to load that too.)
require(bitops,lib.loc="[yourLibraryDirectory]")
require(RCurl,lib.loc="[yourLibraryDirectory]")

# Set ssl.verifypeer to FALSE.
myCsv <- getURL(url,.opts=list(ssl.verifypeer=FALSE))

# Parse csv data.
testCsv <- read.csv(textConnection(myCsv))

# Print out result.
print(testCsv)
flush.console()

# SUCCESS!

{% endhighlight %}
