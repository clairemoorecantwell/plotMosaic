# plotMosaic

plotMosaic.R is a wrapper function for mosaicplot in the MASS package.  It's purpose in life is to make it easier to quickly create and then save as pdf/eps a mosaic plot of your data.  It has lots of options for subsetting and reorganizing your data (see below), and for saving it.  It uses CairoPDF to save to pdf, and the postscript() function to save to postscript.

I welcome suggestions for additional functionality, or for replacing the Cairo part of the script, since it seems kinda buggy.  (NOTE: it uses Cairo and not the pdf() function because Cairo is good at printing IPA symbols correctly, which was important to me at the time I wrote the script.)

Info, copied from the header of the actual R file:

#required parameters:
# x: factor whose levels you want along the x axis (top of the mosaic plot)
# y: factor whose levels you want along the y axis (left of the mosaic plot)
#
# options:
# main: main title for the plot.  Same as in plot()
# xlab, ylab: axis labels
# col: array of color values, ideally one for each level of your y factor. defaults to two greyscale colors
# exclude: array of levels of either factor to exclude from plotting e.g. c("i","ah","preantepenultimate","other","NA") would exclude any levels in either factor called any of these things
# textcol: what color do you want the text on the mosaicplot to be?
# cex: character expansion factor for text on the plot
# savefile: if true, will try to save the file.  Will need filename and path to be specified
# ps: DEFAULTS TO TRUE if true, saves file as .eps.  If false, saves file as pdf using Cairo
# path: path where your file should be saved.  Does nothing if savefile=FALSE
# filename: filename to be given to your saved file. Does nothing if savefile=FALSE
# height,width: parameters passed to the eps or pdf generator
# dimnames: rename the levels of x,y for labeling the axis of the plot?  Takes a list of two arrays of names: dimnames=list(c(names of x), c(names of y)).  For example, if your x is a factor with levels "A" and "P", and your y is a factor with levels "iy" and "ey" you could rename those for display purposes with dimnames=list(c("Antepenultimate","Penultimate"),c("i","e")).  ORDER MATTERS.  IF you use the `order' option, make sure you list the names in the same order you specified the levels to appear in in the order parameter.
# nums: defaults to TRUE, which means numbers are plotted in the mosaicplot.  If FALSE, no numbers are plotted.
# top: defaults to FALSE. if TRUE, numbers must be aligned to the top of the plot (if FALSE, numbers are aligned to the top only when there is no room at the bottom)
# font: specify the font for file output. defaults to "Times"
# order: re-order levels in your factor. this should be a list of the form list(c(levels of x in order),c(levels of y in order))  Specify the levels by their un-renamed names if you used dimnames ("P","A") not ("Penultimate","Antepenultimate").  If you only want to reorder one factor, set the other to NULL: order=list(c("P","A"),NULL). This re-ordering uses the alphabet, so if you have more than 26 levels it will fail.  Also, levels not specified here but which do appear in the graph will appear alphabetically in relation to the specified order of the other levels.
# noNums: suppress text for some columns of the plot but not all? noNums should be a vector of indices of columns for which you want to suppress writing of text.  For example, noNums=c(2,4) would suppress text on the second and fourth columns of the finished plot.  Note that if you re-ordered, these indices should apply to the re-ordered ordering of columns.
