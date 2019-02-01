#! /usr/local/bin/perl5

use FileHandle;
STDOUT->autoflush();
STDERR->autoflush();

# Program: rss_flow.pl
# Author : Steve Weigand
# Company: Centaur Technology
# Descr. : Run the Random Spice Simulation jobs.
#
# $Log: rss_flow.pl,v $
# Revision 1.92  2014/02/17 23:31:38  weigand
# Added VIA test stuff.
#
# Revision 1.91  2012/12/10 17:56:36  weigand
# Changed path of findnet.pl
#
# Revision 1.90  2012/10/23 21:35:52  weigand
# *** empty log message ***
#
# Revision 1.89  2012/10/05 18:21:46  weigand
# More codebase.
#
# Revision 1.88  2012/10/05 18:14:13  weigand
# codebase mods.
#
# Revision 1.87  2012/10/04 23:02:08  weigand
# Adapted for codebase use.
#
# Revision 1.86  2012/04/11 21:35:20  weigand
# Got rid of hsim queue stuff. Now merged with xa queue.
#
# Revision 1.85  2012/01/11 20:55:07  weigand
# Upped the crash limit for data prep.
#
# Revision 1.84  2011/12/02 18:31:50  weigand
# One more hack for dirs properties.
#
# Revision 1.83  2011/12/01 22:46:54  weigand
# Another fix for dirs properties.
#
# Revision 1.82  2011/12/01 20:03:21  weigand
# Put the temp files in .psub_tempfiles directories to unclutter things.
#
# Revision 1.81  2011/10/27 22:10:19  weigand
# Updated slot limit.
#
# Revision 1.80  2011/10/27 22:08:51  weigand
# Changed handling of batch queue. Updated user/bot queue limits.
#
# Revision 1.79  2011/08/08 17:53:23  weigand
# changed xa license name from fastspice_xa to xsim.
#
# Revision 1.78  2011/02/11 23:43:04  weigand
# Added some "dirs" dirs.
#
# Revision 1.77  2010/11/17 19:08:31  weigand
# Removed datestamp marker file.
#
# Revision 1.76  2010/11/15 20:17:04  weigand
# Modified "dirs" properties to do nfs file synching.
#
# Revision 1.75  2010/06/16 21:51:20  weigand
# Shelley's licenses restored to normal.
#
# Revision 1.74  2010/06/02 19:56:36  weigand
# Mods for shelley license count.
#
# Revision 1.73  2010/05/19 21:48:44  weigand
# Modified vxl queue count.
#
# Revision 1.72  2010/03/11 19:55:32  weigand
# Added file locking to help with the removal of temporary files.
#
# Revision 1.71  2010/03/10 22:08:27  weigand
# Fix bug in manual flow.
#
# Revision 1.70  2010/02/16 19:23:58  weigand
# *** empty log message ***
#
# Revision 1.69  2010/02/16 19:20:49  weigand
# Added -priority.
#
# Revision 1.68  2010/01/19 00:55:43  weigand
# Handles xa and hspice now.
#
# Revision 1.67  2009/10/28 21:18:17  weigand
# Bug fix.
#
# Revision 1.66  2009/10/28 21:11:29  weigand
# Added the hsimbg and hsimmsbg queues.
#
# Revision 1.65  2009/10/28 20:22:21  weigand
# Minor change.
#
# Revision 1.64  2009/07/15 16:24:20  weigand
# Added cnb0c.
#
# Revision 1.63  2009/07/08 17:53:13  weigand
# Oops. Added back in RCS log header.
#
#
# Revision 1.62  2009/07/09 12:50:00  weigand
# Added vxl queue to the data prep part of the flow for running verilog-xl.
#
# Revision 1.61  2009/05/18 21:24:30  weigand
# *** empty log message ***
#
# Revision 1.60  2008/09/24 18:39:42  weigand
# Minor bug fix.
#
# Revision 1.59  2008/09/24 17:47:36  weigand
# Scheduling of jobs has changed a bit. Now looks at date of last
# run and bumps up job priority for stuff that hasn't run in a
# long time.
#
# Revision 1.58  2008/07/23 21:41:08  weigand
# Back to linux queue for data prep.
#
# Revision 1.57  2008/07/23 18:03:39  weigand
# Temporary hack for running data prep jobs on dynacell queue machines
# since runv won't work with linux queue machines.
#
# Revision 1.56  2008/05/12 17:20:28  weigand
# *** empty log message ***
#
# Revision 1.55  2008/05/08 17:27:53  weigand
# *** empty log message ***
#
# Revision 1.54  2008/03/09 17:33:22  weigand
# Re-enabled timing runs for cnb.
#
# Revision 1.53  2008/03/03 22:13:01  weigand
# Fixed bug relating to unchanged jobs.
#
# Revision 1.52  2008/03/03 21:37:55  weigand
# *** empty log message ***
#
# Revision 1.51  2008/01/20 07:48:03  weigand
# *** empty log message ***
#
# Revision 1.50  2008/01/20 06:27:04  weigand
# Fixed bugs.
#
# Revision 1.49  2008/01/19 04:59:46  weigand
# Temporary hack.
#
# Revision 1.48  2008/01/19 04:49:44  weigand
# Added hacks for cnb netlist ssb conversion (Fujitsu).
#
# Revision 1.47  2007/12/06 03:14:59  weigand
# Changed path to cenlic.
#
# Revision 1.46  2007/07/17 22:04:25  weigand
# Minor update.
#
# Revision 1.45  2007/05/09 18:40:46  weigand
# Added lnx4 and lnxbig queues.
#
# Revision 1.44  2007/05/09 17:29:01  weigand
# Number of slaves for linux decreased to prevent disk I/O bottlenecks.
#
# Revision 1.43  2007/05/08 19:31:01  weigand
# Got rid of hsimnsbat and hsimnsmsbat queues.
#
# Revision 1.42  2007/03/12 16:45:42  weigand
# Changed number of user ms slots.
#
# Revision 1.41  2007/01/18 05:48:06  weigand
# Took out unix and unixfast queues.
#
# Revision 1.40  2007/01/06 20:54:24  weigand
# Bug fix relating to new queue setup.
#
# Revision 1.39  2007/01/04 17:14:52  weigand
# Added ns queues.
#
# Revision 1.38  2006/11/08 21:33:37  weigand
# Minor update to queue submission.
#
# Revision 1.37  2006/11/08 02:02:00  weigand
# Changed queue submission stuff.
#
# Revision 1.36  2006/11/03 23:14:16  weigand
# Oops forgot to change to hsimmrg.
#
# Revision 1.35  2006/11/03 23:10:30  weigand
# Got rid of the hsim2ms queue. Changed hsimorg to hsimmrg for the
# hsimms queue submissions.
#
# Revision 1.34  2006/11/03 19:33:09  weigand
# Added -nohsim, -nohsim2, -nohsimms, -nohsim2ms.
#
# Revision 1.33  2006/10/31 20:34:54  weigand
# Huge changes.
#
# Revision 1.32  2005/06/03 20:34:13  weigand
# Added -emergency and -emergency2
#
# Revision 1.31  2005/05/23 21:43:54  weigand
# Minor fix.
#
# Revision 1.30  2005/05/23 21:39:50  weigand
# Modified handling of ps output.
#
# Revision 1.29  2005/05/23 21:34:02  weigand
# Update to license file.
#
# Revision 1.28  2005/03/09 21:14:50  weigand
# Minor change.  Added socket interface to manual jobs.
#
# Revision 1.27  2005/03/01 19:54:26  weigand
# License daemon changed its format,  so I had to modify the license
# availability checks.
#
# Revision 1.26  2005/02/21 22:40:19  weigand
# Minor changes to the manual flow.  Now no longer cleans up crashed run
# directories that don't belong to this run.  Same with fixing interrupted
# ops.
#
# Revision 1.25  2005/02/17 18:45:25  weigand
# Fixed a minor typo which wasn't a bug.
#
# Revision 1.24  2005/01/13 18:41:12  weigand
# Minor changes.
#
# Revision 1.23  2005/01/12 03:23:22  weigand
# Added detection of changed timing models.
#
# Revision 1.22  2004/05/28 21:32:13  weigand
# Added real-time reporting of crashes for parts 3 and 4.
#
# Revision 1.21  2004/04/12 17:58:55  weigand
# Bumped down the number of unix slaves.
#
# Revision 1.20  2004/04/05 21:13:31  weigand
# Added bad directory protection through psub.
#
# Revision 1.19  2004/03/19 19:06:27  weigand
# Changed perl version.
#
# Revision 1.18  2004/03/09 19:57:15  weigand
# Minor update.
#
# Revision 1.17  2004/03/05 04:17:48  weigand
# Another tweak to -nobat
#
# Revision 1.16  2004/03/04 20:08:01  weigand
# Minor tweak with -nobat.
#
# Revision 1.15  2004/03/04 20:00:39  weigand
# Added -nobat option.
#
# Revision 1.14  2004/01/21 20:49:34  weigand
# Modified to limit bot to 1 hsimms license while allowing free
# access to all hsimms licenses for the manual flow.
#
# Revision 1.13  2004/01/12 23:16:57  weigand
# Added an extra day before it resets the flow.
#
# Revision 1.12  2003/12/20 22:00:56  weigand
# Added filehandle autoflush.
#
# Revision 1.11  2003/12/17 20:22:17  weigand
# Slightly modified Manual_SetSlaves subroutine.
#
# Revision 1.10  2003/10/31 20:45:57  weigand
# Now gets the lmstat path correct on linux boxes.
#
# Revision 1.9  2003/10/27 16:42:51  weigand
# Minor fix.
#
# Revision 1.8  2003/10/24 21:48:56  weigand
# Added socket.
#
# Revision 1.7  2003/10/20 20:12:38  weigand
# Fixed bug with EmailUser.
#
# Revision 1.6  2003/09/17 18:59:00  weigand
# Minor mod.
#
# Revision 1.5  2003/09/10 20:34:42  weigand
# Added sending of email during crash detection.
#
# Revision 1.4  2003/09/04 16:19:11  weigand
# Bug fix.
#
# Revision 1.3  2003/08/28 22:23:58  weigand
# Minor mod.
#
# Revision 1.2  2003/08/26 20:25:43  weigand
# Minor mod.
#
# Revision 1.1  2003/08/26 17:10:30  weigand
# Initial revision
#
#

use Sys::Hostname;
use Cwd 'abs_path';

require "/vlsi/cad2/bin/psub.pm"; ## Psub - Parallel Job Submission.
require "/vlsi/cad2/bin/crc32_loader.pm";
require "/vlsi/cad2/bin/file_lock.pm"; ## File Locking

if ($#ARGV == -1) { &Usage(); }

@opCTRL = ();
%opRUN = ();
$opRUN_something = 0;
$opWORKDIR = "";
$opRESULTSDIR = "";
$opBAT = 0;
$opBOT = 0;
$opNOBAT = 0;
$opEMERGENCY = 0;
$opEMERGENCY2 = 0;
$opPRIORITY = "";

while ($#ARGV != -1) {
  $arg = shift(@ARGV);
  if ($arg eq "-ctrl") {
    $arg = shift(@ARGV);
    while (($arg ne "") && (substr($arg,0,1) ne "-")) {
      push(@opCTRL,$arg);
      $arg = shift(@ARGV);
    } ## End while
    if (substr($arg,0,1) eq "-") { splice(@ARGV,0,0,$arg); }
  } ## End elsif
  elsif ($arg eq "-run") {
    $arg = shift(@ARGV);
    while (($arg ne "") && (substr($arg,0,1) ne "-")) {
      $opRUN{$arg} = 1;
      $opRUN_something = 1;
      $arg = shift(@ARGV);
    } ## End while
    if (substr($arg,0,1) eq "-") { splice(@ARGV,0,0,$arg); }
  } ## End elsif
  elsif ($arg eq '-workdir') { $opWORKDIR = shift(@ARGV); }
  elsif ($arg eq '-resultsdir') { $opRESULTSDIR = shift(@ARGV); }
  elsif ($arg eq '-bat') { $opBAT = 1; }
  elsif ($arg eq '-bot') { $opBOT = 1; }
  elsif ($arg eq '-emergency') { $opEMERGENCY = 1; }
  elsif ($arg eq '-emergency2') { $opEMERGENCY2 = 1; }
  elsif ($arg eq '-nobat') { $opNOBAT = 1; }
  elsif ($arg eq '-priority') { $opPRIORITY = shift(@ARGV); }
  elsif (($arg eq '-help') || ($arg eq '--help')) { &Usage(); }
  else {
    print "ERROR: Unknown command line argument: $arg\n";
    &Usage();
  } ## End else
} ## End while

if (($opEMERGENCY == 1) || ($opEMERGENCY2 == 1)) {
  $opNOBAT = 1;
  $opBAT = 0;
}

if ($opBAT && $opNOBAT) {
  print "ERROR: You can't use -bat and -nobat together.\n";
  exit(1);
}

$USER = getpwuid($>);
if ($opBOT && ($USER ne "bot")) {
  print "ERROR: You must be user \"bot\" to run in -bot mode.\n";
  exit(1);
}

## Un-comment out the following if testing...
#if (($USER ne "weigand") && ($USER ne "bot")) {
#  print << 'EOF';
#
#Sorry. The rss flow is currently down for maintenance.
#
# - Steve
#
#EOF
#  exit(1);
#}


$CHIP = $ENV{"CHIP"};
$CHIPBRF = $ENV{"CHIPBRF"};
$CADHOME = $ENV{"CADHOME"};
$CENTHOME = $ENV{"CENTHOME"};

$HOME = $ENV{"HOME"};
if ((! $opBOT) && ($HOME eq "")) {
  print "ERROR: You must set your HOME environment variable first.\n";
  exit(1);
}
if (! -e "$HOME/.cshrc") {
  print "ERROR: Could not find $HOME/.cshrc.\n";
  exit(1);
}

## Set the server hostname.
$HOSTNAME = $ENV{"HOST"};
if ($HOSTNAME eq "") {
  $HOSTNAME = (gethostbyname(hostname()))[1];
  $check_iaddr = gethostbyname($HOSTNAME);
  if (!$check_addr) {
    $HOSTNAME = hostname();
    $check_iaddr = gethostbyname($HOSTNAME);
    if (!check_iaddr) {
      print "ERROR: Unable to resolve hostname of the machine you're running on.\n";
      exit(1);
    }
  }
}
$HOSTNAME =~ s/\.centtech\.com$//;

if (($opPRIORITY ne "") && (($opPRIORITY <= 0) || ($opPRIORITY !~ /^[0-9]+$/))) {
  print "ERROR: The -priority option must be set to positive, non-zero integer.\n";
  exit(1);
}


if (!$opBOT) {
  if ($#opCTRL == -1) {
    print "ERROR: You need to specify the -ctrl option.\n";
    exit(1);
  }
  %TMPU = ();
  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    if (! -e $real_ctrlfile) {
      print "ERROR: Can't find control file: $real_ctrlfile\n";
      exit(1);
    }
    @line = split(/\//,$real_ctrlfile);
    if ($#line < 1) {
      print "ERROR: Bad syntax \"-ctrl $ctrlfile\" ... Make sure you list the control file with \"\$userdir/\$controlfile\".\n";
      exit(1);
    }
    $userdir = $line[$#line - 1];
    $partial_controlfile = $userdir . "/" . $line[$#line];
    if ($TMPU{$userdir} != 0) {
      print "ERROR: There's more than one control file by the same userdir ($userdir).\n";
      exit(1);
    }
    $TMPU{$userdir} = 1;
  }
  %TMP = ();
  foreach $userrundir (sort(keys(%opRUN))) {
    if ($opRUN{$userrundir} == 0) { next; }
    @line = split(/\//,$userrundir);
    $userdir = shift(@line);
    if ($#line != 0) {
      print "ERROR: \"-run $userrundir\" is bad syntax.  Must be \$userdir/\$rundir.  No absolute path names.  Only one slash.\n";
      exit(1);
    }
    if ($TMPU{$userdir} == 0) {
      print "ERROR: \"-run $userrundir\" has userdir ($userdir) which doesn't correspond with any control file you listed.\n";
      exit(1);
    }
    $TMPU{$userdir} = 2;
  }
  if ($opRUN_something) {
    foreach $userdir (sort(keys(%TMPU))) {
      if ($TMPU{$userdir} == 1) {
        print "ERROR: Control file corresponding to userdir \"$userdir\" is not going to be run because it's not mentioned in the -run option.  Please remove that control file from the -ctrl option or include it in the -run option.\n";
        exit(1);
      }
    }
  }
  %TMP = ();
  %TMPU = ();
  if ($opWORKDIR eq "") {
    $opWORKDIR = "$CHIP/random_spice/manual_running";
  }
  if ($opRESULTSDIR eq "") {
    $opRESULTSDIR = "$CHIP/random_spice/manual_results";
  }
  if (! -e $opWORKDIR) {
    print "ERROR: Working directory does not exist: $opWORKDIR\n";
    exit(1);
  }
  if (! -e $opRESULTSDIR) {
    print "ERROR: Results directory does not exist: $opRESULTSDIR\n";
    exit(1);
  }

  $tmpworkdir1 = "";
  if (!open(IN,"/vlsi/bin/findnet.pl $opWORKDIR |")) {
    print "ERROR: Can't run command: /vlsi/bin/findnet.pl $opWORKDIR\n";
    exit(1);
  }
  $tmpworkdir1 = <IN>;
  chop($tmpworkdir1);
  close(IN);

  $tmpworkdir2 = "";
  if (!open(IN,"/vlsi/bin/findnet.pl $CHIP/random_spice/running |")) {
    print "ERROR: Can't run command: /vlsi/bin/findnet.pl $CHIP/random_spice/running\n";
    exit(1);
  }
  $tmpworkdir2 = <IN>;
  chop($tmpworkdir2);
  close(IN);

  if ($tmpworkdir1 eq $tmpworkdir2) {
    print "ERROR: You can't run in the \$CHIP/random_spice/running directory.  That's for the automated flows only!  Try using \"-workdir manual_running\" instead.\n";
    exit(1);
  }

  $tmpworkdir1 = "";
  if (!open(IN,"/vlsi/bin/findnet.pl $opRESULTSDIR |")) {
    print "ERROR: Can't run command: /vlsi/bin/findnet.pl $opRESULTSDIR\n";
    exit(1);
  }
  $tmpworkdir1 = <IN>;
  chop($tmpworkdir1);
  close(IN);

  $tmpworkdir2 = "";
  if (!open(IN,"/vlsi/bin/findnet.pl $CHIP/random_spice/results |")) {
    print "ERROR: Can't run command: /vlsi/bin/findnet.pl $CHIP/random_spice/results\n";
    exit(1);
  }
  $tmpworkdir2 = <IN>;
  chop($tmpworkdir2);
  close(IN);

  if ($tmpworkdir1 eq $tmpworkdir2) {
    print "ERROR: You can't put results in the \$CHIP/random_spice/results directory.  That's for the automated flows only!  Try using \"-resultsdir manual_results\" instead.\n";
    exit(1);
  }
}


$dateval = localtime;
print "$dateval: Starting\n";

if (-e "/usr/local/bin/gzip") { $GZIPPATH = "/usr/local/bin/gzip"; } ## Solaris
else { $GZIPPATH = "/bin/gzip"; } ## Linux

if (-e "/usr/local/bin/gtar") { $GTARPATH = "/usr/local/bin/gtar"; } ## Solaris
else { $GTARPATH = "/bin/gtar"; } ## Linux

$SOLARIS = 0;

if (open(TMPUN,"/bin/uname -s |")) {
  $UNAMEVALUE = <TMPUN>;
  close(TMPUN);
  chop($UNAMEVALUE);
  if ($UNAMEVALUE =~ /Sun/i) { $SOLARIS = 1; }
}

if ($CENTHOME eq "/vlsi/centaur") {
  $MAIN_SCRATCH_DIR = "/n/scr_rss/ckttmp";
}
else {
  ## For /vlsi/via
  $MAIN_SCRATCH_DIR = "$CHIP/random_spice";
}

$HACK_NETLIST_DIR = "${MAIN_SCRATCH_DIR}/rss_tmp_cache";

if (($CHIPBRF =~ /^cnb/) && ($CHIPBRF ne "cnb") && ($CHIPBRF ne "cnb0c")) {
  ## Unfortunately, we've hard-coded cnb and cnb0c into this script for
  ## purpose of netlist hacking for stress dsl parameters.  Look for
  ## all occurrences of cnb and cnb0c here and add this chipbrf to the
  ## list of chips.  Then look at rss_flow.hack_netlist.pl and add it
  ## there if needed.
  ##
  ## This netlist hacking was only needed for these chips because of the
  ## different hspice technologies used (we use rev 1.0 for tt_tt*, but
  ## rev 1.1 for all other corners).
  print "ERROR: Oops. I haven't setup $CHIPBRF yet. This chip requires special handling. See Steve Weigand.\n";
  exit(1);
}

## Make sure we're executing from the codebase wrapper.pl script.
## By the way, these are only used for manual runs. For automated
## bot jobs, we'll need to figure out the codebase settings on an
## individual chip-by-chip basis, rather than just using these
## environment settings which are based only on the current chip...

$CODEBASE_CBDIR = $ENV{"CODEBASE_weigand_rss_CBDIR"};
$CODEBASE_CBNAME = $ENV{"CODEBASE_weigand_rss_CBNAME"};
$CODEBASE_PROJ = $ENV{"CODEBASE_weigand_rss_PROJ"};
$CODEBASE_BUILD = $ENV{"CODEBASE_weigand_rss_BUILD"};
$CODEBASE_BUILDDIR = $ENV{"CODEBASE_weigand_rss_BUILDDIR"};

if (($CODEBASE_CBDIR eq "") ||
    ($CODEBASE_CBNAME eq "") ||
    ($CODEBASE_PROJ eq "") ||
    ($CODEBASE_BUILD eq "") ||
    ($CODEBASE_BUILDDIR eq "")) {
  print "ERROR: Executing this script directly is forbidden. You must execute this script by linking to the codebase wrapper script and executing that link.\n";
  exit(1);
}

###############################################################################

  ## Set the limits of slots per user and for bot in the non-batch queues.
  ## The user or bot can only get these many slots in the non-batch queues,
  ## and the rest will go to the batch queues. Note that "XA" refers to
  ## both XA and Hsim, since they share licenses and are both in the "xa"
  ## queue. Hspice is on its own license and queue, though...
  $BOT_XA_SLOTS = 2;
  $BOT_HSPICE_SLOTS = 1;

  $USER_XA_SLOTS = 3;
  $USER_HSPICE_SLOTS = 2;

  if ($opBOT) {
    &DetermineCodebaseLocations();
  
    &ReadRunFile();

    &ReadReleasesFile(); ## releases_file.txt

    &ReadActiveFile();   ## rss_flow.pl.active    (which goes away after run)

    &KillRunIfNeeded();
  
    $STARTTIMEVAL = time;
    &WriteActiveFile();
  
    &MakeMainDirs();
    &FixInterruptedOps();
    &CleanUpCrashedRunDirs();
  
    &ScanForControlFiles();
    &DeleteOldResultDirs();
    &CreateNewResultDirs();

    &LaunchControlFileJobs();
  
    &ReadControlFileDumps();

    &FindAllLicenses();

#####################
## HACK CNB:
    &Hack_Spice();
    &Hack_ControlFileDumps();
##
#####################
  
    &PrepareRundirs();
  
    &LaunchDataPrepJobs();

    $result = &LaunchSimJobs();
  
    if ($result != 2) { &FixInterruptedOps(); }
    &CleanUpCrashedRunDirs();
    &CleanRunningDir();
  
    system("/bin/rm -f rss_flow.pl.active >/dev/null 2>&1");
  }
  else {
    ## Manual flow...
    %CHIPS = ();
    &Manual_ScanForControlFiles();
    &Manual_MakeUserDirs();
    &Manual_FixInterruptedOps();
    &Manual_CleanUpCrashedRunDirs();
    $SIG{"INT"} = sub {
      local $SIG{"INT"} = 'IGNORE';
      print "ERROR: Received interrupt signal.  Cleaning up files and aborting.\n";
      &Manual_CleanUpTempfiles();
      &Manual_FixInterruptedOps();
      file_lock::Done();
      exit(1);
    };
    &Manual_LaunchControlFileJobs();
    &Manual_ReadControlFileDumps();
    &Manual_FindBadRundirs();
    &Manual_FindAllLicenses();

#####################
## HACK CNB:
    &Manual_Hack_Spice();
    &Manual_Hack_ControlFileDumps();
##
#####################

    &Manual_PrepareRundirs();
    &Manual_LaunchDataPrepJobs();
    &Manual_CleanUpTempfiles();
    file_lock::Done();
    $result = &Manual_LaunchSimJobs();
    if ($result != 2) { &Manual_FixInterruptedOps(); }

    &Manual_CleanUpCrashedRunDirs();
    &Manual_CleanRunningDir();
  }

  $dateval = localtime;
  print "\n$dateval: Done.\n";
  exit(0);

###############################################################################
###############################################################################
sub DetermineCodebaseLocations {
  ## This will determine all of the codebase locations for each chip. Each
  ## chip can potentially point to a different build of the RSS flow code.
  ## So we're going to record that at:
  ##   $CODEBASE_LOCATIONS{$chipbrf}{"exists"} = 1;
  ##   $CODEBASE_LOCATIONS{$chipbrf}{"build"} = $buildname;
  ##   $CODEBASE_LOCATIONS{$chipbrf}{"builddir"} = $builddir;
  ##
  ## NOTE: This is for bot jobs only, so we don't use the $CODEBASE_BUILDDIR
  ## for the current chip. So no environment overrides are possible here.

  my ($builddir, $buildname, $chipbrf, @allfiles);
  local(*DIR);

  if (! opendir(DIR,"$CODEBASE_CBDIR/chips")) {
    print "ERROR: Can't read directory: $CODEBASE_CBDIR/chips : $!\n";
    exit(1);
  }
  @allfiles = readdir(DIR);
  closedir(DIR);
  foreach $chipbrf (@allfiles) {
    if (($chipbrf eq ".") || ($chipbrf eq "..")) { next; }
    if (! -l "$CODEBASE_CBDIR/chips/$chipbrf/rss") { next; }
    $builddir = &GimmeSimplePath("$CODEBASE_CBDIR/chips/$chipbrf/rss");
    if ($builddir eq "") { next; }
    $buildname = $builddir;
    $buildname =~ s/^.*\///;
    $CODEBASE_LOCATIONS{$chipbrf}{"exists"} = 1;
    $CODEBASE_LOCATIONS{$chipbrf}{"build"} = $buildname;
    $CODEBASE_LOCATIONS{$chipbrf}{"builddir"} = $builddir;
  }

  return 1;
} ## End sub DetermineCodebaseLocations
###############################################################################
sub ReadRunFile {
  local(*IN);
  %RUNFILE = ();
  $RUNFILE_USED = 0;

  if (! open(IN,"/home/users3/weigand/cron/rss.runfile.txt")) { return 1; }

  while(<IN>) {
    chop;
    s/\s+/ /g;
    s/ $//;
    s/^ //;
    if ($_ ne "") {
      $RUNFILE{$_} = 1;
      $RUNFILE_USED = 1;
    }
  }
  close(IN);

  return 1;
} ## End sub ReadRunFile
###############################################################################
sub ReadReleasesFile {
  ## Read in the releases_file.txt file ...  Store in global %CHIPS.

  local(*RELF,$dateval,$linecounter,@line,$appname,
        $projectname,$cadhome,$centhome,$releasename,$chipreltotal);

  if (!open(RELF,"</home/users3/weigand/cron/releases_file.txt")) {
    print "ERROR: Can't read file: /home/users3/weigand/cron/releases_file.txt\n";
    exit(1);
  }

  $dateval = localtime;
  print "$dateval: Reading releases_file.txt file.\n";

  $linecounter = 0;
  @CHIPRELEASES = ();

  while(<RELF>) {
    chop;
    s/\s+/ /g;
    s/^ //;
    s/ $//;

    $linecounter++;

    ## <appname> <projectname> <cadhome> <centhome> [releasename]

    if ($_ ne "") {
      @line = split(/ /);
      if (($#line < 3) || ($#line >= 5)) {
        print "WARNING: Line $linecounter: Syntax error.\n";
      }
      else {
        $appname = shift(@line);
	$projectname = shift(@line);
	$cadhome = shift(@line);
	$centhome = shift(@line);
	#if ($#line != 0) { next; }
	#$releasename = shift(@line);
	if ($appname eq 'rss') {
          $CHIPS{$projectname}{"exists"} = 1;
          $CHIPS{$projectname}{"cadhome"} = $cadhome;
          $CHIPS{$projectname}{"centhome"} = $centhome;
	}
      }
    }
  } ## End while

  close(RELF);

  $chipreltotal = 0;
  foreach $projectname (keys(%CHIPS)) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }
    $chipreltotal++;
  }

  if ($chipreltotal == 0) {
    print "There are no chip releases in the releases_file.txt file.  Nothing to do.\n";
    exit(0);
  }

  return 1;
} ## End sub ReadReleasesFile
###############################################################################
sub ReadActiveFile {
  ## Read the rss_flow.pl.active file.  It exists if another instance of
  ## rss_flow.pl is already running.  It can also exist if the previous
  ## instance aborted before completion,  leaving around the active file.
  ## This file contains the process ID of the running program, and the
  ## datestamp of when that program began running.
  ##
  ## This information is used later on to determine if we need to kill the
  ## previous running program,  amongst other things.
  ##
  ## Store in global: $RUNNINGALREADY, $RUNNINGSINCE, $RUNNINGPID.

  local(*TMPIN);

  $RUNNINGALREADY = 0;
  $RUNNINGSINCE = 0;
  $RUNNINGPID = 0;
  if (-e "rss_flow.pl.active") {
    if (open(TMPIN,"<rss_flow.pl.active")) {
      $RUNNINGPID = <TMPIN>;
      chop($RUNNINGPID);
      $RUNNINGSINCE = <TMPIN>;
      chop($RUNNINGSINCE);
      close(TMPIN);
      if (($RUNNINGSINCE != 0) && ($RUNNINGPID != $$)) { $RUNNINGALREADY = 1; }
    }
  }

  return 1;
} ## End sub ReadActiveFile
###############################################################################
sub KillRunIfNeeded {
  ## Check to see that another copy of this program is not still running.  If
  ## it is,  kill it by sending a ctrl-C first.  That will let it die
  ## gracefully.  If that doesn't work,  kill it forcefully.  Don't continue
  ## until it is definitely killed.  This could take a minute or two.
  ##
  ## We kill only under the following circumstances:
  ## - Previous instance is running more than 120 hours (5 days).

  local($cmd,$counter,*PSIN,$firstline,$secondline,$dateval,$timeval,$signum);

  $counter = 0;

  while ($RUNNINGALREADY) {
    $counter++;

    $cmd = "/bin/ps -o args -p $RUNNINGPID";
    if (! $SOLARIS) {
      $cmd .= " --cols 1000"; ## Linux truncates the output unless you
                              ## give it a really long line width.
    }
    open(PSIN,"$cmd |");
    $firstline = <PSIN>; ## Throw away line.
    $secondline = <PSIN>;
    close(PSIN);
  
    if ($secondline !~ /rss_flow\.pl/) { $RUNNINGALREADY = 0; last; }
  
    $dateval = localtime;
    $timeval = time;

    if (($timeval - $RUNNINGSINCE) > (5 * 24 * 60 * 60)) {
      if ($counter == 1) {
        print "$dateval: Oops! Another instance of rss_flow.pl (pid=$RUNNINGPID) has been running for more than 5 days.  I'll kill it and start over.\n";
      }
    }
    else {
      print "$dateval: Oops! Another instance of rss_flow.pl (pid=$RUNNINGPID) has been running for less than 5 days,  so I'll abort and let that job continue to run.\n";
      exit(5);
    }
  
    if ($counter == 1) { $signum = "-2"; } ## SIGINT
    else { $signum = "-9"; } ## SIGKILL
  
    system("/bin/kill $signum $RUNNINGPID");
    sleep 1;
    system("/bin/kill $signum $RUNNINGPID");
    sleep 10;
    system("/bin/kill $signum $RUNNINGPID");
    sleep 60;
  }

  return 1;
} ## End sub KillRunIfNeeded
###############################################################################
sub WriteActiveFile {
  local (*TMPOUT);

  if (!open(TMPOUT,">rss_flow.pl.active")) {
    print "ERROR: Can't create file rss_flow.pl.active\n";
    exit(10);
  }
  print TMPOUT "$$\n";
  print TMPOUT "$STARTTIMEVAL\n";
  close(TMPOUT);

  return 1;
} ## End sub WriteActiveFile
###############################################################################
sub MakeMainDirs {
  ## Just make the main directories if they don't exist.
  local($projectname,$centhome,$dirname,$goodchip,$file,*DIR,@allfiles);

  $dateval = localtime;
  print "$dateval: Making main directories if needed...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    $goodchip = 1;
    foreach $dirname ("random_spice",
                      "random_spice/user",
		      "random_spice/results",
                      "random_spice/running",
		      "random_spice/Summary",
		      "random_spice/templates",
		      "random_spice/templates/pending_summaries") {

      if (($dirname eq 'random_spice/running') && (-e "$centhome/$projectname/$dirname")) {
        ## Just for the automated (bot) RSS flows, we can clean up stuff,
	## because we know we're the only user using this...
	##
        ## Clean it out.  We don't want to remove the directory itself,
	## because it might point to somewhere with a soft link.  We can't
	## simply do this:
	##    rm -rf $centhome/$projectname/$dirname
	## because that just deletes the symbollic link,  not what it points to.
	## And we can't do this:
	##    rm -rf $centhome/$projectname/$dirname/*
	## Because that doesn't kill any of the files that start with ".".
	## And we can't do this:
	##    rm -rf $centhome/$projectname/$dirname/*
	##    rm -rf $centhome/$projectname/$dirname/.*
	## Because that would delete the parent directory as well ("..").
	## So we need to get a list of files inside of the directory and
	## delete them individually.  It's a pain.

	if (! opendir(DIR,"$centhome/$projectname/$dirname")) {
	  print "ERROR: Can't read directory: $centhome/$projectname/$dirname\n";
	  delete($CHIPS{$projectname});
	  $goodchip = 0;
	  last;
	}
	@allfiles = readdir(DIR);
	closedir(DIR);
	foreach $file (@allfiles) {
	  if (($file eq '.') || ($file eq '..')) { next; }
	  system("/bin/rm -rf $centhome/$projectname/$dirname/$file >/dev/null 2>&1");
	}
      }
      if (! -e "$centhome/$projectname/$dirname") {
        system("/bin/mkdir -m 777 $centhome/$projectname/$dirname >/dev/null 2>&1");
      }
      if (! -e "$centhome/$projectname/$dirname") {
        print "ERROR: Can't create directory: $centhome/$projectname/$dirname\n";
	delete($CHIPS{$projectname});
	$goodchip = 0;
        last;
      }
    }
    if (!$goodchip) { next; }

    if (! -e "$centhome/$projectname/random_spice/templates/defaults.pm") {
      print "ERROR: Couldn't locate defaults file,  so the flow will not be run for $projectname : $centhome/$projectname/random_spice/templates/defaults.pm\n";
      delete($CHIPS{$projectname});
      next;
    }
  }

  return 1;
} ## End sub MakeMainDirs
###############################################################################
sub FixInterruptedOps {
  ## If the previous run of rss_flow.pl was interrupted or crashed,
  ## we can fix anything that was in a critical state at the moment it
  ## crashed.  This occurs when the results/userdir/rundir is being
  ## renamed to results/userdir/tmp._.rundir.old.  If that file exists,
  ## then it checks to see if the rundir also exists.  If the rundir
  ## doesn't exist,  then it renames tmp._.rundir.old back to rundir.
  ## Otherwise,  it checks to see if tmp._.rundir.okay exists,  and if
  ## so it will remove the tmp._.rundir.old directory.  If the tmp._.rundir.okay
  ## file doesn't exist,  then it removes the rundir directory and renames
  ## the tmp._.rundir.old back to rundir.  Simple, right?
  ##
  ## We don't look at the control files for this.  So we're sorta flying
  ## blind.  But we do that on purpose because if a control file was
  ## removed during this run,  yet it existed in the previous run,  then
  ## those rundirs would disappear off radar (even though they exist).
  ## So we're just going to go through all the directories...
  local($projectname,$centhome,$needrefresh,*DIR,*TMPOUT,@alluserdirs,
        $userdir,@allrundirs,$rundir, $thisrundir);

  ## Lock-out any interrupts that might happen while we do this critical task...
  local $SIG{"INT"} = "IGNORE";
  local $SIG{"TERM"} = "IGNORE";
  local $SIG{"PIPE"} = "IGNORE";

  $dateval = localtime;
  print "$dateval: Fixing any interrupted operations leftover from previous run...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    $needrefresh = 0;

    if (!opendir(DIR,"$centhome/$projectname/random_spice/results")) {
      print "ERROR: Can't read directory: $centhome/$projectname/random_spice/results\n";
      delete($CHIPS{$projectname});
      next;
    }
    @alluserdirs = readdir(DIR);
    closedir(DIR);
    foreach $userdir (@alluserdirs) {
      if (($userdir eq ".") || ($userdir eq "..")) { next; }
      if (!opendir(DIR,"$centhome/$projectname/random_spice/results/$userdir")) {
	next;
      }
      @allrundirs = readdir(DIR);
      closedir(DIR);
      foreach $rundir (@allrundirs) {
        if (($rundir eq ".") || ($rundir eq "..")) { next; }
	$thisrundir = $rundir;
	if ($thisrundir =~ s/^tmp\._\.//) {
	  if ($thisrundir =~ s/\.old$//) {
	    if ($thisrundir eq "") { } ## Do nothing
	    elsif (! -e "$centhome/$projectname/random_spice/results/$userdir/$thisrundir") {
	      print "  --> Renaming $centhome/$projectname/random_spice/results/$userdir/$rundir back to $thisrundir.\n";
	      system("/bin/mv $centhome/$projectname/random_spice/results/$userdir/$rundir $centhome/$projectname/random_spice/results/$userdir/$thisrundir >/dev/null 2>&1");
	      if (-e "$centhome/$projectname/random_spice/results/$userdir/tmp._.$thisrundir.okay") {
	        system("/bin/rm -f $centhome/$projectname/random_spice/results/$userdir/tmp._.$thisrundir.okay > /dev/null 2>&1");
	      }
	    }
	    elsif (-e "$centhome/$projectname/random_spice/results/$userdir/tmp._.$thisrundir.okay") {
	      print "  --> Removing old $centhome/$projectname/random_spice/results/$userdir/$thisrundir and replacing with $rundir.\n";
	      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/$thisrundir > /dev/null 2>&1");
	      system("/bin/mv $centhome/$projectname/random_spice/results/$userdir/$rundir $centhome/$projectname/random_spice/results/$userdir/$thisrundir >/dev/null 2>&1");
	      system("/bin/rm -f $centhome/$projectname/random_spice/results/$userdir/tmp._.$thisrundir.okay > /dev/null 2>&1");
	    }
	    else {
	      print "  --> Removing $centhome/$projectname/random_spice/results/$userdir/$rundir.\n";
	      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/$rundir > /dev/null 2>&1");
	      $needrefresh = 1;
	    }
	  }
	}
      }
    } ## End foreach

    if ($needrefresh) {
      if (! -e "$centhome/$projectname/random_spice/templates/pending_summaries.refresh") {
        open(TMPOUT,">$centhome/$projectname/random_spice/templates/pending_summaries.refresh");
        close(TMPOUT);
      }
    }
  } ## End foreach

  return 1;
} ## End sub FixInterruptedOps
###############################################################################
sub CleanUpCrashedRunDirs {
  ## If the crashed_run subdirectories are empty,  delete them.  They are
  ## left-overs from a time when the flow did crash,  but this latest run
  ## didn't result in a crash.
  local($projectname,$centhome,$userdir,@allfiles,*DIR,@alluserdirs);

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }
    $dateval = localtime;
    print "$dateval: Cleaning crashed_run directories in project $projectname...\n";

    $centhome = $CHIPS{$projectname}{"centhome"};

    if (!opendir(DIR,"$centhome/$projectname/random_spice/results")) {
      print "ERROR: Can't read directory: $centhome/$projectname/random_spice/results\n";
      delete($CHIPS{$projectname});
      next;
    }
    @alluserdirs = readdir(DIR);
    closedir(DIR);
    foreach $userdir (@alluserdirs) {
      if (($userdir eq ".") || ($userdir eq "..")) { next; }

      if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
        @allfiles = ();
	if (opendir(DIR,"$centhome/$projectname/random_spice/results/$userdir/crashed_run")) {
	  foreach $subdir (readdir(DIR)) {
	    if (($subdir ne '.') && ($subdir ne '..')) {
	      push(@allfiles,$subdir);
	    }
	  }
	  closedir(DIR);
	  if ($#allfiles == -1) {
	    print "  Deleting unneeded crashed_run directory: $centhome/$projectname/random_spice/results/$userdir/crashed_run\n";
	    system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run >/dev/null 2>&1");
	  }
	}
      }
    }
  }

  return 1;
} ## End sub CleanUpCrashedRunDirs
###############################################################################
sub ScanForControlFiles {
  ## This just looks for all of control.pl files in the "user" directory
  ## for each chip.  Stores the results in global:
  ##    $CHIPS{$projectname}{"userdirs"}{$dirname}{"exists"} = 1 | 2;
  ## If there is no control.pl file in the directory,  then it's just set to 1.
  ## Otherwise it is set to 2.
  ## Where $dirname is just the name of the subdir in:
  ##   $centhome/$projectname/random_spice/user/

  local($projectname,$centhome,$userdir,*DIR,@allfiles);

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }
    $dateval = localtime;
    print "$dateval: Scanning for control files in project $projectname...\n";

    $centhome = $CHIPS{$projectname}{"centhome"};

    @allfiles = ();
    if (opendir(DIR,"$centhome/$projectname/random_spice/user")) {
      @allfiles = readdir(DIR);
      closedir(DIR);
    }

    foreach $userdir (@allfiles) {
      if (($userdir eq ".") || ($userdir eq "..")) { next; }
      if ($userdir =~ /[^a-zA-Z0-9_\.]/) {
        print "ERROR: The userdir contains illegal characters: $centhome/$projectname/random_spice/user/$userdir\n";
	next;
      }
      if (-e "$centhome/$projectname/random_spice/user/$userdir/control.pl") {
        $CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} = 2;
      }
      elsif (-d "$centhome/$projectname/random_spice/user/$userdir") {
        $CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} = 1;
      }
    }
  } ## End foreach

  return 1;
} ## End sub ScanForControlFiles
###############################################################################
sub DeleteOldResultDirs {
  ## Delete the old result directories since we no longer have a corresponding
  ## user directory for them.
  local($projectname,$centhome,$needrefresh,$subdir,$thisdir,@allsubdirs,
        *DIR,*TMPOUT,@allsubsubdirs,$subsubdir);

  $dateval = localtime;
  print "$dateval: Deleteing old results directories if needed...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    $needrefresh = 0;

    if (!opendir(DIR,"$centhome/$projectname/random_spice/results")) {
      print "ERROR: Can't read directory: $centhome/$projectname/random_spice/results\n";
      delete($CHIPS{$projectname});
      next;
    }
    @allsubdirs = readdir(DIR);
    closedir(DIR);
    foreach $subdir (@allsubdirs) {
      if (($subdir eq '.') || ($subdir eq '..')) { next; }
      if ($CHIPS{$projectname}{"userdirs"}{$subdir}{"exists"} == 0) {
        ## No longer needed so delete it.
	delete($CHIPS{$projectname}{"userdirs"}{$subdir});
        print "Removing unneeded results directory: $centhome/$projectname/random_spice/results/$subdir\n";
	$needrefresh = 1;
	if (! -l "$centhome/$projectname/random_spice/results/$subdir") {
          system("/bin/rm -rf $centhome/$projectname/random_spice/results/$subdir >/dev/null 2>&1");
	}
	else {
	  ## It's a symbolic link,  so we need to delete what it points to,
	  ## and then we can delete the link.
          if (!opendir(DIR,"$centhome/$projectname/random_spice/results/$subdir")) {
            print "ERROR: Can't read directory: $centhome/$projectname/random_spice/results/subdir\n";
          }
	  else {
            @allsubsubdirs = readdir(DIR);
            closedir(DIR);
	    foreach $subsubdir (@allsubsubdirs) {
	      if (($subsubdir eq '.') || ($subsubdir eq '..')) { next; }
              system("/bin/rm -rf $centhome/$projectname/random_spice/results/$subdir/$subsubdir >/dev/null 2>&1");
	    }
            system("/bin/rm -rf $centhome/$projectname/random_spice/results/$subdir >/dev/null 2>&1");
	  }
	}
      }
    }

    if ($needrefresh) {
      if (! -e "$centhome/$projectname/random_spice/templates/pending_summaries.refresh") {
        open(TMPOUT,">$centhome/$projectname/random_spice/templates/pending_summaries.refresh");
        close(TMPOUT);
      }
    }
  }

  return 1;
} ## End sub DeleteOldResultDirs
###############################################################################
sub CreateNewResultDirs {
  ## Create any new result directories.
  local($projectname,$centhome,$maindir,$userdir);

  $dateval = localtime;
  print "$dateval: Creating new results/running directories if needed...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};
    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      foreach $maindir ("results","running") {
        if ($maindir eq 'results') {
          if (! -e "$centhome/$projectname/random_spice/$maindir/$userdir") {
	    print "Creating new results directory: $centhome/$projectname/random_spice/$maindir/$userdir\n";
	    system("/bin/mkdir $centhome/$projectname/random_spice/$maindir/$userdir >/dev/null 2>&1");
	  }
	}
	else {
	  system("/bin/mkdir $centhome/$projectname/random_spice/$maindir/$userdir >/dev/null 2>&1");
	}
	if (! -e "$centhome/$projectname/random_spice/$maindir/$userdir") {
	  print "ERROR: Can't create directory: $centhome/$projectname/random_spice/$maindir/$userdir\n";
	  delete($CHIPS{$projectname}{"userdirs"}{$userdir});
	  next;
	}
      }
    }
  }

  return 1;
} ## End sub CreateNewResultDirs
###############################################################################
sub LaunchControlFileJobs {
  ## This creates the Psub jobs to run rss_flow_chkcf.pl on all of the
  ## control.pl files.  It stores the results in the running directories.
  local(%CTRL,$projectname,$centhome,$cadhome,$userdir,$cmd,$status,$gotone,
        $slavegroup,$jobid,$build,$builddir);

  $dateval = localtime;
  print "\n$dateval: Launching dump_control jobs...\n";
  $psub::CRASHLIMIT = 200;
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  %CTRL = ();
  &SetSlaves(\%CTRL);

  $CTRL{"socket"} = -1;
  @{$CTRL{"socketusers"}} = ("bot","weigand");

  $gotone = 0;

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};
    $cadhome = $CHIPS{$projectname}{"cadhome"};

    $builddir = $CODEBASE_LOCATIONS{$projectname}{"builddir"};
    $build = $CODEBASE_LOCATIONS{$projectname}{"build"};
    if ($builddir eq "") {
      print "ERROR: Can't find codebase for chip \"$projectname\". Ignoring this chip.\n";
      $CHIPS{$projectname}{"exists"} = 0;
      next;
    }

    foreach $slavegroup (keys(%{$CTRL{"slaves"}})) {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname");
      if (-e "$centhome/$projectname/random_spice/manual_running") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/manual_running");
      }
      if (-e "$centhome/$projectname/random_spice/manual_results") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/manual_results");
      }
      if (-e "$centhome/$projectname/random_spice/running") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/running");
      }
      if (-e "$centhome/$projectname/random_spice/results") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/results");
      }
    }

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      $jobid = "dump_control\.$projectname\.$userdir";

      push(@{$CTRL{"jobs"}{$jobid}{"dirs"}},"+$centhome/$projectname/random_spice/running/$userdir");

      $CTRL{"jobs"}{$jobid}{"group"} = "linux";
      #@{$CTRL{"jobs"}{$jobid}{"altgroups"}} = ("unixfast","unix");
      $cmd = "/bin/csh -fc 'source /home/users3/bot/.cshrc >& /dev/null; ";
      $cmd .= "setenv CODEBASE_weigand_rss_BUILD $build; ";
      $cmd .= "setenv CODEBASE_weigand_rss_BUILDDIR $builddir; ";
      $cmd .= "$builddir/rss_flow_part1.pl $projectname $cadhome $centhome $userdir ";
      $cmd .= ">& $centhome/$projectname/random_spice/running/$userdir/rss_flow_part1.trace.txt'";
        ## NOTE: This is the automated RSS flow. There's no need to append the name
	## of the file with "${HOSTNAME}.$$".  You only do that with the manual
	## flow to prevent collisions when there is more than one run happening
	## at the same time.
      $CTRL{"jobs"}{$jobid}{"cmd"} = $cmd;
      $gotone = 1;
      if (-e "$centhome/$projectname/random_spice/running/$userdir/rss_flow_part1.trace.txt") {
        system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/rss_flow_part1.trace.txt >/dev/null 2>&1");
      }
    }
  }

  if (! $gotone) {
    print "There are no jobs to run at this moment.  Aborting flow.\n";
    &CleanRunningDir();
    system("/bin/rm -f rss_flow.pl.active >/dev/null 2>&1");
    print "\nDone.\n";
    exit(0);
  }

  $status = &psub::launch(\%CTRL);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRL);

  ## Now detect any failed runs, and move their running directories
  ## to the results/$userdir/crashed_run directory.

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }
      if ($CTRL{"jobs"}{"dump_control\.$projectname\.$userdir"}{"status"} eq "success") {
        if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part1") {
          system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part1 >/dev/null 2>&1");
        }
      }
      else {
        print "ERROR: Crashed / failed run detected during dump_control.  Moving run $projectname $userdir to results crashed_run dir....\n";
	&EmailUser("part1","$centhome/$projectname/random_spice/user/$userdir/control.pl","$centhome/$projectname/random_spice/results/$userdir/crashed_run/part1",$userdir,"");
        $CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} = 1;
        if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
          system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run >/dev/null 2>&1");
        }
        system("/bin/mkdir $centhome/$projectname/random_spice/results/$userdir/crashed_run >/dev/null 2>&1");
        if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
          print "ERROR: Can't create directory $centhome/$projectname/random_spice/results/$userdir/crashed_run\n";
	  print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
          system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir >/dev/null 2>&1");
        }
        else {
          system("/bin/mv -f $centhome/$projectname/random_spice/running/$userdir $centhome/$projectname/random_spice/results/$userdir/crashed_run/part1 >/dev/null 2>&1");
	  system("/bin/touch $centhome/$projectname/random_spice/templates/pending_summaries/$userdir >/dev/null 2>&1");
        }
      }
    }
  }

  return 1;
} ## End sub LaunchControlFileJobs
###############################################################################
sub ReadControlFileDumps {
  ## This reads the control file dumps which were generated by the
  ## LaunchControlFileJobs run.  It's looking for the names of all
  ## the rundirs,  the eckt_cellname,  and it's looking for their run property
  ## to see if it's supposed to be run or not.
  ##
  ## It stores the results in:
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1 | 2;
  ## If it's 1,  it means it exists but it is not to be run.
  ## It it's 2,  it means it exists and it is to be run.
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"} = $cellname
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt"} = $eckt
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"spice_techfile"} = $spice_techfile
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sim_cmd"} = $sim_cmd
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sim_type"} = $sim_type
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sum_cmd"} = $sum_cmd
  ## $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"limit_kept_jobs"} = $value
  ## @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_prep"}} = ($qname1,$qname2,...);
  ## @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sim"}} = ($qname1,$qname2,...);
  ## @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sum"}} = ($qname1,$qname2,...);

  local($projectname,$centhome,$userdir,*IN,$rundir,$runval,@line);

  $dateval = localtime;
  print "\n$dateval: Reading all of the control file dumps...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }
      if (!open(IN,"<$centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt")) {
        print "ERROR: Couldn't read control file dump,  so I will not run anything in $projectname $userdir : $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt\n";
        delete ($CHIPS{$projectname}{"userdirs"}{$userdir});
	next;
      }
      $rundir = "";
      while(<IN>) {
        chop;
	if (s/^RUNDIR: //) {
	  $rundir = $_;
          if ($rundir =~ /[^a-zA-Z0-9_\.]/) {
            print "ERROR: The rundir contains illegal characters: \"$rundir\" ($centhome/$projectname/random_spice/user/$userdir/control.pl)\n";
	    $rundir = "";
	    next;
          }
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	}
	elsif (/ERROR:/) {
	  ## The rss_flow_part1.pl script should've catched any errors,  but
	  ## just in case...
	  delete($CHIPS{$projectname}{"userdirs"}{$userdir});
	  last;
	}
	elsif ($rundir eq "") { next; }
	elsif (/^\s+run = \"(.*)\"$/) {
	  $runval = $1;
	  if ($runval != 0) {
	    $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 2;
	  }
	}
	elsif (/^\s+eckt_cellname = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"} = $1;
	}
	elsif (/^\s+eckt = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt"} = $1;
	}
	elsif (/^\s+spice_techfile = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"spice_techfile"} = $1;
	}
	elsif (/^\s+sim_cmd = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sim_cmd"} = $1;
	}
	elsif (/^\s+sim_type = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sim_type"} = $1;
	}
	elsif (/^\s+sum_cmd = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sum_cmd"} = $1;
	}
	elsif (/^\s+limit_kept_logs = \"(.*)\"$/) {
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"limit_kept_logs"} = $1;
	}
	elsif (s/^\s+queue_prep = \(//) {
	  s/[\)\"]+//g;
	  @line = split(/[ \t,]+/);
	  @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_prep"}} = @line;
	}
	elsif (s/^\s+queue_sim = \(//) {
	  s/[\)\"]+//g;
	  @line = split(/[ \t,]+/);
	  @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sim"}} = @line;
	}
	elsif (s/^\s+queue_sum = \(//) {
	  s/[\)\"]+//g;
	  @line = split(/[ \t,]+/);
	  @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sum"}} = @line;
	}
      }
      close(IN);
    }
  }

  ## HACK...
  if ($RUNFILE_USED) {
    foreach $projectname (sort(keys(%CHIPS))) {
      if ($CHIPS{$projectname}{"exists"} == 0) { next; }
  
      foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} == 0 ) { next; }
  
        foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
          if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} == 0) { next; }
	  if ($RUNFILE{"$userdir/$rundir"} == 0) {
            $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	  }
        }
      }
    }
  }

  return 1;
} ## End sub ReadControlFileDumps
###############################################################################
sub FindAllLicenses {
  ## Automated flow only...
  ## Up until now we didn't do a license check, because we didn't know which
  ## licenses were needed.  Now we do, so we check for licenses.  We'll
  ## cancel jobs that require licenses that are not available.

  local($dateval, $did_hspice_licchk, $did_xa_licchk, $projectname, $qname,
        $rundir, $userdir, $uses_hspbatch, $uses_hspice, $uses_xa,
	$uses_xabat, @queue_sim);

  $dateval = localtime;
  print "\n$dateval: Finding licenses...\n";

  $did_xa_licchk = 0;
  $did_hspice_licchk = 0;

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

	@queue_sim = @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sim"}};
	## Note that queue_sim should be set either by the user or by using
	## the "sim_type" property which causes the control file dumper to
	## set queue_sim for the user.
        
        $uses_hspice = 0;
        $uses_hspbatch = 0;
        $uses_xa = 0;
        $uses_xabat = 0;
            
        foreach $qname (@queue_sim) {
          if ($qname eq "hspice")         { $uses_hspice = 1; }
          elsif ($qname eq "hspbatch")    { $uses_hspbatch = 1; }
          elsif ($qname eq "xa")          { $uses_xa = 1; }
          elsif ($qname eq "xabat")       { $uses_xabat = 1; }
        }

        if ($uses_hspice || $uses_hspbatch) {
	  if (! $did_hspice_licchk) {
            &FindTotalHspiceLicenses();
            $did_hspice_licchk = 1;
	  }
          if ($TOTAL_LICENSES_HSPICE == 0) {
            $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	    print "ERROR: No hspice licenses to run chip=\"$projectname\" userdir=\"$userdir\" rundir=\"$rundir\". Canceling job.\n";
	    next;
	  }
        }
        if ($uses_xa || $uses_xabat) {
	  if (! $did_xa_licchk) {
            &FindTotalXaLicenses();
            $did_xa_licchk = 1;
	  }
          if ($TOTAL_LICENSES_XA == 0) {
            $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	    print "ERROR: No xa/hsim licenses to run chip=\"$projectname\" userdir=\"$userdir\" rundir=\"$rundir\". Canceling job.\n";
	    next;
	  }
        }
      }
    }
  }

  return 1;
} ## End sub FindAllLicenses
###############################################################################
sub FindTotalHspiceLicenses {
  ## Finds the hspice licenses.
  ##
  ## Assumes you need hspice licenses. Don't call if otherwise.

  local ($counter,$dateval,$sleepval,*IN);

  $dateval = localtime;
  print "$dateval: Determining hspice license count...\n";

  $TOTAL_LICENSES_HSPICE = 0;

  for ($counter = 0; $counter <= 4; $counter++) {
    ## Loop 5 times until we get a non-zero license count.  We do this
    ## because cenlic is buggy and sometimes shows zero licenses.
    $sleepval = 10 * ($counter * 2); ## 10, 20, 40, 60, 80 seconds.
    if (!open(IN,"/Server/bin/cenlic hspice |")) {
      sleep $sleepval;
      next;
    }
    while(<IN>) {
      chop;
      ## Users of hspice:  (Total of 4 licenses ...)
  
      if (/Users of hspice\:\s+\(Total of (\S+) license[s]* /) {
        $TOTAL_LICENSES_HSPICE = $1;
      }
    }
    close(IN);
    if ($TOTAL_LICENSES_HSPICE == 0) { sleep $sleepval; }
    else { last; }
  }

  print "INFO: Total of $TOTAL_LICENSES_HSPICE hspice licenses.\n";

  if ($TOTAL_LICENSES_HSPICE == 0) {
    print "ERROR: Can't find any hspice licenses. This is not normal.\n";
  }

  if ($BOT_HSPICE_SLOTS > $TOTAL_LICENSES_HSPICE) {
    $BOT_HSPICE_SLOTS = $TOTAL_LICENSES_HSPICE;
  }

  if ($USER_HSPICE_SLOTS > $TOTAL_LICENSES_HSPICE) {
    $USER_HSPICE_SLOTS = $TOTAL_LICENSES_HSPICE;
  }

  return 1;
} ## End sub FindTotalHspiceLicenses
###############################################################################
sub FindTotalXaLicenses {
  ## Finds the xa licenses.
  ##
  ## Assumes you need xa/hsim licenses. Don't call if otherwise.
  ##
  ## The licenses we use for xa and hsim are the same now. They are:
  ##   cenlic hsim-sc
  ##   cenlic hsim-ms
  ##   cenlic xsim
  ##
  ## The "xsim" licenses are "custom sim" licenses which means they can run
  ## on any number of transistors. Our license search order is in the order
  ## given above. So, if the transistor count is less than 100,000, it will
  ## first choose hsim-sc. If it's between 100,000 and 1,000,000, it will
  ## choose hsim-ms. Otherwise it grabs xsim.
  ##
  ## We just add up these licenses and store the result into $TOTAL_LICENSES_XA.

  local ($counter,$dateval,$license_name,$sleepval,$total_licenses_here,*IN);

  $dateval = localtime;
  print "$dateval: Determining xa/hsim license count...\n";

  $TOTAL_LICENSES_XA = 0;

  foreach $license_name ("hsim-sc","hsim-ms","xsim") {
    for ($counter = 0; $counter <= 4; $counter++) {
      ## Loop 5 times until we get a non-zero license count.  We do this
      ## because cenlic is buggy and sometimes shows zero licenses.
      $total_licenses_here = 0;
      $sleepval = 10 * ($counter * 2); ## 10, 20, 40, 60, 80 seconds.
      if (!open(IN,"/Server/bin/cenlic $license_name |")) {
        sleep $sleepval;
        next;
      }
      while(<IN>) {
        chop;
        ## Users of $license_name:  (Total of 4 licenses ...)
    
        if (/Users of \Q$license_name\E\:\s+\(Total of (\S+) license[s]* /) {
          $total_licenses_here = $1;
        }
      }
      close(IN);
      if ($total_licenses_here == 0) { sleep $sleepval; }
      else {
        $TOTAL_LICENSES_XA += $total_licenses_here;
	last;
      }
    }
  }

  print "INFO: Total of $TOTAL_LICENSES_XA xa/hsim licenses.\n";

  if ($TOTAL_LICENSES_XA == 0) {
    print "ERROR: Can't find any xa/hsim licenses. This is not normal.\n";
  }

  if ($BOT_XA_SLOTS > $TOTAL_LICENSES_XA) {
    $BOT_XA_SLOTS = $TOTAL_LICENSES_XA;
  }

  if ($USER_XA_SLOTS > $TOTAL_LICENSES_XA) {
    $USER_XA_SLOTS = $TOTAL_LICENSES_XA;
  }

  return 1;
} ## End sub FindTotalXaLicenses
###############################################################################
sub PrepareRundirs {
  ## After we've read in the control file dumps,  it's time to figure out
  ## which "results" rundirs directories get to stay and which are to be
  ## removed.  As well as the creation of new rundirs in the results
  ## and running directories.

  local($projectname,$centhome,$userdir,$needrefresh,$thingy,$rundir,$sum_cmd,
        *OUT,*DIR,*TMPOUT,@allfiles);

  $dateval = localtime;
  print "\n$dateval: Cleaning up and/or creating individual rundir directories ...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    $needrefresh = 0;

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      @allfiles = ();
      if (opendir(DIR,"$centhome/$projectname/random_spice/results/$userdir")) {
        @allfiles = readdir(DIR);
	closedir(DIR);
      }

      foreach $thingy (@allfiles) {
        if (($thingy eq ".") || ($thingy eq "..")) { next; }
        if (($thingy ne "crashed_run") && (-d "$centhome/$projectname/random_spice/results/$userdir/$thingy")) {
          if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$thingy}{"exists"} != 0) { next; }
	  print "Deleting unneeded rundir: $centhome/$projectname/random_spice/results/$userdir/$thingy\n";
	  system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/$thingy >/dev/null 2>&1");
	  $needrefresh = 1;
	}
      }

      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
	if (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir") {
	  print "Creating new rundir: $centhome/$projectname/random_spice/results/$userdir/$rundir\n";
	  system("/bin/mkdir $centhome/$projectname/random_spice/results/$userdir/$rundir >/dev/null 2>&1");
	  if (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir") {
	    print "ERROR: Unable to create rundir: $centhome/$projectname/random_spice/results/$userdir/$rundir\n";
	    $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	  }
	}
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
	system("/bin/mkdir $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
	if (! -e "$centhome/$projectname/random_spice/running/$userdir/$rundir") {
	  print "ERROR: Unable to create rundir: $centhome/$projectname/random_spice/running/$userdir/$rundir\n";
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	}
      }
    }
    if ($needrefresh) {
      if (! -e "$centhome/$projectname/random_spice/templates/pending_summaries.refresh") {
        open(TMPOUT,">$centhome/$projectname/random_spice/templates/pending_summaries.refresh");
        close(TMPOUT);
      }
    }
  }

  return 1;
} ## End sub PrepareRundirs
###############################################################################
sub LaunchDataPrepJobs {
  ## This launches the data prep jobs.  This covers all of the run through to,
  ## but not including,  the SPICE simulation job.
  local ($build, $builddir, $cadhome, $centhome, $cmd, $counter, $gotone, $jobid,
         $projectname, @qnames, $rundir, $slavegroup, $status, $userdir,
	 %CTRL);

  $dateval = localtime;
  print "\n$dateval: Launching data prep jobs...\n";
  $psub::CRASHLIMIT = 200;
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  %CTRL = ();
  &SetSlaves(\%CTRL);

  $CTRL{"socket"} = -1;
  @{$CTRL{"socketusers"}} = ("bot","weigand");

  $gotone = 0;

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};
    $cadhome = $CHIPS{$projectname}{"cadhome"};

    $builddir = $CODEBASE_LOCATIONS{$projectname}{"builddir"};
    $build = $CODEBASE_LOCATIONS{$projectname}{"build"};
    if ($builddir eq "") {
      print "ERROR: Can't find codebase for chip \"$projectname\". Ignoring this chip.\n";
      $CHIPS{$projectname}{"exists"} = 0;
      next;
    }

    foreach $slavegroup (keys(%{$CTRL{"slaves"}})) {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname");
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$MAIN_SCRATCH_DIR);
      if (-e "$centhome/$projectname/random_spice/manual_running") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/manual_running");
      }
      if (-e "$centhome/$projectname/random_spice/manual_results") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/manual_results");
      }
      if (-e "$centhome/$projectname/random_spice/running") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/running");
      }
      if (-e "$centhome/$projectname/random_spice/results") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/results");
      }
    }

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
	
        @qnames = @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_prep"}};

	if ($#qnames == -1) { @qnames = ("vxl"); } ## Shouldn't happen.

	$jobid = "data_prep\.$projectname\.$userdir\.$rundir";
        push(@{$CTRL{"jobs"}{$jobid}{"dirs"}},"+$centhome/$projectname/random_spice/running/$userdir/$rundir");
	$CTRL{"jobs"}{$jobid}{"group"} = shift(@qnames);
	if ($#qnames != -1) {
	  @{$CTRL{"jobs"}{$jobid}{"altgroups"}} = @qnames;
	}
        $cmd = "/bin/csh -fc 'source /home/users3/bot/.cshrc >& /dev/null; ";
        $cmd .= "setenv CODEBASE_weigand_rss_BUILD $build; ";
        $cmd .= "setenv CODEBASE_weigand_rss_BUILDDIR $builddir; ";
	$cmd .= "$builddir/rss_flow_part2.pl $projectname $cadhome $centhome $userdir $rundir ";
	$cmd .= ">& $centhome/$projectname/random_spice/running/$userdir/$rundir/rss_flow_part2.pl.trace.txt'";
	$CTRL{"jobs"}{$jobid}{"cmd"} = $cmd;
	$gotone = 1;
      }
    }
  }


  if (! $gotone) {
    print "There are no jobs to run at this moment.  Aborting flow.\n";
    &CleanRunningDir();
    system("/bin/rm -f rss_flow.pl.active >/dev/null 2>&1");
    print "\nDone.\n";
    exit(0);
  }

  $status = &psub::launch(\%CTRL);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRL);

  ## Now detect any failed runs, and move their running directories
  ## to the results/$userdir/crashed_run directory.

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

	$jobid = "data_prep\.$projectname\.$userdir\.$rundir";

	if ($CTRL{"jobs"}{$jobid}{"status"} eq "success") {
          if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir") {
            system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
          }
	}
	else {
          print "ERROR: Crashed / failed run detected during data_prep.  Moving run $projectname $userdir $rundir to results crashed_run dir....\n";
	  &EmailUser("part2","$centhome/$projectname/random_spice/user/$userdir/control.pl","$centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir",$userdir,$rundir);
          if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir") {
            system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
	  }
          if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir") {
            system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
	  }
          if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir") {
            system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
	  }
            
          $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
          if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
            system("/bin/mkdir $centhome/$projectname/random_spice/results/$userdir/crashed_run >/dev/null 2>&1");
          }
          if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
            print "ERROR: Can't create directory $centhome/$projectname/random_spice/results/$userdir/crashed_run\n";
	    print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
            system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
          }
          else {
            system("/bin/mv -f $centhome/$projectname/random_spice/running/$userdir/$rundir $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
	    if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir/control_file_dump.txt") {
	      system("/bin/cp -p $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
	    }
	    if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir/rss_flow_part1.trace.txt") {
	      system("/bin/cp -p $centhome/$projectname/random_spice/running/$userdir/rss_flow_part1.trace.txt $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
	    }
	    ## Leftover directory from the runv commands.
	    system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir/LINUX_* >/dev/null 2>&1");
	    system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part2.$rundir/SOLARIS* >/dev/null 2>&1");
	    system("/bin/touch $centhome/$projectname/random_spice/templates/pending_summaries/$userdir\-$rundir >/dev/null 2>&1");
          }
	}
      }
    }
  }

  return 1;
} ## End sub LaunchDataPrepJobs
###############################################################################
sub LaunchSimJobs {
  ## Do we need to run part3 (the SPICE sim jobs) or part4 (the summary jobs)?
  ## We've already determined if the part2 or part1 jobs have crashed and
  ## eliminated them from the %CHIPS data structure.  So now we just need to
  ## look at the crc32's and such and see if there's anything that has changed:
  ##  1. If the crc on the netlist or vectors have changed,  rerun sim + sum.
  ##  2. If the old sim_cmd != new sim_cmd,  rerun sim + sum.
  ##  3. If the old sum_cmd != new sum_cmd,  rerun sum.
  ##  4. If the old simulation results don't exist,  rerun sim + sum.
  ##  5. If the old summary results don't exist,  rerun sum.
  ##  6. Otherwise,  don't rerun and keep the results the same.
  ## 
  ## We're prioritizing sim jobs like this:
  ##  1. If there's nothing different this time around than last time
  ##     except new vectors,  then it gets second priority.

  local($builddir, $cadhome, $centhome, $cmd, $crc_spice_new, $crc_spice_old,
	$crc_vector_header_new, $crc_vector_header_old, $crc_vectors_new,
	$crc_vectors_old, $dir_count, $eckt_cellname, $gotone, $jobid, $jobid1, $jobid2,
	$limit_kept_logs, $need_to_run_part3, $need_to_run_part4, $nowdate,
	$projectname, $reason, $rundir, $sim_cmd_new, $sim_cmd_old,
	$simrundate, $slavegroup, $status, $sum_cmd_new, $sum_cmd_old,
	$userdir, %JOBXREF, *DIR, *IN, *OUT, %CTRL, @alldirs, @simqnames,
	@sumqnames, $uses_hsim, $uses_hsimbat, $uses_hsimbg, $uses_hsimms,
	$uses_hsimmsbat, $uses_hsimmsbg, $uses_hsimns, $uses_hsimnsbat,
	$uses_hsimnsms, $uses_hsimnsmsbat, @extraq);

  $dateval = localtime;
  print "\n$dateval: Launching simulation and summary jobs...\n";

  %CTRL = ();
  &SetSlaves(\%CTRL);

  $CTRL{"socket"} = -1;
  @{$CTRL{"socketusers"}} = ("bot","weigand");

  $gotone = 0; ## Do we even have a job to run?
  %JOBXREF = ();

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};
    $cadhome = $CHIPS{$projectname}{"cadhome"};

    $builddir = $CODEBASE_LOCATIONS{$projectname}{"builddir"};
    $build = $CODEBASE_LOCATIONS{$projectname}{"build"};
    if ($builddir eq "") {
      print "ERROR: Can't find codebase for chip \"$projectname\". Ignoring this chip.\n";
      $CHIPS{$projectname}{"exists"} = 0;
      next;
    }

    foreach $slavegroup (keys(%{$CTRL{"slaves"}})) {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname");
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$MAIN_SCRATCH_DIR);
      if (-e "$centhome/$projectname/random_spice/manual_running") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/manual_running");
      }
      if (-e "$centhome/$projectname/random_spice/manual_results") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/manual_results");
      }
      if (-e "$centhome/$projectname/random_spice/running") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/running");
      }
      if (-e "$centhome/$projectname/random_spice/results") {
        push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$centhome/$projectname/random_spice/results");
      }
    }

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

        @simqnames = @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sim"}};
	if ($#simqnames == -1) { @simqnames = ("xa","xabat"); } ## Shouldn't happen.

        @sumqnames = @{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"queue_sum"}};
	if ($#sumqnames == -1) { @sumqnames = ("linux"); } ## Shouldn't happen.

	$eckt_cellname = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"};

	$sim_cmd_new = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sim_cmd"};
	$sim_cmd_old = "";
	if (-e "$centhome/$projectname/random_spice/results/$userdir/$rundir/info.sim_cmd") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/results/$userdir/$rundir/info.sim_cmd")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/results/$userdir/$rundir/info.sim_cmd : $!\n";
	  }
	  else {
	    $sim_cmd_old = <IN>;
	    chop($sim_cmd_old);
	    close(IN);
	  }
	}

	$sum_cmd_new = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"sum_cmd"};
	$sum_cmd_old = "";
	if (-e "$centhome/$projectname/random_spice/results/$userdir/$rundir/info.sum_cmd") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/results/$userdir/$rundir/info.sum_cmd")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/results/$userdir/$rundir/info.sum_cmd : $!\n";
	  }
	  else {
	    $sum_cmd_old = <IN>;
	    chop($sum_cmd_old);
	    close(IN);
	  }
	}

	$crc_spice_new = "";
	if (-e "$centhome/$projectname/random_spice/running/$userdir/$rundir/main.spi.crc") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/running/$userdir/$rundir/main.spi.crc")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/running/$userdir/$rundir/main.spi.crc\n";
	  }
	  else {
	    $crc_spice_new = <IN>;
	    chop($crc_spice_new);
	    close(IN);
	  }
	}

	$crc_spice_old = "";
	if (-e "$centhome/$projectname/random_spice/results/$userdir/$rundir/main.spi.crc") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/results/$userdir/$rundir/main.spi.crc")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/results/$userdir/$rundir/main.spi.crc\n";
	  }
	  else {
	    $crc_spice_old = <IN>;
	    chop($crc_spice_old);
	    close(IN);
	  }
	}

	$crc_vector_header_new = "";
	if (-e "$centhome/$projectname/random_spice/running/$userdir/$rundir/${eckt_cellname}.vector_header.crc") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/running/$userdir/$rundir/${eckt_cellname}.vector_header.crc")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/running/$userdir/$rundir/${eckt_cellname}.vector_header.crc\n";
	  }
	  else {
	    $crc_vector_header_new = <IN>;
	    chop($crc_vector_header_new);
	    close(IN);
	  }
	}

	$crc_vector_header_old = "";
	if (-e "$centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vector_header.crc") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vector_header.crc")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vector_header.crc\n";
	  }
	  else {
	    $crc_vector_header_old = <IN>;
	    chop($crc_vector_header_old);
	    close(IN);
	  }
	}

	$crc_vectors_new = "";
	if (-e "$centhome/$projectname/random_spice/running/$userdir/$rundir/${eckt_cellname}.vectors.crc") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/running/$userdir/$rundir/${eckt_cellname}.vectors.crc")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/running/$userdir/$rundir/${eckt_cellname}.vectors.crc\n";
	  }
	  else {
	    $crc_vectors_new = <IN>;
	    chop($crc_vectors_new);
	    close(IN);
	  }
	}

	$crc_vectors_old = "";
	if (-e "$centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vectors.crc") {
	  if (!open(IN,"<$centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vectors.crc")) {
	    print "ERROR: Can't read $centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vectors.crc\n";
	  }
	  else {
	    $crc_vectors_old = <IN>;
	    chop($crc_vectors_old);
	    close(IN);
	  }
	}

        $simrundate = "";
	if (-e "$centhome/$projectname/random_spice/results/$userdir/$rundir/info.simrun") {
	  $simrundate = (stat("$centhome/$projectname/random_spice/results/$userdir/$rundir/info.simrun"))[9];
	  $simrundate = sprintf("%012u",$simrundate);
	}

	$reason = 0;

	if ($crc_spice_new ne $crc_spice_old) { $reason |= 1; }
	if ($crc_vector_header_new ne $crc_vector_header_old) { $reason |= 2; }
	if ($crc_vectors_new ne $crc_vectors_old) { $reason |= 4; }
	if ($sim_cmd_new ne $sim_cmd_old) { $reason |= 8; }
	if ($sum_cmd_new ne $sum_cmd_old) { $reason |= 16; }
	if ((! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/main.spi") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.vectors.gz") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/info.sim_cmd") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/info.simrun") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/main.log.gz") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/logfile") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/sim.log.gz")) {
	  $reason |= 32;
	}

	$need_to_run_part3 = 0;
	$need_to_run_part4 = 0;

	if ($reason == 4) {
	  ## Just the vectors have changed.  So check to see if there is already
	  ## enough failing runs.  If so,  we won't rerun this.
	  $limit_kept_logs = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"limit_kept_logs"};

	  if (opendir(DIR,"$centhome/$projectname/random_spice/results/$userdir/$rundir/previous_violations")) {
	    @alldirs = ();
	    @alldirs = readdir(DIR);
	    closedir(DIR);
  
	    $dir_count = $#alldirs - 1; ## Subtracting off the "." and ".." directories.
  
	    if ($dir_count >= $limit_kept_logs) {
	      print "  --> $projectname $userdir $rundir : Reached failing run limit (limit_kept_logs=$limit_kept_logs). Will not run more jobs.\n";
              $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	      next;
	    }
	  }
	}

        if (($reason != 16) && ($reason != 0)) {
	  ## If it was just 16, then it would mean just the summary would
	  ## need to be redone. If it was 0, then nothing needs to be done.
	  ## But if it was anything else, it means that both a sim run and
	  ## a summary run needs to happen...
	  $need_to_run_part3 = 1;
	  $need_to_run_part4 = 1;
	}
	if (($sum_cmd_new ne $sum_cmd_old) ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/info.sum_cmd") ||
	    (! -e "$centhome/$projectname/random_spice/results/$userdir/$rundir/${eckt_cellname}.sum.gz")) {
	  $need_to_run_part4 = 1;
	}

	if ((! $need_to_run_part3) && (! $need_to_run_part4)) {
	  ## Everything's the same as the previous run.  No need to rerun.
	  print "No need to rerun part3 or part4 for $projectname $userdir $rundir.\n";
	  system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
	  $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	}
	elsif ($need_to_run_part4 && (! $need_to_run_part3)) {
	  ## Just run the summary command.  Okay,  we need to copy the previous results over
	  ## since we didn't run the simulator here...
	  system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
	  system("/bin/mkdir $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
	  if (! -e "$centhome/$projectname/random_spice/running/$userdir/$rundir") {
	    print "ERROR: Oops.  Weird error trying to recreate directory $centhome/$projectname/random_spice/running/$userdir/$rundir\n";
	    $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	  }
	  else {
	    if (-e "$centhome/$projectname/random_spice/running/$userdir/$rundir.tar") {
	      system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/$rundir.tar >/dev/null 2>&1");
	    }
	    $cmd = "cd $centhome/$projectname/random_spice/results/$userdir >/dev/null 2>&1; ";
	    $cmd .= "$GTARPATH -cf $centhome/$projectname/random_spice/running/$userdir/$rundir.tar $rundir ";
	    $cmd .= "-X$centhome/$projectname/random_spice/templates/gtar_exclude.txt ";
	    $cmd .= ">/dev/null 2>&1";
	    system($cmd);
	    $status = $?;
	    if (($status != 0) || (! -e "$centhome/$projectname/random_spice/running/$userdir/$rundir.tar")) {
	      print "ERROR: Couldn't tar up old directory: $cmd\n";
	      $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	      system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/$rundir.tar >/dev/null 2>&1");
	      system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
	    }
	    else {
	      $cmd = "cd $centhome/$projectname/random_spice/running/$userdir >/dev/null 2>&1; ";
	      $cmd .= "$GTARPATH -xf $rundir.tar >/dev/null 2>&1";
	      system($cmd);
	      $status = $?;
	      if (($status != 0) || (! -e "$centhome/$projectname/random_spice/running/$userdir/$rundir")) {
	        print "ERROR: Couldn't untar: $cmd\n";
	        $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	        system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/$rundir.tar >/dev/null 2>&1");
	        system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
	      }
	      else {
	        system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/$rundir.tar >/dev/null 2>&1");

		if (!open(OUT,">$centhome/$projectname/random_spice/running/$userdir/$rundir/info.sum_cmd")) {
		  print "ERROR: Can't create file $centhome/$projectname/random_spice/running/$userdir/$rundir/info.sum_cmd : $!\n";
	          $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	          system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
		}
		else {
		  print OUT "$sum_cmd_new\n";
		  close(OUT);

	          $jobid = "sum\.$projectname\.$userdir\.$rundir";
	          push(@{$CTRL{"jobs"}{$jobid}{"dirs"}},"+$centhome/$projectname/random_spice/running/$userdir/$rundir");
	          $CTRL{"jobs"}{$jobid}{"group"} = shift(@sumqnames);
		  if ($#sumqnames != -1) {
	            @{$CTRL{"jobs"}{$jobid}{"altgroups"}} = @sumqnames;
		  }
                  $cmd = "/bin/csh -fc 'source /home/users3/bot/.cshrc >& /dev/null; ";
                  $cmd .= "setenv CODEBASE_weigand_rss_BUILD $build; ";
                  $cmd .= "setenv CODEBASE_weigand_rss_BUILDDIR $builddir; ";
	          $cmd .= "$builddir/rss_flow_part4.pl $projectname $cadhome $centhome $userdir $rundir ";
	          $cmd .= ">& $centhome/$projectname/random_spice/running/$userdir/$rundir/rss_flow_part4.pl.trace.txt'";
	          $CTRL{"jobs"}{$jobid}{"cmd"} = $cmd;
	          $CTRL{"jobs"}{$jobid}{"info_reason"} = $reason;
	          $CTRL{"jobs"}{$jobid}{"post"} = \&PostSubPart4;
	          $CTRL{"jobs"}{$jobid}{"info_projectname"} = $projectname;
	          $CTRL{"jobs"}{$jobid}{"info_centhome"} = $centhome;
	          $CTRL{"jobs"}{$jobid}{"info_userdir"} = $userdir;
	          $CTRL{"jobs"}{$jobid}{"info_rundir"} = $rundir;

		  $gotone = 1;
		}
	      }
	    }
	  }
	}
	elsif ($need_to_run_part4 && $need_to_run_part3) {
	  $nowdate = time;
	  if ($simrundate eq "") {
	    ## This cell has never been run before,  so put it higher in the
	    ## run priority...
	    $jobid1 = "a.sim\.$projectname\.$userdir\.$rundir";
	  }
	  elsif (($reason & (1 | 2 | 8 | 32)) != 0) {
	    ## These jobs get run first,  because they don't just have new vectors.
	    ## They have new netlists and/or new sim commands.  And they have
	    ## run at least once before.
	    ##
	    ## We use the simrundate integer to prioritize better.  The stuff
	    ## that's older gets run first.
	    if (abs($nowdate - $simrundate) > (60 * 60 * 24 * 30)) {
	      ## If a job hasn't run in more than 30 days,  just bump it
	      ## up to an "a" class job...
	      $jobid1 = "a.sim\.$simrundate\.$projectname\.$userdir\.$rundir";
	    }
	    else {
	      $jobid1 = "b.sim\.$simrundate\.$projectname\.$userdir\.$rundir";
	    }
	  }
	  else {
	    ## Just new vectors...
	    if (abs($nowdate - $simrundate) > (60 * 60 * 24 * 35)) {
	      ## If it's been over 5 weeks,  bump it to an "a" class job...
	      $jobid1 = "a.sim\.$simrundate\.$projectname\.$userdir\.$rundir";
	    }
	    elsif (abs($nowdate - $simrundate) > (60 * 60 * 24 * 28)) {
	      ## If it's been over 4 weeks,  bump it to a "b" class job...
	      $jobid1 = "b.sim\.$simrundate\.$projectname\.$userdir\.$rundir";
	    }
	    else {
	      $jobid1 = "c.sim\.$simrundate\.$projectname\.$userdir\.$rundir";
	    }
	  }

	  push(@{$CTRL{"jobs"}{$jobid1}{"dirs"}},"+$centhome/$projectname/random_spice/running/$userdir/$rundir");

	  $JOBXREF{"$projectname\.$userdir\.$rundir"} = $jobid1;

	  $CTRL{"jobs"}{$jobid1}{"group"} = shift(@simqnames);
	  if ($#simqnames != -1) {
	    @{$CTRL{"jobs"}{$jobid1}{"altgroups"}} = @simqnames;
	  }
          $cmd = "/bin/csh -fc 'source /home/users3/bot/.cshrc >& /dev/null; ";
          $cmd .= "setenv CODEBASE_weigand_rss_BUILD $build; ";
          $cmd .= "setenv CODEBASE_weigand_rss_BUILDDIR $builddir; ";
	  $cmd .= "$builddir/rss_flow_part3.pl $projectname $cadhome $centhome $userdir $rundir ";
	  $cmd .= ">& $centhome/$projectname/random_spice/running/$userdir/$rundir/rss_flow_part3.pl.trace.txt'";
	  $CTRL{"jobs"}{$jobid1}{"cmd"} = $cmd;
	  $CTRL{"jobs"}{$jobid1}{"post"} = \&PostSubPart3;
	  $CTRL{"jobs"}{$jobid1}{"info_reason"} = $reason;
	  $CTRL{"jobs"}{$jobid1}{"info_projectname"} = $projectname;
	  $CTRL{"jobs"}{$jobid1}{"info_centhome"} = $centhome;
	  $CTRL{"jobs"}{$jobid1}{"info_userdir"} = $userdir;
	  $CTRL{"jobs"}{$jobid1}{"info_rundir"} = $rundir;
	  
	  $jobid2 = "sum\.$projectname\.$userdir\.$rundir";
	  push(@{$CTRL{"jobs"}{$jobid2}{"dirs"}},"+$centhome/$projectname/random_spice/running/$userdir/$rundir");
	  $CTRL{"jobs"}{$jobid2}{"group"} = shift(@sumqnames);
	  if ($#sumqnames != -1) {
	    @{$CTRL{"jobs"}{$jobid2}{"altgroups"}} = @sumqnames;
	  }
          $cmd = "/bin/csh -fc 'source /home/users3/bot/.cshrc >& /dev/null; ";
          $cmd .= "setenv CODEBASE_weigand_rss_BUILD $build; ";
          $cmd .= "setenv CODEBASE_weigand_rss_BUILDDIR $builddir; ";
	  $cmd .= "$builddir/rss_flow_part4.pl $projectname $cadhome $centhome $userdir $rundir ";
	  $cmd .= ">& $centhome/$projectname/random_spice/running/$userdir/$rundir/rss_flow_part4.pl.trace.txt'";
	  $CTRL{"jobs"}{$jobid2}{"cmd"} = $cmd;
	  @{$CTRL{"jobs"}{$jobid2}{"posdep"}} = ($jobid1);
	  $CTRL{"jobs"}{$jobid2}{"post"} = \&PostSubPart4;
	  $CTRL{"jobs"}{$jobid2}{"info_reason"} = $reason;
	  $CTRL{"jobs"}{$jobid2}{"info_projectname"} = $projectname;
	  $CTRL{"jobs"}{$jobid2}{"info_centhome"} = $centhome;
	  $CTRL{"jobs"}{$jobid2}{"info_userdir"} = $userdir;
	  $CTRL{"jobs"}{$jobid2}{"info_rundir"} = $rundir;

	  $gotone = 1;
	}
      }
    }
  }

  if (! $gotone) {
    print "There are no simulation or summary jobs to run at this moment.\n";
    return 2;
  }

  ## NOTE: We used to check for bad sim_cmd and queue_sim properties.
  ## And we used to reprioritize the queue names so that batch stuff
  ## was last.  Now we do all of that in rss_flow_chkcf.pl.

  ## NOTE: No need to massage the "group" and "altgroups" properties,
  ## because this is bot, not a normal user.

  $psub::CRASHLIMIT = 5000; ## Because we could have PEON jobs getting killed.
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  $status = &psub::launch(\%CTRL);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRL);

  ## Now detect any failed runs...
  $dateval = localtime;
  print "\n$dateval: Finalizing the results...\n";

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

        $jobid1 = $JOBXREF{"$projectname\.$userdir\.$rundir"}; ## If it exists.
        $jobid2 = "sum\.$projectname\.$userdir\.$rundir";

        if ($CTRL{"jobs"}{$jobid1}{"cmd"} ne "") {
          if ($CTRL{"jobs"}{$jobid1}{"status"} ne "success") {
            $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
          } ## End else
        } ## End if

        if (($CTRL{"jobs"}{$jobid2}{"cmd"} ne "") && 
            (($CTRL{"jobs"}{$jobid1}{"cmd"} eq "") || ($CTRL{"jobs"}{$jobid1}{"status"} eq "success"))) {
          if ($CTRL{"jobs"}{$jobid2}{"status"} ne "success") {
            $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
          } ## End else
        } ## End if
      } ## End foreach
    } ## End foreach
  } ## End foreach

  return 1;
} ## End sub LaunchSimJobs
###############################################################################
sub CleanRunningDir {
  ## Removes the "running" directories now that they're not needed.
  local($projectname,$centhome,*DIR,@allfiles,$file);

  foreach $projectname (sort(keys(%CHIPS))) {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }
    $dateval = localtime;
    print "$dateval: Cleaning running directory in project $projectname...\n";

    $centhome = $CHIPS{$projectname}{"centhome"};

    if (! opendir(DIR,"$centhome/$projectname/random_spice/running")) {
      print "ERROR: Can't read directory: $centhome/$projectname/random_spice/running\n";
      last;
    }
    @allfiles = readdir(DIR);
    closedir(DIR);
    foreach $file (@allfiles) {
      if (($file eq '.') || ($file eq '..')) { next; }
      system("/bin/rm -rf $centhome/$projectname/random_spice/running/$file >/dev/null 2>&1");
    }
  }

  return 1;
} ## End sub CleanRunningDir
###############################################################################
sub PostSubPart3 {
  ## This is run after we run Part3 (the actual simulation run).  It's
  ## used to create job statistics file "info.simrun".  That's used by
  ## downline scripts.
  local($jobid,$CTRLref) = @_;
  local($status,$exitcode,$file,$projectname,$centhome,$userdir,$rundir,
        $reason,$endtime,$machine,$maxmem,$cputime,*DIR,*OUT,
	@allfiles);

  $status = $$CTRLref{"jobs"}{$jobid}{"status"};
  $exitcode = $$CTRLref{"jobs"}{$jobid}{"exitcode"};
  if ($exitcode == 111) { $exitcode = 110; }

  $projectname = $$CTRLref{"jobs"}{$jobid}{"info_projectname"};
  $centhome = $$CTRLref{"jobs"}{$jobid}{"info_centhome"};
  $userdir = $$CTRLref{"jobs"}{$jobid}{"info_userdir"};
  $rundir = $$CTRLref{"jobs"}{$jobid}{"info_rundir"};
  $reason = $$CTRLref{"jobs"}{$jobid}{"info_reason"};

  $endtime = localtime($$CTRLref{"jobs"}{$jobid}{"end"});
  $machine = $$CTRLref{"jobs"}{$jobid}{"machine"};
  $maxmem = $$CTRLref{"jobs"}{$jobid}{"maxmem"};
  $cputime = $$CTRLref{"jobs"}{$jobid}{"cputime"};

  if (!open(OUT,">$centhome/$projectname/random_spice/running/$userdir/$rundir/info.simrun")) {
    print "ERROR: PostSubPart3: Unable to create file: $centhome/$projectname/random_spice/running/$userdir/$rundir/info.simrun : $!\n";
    return 1;
  }
  print OUT "$endtime\n";
  print OUT "$cputime\n";
  print OUT "$maxmem\n";
  print OUT "$machine\n";
  print OUT "$reason\n";
  close(OUT);

  if ($exitcode != 0) {
    print "ERROR: Crashed / failed run detected during sim.  Moving run $projectname $userdir $rundir to results crashed_run dir....\n";
    &EmailUser("part3","$centhome/$projectname/random_spice/user/$userdir/control.pl","$centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir",$userdir,$rundir);
    if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir") {
      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
    }
    if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir") {
      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
    if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
      system("/bin/mkdir $centhome/$projectname/random_spice/results/$userdir/crashed_run >/dev/null 2>&1");
    }
    if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
      print "ERROR: Can't create directory $centhome/$projectname/random_spice/results/$userdir/crashed_run\n";
      print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
      system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
    }
    else {
      if (opendir(DIR,"$centhome/$projectname/random_spice/running/$userdir/$rundir")) {
        @allfiles = readdir(DIR);
	closedir(DIR);
	foreach $file (@allfiles) {
	  if (($file =~ /^main\.chk$/) ||
	      ($file =~ /^main\.chk\.err\.txt[0-9]$/) ||
	      ($file eq "main.log") ||
	      ($file eq "sim.log")) {
            system("$GZIPPATH -9 $centhome/$projectname/random_spice/running/$userdir/$rundir/$file >/dev/null 2>&1");
	  }
	}
      }
      system("/bin/mv -f $centhome/$projectname/random_spice/running/$userdir/$rundir $centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
      system("/bin/touch $centhome/$projectname/random_spice/templates/pending_summaries/$userdir\-$rundir >/dev/null 2>&1");
    }
  }
  else {
    if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir") {
      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
    }
  }

  return $exitcode;
} ## End sub PostSubPart3
###############################################################################
sub PostSubPart4 {
  ## This is run after we run Part3 (the actual simulation run).  It's
  ## used to create job statistics file "info.simrun".  That's used by
  ## downline scripts.
  local($jobid,$CTRLref) = @_;
  local($exitcode,$projectname,$centhome,$userdir,$rundir);
        
  $exitcode = $$CTRLref{"jobs"}{$jobid}{"exitcode"};
  if ($exitcode == 111) { $exitcode = 110; }

  $projectname = $$CTRLref{"jobs"}{$jobid}{"info_projectname"};
  $centhome = $$CTRLref{"jobs"}{$jobid}{"info_centhome"};
  $userdir = $$CTRLref{"jobs"}{$jobid}{"info_userdir"};
  $rundir = $$CTRLref{"jobs"}{$jobid}{"info_rundir"};

  if ($exitcode != 0) {
    print "ERROR: Crashed / failed run detected during summary.  Moving run $projectname $userdir $rundir to results crashed_run dir....\n";
    &EmailUser("part4","$centhome/$projectname/random_spice/user/$userdir/control.pl","$centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir",$userdir,$rundir);
    if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir") {
      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
    if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
      system("/bin/mkdir $centhome/$projectname/random_spice/results/$userdir/crashed_run >/dev/null 2>&1");
    }
    if (! -e "$centhome/$projectname/random_spice/results/$userdir/crashed_run") {
      print "ERROR: Can't create directory $centhome/$projectname/random_spice/results/$userdir/crashed_run\n";
      print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
      system("/bin/rm -rf $centhome/$projectname/random_spice/running/$userdir/$rundir >/dev/null 2>&1");
    }
    else {
      system("/bin/mv -f $centhome/$projectname/random_spice/running/$userdir/$rundir $centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
      system("/bin/touch $centhome/$projectname/random_spice/templates/pending_summaries/$userdir\-$rundir >/dev/null 2>&1");
    }
  }
  else {
    if (-e "$centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir") {
      system("/bin/rm -rf $centhome/$projectname/random_spice/results/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
  }

  return $exitcode;
} ## End sub PostSubPart4
###############################################################################
sub SetSlaves {
  ## Settings for Psub slave groups.  These may need to be updated occasionally
  ## to track the changes in /vlsi/cad/queue/current/b.conf....

  local($CTRLref) = @_;
  local($slavegroup, $total_hsim, $total_hsimbat, $total_hsimbg, $total_hsimms,
	$total_hsimmsbat, $total_hsimmsbg, $total_hsimns, $total_hsimnsbat,
	$total_hsimnsms, $total_hsimnsmsbat, $total_hspbatch, $total_hspice,
	$total_xa, $total_xabat);

  #################
  ## First we calculate the total slots we have available for each of the
  ## SPICE simulator queues.  This is based on the license counts and the
  ## user limits for each queue...

  ## hspice and hspbatch queue...

  if ($opBAT)    { $total_hspice = 0; }
  elsif ($opBOT) { $total_hspice = $BOT_HSPICE_SLOTS; }
  else           { $total_hspice = $USER_HSPICE_SLOTS; }
  if ($opEMERGENCY) {
    ## If -emergency,  then give all hsim licenses except for the ones reserved
    ## for bot...
    $total_hspice = $TOTAL_LICENSES_HSPICE - $BOT_HSPICE_SLOTS;
    if ($total_hspice <= 0) { $total_hspice = 1; }
  }
  elsif ($opEMERGENCY2) {
    ## If -emergency2,  then give all hsim licenses including the ones reserved
    ## for bot...
    $total_hspice = $TOTAL_LICENSES_HSPICE;
  }
  if ($opNOBAT)   { $total_hspbatch = 0; }
  elsif (!$opBOT) { $total_hspbatch = $TOTAL_LICENSES_HSPICE - $BOT_HSPICE_SLOTS - $total_hspice; }
  else            { $total_hspbatch = $TOTAL_LICENSES_HSPICE - $BOT_HSPICE_SLOTS; }
  if ($total_hspbatch < 0) {
    $total_hspbatch = 0;
  }
  if (($total_hspbatch == 0) && (!$opNOBAT)) {
    $total_hspbatch = 1; ## Just in case
  }

  ## xa and xabat queue...

  if ($opBAT)    { $total_xa = 0; }
  elsif ($opBOT) { $total_xa = $BOT_XA_SLOTS; }
  else           { $total_xa = $USER_XA_SLOTS; }
  if ($opEMERGENCY) {
    ## If -emergency,  then give all xa/hsim licenses except for the ones reserved
    ## for bot...
    $total_xa = $TOTAL_LICENSES_XA - $BOT_XA_SLOTS;
    if ($total_xa <= 0) { $total_xa = 1; }
  }
  elsif ($opEMERGENCY2) {
    ## If -emergency2,  then give all xa/hsim licenses including the ones reserved
    ## for bot...
    $total_xa = $TOTAL_LICENSES_XA;
  }
  if ($opNOBAT)   { $total_xabat = 0; }
  elsif (!$opBOT) { $total_xabat = $TOTAL_LICENSES_XA - $BOT_XA_SLOTS - $total_xa; }
  else            { $total_xabat = $TOTAL_LICENSES_XA - $BOT_XA_SLOTS; }
  if ($total_xabat < 0) {
    $total_xabat = 0;
  }
  if (($total_xabat == 0) && (!$opNOBAT)) {
    $total_xabat = 1; ## Just in case
  }

  #################
  ## Now on to the psub settings...

  ## hspice

  $$CTRLref{"slaves"}{"hspice"}{"numslaves"} = $total_hspice;
  $$CTRLref{"slaves"}{"hspice"}{"qname"} = "hspice";
  $$CTRLref{"slaves"}{"hspice"}{"stay"} = 1;
  if ($opBOT) {
    $$CTRLref{"slaves"}{"hspice"}{"staytimeout"} = 86400;
  }
  elsif ($opEMERGENCY || $opEMERGENCY2) {
    $$CTRLref{"slaves"}{"hspice"}{"staytimeout"} = 6 * 3600;
  }
  else {
    $$CTRLref{"slaves"}{"hspice"}{"staytimeout"} = 1800;
  }
  $$CTRLref{"slaves"}{"hspice"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"hspice"}{"crashproof"} = 1;
  if ($total_hspice == 0) { delete($$CTRLref{"slaves"}{"hspice"}); }

  ## hspbatch

  $$CTRLref{"slaves"}{"hspbatch"}{"numslaves"} = $total_hspbatch;
  $$CTRLref{"slaves"}{"hspbatch"}{"qname"} = "hspbatch";
  $$CTRLref{"slaves"}{"hspbatch"}{"stay"} = 1;
  if ($opEMERGENCY || $opEMERGENCY2) {
    $$CTRLref{"slaves"}{"hspbatch"}{"staytimeout"} = 6 * 3600;
  }
  else {
    $$CTRLref{"slaves"}{"hspbatch"}{"staytimeout"} = 600;
  }
  $$CTRLref{"slaves"}{"hspbatch"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"hspbatch"}{"crashproof"} = 1;
  if ($total_hspbatch == 0) { delete($$CTRLref{"slaves"}{"hspbatch"}); }

  ## xa

  $$CTRLref{"slaves"}{"xa"}{"numslaves"} = $total_xa;
  $$CTRLref{"slaves"}{"xa"}{"qname"} = "xa";
  $$CTRLref{"slaves"}{"xa"}{"stay"} = 1;
  if ($opBOT) {
    $$CTRLref{"slaves"}{"xa"}{"staytimeout"} = 86400;
  }
  elsif ($opEMERGENCY || $opEMERGENCY2) {
    $$CTRLref{"slaves"}{"xa"}{"staytimeout"} = 6 * 3600;
  }
  else {
    $$CTRLref{"slaves"}{"xa"}{"staytimeout"} = 1800;
  }
  $$CTRLref{"slaves"}{"xa"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"xa"}{"crashproof"} = 1;
  if ($total_xa == 0) { delete($$CTRLref{"slaves"}{"xa"}); }

  ## xabat

  $$CTRLref{"slaves"}{"xabat"}{"numslaves"} = $total_xabat;
  $$CTRLref{"slaves"}{"xabat"}{"qname"} = "xabat";
  $$CTRLref{"slaves"}{"xabat"}{"stay"} = 1;
  if ($opEMERGENCY || $opEMERGENCY2) {
    $$CTRLref{"slaves"}{"xabat"}{"staytimeout"} = 6 * 3600;
  }
  else {
    $$CTRLref{"slaves"}{"xabat"}{"staytimeout"} = 600;
  }
  $$CTRLref{"slaves"}{"xabat"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"xabat"}{"crashproof"} = 1;
  if ($total_xabat == 0) { delete($$CTRLref{"slaves"}{"xabat"}); }

  ## And the rest...

  $$CTRLref{"slaves"}{"linux"}{"numslaves"} = 12; ## Limited by peak disk I/O.
  $$CTRLref{"slaves"}{"linux"}{"qname"} = "linux";
  $$CTRLref{"slaves"}{"linux"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"linux"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"linux"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"linux"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"vxl"}{"numslaves"} = 11; ## Limited by 11 verilog-xl licenses.
  $$CTRLref{"slaves"}{"vxl"}{"qname"} = "vxl";
  $$CTRLref{"slaves"}{"vxl"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"vxl"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"vxl"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"vxl"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"dynacell"}{"numslaves"} = 12;
  $$CTRLref{"slaves"}{"dynacell"}{"qname"} = "dynacell";
  $$CTRLref{"slaves"}{"dynacell"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"dynacell"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"dynacell"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"dynacell"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"unix"}{"numslaves"} = 5;
  $$CTRLref{"slaves"}{"unix"}{"qname"} = "unix";
  $$CTRLref{"slaves"}{"unix"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"unix"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"unix"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"unix"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"unixfast"}{"numslaves"} = 4;
  $$CTRLref{"slaves"}{"unixfast"}{"qname"} = "unixfast";
  $$CTRLref{"slaves"}{"unixfast"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"unixfast"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"unixfast"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"unixfast"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"lnx4"}{"numslaves"} = 6;
  $$CTRLref{"slaves"}{"lnx4"}{"qname"} = "lnx4";
  $$CTRLref{"slaves"}{"lnx4"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"lnx4"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"lnx4"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"lnx4"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"lnx32"}{"numslaves"} = 1;
  $$CTRLref{"slaves"}{"lnx32"}{"qname"} = "lnx32";
  $$CTRLref{"slaves"}{"lnx32"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"lnx32"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"lnx32"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"lnx32"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"lnx64"}{"numslaves"} = 1;
  $$CTRLref{"slaves"}{"lnx64"}{"qname"} = "lnx64";
  $$CTRLref{"slaves"}{"lnx64"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"lnx64"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"lnx64"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"lnx64"}{"crashproof"} = 1;

  $$CTRLref{"slaves"}{"lnxbig"}{"numslaves"} = 6;
  $$CTRLref{"slaves"}{"lnxbig"}{"qname"} = "lnxbig";
  $$CTRLref{"slaves"}{"lnxbig"}{"stay"} = 1;
  $$CTRLref{"slaves"}{"lnxbig"}{"staytimeout"} = 600;
  $$CTRLref{"slaves"}{"lnxbig"}{"inactivetimeout"} = 60;
  $$CTRLref{"slaves"}{"lnxbig"}{"crashproof"} = 1;

  foreach $slavegroup (keys(%{$$CTRLref{"slaves"}})) {
    if ($$CTRLref{"slaves"}{$slavegroup}{"qname"} eq "") { next; }
    if ($$CTRLref{"slaves"}{$slavegroup}{"numslaves"} == 0) { next; }
    @{$$CTRLref{"slaves"}{$slavegroup}{"dirs"}} = ($MAIN_SCRATCH_DIR,$CODEBASE_CBDIR,"/vlsi/cad2/bin","/vlsi/cad3/bin",$HOME,$CADHOME);
    if ($opPRIORITY ne "") {
      $$CTRLref{"slaves"}{$slavegroup}{"priority"} = $opPRIORITY;
    }
  }

  return 1;
} ## End sub SetSlaves
###############################################################################
###############################################################################
## MANUAL FLOW STUFF FOLLOWS ...
###############################################################################
###############################################################################
sub Manual_ScanForControlFiles {
  ## Similar to ScanForControlFiles().

  local($ctrlfile,$real_ctrlfile,@line,$userdir);

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    if (! -e $real_ctrlfile) {
      print "ERROR: Can't find control file: $real_ctrlfile\n";
      exit(1);
    }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if (($userdir eq ".") || ($userdir eq "..")) {
      print "ERROR: Userdir is \"$userdir\" for control file \"$ctrlfile\".  Bad userdir.\n";
      exit(1);
    }
    if ($userdir =~ /[^a-zA-Z0-9_\.]/) {
      print "ERROR: The userdir contains illegal characters: $userdir ($ctrlfile)\n";
      exit(1);
    }
  } ## End foreach

  return 1;
} ## End sub Manual_ScanForControlFiles
###############################################################################
sub Manual_MakeUserDirs {
  ## Make the running/results user dirs if not present...
  local ($ctrlfile,$dirname,$real_ctrlfile,@line,$userdir);

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    foreach $dirname ("$opWORKDIR/$userdir",
                      "$opRESULTSDIR/$userdir") {
      if (! -e $dirname) {
        system("/bin/mkdir $dirname >/dev/null 2>&1");
      }
      if (! -e $dirname) {
        print "ERROR: Unable to make directory: $dirname\n";
        exit(1);
      }
      system("/bin/chmod 777 $dirname >/dev/null 2>&1");
    }
  }

  return 1;
} ## End sub Manual_MakeUserDirs
###############################################################################
sub Manual_LaunchControlFileJobs {
  ## Just like LaunchControlFileJobs()

  local($cmd, $ctrlfile, $datenow, $datestamp, $dateval, $dumpfile,
        $dumpfile_lock, $dumpfile_lock_resolved, $dumpfile_resolved,
	$file, $file_tmp, $gotone, $jobid, $lockstring, $machinename, $pid,
	$real_ctrlfile, $result, $slavegroup, $starttime, $status, $thingy,
	$userdir, $username, %CTRL, *DIR, @allfiles, @line, @results);

  $dateval = localtime;
  print "\n$dateval: Launching dump_control job(s)...\n";
  $psub::CRASHLIMIT = 200;
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  %CTRL = ();
  &SetSlaves(\%CTRL);
  $CTRL{"socket"} = -1;
  @{$CTRL{"socketusers"}} = ($USER,"weigand","root");

  $gotone = 0;

  foreach $slavegroup (keys(%{$CTRL{"slaves"}})) {
    push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$CHIP);
    push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$MAIN_SCRATCH_DIR);
    if (-e "$CHIP/random_spice/manual_running") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$CHIP/random_spice/manual_running");
    }
    if (-e "$CHIP/random_spice/manual_results") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$CHIP/random_spice/manual_results");
    }
    if ($opWORKDIR ne "") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$opWORKDIR);
    }
    if ($opRESULTSDIR ne "") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$opRESULTSDIR);
    }
  }

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    $dumpfile = "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$";
    $dumpfile_resolved = &GimmeSimplePath($dumpfile);
    if ($dumpfile_resolved eq "") { $dumpfile_resolved = $dumpfile; }
    $CHIPS{$userdir}{"dumpfile"} = $dumpfile_resolved;

    ## Get a lock on the dumpfile to prevent it from being deleted by
    ## another instance of the program running...

    $result = &file_lock::Lock($dumpfile_resolved);
    if ($result == 0) {
      ## This should never happen in reality, because the lock file actually
      ## has the hostname and pid in it. But who knows, maybe a bug or a
      ## problem with the file lock daemon?
      if ($file_lock::ERRMSG ne "") {
        print "ERROR: File locking reports error: $file_lock::ERRMSG\n";
        print "ERROR: Try again later.\n";
        exit(1);
      }
      print "\nWARNING: Unable to get a file lock for \"$dumpfile_resolved\". Contact programmer.\n";
      foreach $thingy (@file_lock::LOCKS_INVALID) {
        $thingy =~ /^(\S+) (\S+) (\S+) (\S+) (.*)$/;
        $machinename = $1;
        $username = $2;
        $pid = $3;
        $starttime = localtime($4);
        $lockstring = $5;
        print "  -> lockfile = $lockstring\n";
        print "     user     = $username\n";
        print "     machine  = $machinename\n";
        print "     pid      = $pid\n";
        print "     since    = $starttime\n\n";
      }
      $CHIPS{$userdir}{"bad"} = 1;
      next;
    }

    $jobid = "dump_control\.$userdir";

    push(@{$CTRL{"jobs"}{$jobid}{"dirs"}},"+$opWORKDIR/$userdir");

    $CTRL{"jobs"}{"dump_control\.$userdir"}{"group"} = "linux";
    $cmd = "/bin/csh -fc 'source $HOME/.cshrc >& /dev/null; ";
    $cmd .= "$CODEBASE_BUILDDIR/rss_flow_part1.pl -manual $CHIPBRF $CADHOME $CENTHOME $userdir $real_ctrlfile $opWORKDIR ";
    $cmd .= "control_file_dump.$HOSTNAME.$$ ";
    $cmd .= "COPY_TM_CHKCF.$HOSTNAME.$$ ";
    $cmd .= ">& $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt'";
    $CTRL{"jobs"}{"dump_control\.$userdir"}{"cmd"} = $cmd;
    $CTRL{"jobs"}{"dump_control\.$userdir"}{"info_dumpfile"} = $dumpfile_resolved;
    $gotone = 1;

    if (-e $dumpfile_resolved) {
      system("/bin/rm -f $dumpfile_resolved >/dev/null 2>&1");
    }
    if (-e "$opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt") {
      system("/bin/rm -f $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt >/dev/null 2>&1");
    }
    if (-e "$opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$") {
      system("/bin/rm -rf $opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$ >/dev/null 2>&1");
    }

    ## And let's cleanup any control file dumps that might have come from
    ## interrupted runs...

    if (!opendir(DIR,"$opWORKDIR/$userdir")) {
      print "ERROR: Can't read directory $opWORKDIR/$userdir : $!\n";
      exit(1);
    }
    @allfiles = readdir(DIR);
    closedir(DIR);

    $datenow = time;

    foreach $file (@allfiles) {
      if (($file =~ /^rss_flow_part1\..*trace\.txt$/) ||
          ($file =~ /^control_file_dump\..*$/) ||
          ($file =~ /^COPY_TM_CHKCF\..*$/)) {
        ## Query file lock on this...
        ## File will look like one of these:
        ##   control_file_dump.$HOSTNAME.$$
        ##   rss_flow_part1.$HOSTNAME.$$.trace.txt
        ##   COPY_TM_CHKCF.$HOSTNAME.$$
        $file_tmp = $file;
        $file_tmp =~ s/\.trace\.txt$//;
        $file_tmp =~ s/^control_file_dump\.//;
        $file_tmp =~ s/^rss_flow_part1\.//;
        $file_tmp =~ s/^COPY_TM_CHKCF\.//;

        $dumpfile_lock = "$opWORKDIR/$userdir/control_file_dump.$file_tmp";

        $dumpfile_lock_resolved = &GimmeSimplePath($dumpfile_lock);
        if ($dumpfile_lock_resolved eq "") { $dumpfile_lock_resolved = $dumpfile_lock; }

        @results = file_lock::Check($dumpfile_lock_resolved);
        if (($#results != -1) && ($results[0] == 0)) {
          ## The lock isn't present on this file, so we can delete it...
          system("/bin/rm -f $dumpfile_lock_resolved >/dev/null 2>&1");
          if (-e "$opWORKDIR/$userdir/rss_flow_part1.$file_tmp.trace.txt") {
            system("/bin/rm -f $opWORKDIR/$userdir/rss_flow_part1.$file_tmp.trace.txt >/dev/null 2>&1");
          }
          if (-e "$opWORKDIR/$userdir/COPY_TM_CHKCF.$file_tmp") {
            system("/bin/rm -rf $opWORKDIR/$userdir/COPY_TMP_CHKCF.$file_tmp >/dev/null 2>&1");
          }
        }
      }
    }
  }

  if (! $gotone) {
    print "There are no jobs to run at this moment.  Aborting flow.\n";
    exit(1);
  }

  $status = &psub::launch(\%CTRL);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRL);

  ## Now detect any failed runs, and move their running directories
  ## to the results/$userdir/crashed_run directory.

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    if ($CTRL{"jobs"}{"dump_control\.$userdir"}{"status"} eq "success") {
      if (-e "$opRESULTSDIR/$userdir/crashed_run/part1") {
        system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part1 >/dev/null 2>&1");
      }
    }
    else {
      print "ERROR: Crashed / failed run detected during dump_control.  Moving run \"$userdir\" to \"$opRESULTSDIR/$userdir/crashed_run/part1/\" dir....\n";
      &EmailUser("part1",$real_ctrlfile,"$opRESULTSDIR/$userdir/crashed_run/part1",$userdir,"");
      $CHIPS{$userdir}{"bad"} = 1;

      ## NOTE: There's still the possibility of a race condition here if you have
      ## more than one run happening at the same time with two different command
      ## lines. They could both crash at the same time, and then they're now
      ## fighting to create the crashed_run directory and move files to it.  It
      ## shouldn't be a problem, though, because they should both have the same
      ## data....

      if (-e "$opRESULTSDIR/$userdir/crashed_run/part1") {
        system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part1 >/dev/null 2>&1");
      }
      if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
        system("/bin/mkdir $opRESULTSDIR/$userdir/crashed_run >/dev/null 2>&1");
      }
      if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
        print "ERROR: Can't create directory $opRESULTSDIR/$userdir/crashed_run\n";
        print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
        if (-e "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$") {
          system("/bin/rm -f $opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$ >/dev/null 2>&1");
        }
        if (-e "$opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt") {
          system("/bin/rm -f $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt >/dev/null 2>&1");
        }
        if (-e "$opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$") {
          system("/bin/rm -f $opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$ >/dev/null 2>&1");
        }
      }
      else {
        system("/bin/chmod 777 $opRESULTSDIR/$userdir/crashed_run >/dev/null 2>&1");
        system("/bin/mkdir $opRESULTSDIR/$userdir/crashed_run/part1 >/dev/null 2>&1");
        if (! -e "$opRESULTSDIR/$userdir/crashed_run/part1") {
          print "ERROR: Can't create directory $opRESULTSDIR/$userdir/crashed_run/part1\n";
          print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
          if (-e "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$") {
            system("/bin/rm -f $opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$ >/dev/null 2>&1");
          }
          if (-e "$opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt") {
            system("/bin/rm -f $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt >/dev/null 2>&1");
          }
          if (-e "$opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$") {
            system("/bin/rm -f $opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$ >/dev/null 2>&1");
          }
        }
        else {
          system("/bin/chmod 777 $opRESULTSDIR/$userdir/crashed_run/part1 >/dev/null 2>&1");
          if (-e "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$") {
            system("/bin/mv -f $opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$ $opRESULTSDIR/$userdir/crashed_run/part1/control_file_dump.txt >/dev/null 2>&1");
	  }
	  if (-e "$opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt") {
            system("/bin/mv -f $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt $opRESULTSDIR/$userdir/crashed_run/part1/rss_flow_part1.trace.txt >/dev/null 2>&1");
	  }
          if (-e "$opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$") {
            system("/bin/mv -f $opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$ $opRESULTSDIR/$userdir/crashed_run/part1/COPY_TM_CHKCF >/dev/null 2>&1");
	  }
          system("/bin/chmod -R a+rw $opRESULTSDIR/$userdir/crashed_run/part1 >/dev/null 2>&1");
        }
      }

      ## And now release the lock...

      $dumpfile_resolved = $CHIPS{$userdir}{"dumpfile"};
      file_lock::Unlock($dumpfile_resolved);
    }
  }

  return 1;
} ## End sub Manual_LaunchControlFileJobs
###############################################################################
sub Manual_ReadControlFileDumps {
  ## Just like ReadControlFileDumps()
  ## Structure is:
  ##  $CHIPS{$userdir}{....}

  local($ctrlfile, $dateval, $dumpfile, $dumpfile_lock, $real_ctrlfile,
        $rundir, $runval, $userdir, *IN, @line);

  $dateval = localtime;
  print "\n$dateval: Reading the control file dump(s)...\n";

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} == 1) { next; }

    $dumpfile = "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$";

    if (!open(IN,"<$dumpfile")) {
      print "ERROR: Couldn't read control file dump: $dumpfile\n";
      &Manual_CleanUpTempfiles();
      $dumpfile_lock = $CHIPS{$userdir}{"dumpfile"};
      file_lock::Unlock($dumpfile_lock);
      file_lock::Done();
      exit(1);
    }
    $rundir = "";
    while(<IN>) {
      chop;
      if (s/^RUNDIR: //) {
        $rundir = $_;
        if ($rundir =~ /[^a-zA-Z0-9_\.]/) {
          print "ERROR: The rundir contains illegal characters: \"$rundir\" ($ctrlfile)\n";
          $rundir = "";
          next;
        }
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
      elsif (/ERROR:/) {
        ## The rss_flow_part1.pl script should've catched any errors,  but
        ## just in case...
        delete($CHIPS{$userdir});
        last;
      }
      elsif ($rundir eq "") { next; }
      elsif (/^\s+run = \"(.*)\"$/) {
        $runval = $1;
        if ($runval != 0) {
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 2;
        }
      }
      elsif (/^\s+eckt_cellname = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"} = $1;
      }
      elsif (/^\s+eckt = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"eckt"} = $1;
      }
      elsif (/^\s+spice_techfile = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"spice_techfile"} = $1;
      }
      elsif (/^\s+sim_cmd = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"sim_cmd"} = $1;
      }
      elsif (/^\s+sim_type = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"sim_type"} = $1;
      }
      elsif (/^\s+sum_cmd = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"sum_cmd"} = $1;
      }
      elsif (/^\s+limit_kept_logs = \"(.*)\"$/) {
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"limit_kept_logs"} = $1;
      }
      elsif (s/^\s+queue_prep = \(//) {
        s/[\)\"]+//g;
        @line = split(/[ \t,]+/);
        @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_prep"}} = @line;
      }
      elsif (s/^\s+queue_sim = \(//) {
        s/[\)\"]+//g;
        @line = split(/[ \t,]+/);
        @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_sim"}} = @line;
      }
      elsif (s/^\s+queue_sum = \(//) {
        s/[\)\"]+//g;
        @line = split(/[ \t,]+/);
        @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_sum"}} = @line;
      }
    }
    close(IN);
  }

  return 1;
} ## End sub Manual_ReadControlFileDumps
###############################################################################
sub Manual_FindBadRundirs {
  ## Goes through the command line -run option and looks for any rundirs
  ## that weren't in the control file dump...
  local($badrun,$userrundir,@line,$userdir,$rundir,$ctrlfile,$real_ctrlfile);

  $badrun = 0;

  foreach $userrundir (sort(keys(%opRUN))) {
    if ($opRUN{$userrundir} == 0) { next; }
    @line = split(/\//,$userrundir);
    $userdir = shift(@line);
    $rundir = shift(@line);

    if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} == 0) {
      print "ERROR: Command line option \"-run $userrundir\" given,  but rundir \"$rundir\" doesn't exist in the control file for userdir=\"$userdir\".\n";
      $badrun = 1;
    }
  }
  if ($badrun == 1) {
    &Manual_CleanUpTempfiles();
    file_lock::Done();
    exit(1);
  }

  return 1;
} ## End sub Manual_FindBadRundirs
###############################################################################
sub Manual_FindAllLicenses {
  ## Up until now we didn't do a license check, because we didn't know which
  ## licenses were needed.  Now we do, so we check for licenses. Cancel jobs
  ## which have no licenses to run them...

  local($ctrlfile, $dateval, $did_hspice_licchk, $did_xa_licchk, $qname,
        $real_ctrlfile, $rundir, $userdir, $uses_hspbatch, $uses_hspice,
	$uses_xa, $uses_xabat, @line, @queue_sim);

  $dateval = localtime;
  print "\n$dateval: Finding licenses...\n";

  $did_xa_licchk = 0;
  $did_hspice_licchk = 0;

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

      @queue_sim = @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_sim"}};

      $uses_hspice = 0;
      $uses_hspbatch = 0;
      $uses_xa = 0;
      $uses_xabat = 0;
      
      foreach $qname (@queue_sim) {
        if    ($qname eq "hspice")      { $uses_hspice = 1; }
        elsif ($qname eq "hspbatch")    { $uses_hspbatch = 1; }
        elsif ($qname eq "xa")          { $uses_xa = 1; }
        elsif ($qname eq "xabat")       { $uses_xabat = 1; }
      }

      if ($uses_hspice || $uses_hspbatch) {
        if (! $did_hspice_licchk) {
          &FindTotalHspiceLicenses();
          $did_hspice_licchk = 1;
        }
        if ($TOTAL_LICENSES_HSPICE == 0) {
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
          print "ERROR: No hspice licenses to run userdir=\"$userdir\" rundir=\"$rundir\". Canceling job.\n";
          next;
        }
      }
      if ($uses_xa || $uses_xabat) {
        if (! $did_xa_licchk) {
          &FindTotalXaLicenses();
          $did_xa_licchk = 1;
        }
        if ($TOTAL_LICENSES_XA == 0) {
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
          print "ERROR: No xa/hsim licenses to run userdir=\"$userdir\" rundir=\"$rundir\". Canceling job.\n";
          next;
        }
      }
    }
  }

  return 1;
} ## End sub Manual_FindAllLicenses
###############################################################################
sub Manual_PrepareRundirs {
  ## Just like PrepareRundirs()
  local($dateval,$gotone,$ctrlfile,$real_ctrlfile,@line,$userdir,$rundir);

  $dateval = localtime;
  print "\n$dateval: Cleaning up and/or creating individual rundir directories ...\n";

  $gotone = 0;

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
      if (! -e "$opRESULTSDIR/$userdir/$rundir") {
        print "Creating new rundir: $opRESULTSDIR/$userdir/$rundir\n";
        system("/bin/mkdir $opRESULTSDIR/$userdir/$rundir >/dev/null 2>&1");
        if (! -e "$opRESULTSDIR/$userdir/$rundir") {
          print "ERROR: Unable to create rundir: $opRESULTSDIR/$userdir/$rundir\n";
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
        }
      }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
      system("/bin/chmod 777 $opRESULTSDIR/$userdir/$rundir >/dev/null 2>&1");
      if (-e "$opWORKDIR/$userdir/$rundir") {
        system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
      }
      system("/bin/mkdir $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
      if (! -e "$opWORKDIR/$userdir/$rundir") {
        print "ERROR: Unable to create rundir: $opWORKDIR/$userdir/$rundir\n";
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
      else {
        system("/bin/chmod 777 $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
        $gotone = 1;
      }
    }
  }

  if (!$gotone) {
    print "ERROR: Nothing to do.\n";
    &Manual_CleanUpTempfiles();
    file_lock::Done();
    exit(1);
  }

  return 1;
} ## End sub Manual_PrepareRundirs
###############################################################################
sub Manual_LaunchDataPrepJobs {
  ## Just like LaunchDataPrepJobs()
  local($cmd, $counter, $ctrlfile, $dateval, $dumpfile_lock, $gotone, $jobid,
        $real_ctrlfile, $rundir, $slavegroup, $status, $userdir, %CTRL, @line,
	@qnames);

  $dateval = localtime;
  print "\n$dateval: Launching data prep job(s)...\n";
  $psub::CRASHLIMIT = 200;
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  %CTRL = ();
  &SetSlaves(\%CTRL);
  $CTRL{"socket"} = -1;
  @{$CTRL{"socketusers"}} = ($USER,"weigand","root");

  $gotone = 0;

  foreach $slavegroup (keys(%{$CTRL{"slaves"}})) {
    push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$CHIP);
    push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$MAIN_SCRATCH_DIR);
    if (-e "$CHIP/random_spice/manual_running") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$CHIP/random_spice/manual_running");
    }
    if (-e "$CHIP/random_spice/manual_results") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$CHIP/random_spice/manual_results");
    }
    if ($opWORKDIR ne "") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$opWORKDIR);
    }
    if ($opRESULTSDIR ne "") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$opRESULTSDIR);
    }
  }

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

      @qnames = @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_prep"}};

      if ($#qnames == -1) { @qnames = ("vxl"); } ## Shouldn't happen.
      
      $jobid = "data_prep\.$userdir\.$rundir";
      push(@{$CTRL{"jobs"}{$jobid}{"dirs"}},"+$opWORKDIR/$userdir/$rundir");
      $CTRL{"jobs"}{$jobid}{"group"} = shift(@qnames);
      if ($#qnames != -1) {
        @{$CTRL{"jobs"}{$jobid}{"altgroups"}} = @qnames;
      }
      $cmd = "/bin/csh -fc 'source $HOME/.cshrc >& /dev/null; ";
      $cmd .= "$CODEBASE_BUILDDIR/rss_flow_part2.pl -manual $CHIPBRF $CADHOME $CENTHOME $userdir $rundir $opWORKDIR ";
      $cmd .= "control_file_dump.$HOSTNAME.$$ ";
      $cmd .= "rss_flow_part1.$HOSTNAME.$$.trace.txt ";
      $cmd .= "COPY_TM_CHKCF.$HOSTNAME.$$ ";
      $cmd .= ">& $opWORKDIR/$userdir/$rundir/rss_flow_part2.pl.trace.txt'";
      $CTRL{"jobs"}{$jobid}{"cmd"} = $cmd;
      $gotone = 1;
    }
  }

  if (! $gotone) {
    print "There are no jobs to run at this moment.  Aborting flow.\n";

    ## Now cleanup the running directory...
    foreach $ctrlfile (@opCTRL) {
      $real_ctrlfile = $ctrlfile;
      if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
      @line = split(/\//,$real_ctrlfile);
      $userdir = $line[$#line - 1];

      if ($opRUN_something) {
        foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
          if ($opRUN{"$userdir/$rundir"} == 0) { next; }

	  if (-e "$opWORKDIR/$userdir/$rundir") {
            system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
	  }
        }
      }
      else {
        if (-e "$opWORKDIR/$userdir") {
          system("/bin/rm -rf $opWORKDIR/$userdir >/dev/null 2>&1");
	}
      }
  
    }
    print "\nDone.\n";
    exit(0);
  }

  $status = &psub::launch(\%CTRL);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRL);

  ## Now detect any failed runs, and move their running directories
  ## to the results/$userdir/crashed_run directory.

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

      $jobid = "data_prep\.$userdir\.$rundir";
      
      if ($CTRL{"jobs"}{$jobid}{"status"} eq "success") {
        if (-e "$opRESULTSDIR/$userdir/crashed_run/part2.$rundir") {
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
        }
      }
      else {
        print "ERROR: Crashed / failed run detected during data_prep.  Moving run $userdir $rundir to \"$opRESULTSDIR/$userdir/crashed_run/part2.$rundir\" dir....\n";
        &EmailUser("part2",$real_ctrlfile,"$opRESULTSDIR/$userdir/crashed_run/part2.$rundir",$userdir,$rundir);
        if (-e "$opRESULTSDIR/$userdir/crashed_run/part2.$rundir") {
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
        }
        if (-e "$opRESULTSDIR/$userdir/crashed_run/part3.$rundir") {
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
        }
        if (-e "$opRESULTSDIR/$userdir/crashed_run/part4.$rundir") {
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
        }
          
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
        if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
          system("/bin/mkdir $opRESULTSDIR/$userdir/crashed_run >/dev/null 2>&1");
        }
        if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
          print "ERROR: Can't create directory $opRESULTSDIR/$userdir/crashed_run\n";
          print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
          system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
        }
        else {
          system("/bin/mv -f $opWORKDIR/$userdir/$rundir $opRESULTSDIR/$userdir/crashed_run/part2.$rundir >/dev/null 2>&1");
	  if (! -e "$opRESULTSDIR/$userdir/crashed_run/part2.$rundir/control_file_dump.txt") {
            system("/bin/cp -p $opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$ $opRESULTSDIR/$userdir/crashed_run/part2.$rundir/control_file_dump.txt >/dev/null 2>&1");
	  }
	  if (! -e "$opRESULTSDIR/$userdir/crashed_run/part2.$rundir/rss_flow_part1.trace.txt") {
            system("/bin/cp -p $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt $opRESULTSDIR/$userdir/crashed_run/part2.$rundir/rss_flow_part1.trace.txt >/dev/null 2>&1");
	  }
	  if (! -e "$opRESULTSDIR/$userdir/crashed_run/part2.$rundir/COPY_TM_CHKCF") {
            system("/bin/cp -p $opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$.trace.txt $opRESULTSDIR/$userdir/crashed_run/part2.$rundir/COPY_TM_CHKCF >/dev/null 2>&1");
	  }
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part2.$rundir/LINUX_* >/dev/null 2>&1");
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part2.$rundir/SOLARIS* >/dev/null 2>&1");
        }
      }
    }

    $dumpfile_lock = $CHIPS{$userdir}{"dumpfile"};
    file_lock::Unlock($dumpfile_lock);
  }

  return 1;
} ## End sub Manual_LaunchDataPrepJobs
###############################################################################
sub Manual_CleanUpTempfiles {
  ## Removes the temporary files:
  ##   control_file_dump.$HOSTNAME.$$
  ##   rss_flow_part1.$HOSTNAME.$$.trace.txt
  ##   ../COPY_TM_CHKCF.$HOSTNAME.$$
  local($ctrlfile,$dumpfile_lock,$real_ctrlfile,@line,$userdir);

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if (-e "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$") {
      system("/bin/rm -f $opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$ >/dev/null 2>&1");
    }
    if (-e "$opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt") {
      system("/bin/rm -f $opWORKDIR/$userdir/rss_flow_part1.$HOSTNAME.$$.trace.txt >/dev/null 2>&1");
    }
    if (-e "$opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$") {
      system("/bin/rm -rf $opWORKDIR/$userdir/COPY_TM_CHKCF.$HOSTNAME.$$ >/dev/null 2>&1");
    }

    $dumpfile_lock = $CHIPS{$userdir}{"dumpfile"};
    if ($dumpfile_lock ne "") {
      file_lock::Unlock($dumpfile_lock);
    }
  }

  return 1;
} ## End sub Manual_CleanUpTempfiles
###############################################################################
sub Manual_LaunchSimJobs {
  ## Just like LaunchSimJobs()
  local($cmd, $crc_spice_new, $crc_spice_old, $crc_vector_header_new,
	$crc_vector_header_old, $crc_vectors_new, $crc_vectors_old, $ctrlfile,
	$dateval, $dir_count, $eckt_cellname, $gotone, $jobid, $jobid1,
	$jobid2, $limit_kept_logs, $need_to_run_part3, $need_to_run_part4,
	$nowdate, $real_ctrlfile, $reason, $rundir, $sim_cmd_new, $sim_cmd_old,
	$simrundate, $slavegroup, $status, $sum_cmd_new, $sum_cmd_old, $userdir,
	%CTRL, %JOBXREF, *DIR, *IN, *OUT, @alldirs, @line, @simqnames,
	@sumqnames);

  $dateval = localtime;
  print "\n$dateval: Launching simulation and summary jobs...\n";

  %CTRL = ();
  &SetSlaves(\%CTRL);
  $CTRL{"socket"} = -1;
  @{$CTRL{"socketusers"}} = ($USER,"weigand","root");

  $gotone = 0; ## Do we even have a job to run?
  %JOBXREF = ();

  foreach $slavegroup (keys(%{$CTRL{"slaves"}})) {
    push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$CHIP);
    push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$MAIN_SCRATCH_DIR);
    if (-e "$CHIP/random_spice/manual_running") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$CHIP/random_spice/manual_running");
    }
    if (-e "$CHIP/random_spice/manual_results") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},"$CHIP/random_spice/manual_results");
    }
    if ($opWORKDIR ne "") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$opWORKDIR);
    }
    if ($opRESULTSDIR ne "") {
      push(@{$CTRL{"slaves"}{$slavegroup}{"dirs"}},$opRESULTSDIR);
    }
  }

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

      @simqnames = @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_sim"}};
      if ($#simqnames == -1) { @simqnames = ("xa","xabat"); } ## Shouldn't happen.
      
      @sumqnames = @{$CHIPS{$userdir}{"rundirs"}{$rundir}{"queue_sum"}};
      if ($#sumqnames == -1) { @sumqnames = ("linux"); } ## Shouldn't happen.
      
      $eckt_cellname = $CHIPS{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"};
      
      $sim_cmd_new = $CHIPS{$userdir}{"rundirs"}{$rundir}{"sim_cmd"};
      $sim_cmd_old = "";
      if (-e "$opRESULTSDIR/$userdir/$rundir/info.sim_cmd") {
        if (!open(IN,"<$opRESULTSDIR/$userdir/$rundir/info.sim_cmd")) {
          print "ERROR: Can't read $opRESULTSDIR/$userdir/$rundir/info.sim_cmd\n";
        }
        else {
          $sim_cmd_old = <IN>;
          chop($sim_cmd_old);
          close(IN);
        }
      }
      
      $sum_cmd_new = $CHIPS{$userdir}{"rundirs"}{$rundir}{"sum_cmd"};
      $sum_cmd_old = "";
      if (-e "$opRESULTSDIR/$userdir/$rundir/info.sum_cmd") {
        if (!open(IN,"<$opRESULTSDIR/$userdir/$rundir/info.sum_cmd")) {
          print "ERROR: Can't read $opRESULTSDIR/$userdir/$rundir/info.sum_cmd\n";
        }
        else {
          $sum_cmd_old = <IN>;
          chop($sum_cmd_old);
          close(IN);
        }
      }
      
      $crc_spice_new = "";
      if (-e "$opWORKDIR/$userdir/$rundir/main.spi.crc") {
        if (!open(IN,"<$opWORKDIR/$userdir/$rundir/main.spi.crc")) {
          print "ERROR: Can't read $opWORKDIR/$userdir/$rundir/main.spi.crc\n";
        }
        else {
          $crc_spice_new = <IN>;
          chop($crc_spice_new);
          close(IN);
        }
      }
      
      $crc_spice_old = "";
      if (-e "$opRESULTSDIR/$userdir/$rundir/main.spi.crc") {
        if (!open(IN,"<$opRESULTSDIR/$userdir/$rundir/main.spi.crc")) {
          print "ERROR: Can't read $opRESULTSDIR/$userdir/$rundir/main.spi.crc\n";
        }
        else {
          $crc_spice_old = <IN>;
          chop($crc_spice_old);
          close(IN);
        }
      }
      
      $crc_vector_header_new = "";
      if (-e "$opWORKDIR/$userdir/$rundir/${eckt_cellname}.vector_header.crc") {
        if (!open(IN,"<$opWORKDIR/$userdir/$rundir/${eckt_cellname}.vector_header.crc")) {
          print "ERROR: Can't read $opWORKDIR/$userdir/$rundir/${eckt_cellname}.vector_header.crc\n";
        }
        else {
          $crc_vector_header_new = <IN>;
          chop($crc_vector_header_new);
          close(IN);
        }
      }
      
      $crc_vector_header_old = "";
      if (-e "$opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vector_header.crc") {
        if (!open(IN,"<$opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vector_header.crc")) {
          print "ERROR: Can't read $opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vector_header.crc\n";
        }
        else {
          $crc_vector_header_old = <IN>;
          chop($crc_vector_header_old);
          close(IN);
        }
      }
      
      $crc_vectors_new = "";
      if (-e "$opWORKDIR/$userdir/$rundir/${eckt_cellname}.vectors.crc") {
        if (!open(IN,"<$opWORKDIR/$userdir/$rundir/${eckt_cellname}.vectors.crc")) {
          print "ERROR: Can't read $opWORKDIR/$userdir/$rundir/${eckt_cellname}.vectors.crc\n";
        }
        else {
          $crc_vectors_new = <IN>;
          chop($crc_vectors_new);
          close(IN);
        }
      }
      
      $crc_vectors_old = "";
      if (-e "$opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vectors.crc") {
        if (!open(IN,"<$opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vectors.crc")) {
          print "ERROR: Can't read $opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vectors.crc\n";
        }
        else {
          $crc_vectors_old = <IN>;
          chop($crc_vectors_old);
          close(IN);
        }
      }
      
      $simrundate = "";
      if (-e "$opRESULTSDIR/$userdir/$rundir/info.simrun") {
        $simrundate = (stat("$opRESULTSDIR/$userdir/$rundir/info.simrun"))[9];
        $simrundate = sprintf("%012u",$simrundate);
      }
      
      $reason = 0;
      
      if ($crc_spice_new ne $crc_spice_old) { $reason |= 1; }
      if ($crc_vector_header_new ne $crc_vector_header_old) { $reason |= 2; }
      if ($crc_vectors_new ne $crc_vectors_old) { $reason |= 4; }
      if ($sim_cmd_new ne $sim_cmd_old) { $reason |= 8; }
      if ($sum_cmd_new ne $sum_cmd_old) { $reason |= 16; }
      if ((! -e "$opRESULTSDIR/$userdir/$rundir/main.spi") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.vectors.gz") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/info.sim_cmd") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/info.simrun") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/main.log.gz") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/logfile") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/sim.log.gz")) {
        $reason |= 32;
      }
      
      $need_to_run_part3 = 0;
      $need_to_run_part4 = 0;
      
      if ($reason == 4) {
        ## Just the vectors have changed.  So check to see if there is already
        ## enough failing runs.  If so,  we won't rerun this.
        $limit_kept_logs = $CHIPS{$userdir}{"rundirs"}{$rundir}{"limit_kept_logs"};
      
        if (opendir(DIR,"$opRESULTSDIR/$userdir/$rundir/previous_violations")) {
          @alldirs = ();
          @alldirs = readdir(DIR);
          closedir(DIR);
      
          $dir_count = $#alldirs - 1; ## Subtracting off the "." and ".." directories.
      
          if ($dir_count >= $limit_kept_logs) {
            print "  --> $userdir $rundir : Reached failing run limit (limit_kept_logs=$limit_kept_logs). Will not run more jobs.\n";
            $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
            next;
          }
        }
      }

      if (($reason != 16) && ($reason != 0)) {
        ## If it was just 16, then it would mean just the summary would
        ## need to be redone. If it was 0, then nothing needs to be done.
        ## But if it was anything else, it means that both a sim run and
        ## a summary run needs to happen...
        $need_to_run_part3 = 1;
        $need_to_run_part4 = 1;
      }
      if (($sum_cmd_new ne $sum_cmd_old) ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/info.sum_cmd") ||
          (! -e "$opRESULTSDIR/$userdir/$rundir/${eckt_cellname}.sum.gz")) {
        $need_to_run_part4 = 1;
      }
      
      if ((! $need_to_run_part3) && (! $need_to_run_part4)) {
        ## Everything's the same as the previous run.  No need to rerun.
        print "No need to rerun part3 or part4 for $userdir $rundir.\n";
        system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
      elsif ($need_to_run_part4 && (! $need_to_run_part3)) {
        ## Just run the summary command.  Okay,  we need to copy the previous results over
        ## since we didn't run the simulator here...
        system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
        system("/bin/mkdir $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
        if (! -e "$opWORKDIR/$userdir/$rundir") {
          print "ERROR: Oops.  Weird error trying to recreate directory $opWORKDIR/$userdir/$rundir\n";
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
        }
        else {
          if (-e "$opWORKDIR/$userdir/$rundir.tar") {
            system("/bin/rm -f $opWORKDIR/$userdir/$rundir.tar >/dev/null 2>&1");
          }
          $cmd = "cd $opRESULTSDIR/$userdir >/dev/null 2>&1; ";
          $cmd .= "$GTARPATH -cf $opWORKDIR/$userdir/$rundir.tar $rundir ";
          $cmd .= "-X$CHIP/random_spice/templates/gtar_exclude.txt ";
          $cmd .= ">/dev/null 2>&1";
          system($cmd);
          $status = $?;
          if (($status != 0) || (! -e "$opWORKDIR/$userdir/$rundir.tar")) {
            print "ERROR: Couldn't tar up old directory: $cmd\n";
            $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
            system("/bin/rm -f $opWORKDIR/$userdir/$rundir.tar >/dev/null 2>&1");
            system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
          }
          else {
            $cmd = "cd $opWORKDIR/$userdir >/dev/null 2>&1; ";
            $cmd .= "$GTARPATH -xf $rundir.tar >/dev/null 2>&1";
            system($cmd);
            $status = $?;
            if (($status != 0) || (! -e "$opWORKDIR/$userdir/$rundir")) {
              print "ERROR: Couldn't untar: $cmd\n";
              $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
              system("/bin/rm -f $opWORKDIR/$userdir/$rundir.tar >/dev/null 2>&1");
              system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
            }
            else {
              system("/bin/rm -f $opWORKDIR/$userdir/$rundir.tar >/dev/null 2>&1");
      
	      if (!open(OUT,">$opWORKDIR/$userdir/$rundir/info.sum_cmd")) {
	        print "ERROR: Can't create file $opWORKDIR/$userdir/$rundir/info.sum_cmd\n";
                $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
                system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
	      }
	      else {
	        print OUT "$sum_cmd_new\n";
	        close(OUT);
      
                $jobid = "sum\.$userdir\.$rundir";
                push(@{$CTRL{"jobs"}{$jobid}{"dirs"}},"+$opWORKDIR/$userdir/$rundir");
                $CTRL{"jobs"}{$jobid}{"group"} = shift(@sumqnames);
	        if ($#sumqnames != -1) {
                  @{$CTRL{"jobs"}{$jobid}{"altgroups"}} = @sumqnames;
	        }
                $cmd = "/bin/csh -fc 'source $HOME/.cshrc >& /dev/null; ";
                $cmd .= "$CODEBASE_BUILDDIR/rss_flow_part4.pl -manual $CHIPBRF $CADHOME $CENTHOME $userdir $rundir $opWORKDIR $opRESULTSDIR ";
                $cmd .= ">& $opWORKDIR/$userdir/$rundir/rss_flow_part4.pl.trace.txt'";
                $CTRL{"jobs"}{$jobid}{"cmd"} = $cmd;
                $CTRL{"jobs"}{$jobid}{"info_reason"} = $reason;
                $CTRL{"jobs"}{$jobid}{"post"} = \&Manual_PostSubPart4;
                $CTRL{"jobs"}{$jobid}{"info_reason"} = $reason;
                $CTRL{"jobs"}{$jobid}{"info_userdir"} = $userdir;
                $CTRL{"jobs"}{$jobid}{"info_rundir"} = $rundir;
      
	        $gotone = 1;
	      }
            }
          }
        }
      }
      elsif ($need_to_run_part4 && $need_to_run_part3) {
	$nowdate = time;
        if ($simrundate eq "") {
          ## This cell has never been run before,  so put it higher in the
          ## run priority...
          $jobid1 = "a.sim\.$userdir\.$rundir";
        }
	elsif (($reason & (1 | 2 | 8 | 32)) != 0) {
	  ## These jobs get run first,  because they don't just have new vectors.
	  ## They have new netlists and/or new sim commands.  And they have
	  ## run at least once before.
	  ##
	  ## We use the simrundate integer to prioritize better.  The stuff
	  ## that's older gets run first.
	  if (abs($nowdate - $simrundate) > (60 * 60 * 24 * 30)) {
	    ## If a job hasn't run in more than 30 days,  just bump it
	    ## up to an "a" class job...
            $jobid1 = "a.sim\.$simrundate\.$userdir\.$rundir";
	  }
	  else {
            $jobid1 = "b.sim\.$simrundate\.$userdir\.$rundir";
	  }
        }
        else {
          ## Just new vectors...
	  if (abs($nowdate - $simrundate) > (60 * 60 * 24 * 35)) {
	    ## If it's been over 5 weeks,  bump it to an "a" class job...
	    $jobid1 = "a.sim\.$simrundate\.$userdir\.$rundir";
	  }
	  elsif (abs($nowdate - $simrundate) > (60 * 60 * 24 * 28)) {
	    ## If it's been over 4 weeks,  bump it to a "b" class job...
	    $jobid1 = "b.sim\.$simrundate\.$userdir\.$rundir";
	  }
	  else {
	    $jobid1 = "c.sim\.$simrundate\.$userdir\.$rundir";
	  }
        }
        $JOBXREF{"$userdir\.$rundir"} = $jobid1;

        push(@{$CTRL{"jobs"}{$jobid1}{"dirs"}},"+$opWORKDIR/$userdir/$rundir");
      
        $CTRL{"jobs"}{$jobid1}{"group"} = shift(@simqnames);
        if ($#simqnames != -1) {
          @{$CTRL{"jobs"}{$jobid1}{"altgroups"}} = @simqnames;
        }
        $cmd = "/bin/csh -fc 'source $HOME/.cshrc >& /dev/null; ";
        $cmd .= "$CODEBASE_BUILDDIR/rss_flow_part3.pl -manual $CHIPBRF $CADHOME $CENTHOME $userdir $rundir $opWORKDIR ";
        $cmd .= ">& $opWORKDIR/$userdir/$rundir/rss_flow_part3.pl.trace.txt'";
        $CTRL{"jobs"}{$jobid1}{"cmd"} = $cmd;
        $CTRL{"jobs"}{$jobid1}{"post"} = \&Manual_PostSubPart3;
        $CTRL{"jobs"}{$jobid1}{"info_reason"} = $reason;
        $CTRL{"jobs"}{$jobid1}{"info_userdir"} = $userdir;
        $CTRL{"jobs"}{$jobid1}{"info_rundir"} = $rundir;
        $CTRL{"jobs"}{$jobid1}{"info_sim_type"} = $CHIPS{$userdir}{"rundirs"}{$rundir}{"sim_type"};
        
        $jobid2 = "sum\.$userdir\.$rundir";
        push(@{$CTRL{"jobs"}{$jobid2}{"dirs"}},"+$opWORKDIR/$userdir/$rundir");
        $CTRL{"jobs"}{$jobid1}{"info_sum_jobid"} = $jobid2;
        $CTRL{"jobs"}{$jobid2}{"group"} = shift(@sumqnames);
        if ($#sumqnames != -1) {
          @{$CTRL{"jobs"}{$jobid2}{"altgroups"}} = @sumqnames;
        }
        $cmd = "/bin/csh -fc 'source $HOME/.cshrc >& /dev/null; ";
        $cmd .= "$CODEBASE_BUILDDIR/rss_flow_part4.pl -manual $CHIPBRF $CADHOME $CENTHOME $userdir $rundir $opWORKDIR $opRESULTSDIR ";
        $cmd .= ">& $opWORKDIR/$userdir/$rundir/rss_flow_part4.pl.trace.txt'";
        $CTRL{"jobs"}{$jobid2}{"cmd"} = $cmd;
        @{$CTRL{"jobs"}{$jobid2}{"posdep"}} = ($jobid1);
        $CTRL{"jobs"}{$jobid2}{"post"} = \&Manual_PostSubPart4;
        $CTRL{"jobs"}{$jobid2}{"info_reason"} = $reason;
        $CTRL{"jobs"}{$jobid2}{"info_userdir"} = $userdir;
        $CTRL{"jobs"}{$jobid2}{"info_rundir"} = $rundir;
      
        $gotone = 1;
      }
    }
  }

  if (! $gotone) {
    print "There are no simulation or summary jobs to run at this moment.\n";
    return 2;
  }

  &Manual_SetSlaves(\%CTRL); ## Override slave group associations for all jobs.

  ## Now check again if we have any jobs to run, after removing jobs which didn't
  ## have enough licenses...

  $gotone = 0;

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
      $gotone = 1;
      last;
    }
    if ($gotone) { last; }
  }

  if (! $gotone) {
    print "There are no simulation or summary jobs to run at this moment.\n";
    return 2;
  }

  ## Now launch...

  $psub::CRASHLIMIT = 5000; ## Because we could have PEON jobs getting killed.
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  $status = &psub::launch(\%CTRL);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRL);

  ## Now detect any failed runs...
  $dateval = localtime;
  print "\n$dateval: Finalizing the results...\n";

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} != 0) { next; }

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }

      $jobid1 = $JOBXREF{"$userdir\.$rundir"}; ## If it exists.
      $jobid2 = "sum\.$userdir\.$rundir";

      if ($CTRL{"jobs"}{$jobid1}{"cmd"} ne "") {
        if ($CTRL{"jobs"}{$jobid1}{"status"} ne "success") {
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
        }
      } ## End if
      
      if (($CTRL{"jobs"}{$jobid2}{"cmd"} ne "") && 
          (($CTRL{"jobs"}{$jobid1}{"cmd"} eq "") || ($CTRL{"jobs"}{$jobid1}{"status"} eq "success"))) {
        if ($CTRL{"jobs"}{$jobid2}{"status"} ne "success") {
          $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
        }
      } ## End if
    } ## End foreach
  } ## End foreach

  return 1;
} ## End sub Manual_LaunchSimJobs
###############################################################################
sub Manual_PostSubPart3 {
  ## Same as PostSubPart3().
  local($jobid,$CTRLref) = @_;
  local($exitcode,$file,$userdir,$rundir,$reason,$endtime,$machine,$maxmem,
        $cputime,*DIR,*OUT,@allfiles);

  $exitcode = $$CTRLref{"jobs"}{$jobid}{"exitcode"};
  if ($exitcode == 111) { $exitcode = 110; }

  $userdir = $$CTRLref{"jobs"}{$jobid}{"info_userdir"};
  $rundir = $$CTRLref{"jobs"}{$jobid}{"info_rundir"};
  $reason = $$CTRLref{"jobs"}{$jobid}{"info_reason"};

  $endtime = localtime($$CTRLref{"jobs"}{$jobid}{"end"});
  $machine = $$CTRLref{"jobs"}{$jobid}{"machine"};
  $maxmem = $$CTRLref{"jobs"}{$jobid}{"maxmem"};
  $cputime = $$CTRLref{"jobs"}{$jobid}{"cputime"};

  if (!open(OUT,">$opWORKDIR/$userdir/$rundir/info.simrun")) {
    print "ERROR: Manual_PostSubPart3: Unable to create file: $opWORKDIR/$userdir/$rundir/info.simrun\n";
    return 1;
  }
  print OUT "$endtime\n";
  print OUT "$cputime\n";
  print OUT "$maxmem\n";
  print OUT "$machine\n";
  print OUT "$reason\n";
  close(OUT);

  if ($exitcode != 0) {
    print "ERROR: Crashed / failed run detected during sim.  Moving run $userdir $rundir to $opRESULTSDIR/$userdir/crashed_run/part3.$rundir dir....\n";
    &EmailUser("part3",$real_ctrlfile,"$opRESULTSDIR/$userdir/crashed_run/part3.$rundir",$userdir,$rundir);
    if (-e "$opRESULTSDIR/$userdir/crashed_run/part3.$rundir") {
      system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
    }
    if (-e "$opRESULTSDIR/$userdir/crashed_run/part4.$rundir") {
      system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
    if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
      system("/bin/mkdir $opRESULTSDIR/$userdir/crashed_run >/dev/null 2>&1");
    }
    if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
      print "ERROR: Can't create directory $opRESULTSDIR/$userdir/crashed_run\n";
      print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
      system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
    }
    else {
      if (opendir(DIR,"$opWORKDIR/$userdir/$rundir")) {
        @allfiles = readdir(DIR);
	closedir(DIR);
	foreach $file (@allfiles) {
	  if (($file =~ /^main\.chk$/) ||
	      ($file =~ /^main\.chk\.err\.txt[0-9]$/) ||
	      ($file eq "main.log") ||
	      ($file eq "sim.log")) {
            system("$GZIPPATH -9 $opWORKDIR/$userdir/$rundir/$file >/dev/null 2>&1");
	  }
	}
      }
      system("/bin/mv -f $opWORKDIR/$userdir/$rundir $opRESULTSDIR/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
    }
  }
  else {
    if (-e "$opRESULTSDIR/$userdir/crashed_run/part3.$rundir") {
      system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part3.$rundir >/dev/null 2>&1");
    }
  }

  return $exitcode;
} ## End sub Manual_PostSubPart3
###############################################################################
sub Manual_PostSubPart4 {
  ## Same as PostSubPart4().
  local($jobid,$CTRLref) = @_;
  local($exitcode,$userdir,$rundir);

  $exitcode = $$CTRLref{"jobs"}{$jobid}{"exitcode"};
  if ($exitcode == 111) { $exitcode = 110; }

  $userdir = $$CTRLref{"jobs"}{$jobid}{"info_userdir"};
  $rundir = $$CTRLref{"jobs"}{$jobid}{"info_rundir"};

  if ($exitcode != 0) {
    print "ERROR: Crashed / failed run detected during summary.  Moving run $userdir $rundir to $opRESULTSDIR/$userdir/crashed_run/part4.$rundir dir....\n";
    &EmailUser("part4",$real_ctrlfile,"$opRESULTSDIR/$userdir/crashed_run/part4.$rundir",$userdir,$rundir);
    if (-e "$opRESULTSDIR/$userdir/crashed_run/part4.$rundir") {
      system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
    $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
    if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
      system("/bin/mkdir $opRESULTSDIR/$userdir/crashed_run >/dev/null 2>&1");
    }
    if (! -e "$opRESULTSDIR/$userdir/crashed_run") {
      print "ERROR: Can't create directory $opRESULTSDIR/$userdir/crashed_run\n";
      print "ERROR: Nowhere to put crash information,  so it will just be deleted.\n";
      system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
    }
    else {
      system("/bin/mv -f $opWORKDIR/$userdir/$rundir $opRESULTSDIR/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
  } ## End else
  else {
    if (-e "$opRESULTSDIR/$userdir/crashed_run/part4.$rundir") {
      system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run/part4.$rundir >/dev/null 2>&1");
    }
  }

  return $exitcode;
} ## End sub Manual_PostSubPart4
###############################################################################
sub Manual_SetSlaves {
  ## This just overrides the SetSlaves() values for the SPICE simulator
  ## queues: hspice, hspbatch, xa, and xabat.
  ##
  ## 1) Detect running and pending jobs by this user for all the SPICE
  ##    simulator queues.  Don't care about batch queues, just regular
  ##    queues.
  ## 2) Adjust the slave count for each regular queue and associated
  ##    batch queue (if available), based on the number of jobs the
  ##    user currently is running in the regular queues.  We steal from
  ##    the regular queue and give to the batch queue.
  ## 3) If user has exceeded the regular queue slot count already, then
  ##    jobs which use that queue will be modified to use the batch
  ##    queue only.  And actually delete the slaves for the regular queue.
  ## 4) Detect when there are no valid queues for a job and cancel it.
  ##
  ## It is called at the time we actually begin to submit jobs for simulation,
  ## not during data-prep.  It not only modifies the $CTRL{"slaves"} records,
  ## it will go through the $CTRL{"jobs"} records to change the "group" and
  ## "altgroups" settings.  If the "group" or "altgroups" properties mentions
  ## any of the slaves,  then they will be modified according to what
  ## should be allowable.
  ##
  ## We used to reprioritize queues (regular queue first, batch queue
  ## only as alternate queue). Now we accept the priorities given by
  ## rss_flow_chkcf.pl.

  local($CTRLref) = @_;

  local($counter, $flag_info_message, $hspice_user_inuse, $is_sim, $jobid,
        $jobid_sum, $killit, $limit_hspbatch, $limit_hspice, $limit_xa,
	$limit_xabat, $new_limit_hspbatch, $new_limit_hspice, $new_limit_xa,
	$new_limit_xabat, $qname, $rundir, $userdir, $xa_user_inuse,
	*QS, @jobq, @jobq_orig, @line);


  ## First get a count of all non-batch SPICE simulator queue slots
  ## being used by this user.  We'll adjust the slave counts for each
  ## queue based on this...

  if ((!$opEMERGENCY) && (!$opEMERGENCY2)) {
    ## If it's -emergency or -emergency2, then SetSlaves() already
    ## removed the batch queues and gave the user the full amount
    ## of slots for each queue.  So we don't need to adjust slave
    ## counts for each queue.
    ##
    ## NOTE: If it's -bat, then SetSlaves() already removed the regular
    ##       queues except hsimbg and hsimmsbg. So we still need to
    ##       enter this block just to manage hsimbg and hsimmsbg.

    if (! open(QS,"/Server/bin/bstat |")) {
      print "ERROR: Can't run /Server/bin/bstat: $!\n";
      &Manual_CleanUpTempfiles();
      file_lock::Done();
      exit(1);
    }

    $hspice_user_inuse = 0;
    $xa_user_inuse = 0;

    while(<QS>) {
      ## 135751      khoi           xa       120   RUNNING       fb130       zebra          
      ## 135923     brian        xabat       120   RUNNING       fb132     hamachi          
      ## 136063     twila           xa       120   RUNNING       cb192        ub40          
      ## 136081       bot           xa       120   RUNNING       fb119      hammer          
      ## 136082       bot        xabat       120   RUNNING       fb120      hammer          
      ## 136084       bot        xabat       120   WAITING       fb131      hammer          
      ## 136087       bot        xabat       120   WAITING        NONE      hammer          
      chop;
      s/\s+/ /g;
      s/^ //;
      s/ $//;
      @line = split(/ /);
      if (($line[1] eq $USER) && ($line[2] eq 'hspice'))   { $hspice_user_inuse++; }
      if (($line[1] eq $USER) && ($line[2] eq 'xa'))       { $xa_user_inuse++; }
    }
    close(QS);

    if (($hspice_user_inuse + $xa_user_inuse) > 0) {
      print "INFO: You are already running the following non-batch queue jobs:\n";
    }
    if ($hspice_user_inuse > 0)   { print "INFO:  hspice = $hspice_user_inuse\n"; }
    if ($xa_user_inuse > 0)       { print "INFO:  xa = $xa_user_inuse\n"; }

    ## Find the limits...

    $limit_hspice = $$CTRLref{"slaves"}{"hspice"}{"numslaves"};
    $limit_hspbatch = $$CTRLref{"slaves"}{"hspbatch"}{"numslaves"};

    $limit_xa = $$CTRLref{"slaves"}{"xa"}{"numslaves"};
    $limit_xabat = $$CTRLref{"slaves"}{"xabat"}{"numslaves"};
  
    ## hspice and hspbatch

    if ($opBAT) {
      ## The non-batch slave group has already been removed in SetSlaves().
      delete($$CTRLref{"slaves"}{"hspice"});
    }
    else {
      $new_limit_hspice = $limit_hspice - $hspice_user_inuse;
      if ($new_limit_hspice <= 0) {
        $new_limit_hspice = 0;
        delete($$CTRLref{"slaves"}{"hspice"});
      }
      else {
        $$CTRLref{"slaves"}{"hspice"}{"numslaves"} = $new_limit_hspice;
      }
      if (!$opNOBAT) {
        $new_limit_hspbatch = $limit_hspice + $limit_hspbatch - $new_limit_hspice;
        if ($new_limit_hspbatch <= 0) {
          $new_limit_hspbatch = 1; ## Just in case.
        }
        $$CTRLref{"slaves"}{"hspbatch"}{"numslaves"} = $new_limit_hspbatch;
      }
    }

    ## xa and xabat

    if ($opBAT) {
      ## The non-batch slave group has already been removed in SetSlaves().
      delete($$CTRLref{"slaves"}{"xa"});
    }
    else {
      $new_limit_xa = $limit_xa - $xa_user_inuse;
      if ($new_limit_xa <= 0) {
        $new_limit_xa = 0;
        delete($$CTRLref{"slaves"}{"xa"});
      }
      else {
        $$CTRLref{"slaves"}{"xa"}{"numslaves"} = $new_limit_xa;
      }
      if (!$opNOBAT) {
        $new_limit_xabat = $limit_xa + $limit_xabat - $new_limit_xa;
        if ($new_limit_xabat <= 0) {
          $new_limit_xabat = 1; ## Just in case.
        }
        $$CTRLref{"slaves"}{"xabat"}{"numslaves"} = $new_limit_xabat;
      }
    }
  }

  ## NOTE: We used to check for bad sim_cmd and queue_sim properties.
  ## And we used to reprioritize the queue names so that batch stuff
  ## was last.  Now we do all of that in rss_flow_chkcf.pl.

  ## Now we need to deal with the SPICE sim jobs themselves.  They
  ## could reference queues that have been deleted, so we delete them
  ## from the job queue list.  We also remove batch queues if the
  ## command line -nobat, -emergency, or -emergency2 was used, and
  ## vice-versa non-batch queues if the command line -bat was used.
  ## And if there are no available queues for them, we report an
  ## error message for it, mark it as dont-run, and move on.
  ##
  ## Note that a user could specify just a regular queue and no
  ## batch queues in the group list for a job.  If we have to
  ## remove all the regular queues (if -bat was used for example),
  ## or if there are no slots available in the regular queue,
  ## we actually have to delete the job.  We don't just override
  ## it to use the batch queue...

  $flag_info_message = 0;

  foreach $jobid (keys(%{$$CTRLref{"jobs"}})) {
    if ($$CTRLref{"jobs"}{$jobid}{"cmd"} eq "") { next; }

    @jobq = ($$CTRLref{"jobs"}{$jobid}{"group"});
    if (defined $$CTRLref{"jobs"}{$jobid}{"altgroups"}) {
      push(@jobq,@{$$CTRLref{"jobs"}{$jobid}{"altgroups"}});
    }

    @jobq_orig = @jobq;

    $is_sim = 0;

    foreach $qname (@jobq) {
      if    ($qname eq "hspice")      { $is_sim = 1; last; }
      elsif ($qname eq "hspbatch")    { $is_sim = 1; last; }
      elsif ($qname eq "xa")          { $is_sim = 1; last; }
      elsif ($qname eq "xabat")       { $is_sim = 1; last; }
    }

    if (! $is_sim) { next; } ## Don't care about this non-sim job.

    for ($counter = 0; $counter <= $#jobq; $counter++) {
      $qname = $jobq[$counter];
      $killit = 0;
      if ((! defined($$CTRLref{"slaves"}{$qname})) ||
          ($$CTRLref{"slaves"}{$qname}{"numslaves"} == 0)) {
	## Slave group for the queue was deleted. So delete this
	## queue in the @jobq.
	$killit = 1;
      }
      if ($qname =~ /bat/) {
        ## Batch queues should be eliminated if -nobat, -emergency,
	## or -emergency2 are used, even if there is no non-bat queue
	## for this job...
        if ($opNOBAT || $opEMERGENCY || $opEMERGENCY2) { $killit = 1; }
      }

      if ($killit) {
	splice(@jobq,$counter,1);
	$counter--;
      }
    }

    if ($#jobq == -1) {
      $flag_info_message = 1;
      $userdir = $$CTRLref{"jobs"}{$jobid}{"info_userdir"};
      $rundir = $$CTRLref{"jobs"}{$jobid}{"info_rundir"};
      $jobid_sum = $$CTRLref{"jobs"}{$jobid}{"info_sum_jobid"};
      $" = ",";
      print "ERROR: Cancelling job userdir=\"$userdir\" rundir=\"$rundir\" because its queues (queue_sim=@jobq_orig) are not available right now. Try again later.\n";
      $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      delete($$CTRLref{"jobs"}{$jobid});
      if ($jobid_sum ne "") {
        ## Have to remove its corresponding summary job also...
        delete($$CTRLref{"jobs"}{$jobid_sum});
      }
    }
    else {
      $$CTRLref{"jobs"}{$jobid}{"group"} = shift(@jobq);
      @{$$CTRLref{"jobs"}{$jobid}{"altgroups"}} = @jobq;
    }
  }

  if ($flag_info_message) {
    print "ERROR: (This usually because you have exceeded the max number of slots available to you in the normal queues, and there are no batch queues available to run these jobs.)\n";
  }

  return 1;
} ## End sub Manual_SetSlaves
###############################################################################
sub Manual_CleanUpCrashedRunDirs {
  ## Just like CleanUpCrashedRunDirs().
  local ($ctrlfile, $dateval, $real_ctrlfile, $subdir, $userdir, *DIR,
	 @allfiles, @line);

  $dateval = localtime;
  print "$dateval: Cleaning empty crashed_run directories (if any).\n";

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($userdir eq "") { next; }

    if (-e "$opRESULTSDIR/$userdir/crashed_run") {
      @allfiles = ();
      if (opendir(DIR,"$opRESULTSDIR/$userdir/crashed_run")) {
        foreach $subdir (readdir(DIR)) {
          if (($subdir ne '.') && ($subdir ne '..')) {
            push(@allfiles,$subdir);
          }
        }
        closedir(DIR);
        if ($#allfiles == -1) {
          print "  Deleting unneeded crashed_run directory: $opRESULTSDIR/$userdir/crashed_run\n";
          system("/bin/rm -rf $opRESULTSDIR/$userdir/crashed_run >/dev/null 2>&1");
        }
      }
    }
  }

  return 1;
} ## End sub Manual_CleanUpCrashedRunDirs
###############################################################################
sub Manual_FixInterruptedOps {
  ## Just like FixInterruptedOps() but for the manual flow.
  local ($ctrlfile, $dateval, $real_ctrlfile, $rundir, $thisrundir, $userdir,
	 *DIR, @allrundirs, @line);

  ## Lock-out any interrupts that might happen while we do this critical task...
  local $SIG{"INT"} = "IGNORE";
  local $SIG{"TERM"} = "IGNORE";
  local $SIG{"PIPE"} = "IGNORE";

  $dateval = localtime;
  print "$dateval: Fixing any interrupted operations leftover from previous run...\n";

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($userdir eq "") { next; }

    if (!opendir(DIR,"$opRESULTSDIR/$userdir")) {
      next;
    }
    @allrundirs = readdir(DIR);
    closedir(DIR);
    foreach $rundir (@allrundirs) {
      if (($rundir eq ".") || ($rundir eq "..")) { next; }
      $thisrundir = $rundir;
      if ($thisrundir =~ s/^tmp\._\.//) {
        if ($thisrundir =~ s/\.old$//) {
          if ($thisrundir eq "") { } ## Do nothing
          elsif (! -e "$opRESULTSDIR/$userdir/$thisrundir") {
            print "  --> Renaming $opRESULTSDIR/$userdir/$rundir back to $thisrundir.\n";
            system("/bin/mv $opRESULTSDIR/$userdir/$rundir $opRESULTSDIR/$userdir/$thisrundir >/dev/null 2>&1");
            if (-e "$opRESULTSDIR/$userdir/tmp._.$thisrundir.okay") {
              system("/bin/rm -f $opRESULTSDIR/$userdir/tmp._.$thisrundir.okay > /dev/null 2>&1");
            }
          }
          elsif (-e "$opRESULTSDIR/$userdir/tmp._.$thisrundir.okay") {
            print "  --> Removing old $opRESULTSDIR/$userdir/$thisrundir and replacing with $rundir.\n";
            system("/bin/rm -rf $opRESULTSDIR/$userdir/$thisrundir > /dev/null 2>&1");
            system("/bin/mv $opRESULTSDIR/$userdir/$rundir $opRESULTSDIR/$userdir/$thisrundir >/dev/null 2>&1");
            system("/bin/rm -f $opRESULTSDIR/$userdir/tmp._.$thisrundir.okay > /dev/null 2>&1");
          }
          else {
            print "  --> Removing $opRESULTSDIR/$userdir/$rundir.\n";
            system("/bin/rm -rf $opRESULTSDIR/$userdir/$rundir > /dev/null 2>&1");
          }
        }
      }
    }
  } ## End foreach

  return 1;
} ## End sub Manual_FixInterruptedOps
###############################################################################
sub Manual_CleanRunningDir {
  ## Removes the "running" directories now that they're not needed.
  local($dateval,$ctrlfile,$real_ctrlfile,@line,$userdir,$rundir);

  $dateval = localtime;
  print "$dateval: Cleaning running directory $opWORKDIR ...\n";

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($opRUN_something && ($opRUN{"$userdir/$rundir"} == 0)) { next; }

      if (-e "$opWORKDIR/$userdir/$rundir") {
        system("/bin/rm -rf $opWORKDIR/$userdir/$rundir >/dev/null 2>&1");
      }
    }
  }

  return 1;
} ## End sub Manual_CleanRunningDir
###############################################################################
sub EmailUser {
  ## If something crashes,  email the userid of the person who owns the
  ## control file or the person who's running this program if it's a manual
  ## run.
  local($partnumber,$ctrlfile,$crashedrundir,$userdir,$rundir) = @_;
  local($UNAMEVALUE, $mailuser, $mailuserid, $solaris, $subject, *OUT, *TMPUN);

  if ($opBOT) {
    ## Get the userid of the owner of the control file...
    $mailuserid = (stat($ctrlfile))[4];
    $mailuser = getpwuid($mailuserid);
    if (($mailuserid == 0) || ($mailuser eq "") || ($mailuser eq "root")) {
      print "ERROR: Can't determine owner of control file, therefore no crash email: $ctrlfile\n";
      return 1;
    }
  }
  else {
    ## Manual run,  so determine username of whomever is running this process...
    $mailuser = getpwuid($>);
    if (($mailuser eq "") || ($mailuser eq "root")) {
      print "ERROR: Can't determine owner of control file, therefore no crash email: $ctrlfile\n";
      return 1;
    }
  }

  $solaris = 0;

  if (open(TMPUN,"/bin/uname -s |")) {
    $UNAMEVALUE = <TMPUN>;
    close(TMPUN);
    chop($UNAMEVALUE);
    if ($UNAMEVALUE =~ /Sun/i) { $solaris = 1; }
  }

  if ($partnumber eq "part1") {
    $subject = "[RSS] Crashed $partnumber of $userdir";
  }
  else {
    $subject = "[RSS] Crashed $partnumber of $userdir/$rundir";
  }

  if ($solaris) {
    if (!open (OUT,"|/bin/mail $mailuser")) {
      print "ERROR: Can't open pipe to /bin/mail $mailuser\n";
      return 1;
    }
    print OUT "To: $mailuser\n";
    print OUT "Subject: $subject\n\n";
  }
  else {
    if (!open (OUT,"|/bin/mail -s \"$subject\" $mailuser")) {
      print "ERROR: Can't open pipe to /bin/mail $mailuser\n";
      return 1;
    }
  }
  print OUT "\n";
  print OUT "Your Random Spice Simulation job is crashing in $partnumber.  The crashed run\n";
  print OUT "can be seen in the following directory:\n";
  print OUT "  $crashedrundir\n\n";

  print OUT "Here's a list of all the parts in this flow and what they do:\n";
  print OUT "  part1 - Dumps out the control file using rss_flow_chkcf.pl\n";
  print OUT "  part2 - Data prep.  Everything up to but not including simulation.\n";
  print OUT "  part3 - Simulation.\n";
  print OUT "  part4 - Summarizes the results of the simulation.\n\n";

  print OUT "You should first diagnose any error messages in any of the files in the\n";
  print OUT "directory shown above.  If you're still puzzled,  see Steve Weigand for\n";
  print OUT "a definitive reason for why your job is crashing.\n\n";

  print OUT " - Bot\n";
  close(OUT);

  return 1;
} ## End sub EmailUser
###############################################################################
###############################################################################
sub Hack_Spice {
  ## For automated / bot runs...
  ##
  ## This is a temporary hack. It creates hacked spice netlists for the
  ## Fujitsu ssb stuff.  Stores all files into a cache at $HACK_NETLIST_DIR.
  ##
  ## This will launch remote jobs to handle this for us in parallel.  These
  ## jobs can run for quite a long time.  Hours even.  This is not good.

  local($build, $builddir, $cmd, $dateval, $dir, $dslver, $eckt,
        $eckt_cellname, $eckt_resolved, $ecktdir, $ecktflatname, $host,
	$jobcounter, $jobid, $lastslash, $projectname,
	$projectname_cellname_dslver_eckt, $rundir, $spice_techfile,
	$status, $userdir, $whereval, %CTRLECKT, %dirs, %eckts, @stuff);

  $dateval = localtime;
  print "$dateval: Determining if need to hack spice netlists for dsl conversion...\n";

  $host = $HOSTNAME;
  $host =~ s/\.centtech\.com$//;

  %eckts = ();

  foreach $projectname ("cnb","cnb0c") {
    ## We can add more chips later if needed.

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      foreach $rundir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}}))) {
        if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
        $spice_techfile = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"spice_techfile"};
	if (($projectname =~ /^cnb/) && (($spice_techfile =~ /r1\.11/) ||
	                                 ($spice_techfile =~ /rev1\.11/))) {
	  $dslver = "cs200_r1.11v20080327";
	}
	elsif (($projectname =~ /^cnb/) && ($spice_techfile =~ /cs250/)) {
	  $dslver = "cs250";
	}
	else {
	  ## Don't need to convert this eckt.
	  ##
	  ## HACK HACK HACK CNB ONLY....
	  ## For now we disable any run that's not one of our new spice corners.
	  ## Later on,  we'll just use "next" in this loop instead of setting
	  ## the "exists" to 1.
          #$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
	  next;
	}

        $eckt = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt"};
	$eckt_cellname = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"};

        $eckt_resolved = &GimmeSimplePath($eckt);
        if ($eckt_resolved ne "") { $eckt = $eckt_resolved; }
	
	$eckts{"$projectname $eckt_cellname $dslver $eckt"}{"exists"} = 1;
	$eckts{"$projectname $eckt_cellname $dslver $eckt"}{"where"}{"$userdir $rundir"} = 1;
      }
    }
  }

  ## Now we have a list of raw eckts.  Process them in parallel...

  %CTRLECKT = ();
  $CTRLECKT{"slaves"}{"linux"}{"numslaves"} = 10;
  $CTRLECKT{"slaves"}{"linux"}{"qname"} = "linux";
  $CTRLECKT{"slaves"}{"linux"}{"stay"} = 1;
  $CTRLECKT{"slaves"}{"linux"}{"staytimeout"} = 600;
  $CTRLECKT{"slaves"}{"linux"}{"inactivetimeout"} = 60;
  $CTRLECKT{"slaves"}{"linux"}{"crashproof"} = 1;
  $CTRLECKT{"socket"} = -1;
  @{$CTRLECKT{"socketusers"}} = ("bot","weigand",$USER);

  if ($opPRIORITY ne "") {
    $CTRLECKT{"slaves"}{"linux"}{"priority"} = $opPRIORITY;
  }

  $psub::CRASHLIMIT = 200;
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},"+$HACK_NETLIST_DIR");
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},$MAIN_SCRATCH_DIR);
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},"/vlsi/cad2/bin");
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},"/vlsi/cad3/bin");
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},$CODEBASE_BUILDDIR);


  %dirs = ();

  $jobcounter = 0;
  foreach $projectname_cellname_dslver_eckt (sort(keys(%eckts))) {
    if ($eckts{$projectname_cellname_dslver_eckt}{"exists"} == 0) { next; }
    @stuff = split(/ /,$projectname_cellname_dslver_eckt);
    $projectname = shift(@stuff);
    $eckt_cellname = shift(@stuff);
    $dslver = shift(@stuff);
    $eckt = join(" ",@stuff);
    $lastslash = rindex($eckt,"/");
    if ($lastslash != -1) {
      $ecktdir = substr($eckt,0,$lastslash);
      if (-d $ecktdir) { $dirs{$ecktdir} = 1; }
    }
    $ecktflatname = $eckt;
    $ecktflatname =~ s/\//\#/g;

    if (! -e "$HACK_NETLIST_DIR/$projectname/$eckt_cellname") {
      system("/bin/mkdir -p -m 777 $HACK_NETLIST_DIR/$projectname/$eckt_cellname >/dev/null 2>&1");
      system("/bin/chmod g+s $HACK_NETLIST_DIR >/dev/null 2>&1");
      system("/bin/chmod g+s $HACK_NETLIST_DIR/$projectname >/dev/null 2>&1");
      system("/bin/chmod g+s $HACK_NETLIST_DIR/$projectname/$eckt_cellname >/dev/null 2>&1");
    }
    if (! -e "$HACK_NETLIST_DIR/$projectname/$eckt_cellname") {
      print "ERROR: Could not create directory $HACK_NETLIST_DIR/$projectname/$eckt_cellname.\n";
      foreach $whereval (sort(keys(%{$eckts{$projectname_cellname_dslver_eckt}{"where"}}))) {
        if ($eckts{$projectname_cellname_dslver_eckt}{"where"}{$whereval} == 0) { next; }
        @stuff = split(/ /,$whereval);
        $userdir = shift(@stuff);
        $rundir = shift(@stuff);
	print "ERROR: Marking userdir \"$userdir\" rundir \"$rundir\" as don't run because of inability to make directory $HACK_NETLIST_DIR/$projectname/$eckt_cellname\n";
        $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
      next;
    }

    $builddir = $CODEBASE_LOCATIONS{$projectname}{"builddir"};
    $build = $CODEBASE_LOCATIONS{$projectname}{"build"};

    ## This job will just update the cached netlist file if needed...
    $jobcounter++;
    $logfile = "$HACK_NETLIST_DIR/$projectname/$eckt_cellname/hack.log.$dslver.$ecktflatname.$host.$$";
    $cmd = "setenv CODEBASE_weigand_rss_BUILD $build; ";
    $cmd .= "setenv CODEBASE_weigand_rss_BUILDDIR $builddir; ";
    $cmd .= "$builddir/rss_flow.hack_netlist.pl $projectname $eckt_cellname $host $$ $dslver \"$eckt\" ";
    $cmd .= "> $logfile 2>&1";
    if (-e $logfile) {
      system("/bin/rm -f $logfile >/dev/null 2>&1");
    }
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"group"} = "linux";
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"cmd"} = $cmd;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_project"} = $projectname;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_cell"} = $eckt_cellname;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_eckt"} = $eckt;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_ecktflat"} = $ecktflatname;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_log"} = $logfile;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_dsl"} = $dslver;
    print "INFO: Job job$jobcounter is for cell=$eckt_cellname dsl=$dslver eckt=$eckt\n";
    ## NOTE: We worry about file locking in the rss_flow.hack_netlist.pl script,
    ## rather than do it here.
  }

  foreach $dir (sort(keys(%dirs))) {
    push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},$dir);
  }

  if ($jobcounter == 0) {
    print "INFO: There are no hack netlist jobs to run at this moment. Skipping.\n";
    return 1;
  }

  $dateval = localtime;
  print "$dateval: Launching jobs to hack spice netlists for ssb stuff...\n";

  $status = &psub::launch(\%CTRLECKT);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRLECKT);

  ## Detect failed runs and prevent launching part2 for the rundirs
  ## involved...

  foreach $jobid (sort(keys(%{$CTRLECKT{"jobs"}}))) {
    if ($CTRLECKT{"jobs"}{$jobid}{"group"} eq "") { next; }
    $logfile = $CTRLECKT{"jobs"}{$jobid}{"info_log"};
    if ($CTRLECKT{"jobs"}{$jobid}{"status"} ne "success") {
      $projectname = $CTRLECKT{"jobs"}{$jobid}{"info_project"};
      $eckt = $CTRLECKT{"jobs"}{$jobid}{"info_eckt"};
      $eckt_cellname = $CTRLECKT{"jobs"}{$jobid}{"info_cell"};
      $ecktflatname = $CTRLECKT{"jobs"}{$jobid}{"info_ecktflat"};
      $dslver = $CTRLECKT{"jobs"}{$jobid}{"info_dsl"};
      if ($eckts{"$projectname $eckt_cellname $dslver $eckt"}{"exists"} == 0) { next; } ## Should never happen.
      foreach $whereval (sort(keys(%{$eckts{"$projectname $eckt_cellname $dslver $eckt"}{"where"}}))) {
        if ($eckts{"$projectname $eckt_cellname $dslver $eckt"}{"where"}{$whereval} == 0) { next; }
        @stuff = split(/ /,$whereval);
        $userdir = shift(@stuff);
        $rundir = shift(@stuff);
	print "ERROR: Bad status from netlist hack script for $projectname $userdir $rundir. Will skip this run. Log file: $logfile\n";
	$CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
    }
    #else {
    #  if (-e $logfile) {
    #    ## Shouldn't exist,  but if it does, delete it.
    #    system("/bin/rm -f $logfile >/dev/null 2>&1");
    #  }
    #}
  }

  return 1;
} ## End sub Hack_Spice
###############################################################################
sub Manual_Hack_Spice {
  ## For manual runs,  just like Hack_Spice for automated/bot runs.

  local($cell_dslver_eckt, $cmd, $dateval, $dir, $dslver, $eckt, $eckt_cellname,
        $eckt_resolved, $ecktflatname, $host, $jobcounter, $jobid, $lastslash,
	$rundir, $spice_techfile, $status, $userdir, $whereval, %CTRLECKT,
	%dirs, %eckts, @stuff);

  if ($CHIPBRF !~ /^cnb/) { return 1; }
    ## We can add more chips later if needed.

  $dateval = localtime;
  print "$dateval: Determining if need to hack spice netlists for dsl conversion...\n";

  $host = $HOSTNAME;
  $host =~ s/\.centtech\.com$//;

  %eckts = ();

  foreach $userdir (sort(keys(%CHIPS))) {
    foreach $rundir (sort(keys(%{$CHIPS{$userdir}{"rundirs"}}))) {
      if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} != 2) { next; }
      $spice_techfile = $CHIPS{$userdir}{"rundirs"}{$rundir}{"spice_techfile"};
      if (($CHIPBRF =~ /^cnb/) && (($spice_techfile =~ /r1\.11/) ||
	                           ($spice_techfile =~ /rev1\.11/))) {
	$dslver = "cs200_r1.11v20080327";
      }
      elsif (($CHIPBRF =~ /^cnb/) && ($spice_techfile =~ /cs250/)) {
	$dslver = "cs250";
      }
      else { next; }

      $eckt = $CHIPS{$userdir}{"rundirs"}{$rundir}{"eckt"};

      $eckt_resolved = &GimmeSimplePath($eckt);
      if ($eckt_resolved ne "") { $eckt = $eckt_resolved; }

      $eckt_cellname = $CHIPS{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"};
      
      $eckts{"$eckt_cellname $dslver $eckt"}{"exists"} = 1;
      $eckts{"$eckt_cellname $dslver $eckt"}{"where"}{"$userdir $rundir"} = 1;
    }
  }

  ## Now we have a list of raw eckts.  Process them in parallel...

  %CTRLECKT = ();
  $CTRLECKT{"slaves"}{"linux"}{"numslaves"} = 10;
  $CTRLECKT{"slaves"}{"linux"}{"qname"} = "linux";
  $CTRLECKT{"slaves"}{"linux"}{"stay"} = 1;
  $CTRLECKT{"slaves"}{"linux"}{"staytimeout"} = 600;
  $CTRLECKT{"slaves"}{"linux"}{"inactivetimeout"} = 60;
  $CTRLECKT{"slaves"}{"linux"}{"crashproof"} = 1;
  $CTRLECKT{"socket"} = -1;
  @{$CTRLECKT{"socketusers"}} = ("bot","weigand",$USER);

  if ($opPRIORITY ne "") {
    $CTRLECKT{"slaves"}{"linux"}{"priority"} = $opPRIORITY;
  }

  $psub::CRASHLIMIT = 200;
  $psub::BAD_MACHINE_TIME = 600;
  $psub::BAD_MACHINE_LIMIT = 6;

  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},"+$HACK_NETLIST_DIR");
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},$MAIN_SCRATCH_DIR);
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},"/vlsi/cad2/bin");
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},"/vlsi/cad3/bin");
  push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},$CODEBASE_BUILDDIR);

  %dirs = ();

  $jobcounter = 0;
  foreach $cell_dslver_eckt (sort(keys(%eckts))) {
    if ($eckts{$cell_dslver_eckt}{"exists"} == 0) { next; }

    @stuff = split(/ /,$cell_dslver_eckt);
    $eckt_cellname = shift(@stuff);
    $dslver = shift(@stuff);
    $eckt = join(" ",@stuff);

    $lastslash = rindex($eckt,"/");
    if ($lastslash != -1) {
      $ecktdir = substr($eckt,0,$lastslash);
      if (-d $ecktdir) { $dirs{$ecktdir} = 1; }
    }
    $ecktflatname = $eckt;
    $ecktflatname =~ s/\//\#/g;

    if (! -e "$HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname") {
      system("/bin/mkdir -p -m 777 $HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname >/dev/null 2>&1");
      system("/bin/chmod g+s $HACK_NETLIST_DIR >/dev/null 2>&1");
      system("/bin/chmod g+s $HACK_NETLIST_DIR/$CHIPBRF >/dev/null 2>&1");
      system("/bin/chmod g+s $HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname >/dev/null 2>&1");
    }
    if (! -e "$HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname") {
      print "ERROR: Could not create directory $HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname.\n";
      foreach $whereval (sort(keys(%{$eckts{$cell_dslver_eckt}{"where"}}))) {
        if ($eckts{$cell_dslver_eckt}{"where"}{$whereval} == 0) { next; }
        @stuff = split(/ /,$whereval);
        $userdir = shift(@stuff);
        $rundir = shift(@stuff);
	print "ERROR: Marking userdir \"$userdir\" rundir \"$rundir\" as don't run because of inability to make directory $HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname\n";
        $CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
      next;
    }

    ## This job will just update the cached netlist file if needed...
    $jobcounter++;
    $logfile = "$HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname/hack.log.$dslver.$ecktflatname.$host.$$";
    $cmd = "$CODEBASE_BUILDDIR/rss_flow.hack_netlist.pl $CHIPBRF $eckt_cellname $host $$ $dslver \"$eckt\" ";
    $cmd .= "> $logfile 2>&1";
    if (-e $logfile) {
      system("/bin/rm -f $logfile >/dev/null 2>&1");
    }
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"group"} = "linux";
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"cmd"} = $cmd;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_eckt"} = $eckt;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_ecktflat"} = $ecktflatname;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_cell"} = $eckt_cellname;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_dsl"} = $dslver;
    $CTRLECKT{"jobs"}{"job$jobcounter"}{"info_log"} = $logfile;
    ## NOTE: We worry about file locking in the rss_flow.hack_netlist.pl script,
    ## rather than do it here.
    print "INFO: Job job$jobcounter is for cell=$eckt_cellname dsl=$dslver eckt=$eckt\n";
  }

  foreach $dir (sort(keys(%dirs))) {
    push(@{$CTRLECKT{"slaves"}{"linux"}{"dirs"}},$dir);
  }

  if ($jobcounter == 0) {
    print "INFO: There are no hack netlist jobs to run at this moment. Skipping.\n";
    return 1;
  }

  $dateval = localtime;
  print "$dateval: Launching jobs to hack spice netlists for dsl conversion...\n";

  $status = &psub::launch(\%CTRLECKT);
  if ($status == 0) {
    print "ERROR: There were fatal errors in the Psub run.\n";
  }
  &psub::Summary(\%CTRLECKT);

  ## Detect failed runs and prevent launching part2 for the rundirs
  ## involved...

  foreach $jobid (sort(keys(%{$CTRLECKT{"jobs"}}))) {
    if ($CTRLECKT{"jobs"}{$jobid}{"group"} eq "") { next; }
    $logfile = $CTRLECKT{"jobs"}{$jobid}{"info_log"};
    if ($CTRLECKT{"jobs"}{$jobid}{"status"} ne "success") {
      $eckt = $CTRLECKT{"jobs"}{$jobid}{"info_eckt"};
      $eckt_cellname = $CTRLECKT{"jobs"}{$jobid}{"info_cell"};
      $dslver = $CTRLECKT{"jobs"}{$jobid}{"info_dsl"};
      if ($eckts{"$eckt_cellname $dslver $eckt"}{"exists"} == 0) { next; } ## Should never happen.
      foreach $whereval (sort(keys(%{$eckts{"$eckt_cellname $dslver $eckt"}{"where"}}))) {
        if ($eckts{"$eckt_cellname $dslver $eckt"}{"where"}{$whereval} == 0) { next; }
        @stuff = split(/ /,$whereval);
        $userdir = shift(@stuff);
        $rundir = shift(@stuff);
	print "ERROR: Bad status from netlist hack script for $CHIPBRF $userdir $rundir. Will skip this run. Log file: $logfile\n";
	$CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} = 1;
      }
    }
    #elsif (-e $logfile) {
    #  ## Shouldn't exist,  but if it does, delete it.
    #  system("/bin/rm -f $logfile >/dev/null 2>&1");
    #}
  }

  return 1;
} ## End sub Manual_Hack_Spice
###############################################################################
sub Hack_ControlFileDumps {
  ## If we hacked an eckt netlist for any rundir,  we need to modify
  ## the control file dump to point to the hacked/cached version.

  $dateval = localtime;
  print "$dateval: Modifying control file dumps with hacked netlist info if needed...\n";

  foreach $projectname ("cnb","cnb0c") {
    if ($CHIPS{$projectname}{"exists"} == 0) { next; }

    $centhome = $CHIPS{$projectname}{"centhome"};

    foreach $userdir (sort(keys(%{$CHIPS{$projectname}{"userdirs"}}))) {
      if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"exists"} != 2) { next; }

      $musthack = 0;

      if (!open(OUT,">$centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt.new")) {
        print "ERROR: Couldn't create file, so I will not run anything in $projectname $userdir : $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt.new $!\n";
        delete ($CHIPS{$projectname}{"userdirs"}{$userdir});
	next;
      }
      if (!open(IN,"<$centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt")) {
        print "ERROR: Couldn't read control file dump,  so I will not run anything in $projectname $userdir : $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt\n";
        delete ($CHIPS{$projectname}{"userdirs"}{$userdir});
	next;
      }
      $rundir = "";
      while(<IN>) {
        chop;
	if (/^\s*RUNDIR:\s+(\S+)\s*$/) {
	  $rundir = $1;
	}
	elsif (/^\s*eckt\s*=\s*\"(.*)\"\s*$/) {
	  $eckt = $1;
          if ($CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"exists"} == 2) {
            $spice_techfile = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"spice_techfile"};
	    $dslver = "";
            if (($projectname =~ /^cnb/) && (($spice_techfile =~ /r1\.11/) ||
	                                     ($spice_techfile =~ /rev1\.11/))) {
	      $dslver = "cs200_r1.11v20080327";
	    }
            elsif (($projectname =~ /^cnb/) && ($spice_techfile =~ /cs250/)) {
	      $dslver = "cs250";
	    }

	    if ($dslver ne "") {
              $eckt_cellname = $CHIPS{$projectname}{"userdirs"}{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"};
              $eckt_resolved = &GimmeSimplePath($eckt);
              if ($eckt_resolved eq "") { $eckt_resolved = $eckt; }
	      $flat_eckt = $eckt_resolved;
	      $flat_eckt =~ s/\//\#/g;
	      $newfile = "$HACK_NETLIST_DIR/$projectname/$eckt_cellname/$dslver.$flat_eckt";
	      if ((-e $newfile) &&
	          (-e "$newfile.incrc")) {
	        $musthack = 1;
	        s/\"\Q$eckt\E\"/\"$newfile\"/;
	      }
	    }
	  }
	}
	print OUT "$_\n";
      }
      close(IN);
      close(OUT);

      if ($musthack) {
        $dateval = localtime;
        print "$dateval: Hacking eckt netlist in control file for $projectname $userdir...\n";
        system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt >/dev/null 2>&1");
        $cmd = "/bin/mv $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt.new ";
        $cmd .= "$centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt ";
	$cmd .= ">/dev/null 2>&1";
	system($cmd);
      }
      else {
        system("/bin/rm -f $centhome/$projectname/random_spice/running/$userdir/control_file_dump.txt.new >/dev/null 2>&1");
      }
    }
  }

  return 1;
} ## End sub Hack_ControlFileDumps
###############################################################################
sub Manual_Hack_ControlFileDumps {

  if ($CHIPBRF !~ /^cnb/) { return 1; }
    ## We can add more chips later if needed.
 
  $dateval = localtime;
  print "$dateval: Modifying control file dumps with hacked netlist info if needed...\n";

  foreach $ctrlfile (@opCTRL) {
    $real_ctrlfile = $ctrlfile;
    if ($real_ctrlfile !~ /^\//) { $real_ctrlfile = "$CHIP/random_spice/user/" . $real_ctrlfile; }
    @line = split(/\//,$real_ctrlfile);
    $userdir = $line[$#line - 1];

    if ($CHIPS{$userdir}{"bad"} == 1) { next; }

    $dumpfile = "$opWORKDIR/$userdir/control_file_dump.$HOSTNAME.$$";

    $musthack = 0;

    if (!open(OUT,">$dumpfile.new")) {
      print "ERROR: Couldn't create file $dumpfile.new : $!\n";
      &Manual_CleanUpTempfiles();
      file_lock::Done();
      exit(1);
    }
    if (!open(IN,"<$dumpfile")) {
      print "ERROR: Couldn't read control file dump $dumpfile : $!\n";
      &Manual_CleanUpTempfiles();
      file_lock::Done();
      exit(1);
    }
    $rundir = "";
    while(<IN>) {
      chop;
      if (/^\s*RUNDIR:\s+(\S+)\s*$/) {
        $rundir = $1;
      }
      elsif (/^\s*eckt\s*=\s*\"(.*)\"\s*$/) {
        $eckt = $1;
        if ($CHIPS{$userdir}{"rundirs"}{$rundir}{"exists"} == 2) {
          $spice_techfile = $CHIPS{$userdir}{"rundirs"}{$rundir}{"spice_techfile"};

	  $dslver = "";
          if (($CHIPBRF =~ /^cnb/) && (($spice_techfile =~ /r1\.11/) ||
	                               ($spice_techfile =~ /rev1\.11/))) {
	    $dslver = "cs200_r1.11v20080327";
	  }
          elsif (($CHIPBRF =~ /^cnb/) && ($spice_techfile =~ /cs250/)) {
	    $dslver = "cs250";
	  }

	  if ($dslver ne "") {
            $eckt_cellname = $CHIPS{$userdir}{"rundirs"}{$rundir}{"eckt_cellname"};
            $eckt_resolved = &GimmeSimplePath($eckt);
            if ($eckt_resolved eq "") { $eckt_resolved = $eckt; }
            $flat_eckt = $eckt_resolved;
            $flat_eckt =~ s/\//\#/g;
            $newfile = "$HACK_NETLIST_DIR/$CHIPBRF/$eckt_cellname/$dslver.$flat_eckt";
            if ((-e $newfile) &&
                (-e "$newfile.incrc")) {
              $musthack = 1;
              s/\"\Q$eckt\E\"/\"$newfile\"/;
            }
          }
        }
      }
      print OUT "$_\n";
    }
    close(IN);
    close(OUT);

    if ($musthack) {
      $dateval = localtime;
      print "$dateval: Hacking eckt netlist in control file for $CHIPBRF $userdir...\n";
      system("/bin/rm -f $dumpfile >/dev/null 2>&1");
      system("/bin/mv $dumpfile.new $dumpfile >/dev/null 2>&1");
    }
    else {
      system("/bin/rm -f $dumpfile.new >/dev/null 2>&1");
    }
  }

  return 1;
} ## End sub Manual_Hack_ControlFileDumps
###############################################################################
sub GimmeSimplePath {
  ## You give it a pathname.  It returns the path that has the least number of
  ## symbolic links.
  ##
  ## Where pathname is some path (relative or absolute).  The path can be to a
  ## file or a directory.  It can contain "." and "..".
  ## 
  ## This subroutine will return either the same path or an alternative
  ## path to the given path.  The resulting path will have the least number
  ## of symbolic links in it.
  ## 
  ## Why would you use this?  Because sometimes you might have a symbolic link
  ## that changes its value,  and you want to always point to the original
  ## thing it pointed to.  So you'd use this subroutine to resolve its "real" path
  ## so that you can remember it for later on.
  ## 
  ## For example,  at centaur we often change the "master" release directory.
  ## One day the master release directory will point to "rel0501",  but the
  ## next day it might point to "rel0512".  So if you were to use this subroutine
  ## originally,  you would have found that the real path is to "rel0501",
  ## and later on you'd be able to detect it when the real path was changed
  ## to "rel0512".  Otherwise,  your scripts may be tricked into thinking
  ## that the master release directory is a constant directory that never
  ## changes.
  ## 
  ## The path you give it must exist.  If it doesn't,  then it results in
  ## an error message.
  ## 
  ## The resolved path is checked prior to returning it out to make sure its
  ## device and inode number match the original path it was given.  Any
  ## differences results in an error message.  So the returned path can never
  ## be to the wrong file by accident.
  ## 
  ## Any error messages will be stored in global $GIMMESIMPLEPATH_ERROR,
  ## and the subroutine will return "".
  ## 
  ## If no errors are detected,  the subroutine returns the resolved path.
  ## 
  ## NOTE:
  ##
  ## It is not guaranteed to return a path that's visible on all machines across
  ## the network.  For portability,  you should pass this result into findnet.pl.
  ## 
  ## For example:
  ## 
  ##   $path1 = &GimmeSimplePath("/vlsi/centaur/c5r");
  ##   ## /n_mounts/fs6/chips/c5r
  ##   if ($path1 eq "") { die("$GIMMESIMPLEPATH_ERROR\n"); }
  ##   $path2 = `findnet.pl $path1`;
  ##   ## /n/chips/c5r
  ##
  ## Remember to add this to your program first:
  ##   use Cwd 'abs_path';

  local($origpath) = @_;
  local($newpath,*DIR,*IN,$lastslash,$dirpath,$filename,@stat_orig,@stat_new);

  $GIMMESIMPLEPATH_ERROR = "";

  if (opendir(DIR,$origpath)) {
    ## Directories can be handled already by Cwd's abs_path().
    closedir(DIR);
    $newpath = abs_path($origpath);
  }
  elsif (open(IN,$origpath)) {
    ## Not a directory.  Could it be a file?
    close(IN);
    $newpath = $origpath;
    if ($newpath !~ /^\//) {
      $newpath = "./" . $newpath;
    }
    $lastslash = rindex($newpath,"/");
    if ($lastslash == -1) {
      ## Should never happen.
      $GIMMESIMPLEPATH_ERROR = "Can't resolve path: $origpath";
      return "";
    }

    $dirpath = abs_path(substr($newpath,0,$lastslash));
    $filename = substr($newpath,$lastslash+1);
    $newpath = $dirpath . '/' . $filename;
  }
  else {
    $GIMMESIMPLEPATH_ERROR = "Path does not exist: $origpath";
    return "";
  }

  ## And just in case we screwed up...
  @stat_orig = stat($origpath);
  @stat_new = stat($newpath);

  if (($stat_orig[0] != $stat_new[0]) ||
      ($stat_orig[1] != $stat_new[1])) {
    ## The device and inode number should match.  If not,  we
    ## messed up.
    $GIMMESIMPLEPATH_ERROR = "Not sure why, but the resolved path isn't the same as the orig path:  orig=$origpath resolved=$newpath";
    return "";
  }

  return $newpath;
} ## End sub GimmeSimplePath
###############################################################################
###############################################################################
###############################################################################
sub Usage {
  print <<'EOF';
This is the main job submission script for the Random Spice Simulation flow.
It can be run in manual or automated mode.

In the manual mode,  you are submitting stuff to the queue right now rather
than waiting for the automated flow to get to it. In the automated mode, it
runs as user "bot" and periodically submits everyone's jobs in the order by
which it prioritizes them.

The manual mode options are:
Usage: rss_flow.pl
        -ctrl $userdir1/$controlfile1 [$userdir2/$controlfile2 ..]
        [-run $userdir1/$rundir1 [$userdirM/$rundirN ..]]
	[-workdir $workdir]
	[-resultsdir $resultsdir]
	[-bat]
	[-nobat]
	[-priority priority_number]

You need to set your $CHIP, $CHIPBRF, $CADHOME, and $CENTHOME environment
variables prior to using the manual mode.

Options:
--------

-ctrl

  This lets you specify which control file(s) you want to use.

  You need to specify either the full or relative path to the control
  file in the format "$userdir/$controlfile".  If you give a relative
  path,  it assumes the path is relative to the following directory:
    $CHIP/random_spice/user/

  And so if you gave it "-ctrl weigand/manual_control.pl",  it would
  look for the control file at:
    $CHIP/random_spice/user/weigand/manual_control.pl

  In this case,  the $userdir is "weigand" and the $controlfile is
  "manual_control.pl".

  However,  you could also give a full path.  For example,  you could give
  it "-ctrl /home/users3/weigand/manhsim/weigand/manual_control.pl".  The
  path doesn't have to point to $CHIP/random_spice/user/...

  The control file is usually named "control.pl",  but for the manual
  flow it can be any name you want it to be.

-run

  Optionally,  you can specify which rundir's in the control file(s) you
  want to run now.  If you don't give this option,  it runs them all.

  The format is "$userdir/$rundir".  The $userdir corresponds to the
  control file you've given,  and the $rundir corresponds to the rundir
  that is inside of the control file.  This should not be an absolute
  pathname.  You should only have one slash in the entire string.  For
  example, "weigand/run1".

-workdir
  
  The working directory can be specified here.  By default,  it's set to:

     $CHIP/random_spice/manual_running/

  This is where the flow runs everything.  It creates sub-directories for
  each of the userdir/rundir you want to run.  This is like the automated flow
  with runs in the $CHIP/random_spice/running/ directory.

-resultsdir

  The results directory can be specified here.  By default,  it's set to:

     $CHIP/random_spice/manual_results/

  This is where the flow copies all the results to when it's finished
  running.  It works just like the automated flow which outputs to the
  directory $CHIP/random_spice/results/.

-bat
  
  You would use this option to indicate that you want to submit all
  jobs to the batch,  low-priority queues.  Otherwise it will try to
  submit jobs to the non-batch queues first before submitting to the
  batch queues.  Remember, batch queue jobs can be killed and
  rescheduled.

-nobat

  This option can be used to specify that you don't want *any* batch
  queue jobs.  It will only use the non-batch queues.  Otherwise some
  of your jobs may get into the batch queues where they may be killed
  and rescheduled by others using the non-batch queues.

  Most people use -nobat.

-priority

  You can give this a queue priority value.  All jobs submitted to the
  queue will be assigned this priority.  Jobs with higher priority will
  always be run first before job any jobs with a lower priority.  But
  doing that means that your jobs will be given an unfair advantage, so
  don't use this unless you believe the queue is treating you unfairly.
  Use sparingly (or never)!  Typically, the default queue priority is 120.
  You can give it a higher number (180 for example) to assure that ALL
  your jobs will be run before other jobs submitted to the same queue.
  TRY NOT TO USE THIS!

EOF
  exit(1);
} ## End sub Usage
###############################################################################

