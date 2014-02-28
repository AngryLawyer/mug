#!/usr/bin/env tclsh

package require cmdline

# Args are defined like {name comparator source version}

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
