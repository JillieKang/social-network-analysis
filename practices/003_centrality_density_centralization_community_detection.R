#' ## Centrality Analysis

#' ### Requirements 
library(igraph)
library(openxlsx)


#' ### Importing the data set 
relations <- read.csv("adj_matrix_val(권영국).csv",header=T,row.names=1,stringsAsFactors=FALSE)
relations[1:10,1:10] 
class(relations)  


#' ### Creating the network of relations in the data set
# Converting the data frame to the matrix 
# Making the row and column names identical
relations <- as.matrix(relations)
colnames(relations) <- rownames(relations) 

# Converting the adjacency matrix into igraph object
# V: vertex = node
# C: character
# D: directed
# W: weighted
nw <- graph_from_adjacency_matrix(relations, mode="directed", weighted=TRUE)
nw

#' ### Visualization: relations in the network
# Showing too many nodes for clear interpretation
plot(
  nw, 
  layout=layout_with_fr,
  #vertex.label=NA,
  vertex.color="white",
  vertex.size=15,
  edge.arrow.size=0.5,
  edge.width = E(nw)$weight,
  vertex.label.color="black",
  vertex.label.family="sans"
)


#' ### Degree centrality Analysis
# `degree()` function does not reflect edge weights
# It only counts the number of connections, ignoring the weight values

# Calculating indegree & outdegree
ideg <- degree(nw, mode="in",loops = F)
odeg <- degree(nw, mode="out",loops = F) 

# Calculating total degree = (indegree + outdegree)
adeg <- degree(nw, mode="all",loops = F) 

# Calculating "weighted" degree centrality by reflecting edge weights
ideg_weighted <- strength(nw, vids = V(nw),mode = c("in"), 
                          loops = FALSE,
                          weights = E(nw)$weight
) 
odeg_weighted <- strength(nw, vids = V(nw),mode = c("out"), 
                          loops = FALSE,
                          weights = E(nw)$weight
)
adeg_weighted <- strength(nw, vids = V(nw),mode = c("all"), 
                          loops = FALSE,
                          weights = E(nw)$weight
)

# Merging them into data frame
centrality_weighted_df <- data.frame(
  node       = rownames(relations),
  indegree   = ideg_weighted,
  outdegree  = odeg_weighted,
  total = adeg_weighted,
  row.names  = NULL,
  stringsAsFactors = FALSE
)

# Saving them as .xlsx
write.xlsx(centrality_weighted_df,"centrality_weighted_df(권영국).xlsx")

# Extracting the top 10 nodes by weighted degree
top_ideg <- ideg_weighted%>%sort(decreasing = TRUE)%>%.[1:10]
top_odeg <- odeg_weighted%>%sort(decreasing = TRUE)%>%.[1:10]
top_adeg <- adeg_weighted%>%sort(decreasing = TRUE)%>%.[1:10]

# Extracting unique nodes among them
top2 <- c(top_ideg, top_odeg)
unique_top2 <- unique(top2)
unique_top2
length(unique_top2)

# Observing Much larger indegree than outdegree
# Suggest preferential relation in this network
head(centrality_weighted_df)

#' ### Visualization: degree centrality distribution using histogram

# Showing a highly right-skewed distribution
hist(ideg_weighted, 
     xlab="Indegree",
     main="Indegree Distribution")

# Showing slightly less skewness in outdegree
hist(odeg_weighted, 
     xlab="Outdegree", 
     main="Outdegree Distribution")

# Checking descriptive statistics of degrees 
mean(ideg_weighted);median(ideg_weighted);sd(ideg_weighted)
mean(odeg_weighted);median(odeg_weighted);sd(odeg_weighted)
mean(adeg_weighted);median(adeg_weighted);sd(adeg_weighted)

# Showing less skewness in outdegree
mean(odeg_weighted);median(odeg_weighted);sd(odeg_weighted)


#' ### Reflecting degree centrality on the network 
# Adding 5 on vertex size because there are so many nodes with only zero or 1 degree
plot(
  nw, 
  layout=layout_with_fr,
  vertex.label=NA,   
  vertex.size=adeg_weighted*0.3+5,
  edge.arrow.size=0.5,
  edge.width = E(nw)$weight,
  edge.color = "orange",
  vertex.color="skyblue")

# Selecting nodes with total degree centrality ≥ 5
# Based on the mean value of the total degree centrality
selected_nodes <- names(adeg_weighted)[adeg_weighted >= 5]

subg <- induced_subgraph(nw, vids = selected_nodes)
subg_adeg_weighted <- strength(subg, vids = V(subg),mode = c("all"), 
                               loops = FALSE,
                               weights = E(subg)$weight
)

# Plotting the network with only nodes having total degree centrality ≥ 5
plot(
  subg,
  layout         = layout_with_fr,
  vertex.label   = NA,
  vertex.size    = subg_adeg_weighted*0.3+5,
  edge.arrow.size= 0.5,
  edge.width     = E(subg)$weight,
  edge.color     = "orange",
  vertex.color   = "skyblue"
)


#' ### Betweenness centrality
# Calculating betweenness centrality
bet <- igraph::betweenness(nw, directed=T) 
head(bet)

# Converting them into the data frame
bet_df <- data.frame(
  node        = rownames(relations),
  betweenness = bet,
  row.names   = NULL,
  stringsAsFactors = FALSE
)

# Top 10 nodes by betweenness centrality
top_b <- head(bet_df[order(bet_df$betweenness, decreasing = TRUE), ], 10)
merged_df <- merge(top_b, centrality_weighted_df, by = "node", all.x = TRUE) 
head(merged_df[order(merged_df$betweenness, decreasing = TRUE), ], 10)

# Nodes with higher betweenness: relating many nodes 
bet %>% sort(decreasing = TRUE)%>%.[1:10]

# Saving them as .xlsx
write.xlsx(bet_df,"betweenness_weighted_df(권영국).xlsx")



#' ## Network Density Analysis
# Calculates the network density
# `edge_density()`doesn't consider the weight of relations
# Despite the network is based on online community encouraging free conversations
# Not many relations are showing
edge_density(nw)

# Calculating network density for a weighted network 
(total_weight <- sum(E(nw)$weight)) 
(num_vertices <- vcount(nw))
(possible_edges <- num_vertices * (num_vertices - 1))
(edge_density_weighted <- total_weight / possible_edges)

# Slightly increased density than the density calculated regardless of weights
possible_edges <- if (is_directed(nw)) {
  num_vertices * (num_vertices - 1)
  # If the network is directed, then calculate n(n-1)
} else {
  num_vertices * (num_vertices - 1) / 2
  # If the network is not directed, then calculate n(n-1)/2
}
(edge_density_weighted <- total_weight / possible_edges)



#' ## Network Centralization 
# 0 ≤ Network centralization ≤ 1
centr_degree(nw, mode="all", loops=FALSE)$centralization 

#' ## Community Detection: Newman-Girvan algorithm 
# Exploratory classification
# Calculate edge betweennesses of all edges
# Cut edges with larger edge betweenness
# Recommending analysis on networks with fewer than 100 nodes
s1 <- cluster_edge_betweenness(
  nw,
  weights = E(nw)$weight,
  directed = TRUE)

# Checking the clusters classified
mem <- membership(s1)
length(unique(mem))
table(mem)
table(mem) %>% sort(decreasing = TRUE) %>% .[1:10]

# 291 clusters within 470 nodes
# Producing many singleton clusters with limited interpretive value

# Converting the result into data frame
community_df <- data.frame(
  node      = names(mem),
  community = as.integer(mem),
  row.names = NULL,
  stringsAsFactors = FALSE
)

# Saving them as .xlsx
write.xlsx(community_df,"community_df.xlsx")

#' ### Visualization: clusters and relations

# Plotting the network with only nodes having total degree centrality ≥ 5
s2 <- cluster_edge_betweenness(
  subg,
  weights = E(subg)$weight,
  directed = TRUE)

plot(s2, subg)

