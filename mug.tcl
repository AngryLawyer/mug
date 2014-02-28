#!/usr/bin/env tclsh

package require cmdline
package require http

# Args are defined like {name comparator source version}

# Writes a sourceable script for using local packages
proc provide_autoloader {path} {
    set destination [file join $path "mug_autoloader.tcl"]
    set mug_path [file join $path mug_packages]

    file mkdir $mug_path

    set first {set ::auto_path [linsert $::auto_path 0 }
    set last {]}

    set file_id [open $destination "w"]
    puts $file_id $first$mug_path$last
    close $file_id
}

proc get_arch {} {
    set sys_os $::tcl_platform(os)
    set sys_machine $::tcl_platform(machine)

    if {$sys_os == "Darwin"} {
        set os "macosx"
    } elseif {$os == "Linux"} {
        set os "linux"
    } else {
        set os "unknown"
    }
    
    # TODO: Make this support non-x86 platforms
    if {$sys_machine == "x86_64"} {
        set machine "x86-64"
    } else {
        set machine "x86"
    } else {
        set machine "unknown"
    }
    return "$os $machine"
}

# Get a URL really simply
proc get_page {url} {
    set token [::http::geturl $url]
    set data [::http::data $token]
    ::http::cleanup $token          
    return $data
}

# From a Teapot URL, extract the meaningful data
proc extract_teapot_string {teapot_string} {
    set start [string first {[[TPM[[} $teapot_string]
    set end [string first {]]MPT]]} $teapot_string]
    return [string range $teapot_string [expr {$start + 7}] [expr {$end - 1}]]
}

proc get_teapot_info {url} {
    set data [get_page $url]
    return [extract_teapot_string $data]
}

proc find_teapot_package {teapot_url my_package_name} {
    set packages [get_teapot_info $teapot_url/package/list]

    foreach {package_tuple} $packages {
        if {[lindex $package_tuple 1] == $my_package_name} {
            return $package_tuple
        }
    }

    return 0
}

proc install {args} {
}

proc main {args} {
    set options {
        {install.arg "" "Install the application"}
    }
    array set params [::cmdline::getoptions args $options]
    #parray params
    #puts $args
    provide_autoloader [pwd]
    puts [find_teapot_package "http://teapot.activestate.com/" "Itcl"]
}

main $::argv
