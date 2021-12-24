# log4jcleaner
A PowerShell script that is supposed to remove the critical JndiLookup.class from certain versions of a log4j-core-2.x.jar

!!! Important !!!

The script is a response to the immediate danger posed by the Log4j "bug" caused by an overlooked design flaw

The idea is to remove the critical ***JndiLookup.class*** from the jar file without replacing the jar file.

This could have been helpful shortly after the day the vulnerability was made public, Dec 5th.

Now its probably *much better* to update the Log4j jar to the current version.

The script might be still helpful in situations where an update is not possible.

*!!! Warning !!!*

The script is tested but it will probably needs more testing.

The current version is working but its more a "template" for a script that could be used to address the vulnerability of Log4j version like 2.12 by removing the class file.

I have not tested this technique with Log4j version 1.x - from what I have read deleting the class might lead to an exception.

The script currently works only localy but it would be no problem to start it with Invoke-Command on any number of remote computers and with different search pathes for each computer.

The script requires either Windows PowerShell 5.1 or PowerShell version 7.x.

I have tested it succesfully on Mac OS.

Feel free to adapt this script to your own needs.

How to use it
---------------

the first and only requirement is that the Execution Policy allows executing scripts

íf not use either one of these commands first:

Set-ExecutionPolicy Unrestricted -Force

or

Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

Set the search path in Script.config

Start the ScriptStarter.ps1

The execution of the script will take a couple of minutes. Especially the updating of the archive.

If everything runs fine there will be a couple of messages and the JndiLookup.class file should be removed from the jar file (s).

If they are any errors (they probably will be) the log file might be helpful.

** a little self-praise at the end;) **

What I like most about my script is the general approach which could serve as a kind of template for other scripts:

- Provided as a psm1 file for more flexibility
- Reading parameters from a config file
- Using pipeline parameters so the ps1-file could be part of a pipeline
- Localized messages with psd1 files
- A simple logging (without Log4j;)
- A few simple Pesters tests
- Hopefully enough comments
