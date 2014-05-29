namespace eval ::mug::cache {

    set CACHE_ROOT /var/

    proc cache_directory_name {name tag url} {
        return $name-$tag-$url
    }

    proc cache_directory_path {name tag url} {
        return ::mug::cache::$CACHE_ROOT/[cache_directory_name]
    }

    proc ensure_cache {cache_directory} {
        file mkdir ::mug::cache::$CACHE_ROOT/$cache_directory
    }

    proc clean_cache {cache_directory} {
        file delete -force ::mug::cache::$CACHE_ROOT/$cache_directory
    }
}
