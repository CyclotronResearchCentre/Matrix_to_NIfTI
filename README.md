# Matrix-to-NIfTI conversion
The aim of the functions available here is:

- turning an arbitrary matrix into a NIfTI image
- provide some "mask" for these converted images

This conversion from a matrix into a [NIfTI image](https://nifti.nimh.nih.gov/) can be useful when one wants to visualize or analyse two-dimensional (brain) connectivity matrices with neuroimaging tools such as [SPM](https://www.fil.ion.ucl.ac.uk/spm/) or [PRoNTo](http://www.mlnl.cs.ucl.ac.uk/pronto/). The mask can then be used to automatically select all or part of the created images.



### Dependencies

The functions rely on some SPM functions thus SPM's main folder must be on Matlab's path.