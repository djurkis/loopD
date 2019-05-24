


## loopD

Simple Deamon that runs your jobs in specified intervals

The intended use is to first create a jobfile that will contain
formated jobs using `jobmaker.sh`, and then launch loopD in the backround
forever. It sleeps for a specified interval and then wakes up to execute
due jobs, therefore you can add jobs with jobmaker and continue using the same process.



```
OPTIONS
-h, --help        Prints help.
-j, --jobfile     Path to associated jobfile. (Default jobs in current Dir)
-v, --verbose     Print jobs when being performed.
-i, --inteval     Sets interval in seconds (Default 60 seconds).
-l, --log         Sets logging filepath (Default off).


COMMANDS
start             Starts a scheduling cycle
                  Executes due jobs and sleeps.




Examples of usage:    (loopDeamon.sh -j ~/jobs -i 60 start)&
```


## jobmaker

Tool to work with loopD since it is always running in the backround.



```
OPTIONS
-h, --help        Prints help.
-l, --list        List jobs.
-j, --jobfile     Sets path for jobfile. (Default jobs)
-f pathtofile     Specifies file as an inupt for updating jobs.


Format:

#  ┌───────────── minute (00 - 59)
#  │ ┌───────────── hour (00 - 23)
#  │ │ ┌───────────── day of month (01 - 31)
#  │ │ │ ┌───────────── month (01 - 12)
#  │ │ │ │ ┌───────────── day of week (1 - 7) (Monday to Sunday);
#  │ │ │ │ │
#  │ │ │ │ │
#  │ │ │ │ │
#  * * * * *  some-script

Where some-script is a single word name of an **executable** file
to be executed in a new shell.

Examples of usage:    ./jobmaker.sh -f jobsduringweekend -l
                      ./jobmaker.sh -j ~/mystuff/secretjobs -f forkbomb -l -h
```
