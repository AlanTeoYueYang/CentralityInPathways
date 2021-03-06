rm(list = ls())
library(dplyr)
library(ggplot2)
all.mouse.essential <- readRDS("mouse_data/MmsPathwayCentralities.rds")

gene.essential <-  all.mouse.essential
gene.essential %>% distinct(.,pathway.name)
gene.essential <-  gene.essential %>%  tidyr::replace_na(list(Description = "Normal"))

# Assigning quantile scores to centrality models
gene.essential %<>% filter(.,total.node < 1000, total.node >20, total.edge > 20,
                           total.edge < 4000) %>%
    mutate(., katz.ssc.quant = round((katz.ssc.rank/total.node)*100),
           katz.und.quant    = round((katz.und.rank/total.node)*100),
           katz.sink.quant   = round((katz.sink.rank/total.node)*100),
           katz.source.quant = round((katz.source.rank/total.node)*100),
           deg.quant         = round((degree.rank/total.node)*100),
           cls.source.quant = round((cls.source.rank/total.node)*100),
           cls.und.quant    = round((cls.und.rank/total.node)*100),
           cls.sink.quant   = round((cls.sink.rank/total.node)*100),
           cls.ssc.quant =    round((cls.ssc.rank/total.node)*100),
           pgr.source.quant =  round((pgr.source.rank/total.node)*100),
           pgr.sink.quant =    round((pgr.sink.rank/total.node)*100),
           pgr.ssc.quant =     round((pgr.ssc.rank/total.node)*100),
           pgr.und.quant =     round((pgr.und.rank/total.node)*100),
           lap.ssc.quant =     round((lap.ssc.rank/total.node)*100),
           lap.source.quant =  round((lap.source.rank/total.node)*100),
           lap.sink.quant =    round((lap.sink.rank/total.node)*100))


### A total of 219 pathways passed the criteria
gene.essential %>% distinct(.,pathway.name)



## Total Number of Letha; genes found in all genes
##gene.essential %>% filter(., Description == "Letha;") %>% distinct(.,node.genes)



# Pathway-wise checking if the rank of the Lethal nodes are different based on centrality
### Getting rid of pathways with no Lethal-genes
    no.Lethals     <- gene.essential %>% group_by(.,pathway.name) %>%
        filter(.,Description =="Lethal") %>% distinct(., pathway.name)
    gene.essential <- gene.essential %>% filter(., pathway.name %in% unlist(no.Lethals))
    no.Lethals     <- gene.essential %>% group_by(.,pathway.name) %>%
        filter(.,Description =="Lethal") %>%
        summarise(count = n()) %>%
        filter(count <= 5) %>%
        distinct(., pathway.name)



gene.essential <- gene.essential[ !(gene.essential$pathway.name %in% unlist(no.Lethals))  ,]

length((gene.essential$node.genes[gene.essential$Description == "Lethal"]))

saveRDS(gene.essential, file = "mouse_data/MMgene_essentials.rds")

