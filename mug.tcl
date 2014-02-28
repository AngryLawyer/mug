#!/usr/bin/env tclsh

package require cmdline

# Args are defined like {name comparator source version}

# Writes a sourceable script for using local packages
proc provide_autoloader {$path} {
    set destination [file join $path "mug_autoloader.tcl"]
    set file_id [open $destination "r"]
    set file_data [read $file_id]
    close $file_id
}

# From a Teapot URL, extract the meaningful data
proc extract_teapot_string {teapot_string} {
    set start [string first {[[TPM[[} $teapot_string]
    set end [string first {]]MPT]]} $teapot_string]
    return [string range $teapot_string [expr {$start + 7}] [expr {$end - 1}]]
}

proc get_arch {} {
    set sys_os $::tcl_platform(os)
    set sys_machine $::tcl_platform(machine)

    if {$sys_os == "Darwin"} {
        # We should probably try and get the x64 version if we need it
        return "macosx-universal"
    } elseif {$os == "Linux"} {
    }
    
    # TODO: Make this support non-x86 platforms
    if {$sys_machine == "x86_64"} {
        return "linux-glibc2.3-x86_64"
    } else {
        return "linux-glibc2.3-ix86"
    }
    error "Unknown architecture $os $machine"
}

proc install {args} {
}

proc main {args} {
    set options {
        {install.arg "" "Install the application"}
    }
    array set params [::cmdline::getoptions args $options]
    parray params
    puts $args
}

main $::argv
