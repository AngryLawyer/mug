namespace eval ::mug::autoloader {

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

}
