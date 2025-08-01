### DAPC ###

setwd("C:/R Folder")

# ─── packages ─────────────────────────────────────────────────────────────
library(adegenet)     # core DAPC tools
library(vcfR)         # quick VCF import
library(tidyverse)    # pipes + data wrangling
library(cowplot)      # to replicate the little inset barplot later


library(adegenet)
library(ape)
rm(list=ls())

data<-read.genepop(file="populations.snps.gen")

find.clusters(data,max.n.clust=25)

groups2<-find.clusters(data,max.n.clust=25)
# 200, 2
groups2
help(find.clusters)

dapc2<-dapc(data,groups2$grp)
# 4, 3
# 3 is number of eigenvalues


pdf("Leptoxis_coosaensis_DAPC.pdf")
scatter(dapc2,scree.da=TRUE,posi.da = "topleft", cell=0, cstar=0, clab=0, col=c("#FF6600","#0099E5"))  #can use grp=data$pop to color by collection locality
#scatter(dapc2,scree.da=TRUE,posi.da = "topleft", cell=0, cstar=0, clab=0, grp=data$pop)


## assumes you already have dapc2 from previous steps
scatter(dapc2,
        scree.da = TRUE,           # tiny bar-plot of DA eigenvalues
        posi.da  = "bottomleft",      # where that bar-plot goes
        cell     = 0,              # no inertia ellipses
        cstar    = 0,              # no star segments
        clab     = 0,              # hide point labels
        col      = c("#FF6600", "#0099E5", "#7C93C8", "#5FB58A")[1:nlevels(dapc2$grp)])


dev.off()

###############################################################################
##  Fancy DAPC plot (ggplot2 version) #########################################
###############################################################################
library(ggplot2)
library(cowplot)

## 1.  Build a tidy dataframe of DF1 + DF2 + cluster labels -------------------
scores <- as.data.frame(dapc2$ind.coord[, 1:2])
colnames(scores) <- c("DF1", "DF2")
scores$Population <- factor(groups2$grp,          # k-means labels
                            labels = c("Buxahatchee",
                                       "Ohatchee",
                                       "Choccolocco",
                                       "Coosa"))   # reorder/rename at will

## 2.  Variance proportions for axis captions --------------------------------
prop <- round(100 * dapc2$var / sum(dapc2$var), 2)

## 3.  Main scatterplot -------------------------------------------------------
pal <- c(Buxahatchee = "#5fb58a",
         Ohatchee    = "#f7a16c",
         Choccolocco = "#7c93c8",
         Coosa       = "#e796c8")

p_scatter <- ggplot(scores, aes(DF1, DF2, colour = Population)) +
  geom_vline(xintercept = 0, linewidth = .7) +
  geom_hline(yintercept = 0, linewidth = .7) +
  geom_point(size = 3.5, alpha = .9) +
  scale_colour_manual(values = pal) +
  labs(x = sprintf("DF1 (%.2f%%)", prop[1]),
       y = sprintf("DF2 (%.2f%%)", prop[2])) +
  coord_equal() +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid            = element_blank(),
    axis.title            = element_text(face = "bold"),
    axis.line             = element_blank(),
    legend.position       = "none",                 # turn off default placement
    legend.position.inside= c(0.13, 0.83),          # x-, y-fraction of panel
    legend.justification  = c("left", "top"),
    legend.title          = element_text(size = 14),
    legend.background     = element_blank()
  ) +
  guides(colour = guide_legend(title = "Population"))


## 4.  Inset barplot of DA eigenvalues (first 3) ------------------------------
eig_df <- data.frame(axis  = factor(1:length(dapc2$eig)),
                     value = dapc2$eig)
p_eig <- ggplot(eig_df, aes(axis, value)) +
  geom_bar(stat = "identity", width = .8, fill = "grey30") +
  labs(y = "DA eigenvalues", x = NULL) +
  theme_minimal(base_size = 9) +
  theme(panel.grid       = element_blank(),
        axis.text.x      = element_blank(),
        axis.ticks.x     = element_blank(),
        axis.title.y     = element_text(size = 9, hjust = .5),
        plot.background  = element_rect(colour = "black", linewidth = .7))

## 5.  Stitch scatter + inset -------------------------------------------------
final <- ggdraw(p_scatter) +
  draw_plot(p_eig,
            x = 0.05, y = 0.05,           # tinkering these moves the inset
            width = 0.25, height = 0.25)

## 6.  Show on screen ---------------------------------------------------------
print(final)

## 7.  …and/or save to file ---------------------------------------------------
# ggsave("LC_DAPC_pretty.png", final, width = 11, height = 6, dpi = 300)


####this is the one i used ####
# ── palette that matches the screenshot ────────────────────────────────────

pdf("Leptoxis_coosaensis_DAPC.pdf")

pal <- c(
  Buxahatchee = "#67C08B",   # soft green
  Ohatchee    = "#F29B6C",   # peach-orange
  Choccolocco = "#7C8FC8",   # bluish lavender
  Coosa       = "#E39BC7"    # light pink
)

# ── scatter (legend on) + eigenvalue inset ─────────────────────────────────
p_scatter <- ggplot(scores, aes(DF1, DF2, colour = Population)) +
  geom_vline(xintercept = 0, linewidth = .7) +
  geom_hline(yintercept = 0, linewidth = .7) +
  geom_point(size = 4.0, alpha = .75) +
  scale_colour_manual(values = pal) +                # << colour map
  labs(x = "DF1",                          # keep % in titles
       y = "DF2",
       colour = "Population") +
  coord_equal() +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid       = element_blank(),
    axis.title       = element_text(face = "bold"),
    axis.line        = element_blank(),
    legend.position  = c(0.01, 0.99),   # inside top-left
    legend.justification = c("left", "top"),
    legend.background = element_blank()
  )

eig_df <- data.frame(axis = factor(1:3),
                     value = dapc2$eig[1:3])

p_eig <- ggplot(eig_df, aes(axis, value)) +
  geom_bar(stat = "identity", width = .8, fill = "grey30") +
  labs(y = "DA eigenvalues", x = NULL) +
  theme_minimal(base_size = 9) +
  theme(panel.grid      = element_blank(),
        axis.text.x     = element_blank(),
        axis.ticks.x    = element_blank(),
        axis.title.y    = element_text(size = 9, hjust = .5),
        plot.background = element_rect(colour = "black", linewidth = .7))



final <- cowplot::ggdraw(p_scatter) +
  cowplot::draw_plot(p_eig, x = 0.10, y = 0.09,
                     width = 0.25, height = 0.25)

print(final)
ggsave("DAPC_final_matching_colours.png", final, w = 11, h = 6, dpi = 300)
dev.off()
