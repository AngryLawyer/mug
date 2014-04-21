namespace eval ::mug::platform {
    namespace expor match_platform

    proc match_platform {available target} {
        #FIXME: Make it split open our version tuple
        return [expr {$available == $target}]
    }

    proc get_arch {sys_os sys_machine} {
        #set sys_os $::tcl_platform(os)
        #set sys_machine $::tcl_platform(machine)

        if {$sys_os == "Darwin"} {
            set os "macosx"
        } elseif {$sys_os == "Linux"} {
            set os "linux"
        } else {
            set os "unknown"
        }
        
        # TODO: Make this support non-x86 platforms
        if {$sys_machine == "x86_64"} {
            set machine "x86-64"
        } elseif {$sys_machine == "x86"} {
            set machine "x86"
        } else {
            set machine "unknown"
        }
        return "$os $machine"
    }

}
