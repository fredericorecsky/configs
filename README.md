# My linux bash terminal config 

This git repository contains a set of config files and bash scripts
that have tooling that I use when doing software development or 
when I am doing any dev-ops task.

## Installing

Assuming that you have curl installed on your system:

     curl -L https://raw.githubusercontent.com/fredericorecsky/configs/master/bin/install_dev_configs | sh

## Update 

Go inside the ~/github/configs/bin and run update_dev_configs

## Goals

It has a place where the bash variables and scripts as well aliases 
are stored and when a new shell starts, it will read from that dir.

The files are usually on your homegir inside github/configs dir.

The files that start with 99_internal will be ignored on git and should
contain specific local configuration. The rest is generic as possible.

Some of the config I have are listed above. Note that the files are sorted
so the number on front means the order.

* 00_base - Basic shell functions and commands
* 99_golang - Golang configuration 
* 99_java - Java configuration
* 99_misc - Bash alias and variables
* 99_perl - Perl configuration
* 99_rakudo - Perl6 configuration
* 99_ruby - Ruby configuration
* bashrc - This is the bashrc that is called by bash, it will remove the old
           one and make the ~/.bashrc a syslink to the bashrc of the project
* ZZ_prompt - If you are using necroperl tools, this will make the prompt 
              use necroperl

## I want to add my own stuff

If is really personal, add a 99_internal file and add your stuff. If you think
that is useful or you want to fix any of the above, just send a merge request
