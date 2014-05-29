namespace eval ::mug::utils {
    namespace export slurp_file

    # Read a given file and spit it out
    proc slurp_file {name} {
        set fp [open $name r]
        set file_data [read $fp]
        close $fp
        return $file_data
    }

    # Check a currently installed package 
    proc get_installed_package_details {package_path} {
        if {[file exists $package_path/.mug_details]} {
            set file_data [slurp_file $package_path/.mug_details]
            return $file_data
        }
        return {}
    } 

    # Write a details file into the installed package
    proc set_installed_package_details {package_path package_details} {

    }
}
