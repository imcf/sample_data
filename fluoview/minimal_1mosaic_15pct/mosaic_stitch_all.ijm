// BEGIN stitching macro HEAD

// default values required to be set:
name = '';  // the dataset name
padlen = 0;  // padding length for mosaic numbering
mcount = 0;  // total number of mosaics in dataset
compute = true;  // whether to compute the overlap)
input_dir = '';  // user will be asked if empty
use_batch_mode = false;

// END stitching macro HEAD


name="mosaic";
padlen=1;
mcount=1;
input_dir="";
use_batch_mode=true;

// BEGIN stitching macro BODY

/*\
 * Variables REQUIRED to be set for body:
 *   name : str (dataset name)
 *   padlen : int (padding length for mosaic numbering)
 *   mcount : int (total number of mosaics in dataset)
 *   compute : boolean (whether to compute the overlap)
\*/

print("Stitching macro for dataset [" + name + "]");
if(input_dir == "") {
	msg = "Select directory for dataset '" + name + "'";
	input_dir = getDirectory(msg);
}
output_dir=input_dir;

setBatchMode(use_batch_mode);

// stitching parameters template
tpl  = "type=[Positions from file] ";
tpl += "order=[Defined by TileConfiguration] ";
tpl += "directory=" + input_dir + " ";
tpl += "fusion_method=[Linear Blending] ";
tpl += "regression_threshold=0.30 ";
tpl += "max/avg_displacement_threshold=2.50 ";
tpl += "absolute_displacement_threshold=3.50 ";
tpl += "computation_parameters=";
tpl += "[Save computation time (but use more RAM)] ";
tpl += "image_output=[Fuse and display] ";
if(compute) {
    tpl += "compute_overlap ";
    tpl += "subpixel_accuracy ";
}

for (id = 0; id < mcount; id++) {
	layout_file = "mosaic_" + IJ.pad(id, padlen) + ".txt";
	ome_tiff = "mosaic_" + IJ.pad(id, padlen) + ".ome.tif ";
	param = tpl + "layout_file=" + layout_file;
	print("===========================================");
	print("*** [" + name + "]: processing " + layout_file);
	run("Grid/Collection stitching", param);
	bfexp  = "save=" + output_dir + "\\" + ome_tiff + " ";
	bfexp += "compression=Uncompressed";
	print("*** [" + name + "]: finished " + layout_file);
	print("*** Exporting to OME-TIFF: " + ome_tiff);
	run("Bio-Formats Exporter", bfexp);
	close();
	print("*** Finished exporting to OME-TIFF.");
}
print("===========================================");
print("[" + name + "]: processed " + mcount + " mosaics.");

setBatchMode(false);

// END stitching macro BODY
