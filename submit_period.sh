#!/bin/ksh

# scripts to submit get_CAMS_MCH.sh on ecaccess at ECMWF

# period 1: 13.2-20.2 2019
# period 2: 23.6-30.6 2019
# period 3: 1.12-7.12 2018
# period 4: 6.6-13.6  2018 (extended from 1.6 until 15.6)
# period 5: 1.4-30.4  2019
# period 6: 1.6-30.6  2019

# define dates for period
year=2019
month=06
hour=00
period=6

# days from 1-9
for day in {1..9} 
do
	sbatch --qos=normal --job-name=${period}CAMS0$day get_CAMS_MCH.sh $year $month 0$day $hour $period
	echo "$year${month}0${day}$hour submitted"
done

# day from 10-31
for day in {10..22} 
do
	sbatch --qos=normal --job-name=${period}CAMS$day get_CAMS_MCH.sh $year $month $day $hour $period
	echo "$year${month}${day}$hour submitted"
done
