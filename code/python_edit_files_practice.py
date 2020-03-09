# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import os
import pandas as pd

import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt


os.chdir("/Volumes/GoogleDrive/My Drive/Wound_Sputum/data/processed")
file=pd.read_table("summary_read_counts.txt")
file.insert(len(file.columns), "Sample", value=file.FileName)

# remove an underscore followed by another underscore prefixed by anything to beg of line to end of line 
file.Sample=file.Sample.replace(to_replace="_[^_]+$", value="", regex=True)

# get the sum of SE, PE1, PE2 after decon step
decon_file = file[file.Process=="decon"]
decon_file_sum=decon_file.groupby(["Sample"])["Bases"].sum().reset_index()
# plot the sum
decon_plot = sns.barplot(data=decon_file_sum, y="Bases", x="Sample")

# get the sum for all steps
file_sum = file.groupby(["Process", "Sample"])["Bases"].sum().reset_index()
# bar plot of summed bases
sns.set(style="white", context="talk")
plt.subplots(3, 1, figsize=(7, 5), sharex=False, squeeze=False)
sns.relplot(data=file_sum, x="Sample", y="Bases", row="Process")


g=sns.FacetGrid(data=file_sum, row="Process")
g.map(sns.barplot, "Bases", "Sample")

sns.relplot(data=file_sum, x="Sample", y="Bases", row="Process")

g=sns.scatterplot(data=file_sum, x="Sample", y="Bases", hue="Process", hue_order=["demux", "decon"])
g.legend(loc='upper right', bbox_to_anchor=(1.25, 0.5), ncol=1)
