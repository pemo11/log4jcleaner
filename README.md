# log4jcleaner
A PowerShell script that is supposed to remove the critical JndiLookup.class from certain versions of a log4j-core-2.x.jar

!!! Important !!!

The script is a response to the immediate danger posed by the Log4j "bug" caused by an overlooked design flaw

The idea is to remove the critical JndiLookup.class from the jar file without replacing the jar file.

This could have been helpful shortly after the day the vulnerability was made public, Dec 5th.

Now its probably much better to update the Log4j jar to the current version.

The script might be still helpful in situations where an update is not possible.

!!! Warning !!!

The script is tested but it will probably needs more testing.

The current version is working but its more a "template" for a script that could be used to address the vulnerability of a Log4j version like 2.12

by removing the class file.

I have not tested this technique with Log4j version 1.x - from what I have read deleting the class might lead to an exception.

The script currently works only localy but it would be no problem to start with Invoke-Command on any number of remote computer.

The script needs either Windows PowerShell 5.1 or PowerShell version 7.x.

I tested it on Mac OS.

Feel free to adapt this script to your own needs.

What I like most about my script is the general approach which could server as a template for other scripts:

>Provided as a psm1 file for more flexibility
>Reading parameters from a config file
>Localized messages with psd1 files
>A simple logging (without Log4j;)
>A few simple Pesters tests
>Hopefully enough comments
