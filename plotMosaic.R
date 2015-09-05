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

plotMosaic <- function(x,y,main="Mosaic Plot",xlab="",ylab="",col=grey(c(0.2,0.8)),exclude=NULL,textcol="black",cex=1.5,savefile=FALSE,ps=TRUE,path="",filename,height=5,width=5,dimnames=NULL,nums=TRUE,top=FALSE,font="Times",order=NULL,noNums=NULL){
	
	library(MASS)

if(savefile){
	if(ps){
	postscript(paste(path,filename,".eps",sep=""), horizontal=FALSE, onefile=FALSE,paper="special", family=font, height=height,width=width,print.it=TRUE)
	} else {
		
	library(Cairo)	
	CairoFonts(
	regular="Times:style=Regular",
	bold="Times:style=Bold",
	italic="Times:style=Italic",
	bolditalic="Times:style=Bold Italic,BoldItalic",
	symbol="Symbol"
)

CairoPDF(paste(path,filename,".pdf",sep=""), paper = "special", family='Times', width=width, height=height)
		
	}
}	
	#order=c("ah","an","iy","al","er")
	if(length(order[[1]])){
		x=as.character(x)
		for(i in 1:length(order)){
			x[x==order[i]]=paste(letters[i],order[i],sep="")
		}
		x=as.factor(x)
	}
	
	if(length(order[[2]])){
		y=as.character(y)
		for(i in 1:length(order)){
			y[y==order[i]]=paste(letters[i],order[i],sep="")
		}
		y=as.factor(y)
	}

	plotthing=table(x,y,exclude=exclude)	
	if(length(dimnames)>0){dimnames(plotthing)=dimnames}
	
	mosaicplot(plotthing,col=col,main=main,xlab="",ylab="",cex=cex)
	print(chisq.test(plotthing))
	
	#calculate the location of text labels
	bottomPers=plotthing[,-1]/rowSums(plotthing)
	topPers=plotthing[,1]/rowSums(plotthing)
	
	#x coordinates: middle of each bar
	widths=rowSums(plotthing)/sum(plotthing)
	xcoords=rep(0,length(widths))
	for(i in 1:length(widths)){
		if(i>1){
		xcoords[i]=(widths[i]/2)+sum(widths[1:i-1])
		} else {xcoords[i]=widths[i]/2}
	}
	
	# Align to top if aligning to the bottom doesn't fit the text
	m=min(bottomPers)
	if(m<0.15|top){
		top=TRUE
		mt=min(topPers)
		max=max(bottomPers)
		}
	if(top){
		numbers=plotthing[,1] #c(plotthing[1,1],plotthing[2,1])
		pers=ifelse(topPers,paste(100*round(topPers,2),"%",sep=""),"0")
		ycoordsN=rep((max+mt)-0.25*mt,length(topPers))
		ycoordsP=rep((max+mt)-0.25*mt-cex*strheight(numbers[1],cex=cex)+0.5*cex*strheight(numbers[1],cex=cex),length(topPers))	
	}else{
	#numbers aligned to the bottom
	numbers=plotthing[,2]
	pers=ifelse(bottomPers,paste(100*round(bottomPers,2),"%",sep=""))
	ycoordsN=c(0.1*m,0.1*m)
	ycoordsP=c(0.1*m+cex*strheight(numbers[1],cex=cex)+0.5*cex*strheight(numbers[1],cex=cex),0.1*m+cex*strheight(numbers[1],cex=cex)+0.5*cex*strheight(numbers[1],cex=cex))
	}
	
	if(length(noNums)){#noNums is NULL by default, but cal be specified as a vector of indices of text to be left out.  For example, if you want to supress the number on the third column of your mosaic plot, noNums=3.  If you want to suppress both the third and fifth columns' numbers, noNums=c(-3,-5)
		xcoords=xcoords[-1*noNums]
		ycoordsN=ycoordsN[-1*noNums]
		ycoordsP=ycoordsP[-1*noNums]
		numbers=numbers[-1*noNums]
		pers=pers[-1*noNums]
	}
	
	if(nums){
	text(xcoords,ycoordsN,numbers,cex=cex,col=textcol)
	text(xcoords,ycoordsP,pers,cex=cex,col=textcol,pos=1)
	mtext(paste('total: ', sum(plotthing), sep=""), side=1, line=1.3, cex=cex, at=0.9,col="black")
	}
	mtext(xlab,side=3,line=0.5,cex=cex/1.6,at=0.5,font=2)
	mtext(ylab,side=2,line=0.5,cex=cex/1.5,at=0.5,font=2)
	


if(savefile){dev.off()}
}
