Scripts from a population genomics study of the federally threatened Painted Rocksnail (Leptoxis coosaensis). This work was performed in the USFWS Southeast Conservation Genetics Lab at Auburn University by E.K. Strasko, P.D. Johnson, J.T. Garner, and N.V. Whelan.

Data was generated utilizing a 2bRAD approach (Wang et al. 2012; https://doi.org/10.1038/nmeth.2023).

Workflow:
Demultiplex (process_radtags) → pre Stacks filtering for 2bRAD data (https://github.com/NathanWhelan/2bRAD-processing/tree/master) → run populations (populations.txt) → analyze data (everything else)

Two datasets were generated in populations: multiple SNPs per locus (LepCo_M) and single SNP per locus (LepCo_S).

The following scripts utilized LepCo_S:
‣ AdmixPipe

The following scripts utilized LepCo_M:
‣ AMOVA
‣ DAPC
‣ IBD
‣ divmigrate
‣ fineradstructure

Allelic richness utilized haplotypes from the LepCo_M dataset generated in populations.

