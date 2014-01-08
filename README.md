This is an collection of scripts to support doing performance and
correctness tests between OpenSCAD versions for exernal content.
As a start, we're downloading and comparing models from Thingiverse.

* things.txt should contain a list of Thingiverse IDs
* Run download.sh - this will download all things as zip file in the zip folder
* Run unpack-all.sh - this will unpack all the zip files into the unpacked folder
* FIXME: cp unpack.log allfiles.txt
* make <version> will run OpenSCAD on all files with the given OpenSCAD version
* collecttimes.sh will create times.csv and comparison.html

Notes:
* To update a single result:
    * rm -r results-<version>/<id>
    * make <version>
    * collecttimes.sh

* To reimport into Numbers:
    * drop times.csv into Numbers
    * copy&paste the resulting table into the main document
    * Show title and rename to 'times' (remove existing times table)
    -> this will rebuild the main table
