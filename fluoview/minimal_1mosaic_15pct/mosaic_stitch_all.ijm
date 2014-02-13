// stitching macro for mosaic
input_dir="";
if(input_dir == "") {
	msg = "Select directory 'mosaic'";
	input_dir = getDirectory(msg);
}
output_dir=input_dir;

padlen="1";

// parameters to compute positions
compute = "";
compute += "compute_overlap ";
compute += "subpixel_accuracy ";

// stitching parameters template
tpl  = "type=[Positions from file] ";
tpl += "order=[Defined by TileConfiguration] ";
tpl += "directory=" + input_dir + " ";
tpl += "fusion_method=[Linear Blending] ";
tpl += "regression_threshold=0.30 ";
tpl += "max/avg_displacement_threshold=2.50 ";
tpl += "absolute_displacement_threshold=3.50 ";
tpl += compute;
tpl += "computation_parameters=";
tpl += "[Save computation time (but use more RAM)] ";
tpl += "image_output=[Fuse and display] ";

for (id=0; id<0; id++) {
	layout_file = "mosaic_" + IJ.pad(id, padlen) + ".txt";
	ome_tiff = "mosaic_" + IJ.pad(id, padlen) + ".ome.tif ";
	param = tpl + "layout_file=" + layout_file;
	print("===========================================");
	print("*** Processing file: " + layout_file);
	run("Grid/Collection stitching", param);
	bfexp  = "save=" + output_dir + "\\" + ome_tiff + " ";
	bfexp += "compression=Uncompressed";
	print("*** Finished processing file: " + layout_file);
	print("*** Exporting to OME-TIFF: " + ome_tiff);
	run("Bio-Formats Exporter", bfexp);
	close();
	print("*** Finished exporting to OME-TIFF.");
}
print("===========================================");
print("*** Finished processing 1 mosaics. ***)";
