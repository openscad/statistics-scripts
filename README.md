This is a collection of scripts to support running performance and
correctness tests between OpenSCAD versions for exernal content.
As a start, we're downloading and comparing models from Thingiverse.

**Prerequisites**

* ImageMagick
* timeout (sudo port install timeout)

**Preparations:**

* things.txt: should contain a list of Thingiverse IDs
* download.sh: This will download all things as zip files in the zip folder (unless they already exist)
* unpack-all.sh: Will unpack all the zip files into the unpacked folder
* find_scad_files.sh: Will locate all OpenSCAD files -> scadfiles.txt
* Makefile: versions = <list of OpenSCAD versions to test>

**Processing:**

* make <version> will run OpenSCAD on all files with the given OpenSCAD version

**Post-processing:**

* make comparison will build comparison.html, times.csv and comparison-preview.csv


Notes:

* To update a single result:
    * rm -r results-<version>/<id>
    * make <version>
    * make comparison
