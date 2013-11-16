#!/usr/bin/perl

print "[Unit]\nDescription=$ARGV[0]\n\n[Service]\nExecStart=$ARGV[1]\n\n";
if($#ARGV >= 2){
	print "[Install]\nWantedBy=$ARGV[2]\n";
}
