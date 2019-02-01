#! /usr/local/bin/perl5

# Program: rss_flow.hack_netlist.pl
# Author : Steve Weigand
# Company: Centaur Technology
# Descr. : Used by rss_flow.pl to run the Fujitsu spice netlist hack.
#
# $Log: rss_flow.hack_netlist.pl,v $
# Revision 1.10  2009/10/20 19:29:00  weigand
# Changed ckttmp dir.
#
# Revision 1.9  2009/07/15 16:15:57  weigand
# Minor change.
#
# Revision 1.8  2008/05/12 17:50:31  weigand
# Changes for new update_dsl_params script.
#
# Revision 1.7  2008/05/08 17:37:50  weigand
# Parameterized dsl version on command line.
#
# Revision 1.6  2008/05/08 17:20:23  weigand
# Changed to use update_dsl_params instead of $CHIP/bin/convert_ckt_to_ssbckt.
#
# Revision 1.5  2008/01/19 20:01:04  weigand
# Minor bug fixes.
#
# Revision 1.4  2008/01/19 04:49:02  weigand
# bug fixes.
#
# Revision 1.3  2008/01/19 02:13:40  weigand
# Added deletion of main stdout logfile.
#
# Revision 1.2  2008/01/19 00:06:37  weigand
# *** empty log message ***
#
# Revision 1.1  2008/01/19 00:00:01  weigand
# Initial revision
#
#
#

use FileHandle;
STDOUT->autoflush();
STDERR->autoflush();

use Cwd 'abs_path';

require "/vlsi/cad2/bin/crc32_loader.pm";
require "/vlsi/cad2/bin/file_lock.pm"; ## File Locking


if ($#ARGV != 5) {
  print <<'EOF';
Usage: rss_flow.hack_netlist.pl $CHIPBRF $cellname $hostname $pid $dsl "$eckt"

Where $CHIPBRF is the name of the chip ("cnb" for example).
Where $cellname is the name of the top-level cell.
Where $hostname is your host name ("addison" for example).
Where $pid is the process id of the process calling this script ("2089"
for example).
Where $dsl is the dsl version (for example "cs250").  This comes from:
  $CHIP/technology/dsl_$dsl.
Where $eckt is the path to the extracted circuit.

This will create a hacked version of the eckt netlist and stores it
into a cache of files at /n/scr_rss/ckttmp/rss_tmp_cache/.

You should not be using this stand-alone,  but it's possible.  You
should try to use rss_flow.pl instead.

EOF
  exit(1);
}

$opCHIPBRF = shift(@ARGV);
$opCELL = shift(@ARGV);
$opHOSTNAME = shift(@ARGV);
$opPID = shift(@ARGV);
$opDSL = shift(@ARGV);
$opECKT = shift(@ARGV);

$FLAT_ECKT_NAME = $opECKT;
$FLAT_ECKT_NAME =~ s/\//\#/g;

## Since it's a hack...
$ENV{"CHIP"} = "/vlsi/centaur/$opCHIPBRF";
$ENV{"CHIPBRF"} = $opCHIPBRF;
$ENV{"CADHOME"} = "/vlsi/cad3";
$ENV{"CENTHOME"} = "/vlsi/centaur";

$WORKDIR = "/n/scr_rss/ckttmp/rss_tmp_cache/$opCHIPBRF/$opCELL";
if (! -e $WORKDIR) {
  system("/bin/mkdir -p -m 777 $WORKDIR >/dev/null 2>&1");
}
if (! -e $WORKDIR) {
  print "ERROR: Can't create directory $WORKDIR\n";
  exit(1);
}

$ENV{"PWD"} = $WORKDIR;
chdir($WORKDIR);

if (-e "/usr/local/bin/gzip") { $GZIPPATH = "/usr/local/bin/gzip"; } ## Solaris
else { $GZIPPATH = "/bin/gzip"; } ## Linux

## Our standard-out has already been redirected to this log file:
$OURLOGFILE = "$WORKDIR/hack.log.$opDSL.$FLAT_ECKT_NAME.$opHOSTNAME.$opPID";

###############################################################################

  $dateval = localtime();
  print "$dateval: Starting with args: $opCHIPBRF $opCELL $opHOSTNAME $opPID $opDSL \"$opECKT\"\n";

  if (! -d "/vlsi/centaur/$opCHIPBRF/technology/dsl_$opDSL") {
    print "ERROR: Unknown DSL version \"$opDSL\" for chip \"$opCHIPBRF\".\n";
    exit(1);
  }

  &CheckIfExtractedNetlist();
  &CheckMustUpdate();
  &LockFiles();
  &HackNetlist();

  exit(0);

###############################################################################
sub DeleteLogFile {
  $dateval = localtime;
  print "$dateval: Deleting our log file $OURLOGFILE\n";

  STDOUT->flush();
  STDERR->flush();
  close(STDOUT);
  close(STDERR);

  system("/bin/rm -f $OURLOGFILE >/dev/null 2>&1");

  return 1;
} ## End sub DeleteLogFile
###############################################################################
sub CheckIfExtractedNetlist {
  ## Go through the eckt file and see if it was extracted using XRC.  If
  ## not,  we need to abort.  We can check this by looking for the first
  ## transistor in the file.  If it has AD=# on it,  it must have been
  ## extracted.
  ##
  ## We're also able to determine if the netlist was already run through
  ## the hack script.  If so,  we abort with exit status code 0.

  $dateval = localtime;
  print "$dateval: Checking to see if the netlist is extracted or schematic...\n";

  if (! -e $opECKT) {
    print "ERROR: Can't find netlist file $opECKT\n";
    exit(1);
  }

  $SIG{"PIPE"} = 'IGNORE';

  if (!open(IN,"/vlsi/cad3/bin/spice_unwrap -lc -in $opECKT |")) {
    print "ERROR: Can't read file $opECKT\n";
    exit(1);
  }
  $gotone = 0;
  $is_extracted = 0;
  $is_already_hacked = 0;
  while(<IN>) {
    chop;
    ## Extracted netlists look like this:
    ##
    ## mxrombuf2/xi657/xregen/xe2/xtuneclk61/mmn3
    ## +xrombuf2/xi657/xregen/xe2/xtuneclk61/int2
    ## +r_xrombuf2/xi657/xregen/tap_mxrombuf2/xi657/xregen/xe2/xtuneclk61/mmn3 vss0
    ## +vbpa nch l=0.065 w=0.79 ad=0.06715 as=0.13825 pd=0.96 ps=1.93 nrd=0 nrs=0
    ## +MULU0=0.64707
    ## *   SA=0.16                SB=0.57
    ## *   LTA1=3.155             LTB1=3.155             W1=0.79
    ## *   WTA1=2.95              WTB1=0.18              L1=0.035
    ##
    ## Whereas schematic netlists look like this:
    ##
    ## mmp o r_i_mmp vdd0 vbna pch w='wp/fp' l=lp m=fp sa=saref sb=saref nrd=0 nrs=0 ad='ad_geo(geop,wp/fp)' as='as_geo(geop,wp/fp)'
    ## + pd='pd_geo(geop,wp/fp)' ps='ps_geo(geop,wp/fp)'
    ##
    ## Also,  we determine if the netlist has been run through the hack script
    ## already.  The netlist will look like this if cnb:
    ##
    ## mxrombuf2/xi657/xregen/xe2/xtuneclk61/mmn2
    ## +xrombuf2/xi657/xregen/xe2/xtuneclk61/int1
    ## +r_vdd0_mxrombuf2/xi657/xregen/xe2/xtuneclk61/mmn2
    ## +xrombuf2/xi657/xregen/xe2/xtuneclk61/int2 vbpa nch l=0.065 w=0.79 ad=0.06715
    ## +as=0.06715 pd=0.96 ps=0.96 nrd=0 nrs=0 DELVTO=0.03106 MULU0=0.81388
    ## +MULVSAT=0.99824
    ## *   SA=3.65e-07            SB=3.65e-07
    ## *   LTA1=3.155e-06         LTB1=3.155e-06         W1=7.9e-07
    ## *   WTA1=2.95e-06          WTB1=1.8e-07           L1=3.5e-08

    if (/^\s*m/) {
      ## NOTE: All characters are changed to lower-case during spice_unwrap...
      $gotone = 1;
      s/\s*\=\s*/=/g;
      s/\s+/ /g;
      if (($opCHIPBRF =~ /^cnb/) && ((/ delvto=/) || (/ mulvsat=/))) {
        $is_already_hacked = 1;
      }
      if (/ ad=(\S+)/) {
        $thingy = $1;
	if (&IsNumber($thingy)) {
	  $is_extracted = 1;
	  last;
	}
      }
    }
  } 
  close(IN);

  if (! $gotone) {
    print "ERROR: Didn't find a single transistor in the file: $opECKT\n";
    exit(1);
  }

  if (!$is_extracted) {
    print "WARNING: This is not an extracted netlist. Aborting.\n";
    &KillFile();
    &DeleteLogFile();
    exit(0);
  }

  if ($is_already_hacked) {
    print "INFO: This netlist is already hacked. Will do nothing.\n";
    &KillFile();
    &DeleteLogFile();
    exit(0);
  }

  return 1;
} ## End sub CheckIfExtractedNetlist
###############################################################################
sub KillFile {
  ## Maybe a hacked netlist file exists,  but it should be deleted.
  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME") {
    system("/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME >/dev/null 2>&1");
  }
  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc") {
    system("/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc >/dev/null 2>&1");
  }
  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.log") {
    system("/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME.log >/dev/null 2>&1");
  }

  return 1;
} ## End sub KillFile
###############################################################################
sub CheckMustUpdate {
  ## Okay,  so the netlist is an extracted netlist,  and it hasn't been
  ## run through the hack script.  So,  get its CRC and check if we have
  ## a cache of a previous time we ran the hack script on this file.
  ## If the cached file exists,  and it's the same CRC,  then we just
  ## exit with status code 0.  Otherwise the program must continue.

  $dateval = localtime;
  print "$dateval: Determining if need to update netlist...\n";

  $NEWCRC = &crc32::crc32_file($opECKT,0); ## Global

  $mustupdate = 0;
  if ((! -e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME") ||
      (! -e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc") ||
      (! -e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.log")) {
    $mustupdate = 1;
    print "INFO: First time this netlist has been seen.\n";
  }
  else {
    if (!open(IN,"<$WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc")) {
      print "ERROR: Can't read file $WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc : $!\n";
      exit(1);
    }
    $oldcrc = <IN>;
    chop($oldcrc);
    close(IN);
    if ($oldcrc != $NEWCRC) {
      $mustupdate = 1;
      print "INFO: Old CRC=$oldcrc does not match new CRC=$NEWCRC\n";
    }
  }

  if (!$mustupdate) {
    $dateval = localtime;
    print "$dateval: No need to update the netlist at this time.  Aborting.\n";
    &DeleteLogFile();
    exit(0);
  }

  $dateval = localtime;
  print "$dateval: Must update netlist...\n";

  return 1;
} ## End sub CheckMustUpdate
###############################################################################
sub LockFiles {

  $dateval = localtime;
  print "$dateval: Attempting to lock $opCHIPBRF $opECKT ...\n";

  &file_lock::Init();

  $LOCKSTRING = "rss_flow.hack_netlist.pl $opCHIPBRF $opECKT"; ## Global
  $firsttime = 1;
  $result = &file_lock::Lock($LOCKSTRING);
  while ($result == 0) {
    if ($file_lock::ERRMSG ne "") {
      print "ERROR: File locking reports error: $file_lock::ERRMSG\n";
      print "ERROR: Try again later.\n";
      exit(1);
    }
    if ($firsttime) {
      print "\nINFO: Waiting for lock on file to be removed:\n";
      foreach $thingy (@file_lock::LOCKS_INVALID) {
        $thingy =~ /^(\S+) (\S+) (\S+) (\S+) (.*)$/;
        $machinename = $1;
        $username = $2;
        $pid = $3;
        $starttime = localtime($4);
        $this_lockstring = $5;
        print "  -> lock    = $this_lockstring\n";
        print "     user    = $username\n";
        print "     machine = $machinename\n";
        print "     pid     = $pid\n";
        print "     since   = $starttime\n\n";
      }
    }
    $firsttime = 0;
    sleep(20); ## Sleep for 20 seconds to retry.
    $result = &file_lock::Lock($LOCKSTRING);
  }

  $dateval = localtime;
  print "$dateval: Got lock on $opCHIPBRF $opECKT\n";

  return 1;
} ## End sub LockFiles
###############################################################################
sub HackNetlist {
  ## Run the dsl conversion script.

  $dateval = localtime;
  print "$dateval: Hacking netlist for dsl conversion...\n";

  $cmd = "/vlsi/cad3/bin/update_dsl_params $opECKT ";
  $cmd .= "-o $WORKDIR/$opDSL.$FLAT_ECKT_NAME.new ";
  $cmd .= "-ssbver $opDSL ";
  if ($opCHIPBRF =~ /^cnb/) {
    $cmd .= "-ncont ";
  }
  $cmd .= "> $WORKDIR/$opDSL.$FLAT_ECKT_NAME.new.log 2>&1";
  system($cmd);
  $status = $?;

  if ($status != 0) {
    print "ERROR: Converter script resulted in a bad exit status code ($status).\n";
    &file_lock::UnlockAll();
    &file_lock::Done();
    exit(1);
  }

  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME") {
    system("/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME");
  }
  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc") {
    system("/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc");
  }
  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.log") {
    system("/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME.log");
  }

  if (!open(OUT,">$WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc")) {
    print "ERROR: Can't create file $WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc : $!\n";
    &file_lock::UnlockAll();
    &file_lock::Done();
    exit(1);
  }
  print OUT "$NEWCRC\n";
  close(OUT);
  system("/bin/chmod 666 $WORKDIR/$opDSL.$FLAT_ECKT_NAME.incrc");

  $cmd = "/bin/mv $WORKDIR/$opDSL.$FLAT_ECKT_NAME.new ";
  $cmd .= "$WORKDIR/$opDSL.$FLAT_ECKT_NAME ";
  $cmd .= ">/dev/null 2>&1";
  system($cmd);
  system("/bin/chmod 666 $WORKDIR/$opDSL.$FLAT_ECKT_NAME");

  $cmd = "/bin/mv $WORKDIR/$opDSL.$FLAT_ECKT_NAME.new.log ";
  $cmd .= "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.log ";
  $cmd .= ">/dev/null 2>&1";
  system($cmd);
  system("/bin/chmod 666 $WORKDIR/$opDSL.$FLAT_ECKT_NAME.log");

  &file_lock::UnlockAll();
  &file_lock::Done();

  $dateval = localtime;
  print "$dateval: Done.\n";

  ## Now for our logfile...

  STDOUT->flush();
  STDERR->flush();
  close(STDOUT);
  close(STDERR);

  sleep(1); ## For NFS synching?

  if (-e "$WORKDIR/$opDSL.$FLAT_ECKT_NAME.hack.log") {
    $cmd = "/bin/rm -f $WORKDIR/$opDSL.$FLAT_ECKT_NAME.hack.log ";
    $cmd .= ">/dev/null 2>&1";
    system($cmd);
  }

  $cmd = "/bin/mv $OURLOGFILE $WORKDIR/$opDSL.$FLAT_ECKT_NAME.hack.log ";
  $cmd .= ">/dev/null 2>&1";
  system($cmd);
  system("/bin/chmod 666 $WORKDIR/$opDSL.$FLAT_ECKT_NAME.hack.log > /dev/null 2>&1");

  sleep(1); ## For NFS synching?

  return 1;
} ## End sub HackNetlist
###############################################################################
sub IsNumber {
# This returns 1 if the thing you give it is a valid signed integer,
# floating point,  or exponential number,  0 otherwise.  The only thing
# that's iffy about it is "+0" or "-0" returns 1, but most tools consider
# those to be valid numbers.  It correctly returns 0 for "4.",  for example,
# since there should be a number after the decimal point.  It understands
# "4e-5" or "4e+5".  It knows that "4e+-5" is wrong.  It's okay with ".4".
# etc.
 local($val) = @_;
 local($val2,$val3);

 $val =~ s/^[\+\-]{1}//;

 $val2 = $val;
 $val2 =~ s/^([0-9\.]+).*/$1/;

 $val3 = $val;
 $val3 =~ s/^[0-9\.]+//;

 if (($val2 !~ /^[0-9]+$/) && ($val2 !~ /^[0-9]+\.[0-9]+$/) &&
     ($val2 !~ /^\.[0-9]+$/)) { return 0; }

 if (($val3 ne "") && ($val3 !~ /^[eE][\+\-]?[0-9]+$/)) { return 0; }

 return 1;
} ## End sub IsNumber
##############################################################################
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
