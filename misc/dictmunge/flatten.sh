# anki requires imports to collection.media to be flat
find dir1 -mindepth 2 -type f -exec mv -t dir2 '{}' +
