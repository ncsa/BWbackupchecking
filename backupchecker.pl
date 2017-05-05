use POSIX qw(strftime);

my $date = strftime "%Y-%m-%d", localtime;
$date = "2016-09-13";
#print $date;
open(DATA, "<backup.txt") or die "Couldn't open file file.txt, $!";

my @backup_folders = ();
my $header = 1;
while(<DATA>){

   if($header != 1)
   {
   my $line  = "$_";
   chomp $line;
   next unless length($line);
   my @const = split(/\s+/, $line);
   my $backup_folder = $const[2];
   $backup_folder =~ s/^\s+//;           # leading whitespace
   $backup_folder =~ s/\s+$//;           # trailing whitespace
    $_ = $backup_folder;
   if(!/^\//)
   {
    $backup_folder = "/".$const[2];
   }
   #print "\ncheckoing outside $backup_folder\n";

   if(/^\/u/ || /^\/projects/ || /^\/scratch/ || /^\/mount\/a/ || /^\/mount\/b/ || /^\/mount\/c/)
        {
                $backup_folder=~s/\/mount\/a/\/u/g;
                $backup_folder=~s/\/mount\/b/\/projects/g;
                $backup_folder=~s/\/mount\/c/\/scratch/g;
                #print "\ncheckoing $backup_folder\n";
                if (!( grep( /^$backup_folder$/, @backup_folders ) )) {
                        print "\npushing".$backup_folder;
                        push (@backup_folders, $backup_folder);
                }
        }
    }
    $header = 0;
}
close(DATA);

`rm -rf ufolders.txt`;
`find /u/ -mindepth 1 -maxdepth 2 -type d -print >>ufolders.txt`;

open(my $fread, '<:encoding(UTF-8)', "ufolders.txt")
  or die "Could not open file ufolders.txt";
my $readhandler= $fread;
my @u_folders = ();
while (my $row = <$readhandler>) {
   chomp $row;
    $row =~ s/^\s+//;           # leading whitespace
    $row =~ s/\s+$//;           # trailing whitespace
    next unless length($row);
    push (@u_folders, $row);
}
close($fread);

print "Missing u folders: ";
foreach $loopvariable (@u_folders)
{
    if (!( grep( /^$loopvariable$/, @backup_folders ) )) {
        print "\n$loopvariable";
    }
}


`rm -rf projectsfolders.txt`;
`find /projects/ -mindepth 1 -maxdepth 2 -type d -print >>projectsfolders.txt`;
open(my $projread, '<:encoding(UTF-8)', "projectsfolders.txt")
  or die "Could not open file ufolders.txt";
my @projects_folders = ();
while (my $row = <$projread>) {
   chomp $row;
    $row =~ s/^\s+//;           # leading whitespace
    $row =~ s/\s+$//;           # trailing whitespace
    next unless length($row);
    push (@projects_folders, $row);
}
close($projread);

print "Missing projects folders: ";
foreach $loopvariable (@projects_folders)
{
    if (!( grep( /^$loopvariable$/, @backup_folders ) )) {
        print "\n$loopvariable";
    }
}

#Scratch folder section

`rm -rf scratchfolders.txt`;
`find /scratch/ -mindepth 1 -maxdepth 2 -type d -print >>scratchfolders.txt`;
open(my $scratchread, '<:encoding(UTF-8)', "scratchfolders.txt")
  or die "Could not open file ufolders.txt";
my @scratch_folders = ();
while (my $row = <$scratchread>) {
   chomp $row;
    $row =~ s/^\s+//;           # leading whitespace
    $row =~ s/\s+$//;           # trailing whitespace
    next unless length($row);
    push (@scratch_folders, $row);
}
close($scratchread);

print "Missing scratch folders: ";
foreach $loopvariable (@scratch_folders)
{
    if (!( grep( /^$loopvariable$/, @backup_folders ) )) {
        print "\n$loopvariable";
    }
}
#end of scratch section
print "\nbackup finder completed execution successfully";
