# SCUID-APL
This is a repository for all data collecting and processing scripts used on the SCUID.

## File and Folder Organization Guide
We would like to make sure that everybody can find what they want easily, so please organize the files in the following way.
1. Everything should be put somewhere inside the `SCUID-APL` folder. If you are using GitHub Desktop, this folder should be under `Documents/GitHub/' on your local machine, unless you customized it while cloning the repository.
2. Under `SCUID-APL`, you will see several folders, named in the format `{Setup}_Test_{XXX}`. These folders are named after the types of experiment, so they should only contain files related to that experiment. For instance, if you collected some data on the MFC setup, and you exposed the chips to Nitric Oxide, the data files should be stored somewhere inside `MFC_Test_NO`, and **not** under `MFC_Test_NO2`.
3. Under each type of experiment, you need to create a new folder for each new run of the experiment. Usually, we don't have more than one set of new data every day, so name the folder following a specific template. Since each setup requires different settings, the format is also different. A detailed template for each type of experiment can be found at the end of this document.

