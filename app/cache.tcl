namespace eval ::mug::cache {
    namespace export cache_directory_path

    variable CACHE_ROOT /var/

    proc cache_directory_name {name tag url} {
        return $name-$tag-$url
    }

    proc cache_directory_path {name tag url} {
        variable CACHE_ROOT
        return $CACHE_ROOT/[cache_directory_name $name $tag $url]
    }

    proc ensure_cache {cache_directory} {
        variable CACHE_ROOT
        file mkdir $CACHE_ROOT/$cache_directory
    }

    proc clean_cache {cache_directory} {
        variable CACHE_ROOT
        file delete -force $CACHE_ROOT/$cache_directory
    }
}
