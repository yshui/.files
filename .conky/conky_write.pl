#!/usr/bin/perl
while(<>){
	chomp;
	$u = quotemeta($_);
	`wmiir xwrite /rbar/conky "label" $u`;
	last if $?;
}
`killall conky-cli`;
`wmiir remove /rbar/conky`;
