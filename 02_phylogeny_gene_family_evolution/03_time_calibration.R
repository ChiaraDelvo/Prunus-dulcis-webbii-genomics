# Date newTree.nwk so the Prunus_persica–TU_Hap1 split is 5.8 million years.
# Packages: ape, phytools, castor.
# Outputs: tree_dated.nwk, Divergence_to_Pdulcis.txt.

library(ape)
library(phytools)
install.packages("castor")
library(castor)

myTree <- ape::read.tree(file = "newTree.nwk")
myTree <- root(myTree, outgroup = "Prunus_mume", resolve.root = TRUE)

plot(myTree)
nodelabels()

# 5.8e6 years is the age of the P. persica–P. dulcis ancestor, not the root.
age <- 5.8e6
node_position_pdulcis <- which(myTree$tip.label == "TU_Hap1")

# Temporary scaling. anchor_node 10 is the root.
dated_tree <- date_tree_red(myTree, anchor_node = 10, anchor_age = age)

# Divergence time is half the tip-to-tip patristic distance.
# Rescale the root age so that split equals 5.8 Mya.
dist_to_ppersica <- get_all_distances_to_tip(tree = dated_tree$tree, focal_tip = "Prunus_persica")
correction_factor_age <- age / (dist_to_ppersica[node_position_pdulcis] / 2)
dated_tree <- date_tree_red(myTree, anchor_node = 10, anchor_age = age * correction_factor_age)

plot.phylo(dated_tree$tree)
edgelabels(round(dated_tree$tree$edge.length / 1000000, 2), font = 2)

dist_to_pdulcis <- get_all_distances_to_tip(tree = dated_tree$tree, focal_tip = "TU_Hap1")
dist_to_pdulcis_df <- data.frame(
  Species = dated_tree$tree$tip.label,
  Mya = dist_to_pdulcis[1:length(dated_tree$tree$tip.label)] / 2
)
write.table(dist_to_pdulcis_df, "Divergence_to_Pdulcis.txt", sep = "\t", col.names = TRUE, row.names = FALSE)

dated_tree$tree$node.label <- NULL
write.tree(phy = dated_tree$tree, file = "tree_dated.nwk")
