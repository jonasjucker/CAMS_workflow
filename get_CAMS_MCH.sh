#!/bin/ksh


        # Specifies the shell that parses the script. If not
        # specified, your login shell will be used.

#SBATCH --workdir=/scratch/ms/ch/cha/cams
#NOPE#SBATCH --qos=long
#SBATCH --qos=long

        # Specifies that your job should be run in the class (queue)
        # express.

#SBATCH --job-name=getCAMS

        # Assigns the specified name to the request

#SBATCH --output=getCAMS.%j.out

        # Specifies the name and location of STDOUT. If not given, the
        # default is /dev/null.  The file will be written in the
        # submitting directory, by default.

#SBATCH --error=getCAMS.%j.out

        # Specifies the name and location of STDERR. If not given, the
        # default is /dev/null.  The file will be written in the
        # submitting directory, by default.


        # Specifies that all environment variables from your shell
        # should be used. You can also list individual variables which
        # should be separated with semicolons.

#SBATCH --mail-type=FAIL

        # Specifies that email should be sent in case the job failes.
        # Other options include always, complete, start, and
        # never. The default is notification = complete.


        # Specifies the total CPU time which can be used by all
        # processes of a serial job step. In this job the hard limit
        # is set to 1 min and the soft limit to 55 sec. Note: All
        # limits are capped by those specified in the class.


        # The queue statement marks the end of your LoadLeveler
        # keyword definitions and places your job in the queue. At least
        # one queue statement is mandatory. It must be the last keyword
     # specified. Any keywords placed after this in the script are
        # ignored by the current job step.


NUMLEVS=60

# variables passed as argument
YEAR=$1
MONTH=$2
DAY=$3
TIME=$4
period=$5

# create directory and clean it, if already present
mkdir -p /scratch/ms/ch/cha/cams/period${period}/${YEAR}${MONTH}${DAY}${TIME}
cd /scratch/ms/ch/cha/cams/period${period}/${YEAR}${MONTH}${DAY}${TIME}
rm -f C3macc_*.tar.gz > /dev/null 2>&1

# mars retrive for CAMS
for STEP in `seq 0 3 80`; do

mars << eof
retrieve,
step = $STEP,
date=$YEAR-$MONTH-$DAY,
time=${TIME}:00:00,
class = mc,
stream = oper,
expver = 0001,
type = fc,
levtype = ml,
levelist = 1/to/${NUMLEVS},
interpolation = nearest_lsm,
par = aermr01/aermr02/aermr03/aermr04/aermr05/aermr06/aermr07/aermr08/aermr09/aermr10/aermr11,
grid = 0.1/0.1,
area = 11.5/-18.3/-10.7/8.0,
rot = -43.0/10.0,
target = C3macc_ml60_${YEAR}-${MONTH}-${DAY}-${TIME}-${STEP}.grb
eof

# pack into tar
/bin/tar cfz C3macc_${YEAR}-${MONTH}-${DAY}-${TIME}-${STEP}.tar.gz C3macc_*_${YEAR}-${MONTH}-${DAY}-${TIME}-${STEP}.grb
rm -f C3macc_*_${YEAR}-${MONTH}-${DAY}-${TIME}-${STEP}.grb
done
