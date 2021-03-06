#!/bin/bash
rm -f gmt.conf
rm -f gmt.history

gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset MAP_FRAME_PEN thick
gmt gmtset MAP_TICK_PEN thick
gmt gmtset MAP_TICK_LENGTH_PRIMARY -3p
#gmt gmtset MAP_DEGREE_SYMBOL none
#gmt gmtset MAP_GRID_CROSS_SIZE_PRIMARY 0.0i
#gmt gmtset MAP_GRID_CROSS_SIZE_SECONDARY 0.0i
#gmt gmtset MAP_GRID_PEN_PRIMARY thin,black
#gmt gmtset MAP_GRID_PEN_SECONDARY thin,black
gmt gmtset MAP_ORIGIN_X 100p
gmt gmtset MAP_ORIGIN_Y 100p
#gmt gmtset FORMAT_GEO_OUT +D
gmt gmtset COLOR_NAN 255/255/255
gmt gmtset COLOR_FOREGROUND 255/255/255
gmt gmtset COLOR_BACKGROUND 0/0/0
gmt gmtset FONT 12p,Helvetica,black
#gmtset MAP_ANNOT_ORTHO snew
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter   
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

exampleFolder=example/
figfolder=$exampleFolder\figures/
mkdir -p $figfolder

parameterFile=$exampleFolder\input/PARAMETERS.h
stationNamePrefix=`grep output4 $parameterFile | cut -d \" -f 2`
stationFile=$exampleFolder`grep input0 $parameterFile | cut -d \" -f 2`
stationNumber=`wc -l $stationFile | awk '{ print $1 }'`
dt=`grep \ dt $parameterFile | cut -d "(" -f2 | cut -d ")" -f1`
nt=`grep Max_Time $parameterFile | cut -d "(" -f2 | cut -d ")" -f1`
timeFile=$exampleFolder\time
seq 0 $(($nt-1)) | awk -v dt="$dt" '{ print $1*dt}'>$timeFile

name=$stationNamePrefix
ps=$figfolder$name.ps
eps=$figfolder$name.eps
pdf=$figfolder$name.pdf

#for iStation in $(seq $stationNumber);
#do
iStation=1
x_stationNumber=`cat $stationFile | awk -v iStation="$iStation" 'NR==iStation{ print $1 }'`
y_stationNumber=`cat $stationFile | awk -v iStation="$iStation" 'NR==iStation{ print $2 }'`

originalxy=$exampleFolder$name$x_stationNumber\_$y_stationNumber

xmin=`gmt gmtinfo $originalxy -C | awk '{print $1}'`
xmax=`gmt gmtinfo $originalxy -C | awk '{print $2}'`
ymin=`gmt gmtinfo $originalxy -C | awk '{print $3}'`
ymax=`gmt gmtinfo $originalxy -C | awk '{print $4}'`

x_normalization=`echo $xmin $xmax | awk ' { if(sqrt($1^2)>(sqrt($2^2))) {print sqrt($1^2)} else {print sqrt($2^2)}}'`
y_normalization=`echo $ymin $ymax | awk ' { if(sqrt($1^2)>(sqrt($2^2))) {print sqrt($1^2)} else {print sqrt($2^2)}}'`

normalization=`echo $x_normalization $y_normalization | awk ' { if($1>$2) {print $1} else {print $2}}'`

timeDuration=`echo "(($nt-1)*($dt))" | bc -l`
region=0/$timeDuration/-1/1
projection=X2.2i/0.8i
XOffset=2.2i
YOffset=0.85i

resampling=10
gmt gmtset MAP_FRAME_AXES wesn
paste -d " " $timeFile $originalxy | awk -v resampling="$resampling" -v normalization="$normalization" 'NR%resampling==0 {print $1, $2/normalization}' | gmt psxy -J$projection -R$region -Bxa2f1+l"Time (s)" -Bya1f0.5+l"Amplitude" -Wthin,black -K > $ps
echo "3 0.5 X" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
echo "0.25 -0.75 Left" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
gmt gmtset MAP_FRAME_AXES wesn
paste -d " " $timeFile $originalxy | awk -v resampling="$resampling" -v normalization="$normalization" 'NR%resampling==0 {print $1, $3/normalization}' | gmt psxy -J -R -B -Wthin,black -O -K -X$XOffset>> $ps
echo "3 0.5 Z" | gmt pstext -R -J -F+jLB -N -O -K >> $ps

iStation=2
x_stationNumber=`cat $stationFile | awk -v iStation="$iStation" 'NR==iStation{ print $1 }'`
y_stationNumber=`cat $stationFile | awk -v iStation="$iStation" 'NR==iStation{ print $2 }'`

originalxy=$exampleFolder$name$x_stationNumber\_$y_stationNumber

xmin=`gmt gmtinfo $originalxy -C | awk '{print $1}'`
xmax=`gmt gmtinfo $originalxy -C | awk '{print $2}'`
ymin=`gmt gmtinfo $originalxy -C | awk '{print $3}'`
ymax=`gmt gmtinfo $originalxy -C | awk '{print $4}'`

x_normalization=`echo $xmin $xmax | awk ' { if(sqrt($1^2)>(sqrt($2^2))) {print sqrt($1^2)} else {print sqrt($2^2)}}'`
y_normalization=`echo $ymin $ymax | awk ' { if(sqrt($1^2)>(sqrt($2^2))) {print sqrt($1^2)} else {print sqrt($2^2)}}'`

normalization=`echo $x_normalization $y_normalization | awk ' { if($1>$2) {print $1} else {print $2}}'`


resampling=10
gmt gmtset MAP_FRAME_AXES WeSn
paste -d " " $timeFile $originalxy | awk -v resampling="$resampling" -v normalization="$normalization" 'NR%resampling==0 {print $1, $2/normalization}' | gmt psxy -J$projection -R$region -Bxa2f1+l"Time (s)" -Bya1f0.5+l"Amplitude" -Wthin,black -X-$XOffset -Y-$YOffset -O -K >> $ps
echo "3 0.5 X" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
echo "0.25 -0.75 Right" | gmt pstext -R -J -F+jLB -N -O -K >> $ps
gmt gmtset MAP_FRAME_AXES wesn
paste -d " " $timeFile $originalxy | awk -v resampling="$resampling" -v normalization="$normalization" 'NR%resampling==0 {print $1, $3/normalization}' | gmt psxy -J -R -B -Wthin,black -O -K -X$XOffset>> $ps
echo "3 0.5 Z" | gmt pstext -R -J -F+jLB -N -O >> $ps

gmt psconvert -A -Te $ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps $eps
rm -f $figfolder/ps2raster_*bb
#done


rm -f gmt.conf
rm -f gmt.history
