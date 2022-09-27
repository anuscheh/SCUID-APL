# Naming Convention for MFC Plots
The Script `MFC_Tests_Data_Plotting.m` should correctly name all the plots it generates. But in case it did not work for you, or you indend to modify the file names of the plots, please read on.

The plots name contains essential information about the test it corresponds to, as well as the property of the plot itself. Below is a list of different parts that a file name typically comprises of, with examples.

1. Test Data, using the format `YYYY-MM-DD` specified in the `ISO 8601` standard. Example: a test conducted on September 12, 2022:
```
2022-09-11
```
2. Sensor information, including Board number, Chip number, and specific Pads on a Chip (usually in groups of 1 to 6 or 7 to 12). Example: a plot showing data collected from Chip 14, Pads 1-6, on Board 0:
```
 B0_C14_P1-6
```
3. Gas information, including the MFC used, the name of the gas (such as `NO`), its concentration, and whether it is humid or not (`Humid` or `Dry`). Example: Nitric oxide gas of 104 ppm concentration, controlled by MFC0 and humidified:
```
MFC0_NO_104ppm_Humid
```
4. Part of the data (e.g. `Full` for entire test or `Run` for one series of steps), and quantities plotted. If multiple quantities are plotted on the same figure, use a plus sign `+` to connect them. Example: normaized, baseline-corrected response data on the second series of exposure steps, with corresponding concentration curve:
```
Run2_RCorr+Conc_Time
```

Theses parts are then concated into a long filename with underscores. Usually the plots are saved as `.png` files. The final file name from the examples above looks like this:
```
2022-09-11_B0_C14_P1-6_MFC0_NO_104ppm_Humid_Run2_RCorr+Conc_Time.png
```