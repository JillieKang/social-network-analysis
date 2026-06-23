#' ## Edge List

#' ### Requirements
library(dplyr)
library(tidyr)
library(openxlsx)
library(igraph)



#' ### Importing data sets
setwd("c:/jillie")
post_result <- read.xlsx('게시글목록(권영국).xlsx')
head(post_result)
comment_result <- read.xlsx('댓글목록(권영국).xlsx')
head(comment_result)



#' ### Assigning IDs to each user(node)

# Merging unique comment writers and post writers into a single vector
master_이용자id <- c(post_result$게시글작성자, comment_result$댓글작성자) %>% unique %>% sort()
master_이용자id <- data.frame(이용자이름=master_이용자id)

# Assigning row numbers as their IDs
master_이용자id$이용자id <- 1:nrow(master_이용자id)
head(master_이용자id)

# Assigning those IDs to the post details and comments 
post_result <- left_join(post_result,master_이용자id, by=c('게시글작성자'='이용자이름')) 
comment_result <- left_join(comment_result,master_이용자id, by=c('댓글작성자'='이용자이름'))
head(post_result)
head(comment_result)



#' ### Creating edge lists: sender -> target

# Edge list creation strategies
# Level 1: Make an edge list of comment writer -> post writer
# Level 2: Make an edge list of reply writer -> original comment writer
# Level 3: Make an edge list of re-reply writer -> reply writer
# Merging the three edge lists 


#' ### Level 1 edge list: comment writer -> post writer
# Matching comment writers with post writers using post IDs

# Extracting post writers from post_result
partial_of_post_result <- post_result[c('게시글id', '게시글작성자', '이용자id')]
head(partial_of_post_result)

# Extracting comment writers from comment_result
level1_of_comments <- comment_result[c('게시글id', '댓글작성자', '댓글수준', '이용자id')]
level1_of_comments <- level1_of_comments[level1_of_comments$댓글수준=='1수준',]
head(level1_of_comments)


# Matching comment writers with post writers using post IDs
# `inner_join()`by post IDs
part1_sender_to_target <- inner_join(level1_of_comments, 
                                     partial_of_post_result,
                                     by='게시글id', 
                                     suffix = c('_sender', '_target') 
                                     # suffix: adding suffix after the name of columns
)

head(part1_sender_to_target) 

# `inner_join()`: No NAs 
table(complete.cases(part1_sender_to_target)) 

# Keeping only senders and targets
part1_sender_to_target <- part1_sender_to_target[c('이용자id_sender', '이용자id_target')]
head(part1_sender_to_target)



#' ### Level 2 edge list: reply writer -> original comment writer
# Matching reply writers and original comment writers using user IDs 
# Extracting original comment writers from comment_result
partial_of_comment_result <- comment_result[c('댓글id', '댓글수준', '댓글작성자', '이용자id', '하위댓글id')]
level1_of_comments <- partial_of_comment_result[partial_of_comment_result$댓글수준=='1수준',] 
head(level1_of_comments)

# Extracting reply writers from comment_result
partial_of_comment_result <- comment_result[c('댓글id', '댓글수준', '댓글작성자', '이용자id')]
level2_of_comments <- partial_of_comment_result[partial_of_comment_result$댓글수준=='2수준',] 
head(level2_of_comments)

# If there are more than two replies under one original comment:
# Assigning both replies to the original comment and separating them using a delimiter
head(level1_of_comments)
level1_of_comments <- level1_of_comments %>% 
  mutate(하위댓글id =  strsplit(하위댓글id,split='|', fixed=TRUE) ) %>%  
  unnest(c(하위댓글id),          
         keep_empty = TRUE)
head(level1_of_comments)

# Matching reply writers and original comment writers using IDs of each post as a key
# `inner_join()`by comment IDs
part2_sender_to_target <-  inner_join(level2_of_comments, 
                                      level1_of_comments, by=c('댓글id'='하위댓글id'), 
                                      suffix = c('_sender', '_target'))

part2_sender_to_target <- part2_sender_to_target[c('이용자id_sender', '이용자id_target')] 
head(part2_sender_to_target) 
table(complete.cases(part2_sender_to_target))



#' ### Level 3 edge list: re-reply writer -> reply writer
# Matching re-reply writers and reply writers based on IDs of each comment
# Extracting replies from comment_result
partial_of_comments <- comment_result[c('댓글id', '댓글수준', '댓글작성자', '이용자id', '하위댓글id')]
level2_of_comments <- partial_of_comments[partial_of_comments$댓글수준=='2수준',]
head(level2_of_comments)

# Extracting re-replies from comment_result
level3_of_comments <- partial_of_comments[partial_of_comments$댓글수준=='3수준',]
head(level3_of_comments)

# If there are more than two re-replies under one reply
# Assign both re-replies to the reply and separating them using a delimiter
level2_of_comments <- level2_of_comments %>% 
  mutate(하위댓글id =  strsplit(하위댓글id,split='|', fixed=TRUE) ) %>%  
  unnest(c(하위댓글id),          
         keep_empty = TRUE)   
head(level2_of_comments)

# Matching re-reply writers and reply writers by comment IDs
# `inner_join()`by comment IDs
part3_sender_to_target <-  inner_join(level3_of_comments, 
                                      level2_of_comments, by=c('댓글id'='하위댓글id'), 
                                      suffix = c('_sender', '_target'))
part3_sender_to_target <- part3_sender_to_target[c('이용자id_sender', '이용자id_target')] 
head(part3_sender_to_target) 
table(complete.cases(part3_sender_to_target)) 


#' ### Merging Edge Lists from All Three Levels
sender_to_target <- rbind(part1_sender_to_target, part2_sender_to_target, part3_sender_to_target)
head(sender_to_target)

# Saving them as .xlsx
write.xlsx(master_이용자id, file='이용자id(권영국).xlsx', colNames=TRUE, overwrite = TRUE)
write.xlsx(sender_to_target, file='edgelist(권영국).xlsx', colNames=TRUE, overwrite = TRUE)





#' ## Creating Networks from Edge Lists

#' ### Directed Binary Network
edgelist <- read.xlsx(xlsxFile = 'edgelist(권영국).xlsx')
str(edgelist)

# Removing loops
edgelist_bin <- edgelist %>% filter(이용자id_sender != 이용자id_target)

# Keeping unique relations only
edgelist_bin <- edgelist_bin[!duplicated(edgelist_bin), ]
head(edgelist_bin)

# Converting edgelist_bin into igraph
# directed = TRUE
g_bin <- graph_from_data_frame(as.matrix(edgelist_bin), directed = TRUE)

# IGRAPH afb01a8 DN-- 644 773 -- 
# afb01a8: unique ID of the graph
# D: Directed
# N: Named
# 664: Numbers of nodes
# 773: Numbers of edges
# name (v/c): name attributes in character form in vertexes
print(g_bin)

# Converting edge lists into matrices
# Extracting adjacency matrix (n x n) from igraph
adj_matrix_bin <- as_adjacency_matrix(g_bin, sparse = FALSE)
class(adj_matrix_bin) 
print(dim(adj_matrix_bin)) 

# Sorting all IDs of nodes in ascending order for QAP analysis
all_nodes_sorted_bin <- sort(V(g_bin)$name) 
adj_matrix_bin <- adj_matrix_bin[all_nodes_sorted_bin, all_nodes_sorted_bin]
adj_matrix_bin[11:20, 11:20]



#' ### Directed Weighted Network
edgelist <- read.xlsx(xlsxFile = 'edgelist(계엄).xlsx')

# Removing loops
edgelist_valued <- edgelist %>% filter(이용자id_sender != 이용자id_target)

# Creating weight attributes of relations
edgelist_valued <- edgelist_valued %>% 
  group_by(이용자id_sender, 이용자id_target) %>%
  summarise(weight = n()) 

# Saving them as .xlsx
write.xlsx(edgelist_valued, file='edgelist_valued(계엄).xlsx', colNames=TRUE, overwrite = TRUE)

# Converting the edge list into igraph
# directed=TRUE
# `graph_from_data_frame()` automatically adapts the column 'weight' as weights for the graph
# weight (e/n): weight attributes in numeric form in edges
g_val <- graph_from_data_frame(edgelist_valued, directed = TRUE)
print(g_val)


# Converting edge lists into matrices
# Extracting adjacency matrix
adj_matrix_val <- as_adjacency_matrix(g_val, sparse = FALSE, 
                                      attr="weight")   
class(adj_matrix_val)
print(dim(adj_matrix_val))

# Sorting all IDs of nodes in ascending order
all_nodes_sorted_val <- sort(V(g_val)$name)
adj_matrix_val <- adj_matrix_val[all_nodes_sorted_val, all_nodes_sorted_val]
adj_matrix_val[11:20, 11:20]
adj_matrix_val[1:10, 1:10]
head(adj_matrix_val)

# Saving them as .csv
# write.csv(adj_matrix_val, "adj_matrix_val(계엄).csv")



#' ### Adding New Attributes for Research: Political Orientation 

# Importing the data set
pol_ori <- read.xlsx('정치성향_가상.xlsx')
class(pol_ori$이용자id)
pol_ori$이용자id <- as.character(pol_ori$이용자id)

# `left_join()` based on nodes in the network: merge political orientations
bbom_bin_df <- igraph::as_data_frame(g_bin, what = "vertices")
bbom_bin_df <- left_join(bbom_bin_df, pol_ori , by=c("name"="이용자id")) %>% 
  mutate(정치성향 = replace_na(정치성향, 3)) 

# Replacing NAs with 3
head(bbom_bin_df)

# Adding political orientation to igraph
V(g_bin)$정치성향 <- bbom_bin_df$정치성향
print(g_bin)

# Converting political orientation into the matrix 
pol_ori_same <- matrix(0, nrow = vcount(g_bin), ncol = vcount(g_bin))

# Naming nodes using igraph
colnames(pol_ori_same) <- V(g_bin)$name
rownames(pol_ori_same) <- V(g_bin)$name
node_pol_ori <- V(g_bin)$정치성향

# Assigning 1 if two nodes have the same political orientation with each other
for (i in 1:vcount(g_bin)){
  for (j in 1:vcount(g_bin)){
    if (node_pol_ori[i] == node_pol_ori[j]){
      pol_ori_same[i, j] <- 1 
    } 
  }
}

# Setting loops to NA
diag(pol_ori_same) <- NA  
pol_ori_same[1:10, 1:10] 
class(pol_ori_same)     

# Sorting names of nodes in ascending order
node_names_sorted <- sort(rownames(pol_ori_same))
pol_ori_same <- pol_ori_same[node_names_sorted, node_names_sorted]

# Saving them as .csv
write.csv(pol_ori_same, "pol_ori_same.csv")
